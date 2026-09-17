import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  await requirePermission(event, "attendance", "read");
  const filters = getQuery(event);
  const params: unknown[] = [];
  let where = "";

  if (filters.date) {
    where = "WHERE a.attendance_date = ?";
    params.push(filters.date);
  }

  return query(`
    SELECT a.id, a.attendance_date AS date, a.checkin_at AS checkIn,
      a.checkout_at AS checkOut, a.attendance_type AS attendanceType,
      a.status, a.remarks, e.id AS employeeId,
      e.nip AS employeeNumber, e.name AS employeeName
    FROM attendances a
    JOIN employees e ON e.id = a.employee_id
    ${where}
    ORDER BY a.attendance_date DESC, e.name
  `, params);
});
