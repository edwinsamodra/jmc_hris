import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

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
  await requirePermission(event, "role", "read");

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

  return {
    success: true,
    data: roles,
  };
});
