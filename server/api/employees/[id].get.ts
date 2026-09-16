import { query } from "#server/utils/database";

export default defineEventHandler(async (event) => {
  const id = Number(getRouterParam(event, "id"));
  const [employee] = await query(`
    SELECT e.*, d.name AS department_name, p.name AS position_name,
      ds.name AS district_name, r.name AS regency_name, pr.name AS province_name
    FROM employees e
    JOIN departments d ON d.id = e.department_id
    JOIN positions p ON p.id = e.position_id
    JOIN districts ds ON ds.id = e.district_id
    JOIN regencies r ON r.id = ds.regency_id
    JOIN provinces pr ON pr.id = r.province_id
    WHERE e.id = ? AND e.deleted_at IS NULL
  `, [id]);

  if (!employee) {
    throw createError({ statusCode: 404, statusMessage: "Pegawai tidak ditemukan" });
  }

  return employee;
});
