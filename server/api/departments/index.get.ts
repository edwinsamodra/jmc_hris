import { query } from "#server/utils/database";

export default defineEventHandler(async () => {
  return query(`
    SELECT d.id, d.code, d.name, COUNT(e.id) AS employeeCount
    FROM departments d
    LEFT JOIN employees e ON e.department_id = d.id AND e.deleted_at IS NULL
    GROUP BY d.id, d.code, d.name
    ORDER BY d.name
  `);
});
