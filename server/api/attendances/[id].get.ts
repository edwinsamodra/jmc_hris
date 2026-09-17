import { getQuery, getRouterParam, createError } from "h3";
import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // RBAC: read permission on 'attendance'
  await requirePermission(event, "attendance", "read");

  const idParam = getRouterParam(event, "id");
  const employeeId = parseInt(idParam || "", 10);

  if (!employeeId || isNaN(employeeId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID Pegawai tidak valid.",
    });
  }

  // Cek keberadaan pegawai
  const empRows = await query<any>(
    `SELECT e.id, e.nip, e.name, e.email, e.employment_type, e.status,
            p.name AS position_name, d.name AS department_name
     FROM employees e
     LEFT JOIN positions p ON p.id = e.position_id
     LEFT JOIN departments d ON d.id = e.department_id
     WHERE e.id = ? AND e.deleted_at IS NULL
     LIMIT 1`,
    [employeeId],
  );

  if (empRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data pegawai tidak ditemukan.",
    });
  }

  const employee = empRows[0];

  const queryParams = getQuery(event);
  const now = new Date();
  let defaultYear = now.getFullYear();
  let defaultMonth = now.getMonth();
  if (defaultMonth === 0) {
    defaultMonth = 12;
    defaultYear -= 1;
  }

  const year = parseInt(String(queryParams.year || defaultYear), 10);
  const month = parseInt(String(queryParams.month || defaultMonth), 10);

  const startDate = `${year}-${String(month).padStart(2, "0")}-01`;
  const nextMonth = month === 12 ? 1 : month + 1;
  const nextYear = month === 12 ? year + 1 : year;
  const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

  // Ambil data summary jika ada
  const summaryRows = await query<any>(
    `SELECT hadir, cuti, kuota_cuti, izin, kuota_izin, unpaid_leave, kuota_unpaid_leave, status_hadir
     FROM attendance_summaries
     WHERE employee_id = ? AND period_year = ? AND period_month = ?
     LIMIT 1`,
    [employeeId, year, month],
  );

  const summary = summaryRows[0] || {
    hadir: 0,
    cuti: 0,
    kuota_cuti: 12,
    izin: 0,
    kuota_izin: 3,
    unpaid_leave: 0,
    kuota_unpaid_leave: 5,
    status_hadir: "Tidak terpenuhi",
  };

  // Ambil data attendances detail dengan DATE_FORMAT dan TIME_FORMAT
  const attendanceRows = await query<any>(
    `SELECT a.id,
            DATE_FORMAT(a.attendance_date, '%Y-%m-%d') AS attendance_date,
            a.checkin_location,
            a.checkout_location,
            TIME_FORMAT(a.checkin_at, '%H:%i:%s') AS checkin_time,
            TIME_FORMAT(a.checkout_at, '%H:%i:%s') AS checkout_time,
            a.attendance_type,
            a.duration_hours,
            a.status,
            a.verification_status,
            a.verified_by_role,
            a.remarks
     FROM attendances a
     WHERE a.employee_id = ?
       AND a.attendance_date >= ?
       AND a.attendance_date < ?
     ORDER BY a.attendance_date DESC, a.id DESC`,
    [employeeId, startDate, endDate],
  );

  const items = attendanceRows.map((row: any) => {
    // Normalisasi label
    let typeLabel = "Hadir";
    if (row.attendance_type === "cuti") typeLabel = "Cuti";
    else if (row.attendance_type === "izin") typeLabel = "Izin";
    else if (row.attendance_type === "unpaid_leave") typeLabel = "Unpaid Leave";

    let verifLabel = "Disetujui";
    if (row.verification_status) {
      const v = row.verification_status.toLowerCase();
      if (v === "ditolak" || v === "rejected") verifLabel = "Ditolak";
      else if (v === "disetujui" || v === "verified" || v === "approved") verifLabel = "Disetujui";
      else verifLabel = row.verification_status;
    }

    const durationVal = row.duration_hours !== null && row.duration_hours !== undefined
      ? Number(Number(row.duration_hours).toFixed(1))
      : (row.status === "terpenuhi" && row.attendance_type === "hadir" ? 8.0 : 0.0);

    return {
      id: row.id,
      tgl: row.attendance_date,
      lokasiCheckin: row.checkin_location || "-",
      lokasiCheckout: row.checkout_location || "-",
      checkinAt: row.checkin_time || null,
      checkoutAt: row.checkout_time || null,
      kehadiran: typeLabel,
      attendanceType: row.attendance_type,
      durasi: durationVal,
      status: row.status === "terpenuhi" ? "Terpenuhi" : "Tidak terpenuhi",
      verifikasi: verifLabel,
      verifikator: row.verified_by_role || "HRD",
      keterangan: row.remarks || "-",
    };
  });

  return {
    success: true,
    data: {
      employee: {
        id: employee.id,
        nip: employee.nip,
        name: employee.name,
        email: employee.email,
        position: employee.position_name || "-",
        department: employee.department_name || "-",
        employmentType: employee.employment_type,
        status: employee.status,
      },
      period: {
        year,
        month,
      },
      summary: {
        hadir: Number(Number(summary.hadir).toFixed(1)),
        statusHadir: summary.status_hadir || (summary.hadir >= 20 ? "Terpenuhi" : "Tidak terpenuhi"),
        cuti: Number(Number(summary.cuti).toFixed(1)),
        kuotaCuti: Number(Number(summary.kuota_cuti).toFixed(1)),
        izin: Number(Number(summary.izin).toFixed(1)),
        kuotaIzin: Number(Number(summary.kuota_izin).toFixed(1)),
        unpaidLeave: Number(Number(summary.unpaid_leave).toFixed(1)),
        kuotaUnpaidLeave: Number(Number(summary.kuota_unpaid_leave).toFixed(1)),
      },
      items,
    },
  };
});
