import { execute } from "#server/utils/database";
import {
  getAuthenticatedSession,
  clearSessionCookie,
  logActivity,
} from "#server/utils/auth-session";

export default defineEventHandler(async (event) => {
  const session = await getAuthenticatedSession(event, { required: false });

  if (session) {
    // Tandai session sebagai logged out di database
    await execute(
      `UPDATE user_sessions SET logged_out_at = NOW() WHERE session_token = ?`,
      [session.sessionToken],
    );

    // Update last_logout_at pada users
    await execute(
      `UPDATE users SET last_logout_at = NOW() WHERE id = ?`,
      [session.user.id],
    );

    // Catat activity log logout
    await logActivity(event, {
      userId: session.user.id,
      moduleCode: "auth",
      action: "logout",
      description: `User ${session.user.username} telah logout`,
      subjectType: "users",
      subjectId: session.user.id,
    });
  }

  // Hapus cookie sesi
  clearSessionCookie(event);

  return {
    success: true,
    message: "Logout berhasil.",
  };
});
