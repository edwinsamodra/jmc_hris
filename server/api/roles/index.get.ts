import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";

export interface RoleRow {
  id: number;
  code: string;
  name: string;
  description: string;
  created_at: string;
  updated_at: string;
}

export default defineEventHandler(async (event) => {
  // Hanya user dengan permission 'read' pada modul 'role' yang diizinkan (Superadmin)
  const auth = await requirePermission(event, "role", "read");

  const urlQuery = getQuery(event);
  const search = typeof urlQuery.q === "string" ? urlQuery.q.trim() : "";

  let sql = `
    SELECT id, code, name, description, created_at, updated_at
    FROM roles
  `;
  const params: any[] = [];

  if (search) {
    sql += ` WHERE name LIKE ? OR description LIKE ? OR code LIKE ?`;
    params.push(`%${search}%`, `%${search}%`, `%${search}%`);
  }

  sql += ` ORDER BY id ASC`;

  const roles = await query<RoleRow>(sql, params);

  // Catat audit log activity read role list
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "role",
    action: "read",
    description: `Melihat daftar role pengguna${search ? ` (filter: "${search}")` : ""}`,
    subjectType: "roles",
  });

  return {
    success: true,
    data: roles,
  };
});

