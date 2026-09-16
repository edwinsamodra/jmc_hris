import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // Superadmin yang mengelola User berhak mencari pegawai untuk di-link ke akun user
  await requirePermission(event, "user", "read");

  const queryParams = getQuery(event);
  const search = typeof queryParams.q === "string" ? queryParams.q.trim() : "";

  let sql = `
    SELECT 
      e.id,
      e.nip,
      e.name,
      e.email,
      e.phone,
      e.position_id,
      p.name AS position_name,
      e.department_id,
      d.name AS department_name,
      u.id AS linked_user_id,
      u.username AS linked_username
    FROM employees e
    JOIN positions p ON p.id = e.position_id
    JOIN departments d ON d.id = e.department_id
    LEFT JOIN users u ON u.employee_id = e.id AND u.deleted_at IS NULL
    WHERE e.deleted_at IS NULL AND e.status = 'active'
  `;
  const params: any[] = [];

  if (search) {
    sql += ` AND (e.name LIKE ? OR e.nip LIKE ?)`;
    const searchPattern = `%${search}%`;
    params.push(searchPattern, searchPattern);
  }

  sql += ` ORDER BY e.name ASC LIMIT 50`;

  const rows = await query<any>(sql, params);

  return {
    success: true,
    data: rows,
  };
});
