import { query } from "#server/utils/database";

export default defineEventHandler(async () => {
  return query(`
    SELECT e.id, e.nip AS employeeNumber, e.name, e.email, e.phone,
      e.joined_at AS joinDate, e.employment_type AS employmentStatus, e.status,
      d.id AS departmentId, d.name AS departmentName,
      p.id AS positionId, p.name AS positionName
    FROM employees e
    JOIN departments d ON d.id = e.department_id
    JOIN positions p ON p.id = e.position_id
    WHERE e.deleted_at IS NULL
    ORDER BY e.id DESC
  `);
});
