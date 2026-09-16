import { query, execute } from "#server/utils/database";
import { requirePermission, assertNotSelfDelete } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  const auth = await requirePermission(event, "user", "delete");
  const idParam = getRouterParam(event, "id");
  const targetUserId = Number(idParam);

  if (!targetUserId || isNaN(targetUserId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID user tidak valid.",
    });
  }

  // 1. Proteksi Khusus: Dilarang menghapus akun diri sendiri
  assertNotSelfDelete(auth.sessionUser.id, targetUserId);

  // Cek apakah user ada
  const existingRows = await query<any>(
    "SELECT id, name, username, role_id FROM users WHERE id = ? AND deleted_at IS NULL LIMIT 1",
    [targetUserId],
  );

  if (existingRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "User tidak ditemukan atau sudah dihapus.",
    });
  }

  const userToDelete = existingRows[0];

  // Soft delete user
  await execute("UPDATE users SET deleted_at = NOW() WHERE id = ?", [targetUserId]);

  // Invalidate all active sessions for this user
  await execute(
    "UPDATE user_sessions SET logged_out_at = NOW() WHERE user_id = ? AND logged_out_at IS NULL",
    [targetUserId],
  );

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "user",
    action: "delete",
    description: `Menghapus user '${userToDelete.username}' (${userToDelete.name}, ID: ${targetUserId})`,
    subjectType: "users",
    subjectId: targetUserId,
    oldValues: {
      id: userToDelete.id,
      name: userToDelete.name,
      username: userToDelete.username,
      role_id: userToDelete.role_id,
    },
  });

  return {
    success: true,
    message: `User '${userToDelete.username}' berhasil dihapus.`,
  };
});
