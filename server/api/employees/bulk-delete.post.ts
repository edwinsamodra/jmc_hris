import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  // RBAC delete permission
  const auth = await requirePermission(event, "employee", "delete");

  const body = await readBody(event);
  if (!body || !Array.isArray(body.ids) || body.ids.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Daftar ID pegawai tidak boleh kosong.",
    });
  }

  const numericIds = body.ids.map(Number).filter((id) => !isNaN(id) && id > 0);
  if (numericIds.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID pegawai tidak valid.",
    });
  }

  const placeholders = numericIds.map(() => "?").join(",");

  // Check for any employee associated with superadmin user
  const superadminUsers = await query<any>(
    `SELECT u.id AS user_id, u.username, u.employee_id, e.name AS employee_name, e.nip
     FROM users u
     JOIN roles r ON r.id = u.role_id
     JOIN employees e ON e.id = u.employee_id
     WHERE u.employee_id IN (${placeholders}) AND r.code = 'superadmin'`,
    numericIds,
  );

  if (superadminUsers.length > 0) {
    const names = superadminUsers.map((u) => `'${u.employee_name}' (NIP: ${u.nip})`).join(", ");
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: `Tidak dapat menghapus pegawai yang terhubung dengan akun Superadmin: ${names}.`,
    });
  }

  // Soft delete all
  await execute(
    `UPDATE employees SET deleted_at = NOW(), updated_by = ? WHERE id IN (${placeholders}) AND deleted_at IS NULL`,
    [auth.sessionUser.id, ...numericIds],
  );

  // Audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "employee",
    action: "delete",
    description: `Menghapus massal ${numericIds.length} data pegawai (IDs: ${numericIds.join(", ")})`,
    subjectType: "employees",
    subjectId: numericIds[0],
    oldValues: {
      deleted_ids: numericIds,
    },
  });

  return {
    success: true,
    message: `${numericIds.length} data pegawai berhasil dihapus.`,
    data: {
      deletedIds: numericIds,
    },
  };
});
