import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export interface RoleDetailRow {
  id: number;
  code: string;
  name: string;
  description: string;
  created_at: string;
  updated_at: string;
}

export interface RolePermissionDetailRow {
  module_id: number;
  module_code: string;
  module_name: string;
  module_description: string;
  sort_order: number;
  can_access: number;
  can_create: number;
  read_scope: "all" | "own" | "no";
  update_scope: "all" | "own" | "no";
  delete_scope: "all" | "own" | "no";
}

export default defineEventHandler(async (event) => {
  // Hanya user dengan permission 'read' pada modul 'role' yang diizinkan (Superadmin)
  const auth = await requirePermission(event, "role", "read");

  const idParam = getRouterParam(event, "id");
  if (!idParam) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID role tidak valid.",
    });
  }

  // Cari data role berdasarkan id atau code
  const roleRows = await query<RoleDetailRow>(
    `SELECT id, code, name, description, created_at, updated_at
     FROM roles
     WHERE id = ? OR code = ?
     LIMIT 1`,
    [idParam, idParam],
  );

  if (roleRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: `Role dengan ID/Code '${idParam}' tidak ditemukan.`,
    });
  }

  const role = roleRows[0];

  // Ambil semua daftar modul beserta permission role ini
  const permissions = await query<RolePermissionDetailRow>(
    `SELECT m.id AS module_id, m.code AS module_code, m.name AS module_name,
            m.description AS module_description, m.sort_order,
            COALESCE(rp.can_access, 0) AS can_access,
            COALESCE(rp.can_create, 0) AS can_create,
            COALESCE(rp.read_scope, 'no') AS read_scope,
            COALESCE(rp.update_scope, 'no') AS update_scope,
            COALESCE(rp.delete_scope, 'no') AS delete_scope
     FROM modules m
     LEFT JOIN role_permissions rp ON rp.module_id = m.id AND rp.role_id = ?
     ORDER BY m.sort_order ASC, m.id ASC`,
    [role.id],
  );

  // Catat audit log activity read detail role
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "role",
    action: "read",
    description: `Melihat detail hak akses role '${role.name}' (${role.code})`,
    subjectType: "roles",
    subjectId: role.id,
  });

  return {
    success: true,
    data: {
      role,
      permissions,
    },
  };
});

