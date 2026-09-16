import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export interface UserRow {
  id: number;
  name: string;
  username: string;
  email: string | null;
  cellphone: string | null;
  status: "active" | "inactive";
  role_id: number;
  role_code: string;
  role_name: string;
  employee_id: number | null;
  employee_nip: string | null;
  employee_name: string | null;
  position_id: number | null;
  position_name: string | null;
  department_id: number | null;
  department_name: string | null;
  created_at: string;
  updated_at: string;
}

export default defineEventHandler(async (event) => {
  await requirePermission(event, "user", "read");

  const urlQuery = getQuery(event);
  const search = typeof urlQuery.q === "string" ? urlQuery.q.trim() : "";
  const roleFilter = urlQuery.role_id ? Number(urlQuery.role_id) : null;
  const statusFilter = typeof urlQuery.status === "string" ? urlQuery.status.trim() : "";

  let sql = `
    SELECT 
      u.id, u.name, u.username, u.email, u.cellphone, u.status,
      u.role_id, r.code AS role_code, r.name AS role_name,
      u.employee_id, e.nip AS employee_nip, e.name AS employee_name,
      p.id AS position_id, p.name AS position_name,
      d.id AS department_id, d.name AS department_name,
      u.created_at, u.updated_at
    FROM users u
    JOIN roles r ON r.id = u.role_id
    LEFT JOIN employees e ON e.id = u.employee_id
    LEFT JOIN positions p ON p.id = e.position_id
    LEFT JOIN departments d ON d.id = e.department_id
    WHERE u.deleted_at IS NULL
  `;
  const params: any[] = [];

  if (search) {
    sql += ` AND (u.name LIKE ? OR u.username LIKE ? OR e.name LIKE ? OR e.nip LIKE ?)`;
    params.push(`%${search}%`, `%${search}%`, `%${search}%`, `%${search}%`);
  }

  if (roleFilter) {
    sql += ` AND u.role_id = ?`;
    params.push(roleFilter);
  }

  if (statusFilter && (statusFilter === "active" || statusFilter === "inactive")) {
    sql += ` AND u.status = ?`;
    params.push(statusFilter);
  }

  sql += ` ORDER BY u.id DESC`;

  const users = await query<UserRow>(sql, params);

  return {
    success: true,
    data: users,
  };
});
