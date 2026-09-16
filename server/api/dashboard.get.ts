import { query } from "#server/utils/database";

export default defineEventHandler(async () => {
  const [summary] = await query(`
    SELECT COUNT(*) AS employees,
      SUM(employment_type = 'pkwtt') AS permanentEmployees,
      SUM(employment_type = 'pkwt') AS contractEmployees,
      SUM(employment_type = 'magang') AS interns,
      (SELECT COUNT(*) FROM departments) AS departments
    FROM employees
    WHERE deleted_at IS NULL AND status = 'active'
  `);
  const recentEmployees = await query(`
    SELECT id, nip AS employeeNumber, name, joined_at AS joinDate,
      employment_type AS employmentStatus
    FROM employees WHERE deleted_at IS NULL
    ORDER BY joined_at DESC, id DESC LIMIT 5
  `);
  return { summary, recentEmployees };
});
