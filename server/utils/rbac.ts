import { H3Event, createError } from "h3";
import { getAuthenticatedSession, AuthSessionUser } from "#server/utils/auth-session";
import { query } from "#server/utils/database";

export type RbacAction = "create" | "read" | "update" | "delete";
export type RbacScope = "all" | "own" | "no";

export interface PermissionRow {
  module_code: string;
  module_name: string;
  can_access: number;
  can_create: number;
  read_scope: RbacScope;
  update_scope: RbacScope;
  delete_scope: RbacScope;
}

export interface RbacAuthResult {
  sessionUser: AuthSessionUser;
  scope: RbacScope;
  canAccess: boolean;
}

/**
 * Validasi otorisasi user terhadap suatu modul & aksi.
 * Melempar error 403 Forbidden jika user tidak memiliki izin.
 */
export async function requirePermission(
  event: H3Event,
  moduleCode: string,
  action: RbacAction = "read",
): Promise<RbacAuthResult> {
  const session = await getAuthenticatedSession(event, { required: true });
  if (!session) {
    throw createError({
      statusCode: 401,
      statusMessage: "Unauthorized",
      message: "Silakan login terlebih dahulu untuk mengakses sumber daya ini.",
    });
  }

  const { user } = session;

  // Ambil permission modul untuk role user
  const permissions = await query<PermissionRow>(
    `SELECT m.code AS module_code, m.name AS module_name,
            rp.can_access, rp.can_create, rp.read_scope, rp.update_scope, rp.delete_scope
     FROM role_permissions rp
     JOIN modules m ON m.id = rp.module_id
     WHERE rp.role_id = ? AND m.code = ?
     LIMIT 1`,
    [user.role_id, moduleCode],
  );

  const perm = permissions[0];
  if (!perm || !perm.can_access) {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: `Anda tidak memiliki hak akses ke modul ${moduleCode}.`,
    });
  }

  let allowed = false;
  let scope: RbacScope = "no";

  switch (action) {
    case "create":
      allowed = Boolean(perm.can_create);
      scope = allowed ? "all" : "no";
      break;
    case "read":
      scope = perm.read_scope;
      allowed = scope !== "no";
      break;
    case "update":
      scope = perm.update_scope;
      allowed = scope !== "no";
      break;
    case "delete":
      scope = perm.delete_scope;
      allowed = scope !== "no";
      break;
  }

  if (!allowed || scope === "no") {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: `Anda tidak diizinkan melakukan aksi '${action}' pada modul ${moduleCode}.`,
    });
  }

  return {
    sessionUser: user,
    scope,
    canAccess: true,
  };
}

/**
 * Aturan Khusus: Superadmin dilarang menghapus akun dirinya sendiri
 */
export function assertNotSelfDelete(currentUserId: number, targetUserId: number) {
  if (Number(currentUserId) === Number(targetUserId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Anda tidak dapat menghapus akun Anda sendiri.",
    });
  }
}

/**
 * Aturan Khusus: Admin HRD dilarang menghapus data pegawai yang terasosiasi akun Superadmin
 */
export async function assertNotSuperadminEmployee(targetEmployeeId: number) {
  const superadminUsers = await query<any>(
    `SELECT u.id, u.username, r.code AS role_code
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE u.employee_id = ? AND r.code = 'superadmin'
     LIMIT 1`,
    [targetEmployeeId],
  );

  if (superadminUsers.length > 0) {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: "Data pegawai yang terasosiasi dengan akun Superadmin tidak dapat dihapus.",
    });
  }
}
