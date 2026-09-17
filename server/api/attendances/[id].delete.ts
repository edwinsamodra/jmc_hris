import { getRouterParam, createError } from "h3";
import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import {
  recalculateAttendanceSummary,
  parseYearMonth,
  formatDateString,
} from "#server/utils/attendance-calculator";

export default defineEventHandler(async (event) => {
  // RBAC: delete on attendance (Admin HRD only)
  const auth = await requirePermission(event, "attendance", "delete");

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

  // Hapus data presensi
  await execute("DELETE FROM attendances WHERE id = ?", [attendanceId]);

  // Rekalkulasi rekap bulanan pegawai
  const period = parseYearMonth(existing.attendance_date);
  await recalculateAttendanceSummary(existing.employee_id, period.year, period.month);

  const formattedDate = formatDateString(existing.attendance_date);

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "attendance",
    action: "delete",
    description: `Menghapus data presensi ${existing.employee_name} tanggal ${formattedDate}`,
    subjectType: "attendances",
    subjectId: attendanceId,
    oldValues: {
      id: existing.id,
      employee_id: existing.employee_id,
      attendance_date: formattedDate,
      attendance_type: existing.attendance_type,
      duration_hours: existing.duration_hours,
      status: existing.status,
    },
  });

  return {
    success: true,
    message: "Data presensi berhasil dihapus.",
  };
});
