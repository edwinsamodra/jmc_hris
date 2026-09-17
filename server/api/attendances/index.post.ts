import { readBody, createError } from "h3";
import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import {
  calculateAttendance,
  recalculateAttendanceSummary,
  normalizeLocation,
} from "#server/utils/attendance-calculator";

export default defineEventHandler(async (event) => {
  // RBAC: create on attendance (Admin HRD only)
  const auth = await requirePermission(event, "attendance", "create");

  const body = await readBody(event);
  if (!body) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Data request tidak boleh kosong.",
    });
  }

  const employeeId = parseInt(body.employee_id || body.employeeId || "", 10);
  const attendanceDate = String(body.attendance_date || body.attendanceDate || body.tgl || "").trim();
  const attendanceType = String(body.attendance_type || body.attendanceType || body.kehadiran || "hadir").trim().toLowerCase() as
    | "hadir"
    | "cuti"
    | "izin"
    | "unpaid_leave";

  if (!employeeId || isNaN(employeeId)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Pegawai wajib dipilih.",
    });
  }

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

  const validTypes = ["hadir", "cuti", "izin", "unpaid_leave"];
  if (!validTypes.includes(attendanceType)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Jenis kehadiran harus salah satu dari: hadir, cuti, izin, unpaid_leave.",
    });
  }

  // Cek keberadaan pegawai
  const empRows = await query<any>(
    "SELECT id, nip, name FROM employees WHERE id = ? AND deleted_at IS NULL LIMIT 1",
    [employeeId],
  );
  if (empRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Pegawai tidak ditemukan.",
    });
  }
  const employee = empRows[0];

  const checkinLocation = normalizeLocation(body.checkin_location || body.checkinLocation || body.lokasiCheckin);
  const checkoutLocation = normalizeLocation(body.checkout_location || body.checkoutLocation || body.lokasiCheckout);
  const checkinTime = body.checkin_time || body.checkinTime || body.checkinAt || null;
  const checkoutTime = body.checkout_time || body.checkoutTime || body.checkoutAt || null;
  const verificationStatus = String(body.verification_status || body.verificationStatus || body.verifikasi || "Disetujui").trim();
  const verifiedByRole = String(body.verified_by_role || body.verifiedByRole || body.verifikator || "HRD").trim();
  const remarks = body.remarks || body.keterangan || null;

  // Hitung status dan durasi menggunakan aturan bisnis
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

  // Cek duplikasi data presensi pada tanggal yang sama untuk pegawai tersebut
  const existingAttendance = await query<any>(
    "SELECT id FROM attendances WHERE employee_id = ? AND attendance_date = ? LIMIT 1",
    [employeeId, attendanceDate],
  );
  if (existingAttendance.length > 0) {
    throw createError({
      statusCode: 409,
      statusMessage: "Conflict",
      message: `Data presensi untuk pegawai '${employee.name}' (NIP: ${employee.nip}) pada tanggal ${attendanceDate} sudah ada. Silakan gunakan fitur edit jika ingin mengubahnya.`,
    });
  }

  let insertResult: any;
  try {
    insertResult = await execute(
      `INSERT INTO attendances (
         employee_id, attendance_date, checkin_at, checkout_at,
         checkin_location, checkout_location, attendance_type,
         duration_hours, status, verification_status, verified_by_role, remarks
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        employeeId,
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
      ],
    );
  } catch (dbErr: any) {
    if (dbErr?.code === "ER_DUP_ENTRY" || dbErr?.errno === 1062 || String(dbErr?.message).includes("Duplicate entry")) {
      throw createError({
        statusCode: 409,
        statusMessage: "Conflict",
        message: `Data presensi untuk pegawai '${employee.name}' (NIP: ${employee.nip}) pada tanggal ${attendanceDate} sudah ada. Silakan gunakan fitur edit jika ingin mengubahnya.`,
      });
    }
    throw dbErr;
  }

  const newId = insertResult.insertId;

  // Rekalkulasi rekap bulanan pegawai
  const [yearStr, monthStr] = attendanceDate.split("-");
  await recalculateAttendanceSummary(employeeId, parseInt(yearStr, 10), parseInt(monthStr, 10));

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "attendance",
    action: "create",
    description: `Menambahkan data presensi ${employee.name} (NIP: ${employee.nip}) tanggal ${attendanceDate}`,
    subjectType: "attendances",
    subjectId: newId,
    newValues: {
      id: newId,
      employee_id: employeeId,
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
    message: "Data presensi berhasil disimpan.",
    data: {
      id: newId,
      employeeId,
      attendanceDate,
      durationHours: calcResult.durationHours,
      status: calcResult.status,
    },
  };
});
