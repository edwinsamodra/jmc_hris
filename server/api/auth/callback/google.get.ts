import { getQuery, sendRedirect, createError, getRequestURL } from "h3";
import { query, execute } from "#server/utils/database";
import { generateSessionToken } from "#server/utils/auth-crypto";
import {
  getClientIp,
  getUserAgent,
  setSessionCookie,
  logActivity,
  INACTIVITY_TIMEOUT_MINUTES,
} from "#server/utils/auth-session";

interface GoogleTokenResponse {
  access_token: string;
  expires_in: number;
  token_type: string;
  scope: string;
  id_token: string;
}

interface GoogleUserInfo {
  id: string;
  email: string;
  verified_email: boolean;
  name: string;
  given_name?: string;
  family_name?: string;
  picture?: string;
}

export default defineEventHandler(async (event) => {
  const queryParams = getQuery(event);
  const code = queryParams.code as string;
  const error = queryParams.error as string;

  if (error) {
    return sendRedirect(event, `/login?error=${encodeURIComponent(`Google Auth Error: ${error}`)}`);
  }

  if (!code) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Authorization code dari Google tidak ditemukan.",
    });
  }

  const clientId = (process.env.CLIENT_ID || "").replace(/^"|"$/g, "").trim();
  const clientSecret = (process.env.CLIENT_SECRET || "").replace(/^"|"$/g, "").trim();

  if (!clientId || !clientSecret) {
    throw createError({
      statusCode: 500,
      statusMessage: "Internal Server Error",
      message: "CLIENT_ID atau CLIENT_SECRET belum dikonfigurasi.",
    });
  }

  const reqUrl = getRequestURL(event);
  const redirectUri = `${reqUrl.origin}/api/auth/callback/google`;

  // 1. Tukar auth code dengan access token
  let tokenData: GoogleTokenResponse;
  try {
    const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: new URLSearchParams({
        code,
        client_id: clientId,
        client_secret: clientSecret,
        redirect_uri: redirectUri,
        grant_type: "authorization_code",
      }).toString(),
    });

    if (!tokenRes.ok) {
      const errText = await tokenRes.text();
      console.error("[Google OAuth Token Error]", errText);
      return sendRedirect(event, `/login?error=${encodeURIComponent("Gagal menukar token dengan Google.")}`);
    }

    tokenData = (await tokenRes.json()) as GoogleTokenResponse;
  } catch (err: any) {
    console.error("[Google OAuth Network Error]", err);
    return sendRedirect(event, `/login?error=${encodeURIComponent("Terjadi kendala koneksi ke Google.")}`);
  }

  // 2. Ambil user profile dari Google
  let googleUser: GoogleUserInfo;
  try {
    const userInfoRes = await fetch("https://www.googleapis.com/oauth2/v2/userinfo", {
      headers: {
        Authorization: `Bearer ${tokenData.access_token}`,
      },
    });

    if (!userInfoRes.ok) {
      return sendRedirect(event, `/login?error=${encodeURIComponent("Gagal mengambil profil akun Google.")}`);
    }

    googleUser = (await userInfoRes.json()) as GoogleUserInfo;
  } catch (err: any) {
    return sendRedirect(event, `/login?error=${encodeURIComponent("Gagal menghubungi Google UserInfo API.")}`);
  }

  const email = googleUser.email;
  if (!email) {
    return sendRedirect(event, `/login?error=${encodeURIComponent("Email tidak ditemukan pada akun Google Anda.")}`);
  }

  // 3. Cocokkan email pengguna dengan tabel users di database
  const users = await query<any>(
    `SELECT u.id, u.employee_id, u.role_id, u.name, u.username, u.email, u.status,
            r.code AS role_code, r.name AS role_name
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE u.email = ? AND u.deleted_at IS NULL
     LIMIT 1`,
    [email],
  );

  if (!users || users.length === 0) {
    return sendRedirect(
      event,
      `/login?error=${encodeURIComponent(`Akun Google (${email}) belum terdaftar di sistem HRIS. Silakan hubungi Administrator.`)}`,
    );
  }

  const user = users[0];

  if (user.status !== "active") {
    return sendRedirect(
      event,
      `/login?error=${encodeURIComponent("Akun HRIS Anda berstatus nonaktif. Silakan hubungi Administrator.")}`,
    );
  }

  // 4. Buat sesi login HRIS
  const ip = getClientIp(event);
  const ua = getUserAgent(event);
  const sessionToken = generateSessionToken();
  const sessionExpiresAt = new Date(Date.now() + INACTIVITY_TIMEOUT_MINUTES * 60 * 1000);

  await execute(
    `INSERT INTO user_sessions (
      user_id, session_token, remember_me, ip_address, user_agent,
      last_activity_at, expires_at, created_at
    ) VALUES (?, ?, 0, ?, ?, NOW(), ?, NOW())`,
    [user.id, sessionToken, ip, ua, sessionExpiresAt],
  );

  await execute(`UPDATE users SET last_login_at = NOW() WHERE id = ?`, [user.id]);

  // Set HTTP-only cookie
  setSessionCookie(event, sessionToken, false);

  // Catat activity log
  await logActivity(event, {
    userId: user.id,
    moduleCode: "auth",
    action: "login",
    description: `User ${user.username} (${user.name}) berhasil login via Google OAuth (${email})`,
    subjectType: "users",
    subjectId: user.id,
  });

  // Redirect ke halaman dashboard aplikasi
  return sendRedirect(event, "/");
});
