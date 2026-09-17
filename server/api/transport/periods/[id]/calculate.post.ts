import { defineEventHandler, createError, readBody } from "h3";
import { execute, query, withConnection } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { calculateTransportAllowance } from "#server/utils/transport-calculator";

const MONTH_NAMES = [
  "",
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
];

export default defineEventHandler(async (event) => {
  // Validasi RBAC: Membutuhkan hak akses modul transport_allowance
  const { sessionUser } = await requirePermission(event, "transport_allowance", "update");

  const id = Number(event.context.params?.id);
  if (!id || isNaN(id)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID periode tidak valid.",
    });
  }

  // 1. Ambil data periode
  const periodRows = await query<any>(
    `SELECT id, period_year, period_month, status FROM transport_allowance_periods WHERE id = ? LIMIT 1`,
    [id]
  );

  if (periodRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Periode tunjangan transport tidak ditemukan.",
    });
  }

  const period = periodRows[0];
  const periodYear = Number(period.period_year);
  const periodMonth = Number(period.period_month);
  const monthName = MONTH_NAMES[periodMonth] || `Bulan ${periodMonth}`;

  // 2. Ambil setting tarif tunjangan transport yang aktif
  // Berlaku mulai <= tanggal akhir bulan periode
  const lastDayOfMonth = new Date(periodYear, periodMonth, 0).toISOString().slice(0, 10);
  const settingRows = await query<any>(
    `SELECT id, base_fare, min_km, max_km, min_work_days, effective_start
     FROM transport_allowance_settings
     WHERE is_active = 1 AND effective_start <= ?
     ORDER BY effective_start DESC, id DESC
     LIMIT 1`,
    [lastDayOfMonth]
  );

  let baseFare = 5000;
  let minKm = 5;
  let maxKm = 25;
  let minWorkDays = 19;

  if (settingRows.length > 0) {
    baseFare = Number(settingRows[0].base_fare);
    minKm = Number(settingRows[0].min_km);
    maxKm = Number(settingRows[0].max_km);
    minWorkDays = Number(settingRows[0].min_work_days ?? 19);
  } else {
    // Fallback ke setting aktif apa pun yang tersedia
    const fallbackSetting = await query<any>(
      `SELECT base_fare, min_km, max_km, min_work_days FROM transport_allowance_settings WHERE is_active = 1 LIMIT 1`
    );
    if (fallbackSetting.length > 0) {
      baseFare = Number(fallbackSetting[0].base_fare);
      minKm = Number(fallbackSetting[0].min_km);
      maxKm = Number(fallbackSetting[0].max_km);
      minWorkDays = Number(fallbackSetting[0].min_work_days ?? 19);
    }
  }

  // 3. Ambil seluruh data pegawai aktif beserta total hari kehadiran 'terpenuhi' pada bulan berjalan
  // Kami menghitung dari attendance_summaries jika ada, atau fallback hitung dari tabel attendances
  const employeesWithAttendance = await query<any>(
    `SELECT e.id, e.nip, e.name, e.employment_type, e.distance_km,
            COALESCE(
              s.hadir,
              (SELECT COUNT(*) FROM attendances a 
               WHERE a.employee_id = e.id 
                 AND YEAR(a.attendance_date) = ? 
                 AND MONTH(a.attendance_date) = ? 
                 AND a.attendance_type = 'hadir' 
                 AND a.status = 'terpenuhi')
            ) AS attendance_days
     FROM employees e
     LEFT JOIN attendance_summaries s ON s.employee_id = e.id 
                                     AND s.period_year = ? 
                                     AND s.period_month = ?
     WHERE e.status = 'active' AND e.deleted_at IS NULL`,
    [periodYear, periodMonth, periodYear, periodMonth]
  );

  // 4. Hitung tunjangan untuk masing-masing pegawai menggunakan calculation engine
  let totalRecipients = 0;
  let totalAmount = 0;

  const calculationResults: Array<{
    employeeId: number;
    baseFare: number;
    originalKm: number;
    roundedKm: number;
    effectiveKm: number;
    attendanceDays: number;
    nominal: number;
    eligibilityStatus: string;
    calculationNote: string;
  }> = [];

  for (const emp of employeesWithAttendance) {
    const calc = calculateTransportAllowance({
      employmentType: emp.employment_type,
      distanceKm: emp.distance_km != null ? Number(emp.distance_km) : null,
      attendanceDays: Number(emp.attendance_days || 0),
      baseFare,
      minKm,
      maxKm,
      minWorkDays,
    });

    if (calc.isEligible && calc.nominal > 0) {
      totalRecipients += 1;
      totalAmount += calc.nominal;
    }

    calculationResults.push({
      employeeId: Number(emp.id),
      baseFare: calc.baseFare,
      originalKm: calc.originalKm,
      roundedKm: calc.roundedKm,
      effectiveKm: calc.effectiveKm,
      attendanceDays: calc.attendanceDays,
      nominal: calc.nominal,
      eligibilityStatus: calc.eligibilityStatus,
      calculationNote: calc.calculationNote,
    });
  }

  // 5. Simpan ke database dalam transaksi atomik
  await withConnection(async (conn) => {
    await conn.beginTransaction();
    try {
      // Hapus rincian lama jika sudah pernah dihitung
      await conn.execute(
        `DELETE FROM transport_allowance_details WHERE transport_allowance_period_id = ?`,
        [id]
      );

      // Masukkan rincian penerima yang berhak (eligible dan nominal > 0)
      for (const res of calculationResults) {
        if (res.eligibilityStatus === "eligible" && res.nominal > 0) {
          await conn.execute(
            `INSERT INTO transport_allowance_details (
               transport_allowance_period_id, employee_id, base_fare, original_km,
               rounded_km, effective_km, attendance_days, nominal, eligibility_status, calculation_note
             ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              id,
              res.employeeId,
              res.baseFare,
              res.originalKm,
              res.roundedKm,
              res.effectiveKm,
              res.attendanceDays,
              res.nominal,
              res.eligibilityStatus,
              res.calculationNote,
            ]
          );
        }
      }

      // Update status dan agregat pada periode
      await conn.execute(
        `UPDATE transport_allowance_periods 
         SET total_recipients = ?, total_amount = ?, status = 'calculated',
             calculated_by = ?, calculated_at = NOW()
         WHERE id = ?`,
        [totalRecipients, totalAmount, sessionUser.id, id]
      );

      await conn.commit();
    } catch (txErr) {
      await conn.rollback();
      throw txErr;
    }
  });

  // 6. Catat activity log
  await logActivity(event, {
    action: "update",
    module: "transport_allowance",
    details: `Melakukan perhitungan tunjangan transport periode ${monthName} ${periodYear}: ${totalRecipients} penerima, total Rp ${totalAmount.toLocaleString("id-ID")}`,
  });

  return {
    success: true,
    message: `Perhitungan tunjangan transport ${monthName} ${periodYear} berhasil diselesaikan.`,
    data: {
      period_id: id,
      period_label: `Bulan ${monthName} ${periodYear}`,
      total_recipients: totalRecipients,
      total_amount: totalAmount,
      base_fare_used: baseFare,
      min_km_used: minKm,
      max_km_used: maxKm,
      min_work_days_used: minWorkDays,
    },
  };
});
