import { query } from "#server/utils/database";
import { getAuthenticatedSession } from "#server/utils/auth-session";

export default defineEventHandler(async (event) => {
  const session = await getAuthenticatedSession(event, { required: true });

  if (!session) {
    return null;
  }

  // Ambil data permissions modul untuk role user
  const permissions = await query<any>(
    `SELECT m.code AS module_code, m.name AS module_name, m.description AS module_description,
            rp.can_access, rp.can_create, rp.read_scope, rp.update_scope, rp.delete_scope
     FROM role_permissions rp
     JOIN modules m ON m.id = rp.module_id
     WHERE rp.role_id = ?
     ORDER BY m.sort_order ASC`,
    [session.user.role_id],
  );

  return {
    success: true,
    data: {
      user: session.user,
      session: {
        rememberMe: session.rememberMe,
        expiresAt: session.expiresAt.toISOString(),
      },
      permissions,
    },
  };
});
