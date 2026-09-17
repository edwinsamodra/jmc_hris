import { readBody, getRouterParam, createError } from "h3";
import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import {
  calculateAttendance,
  recalculateAttendanceSummary,
  normalizeLocation,
  parseYearMonth,
} from "#server/utils/attendance-calculator";

export default defineEventHandler(async (event) => {
  // RBAC: update on attendance (Admin HRD only)
  const auth = await requirePermission(event, "attendance", "update");

  const idParam = getRouterParam(event, "id");
  const attendanceId = parseInt(idParam || "", 10);

  if (!attendanceId || isNaN(attendanceId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID Presensi tidak valid.",
    });
  }

  // Cek keberadaan data presensi
  const existingRows = await query<any>(
    `SELECT a.*, e.nip, e.name AS employee_name
     FROM attendances a
     JOIN employees e ON e.id = a.employee_id
     WHERE a.id = ?
     LIMIT 1`,
    [attendanceId],
  );

  if (existingRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data presensi tidak ditemukan.",
    });
  }

  const existing = existingRows[0];
  const body = await readBody(event);
  if (!body) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Data request tidak boleh kosong.",
    });
  }

  const attendanceDate = String(body.attendance_date || body.attendanceDate || body.tgl || existing.attendance_date).trim();
  
  if (!attendanceDate || !/^\d{4}-\d{2}-\d{2}$/.test(attendanceDate)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Format tanggal presensi harus YYYY-MM-DD.",
    });
  }

  // Validasi: Tidak boleh melakukan presensi untuk masa depan (maksimal hari ini)
  const todayStr = new Date().toLocaleDateString("en-CA"); // Format YYYY-MM-DD local timezone
  if (attendanceDate > todayStr) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: `Tanggal presensi tidak boleh di masa depan (${attendanceDate}). Maksimal tanggal presensi adalah hari ini (${todayStr}).`,
    });
  }

  const attendanceType = String(body.attendance_type || body.attendanceType || body.kehadiran || existing.attendance_type).trim().toLowerCase() as
    | "hadir"
    | "cuti"
    | "izin"
    | "unpaid_leave";

  const checkinLocation = normalizeLocation(
    body.checkin_location !== undefined ? body.checkin_location : (body.checkinLocation !== undefined ? body.checkinLocation : existing.checkin_location)
  );
  const checkoutLocation = normalizeLocation(
    body.checkout_location !== undefined ? body.checkout_location : (body.checkoutLocation !== undefined ? body.checkoutLocation : existing.checkout_location)
  );

  const checkinTime = body.checkin_time !== undefined ? body.checkin_time : (body.checkinAt !== undefined ? body.checkinAt : (existing.checkin_at ? String(existing.checkin_at).substring(11, 19) : null));
  const checkoutTime = body.checkout_time !== undefined ? body.checkout_time : (body.checkoutAt !== undefined ? body.checkoutAt : (existing.checkout_at ? String(existing.checkout_at).substring(11, 19) : null));
  const verificationStatus = String(body.verification_status || body.verificationStatus || body.verifikasi || existing.verification_status || "Disetujui").trim();
  const verifiedByRole = String(body.verified_by_role || body.verifiedByRole || body.verifikator || existing.verified_by_role || "HRD").trim();
  const remarks = body.remarks !== undefined ? body.remarks : (body.keterangan !== undefined ? body.keterangan : existing.remarks);

  // Kalkulasi ulang status dan durasi
  const calcResult = calculateAttendance({
    attendanceType,
    attendanceDate,
    checkinTime,
    checkoutTime,
    checkinLocation,
    checkoutLocation,
    verificationStatus,
  });

  const checkinAt = checkinTime ? `${attendanceDate} ${checkinTime.length === 5 ? checkinTime + ":00" : checkinTime}` : null;
  const checkoutAt = checkoutTime ? `${attendanceDate} ${checkoutTime.length === 5 ? checkoutTime + ":00" : checkoutTime}` : null;

  const finalRemarks = remarks || calcResult.remarksReason || null;

  // Cek duplikasi data presensi pada tanggal baru jika tanggal diubah ke tanggal yang sudah ada presensinya
  const duplicateAttendance = await query<any>(
    "SELECT id FROM attendances WHERE employee_id = ? AND attendance_date = ? AND id != ? LIMIT 1",
    [existing.employee_id, attendanceDate, attendanceId],
  );
  if (duplicateAttendance.length > 0) {
    throw createError({
      statusCode: 409,
      statusMessage: "Conflict",
      message: `Data presensi untuk pegawai '${existing.employee_name}' (NIP: ${existing.nip}) pada tanggal ${attendanceDate} sudah ada di baris data lain. Silakan pilih tanggal lain.`,
    });
  }

  try {
    await execute(
      `UPDATE attendances
       SET attendance_date = ?,
           checkin_at = ?,
           checkout_at = ?,
           checkin_location = ?,
           checkout_location = ?,
           attendance_type = ?,
           duration_hours = ?,
           status = ?,
           verification_status = ?,
           verified_by_role = ?,
           remarks = ?
       WHERE id = ?`,
      [
        attendanceDate,
        checkinAt,
        checkoutAt,
        checkinLocation,
        checkoutLocation,
        attendanceType,
        calcResult.durationHours,
        calcResult.status,
        verificationStatus,
        verifiedByRole,
        finalRemarks,
        attendanceId,
      ],
    );
  } catch (dbErr: any) {
    if (dbErr?.code === "ER_DUP_ENTRY" || dbErr?.errno === 1062 || String(dbErr?.message).includes("Duplicate entry")) {
      throw createError({
        statusCode: 409,
        statusMessage: "Conflict",
        message: `Data presensi untuk pegawai '${existing.employee_name}' (NIP: ${existing.nip}) pada tanggal ${attendanceDate} sudah ada di baris data lain. Silakan pilih tanggal lain.`,
      });
    }
    throw dbErr;
  }

  // Rekalkulasi rekap bulanan pegawai
  const newPeriod = parseYearMonth(attendanceDate);
  await recalculateAttendanceSummary(existing.employee_id, newPeriod.year, newPeriod.month);

  // Jika tanggal sebelumnya berbeda bulan/tahun, rekalkulasi juga bulan sebelumnya
  const oldPeriod = parseYearMonth(existing.attendance_date);
  if (oldPeriod.year !== newPeriod.year || oldPeriod.month !== newPeriod.month) {
    await recalculateAttendanceSummary(existing.employee_id, oldPeriod.year, oldPeriod.month);
  }

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "attendance",
    action: "update",
    description: `Mengubah data presensi ${existing.employee_name} tanggal ${attendanceDate}`,
    subjectType: "attendances",
    subjectId: attendanceId,
    oldValues: {
      attendance_date: existing.attendance_date,
      attendance_type: existing.attendance_type,
      duration_hours: existing.duration_hours,
      status: existing.status,
      checkin_location: existing.checkin_location,
      checkout_location: existing.checkout_location,
    },
    newValues: {
      attendance_date: attendanceDate,
      attendance_type: attendanceType,
      duration_hours: calcResult.durationHours,
      status: calcResult.status,
      checkin_location: checkinLocation,
      checkout_location: checkoutLocation,
    },
  });

  return {
    success: true,
    message: "Data presensi berhasil diperbarui.",
    data: {
      id: attendanceId,
      attendanceDate,
      durationHours: calcResult.durationHours,
      status: calcResult.status,
    },
  };
});
