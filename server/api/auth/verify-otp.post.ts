import { readBody, createError } from "h3";
import { query, execute } from "#server/utils/database";
import {
  verifyOtpHash,
  generateSessionToken,
} from "#server/utils/auth-crypto";
import {
  getClientIp,
  getUserAgent,
  setSessionCookie,
  logActivity,
  INACTIVITY_TIMEOUT_MINUTES,
  REMEMBER_ME_DAYS,
} from "#server/utils/auth-session";

interface VerifyOtpRequestBody {
  otpTicket?: string;
  otp?: string;
  rememberMe?: boolean;
}

export default defineEventHandler(async (event) => {
  const body = await readBody<VerifyOtpRequestBody>(event);

  const otpTicket = (body?.otpTicket || "").trim();
  const otp = (body?.otp || "").trim();
  const rememberMe = Boolean(body?.rememberMe);

  if (!otpTicket) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Tiket OTP tidak valid atau hilang.",
    });
  }

  if (!otp || otp.length !== 4) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Kode OTP harus berupa 4 digit angka.",
    });
  }

  let parsedTicket: { otpId: number; userId: number; sentTo: string };
  try {
    parsedTicket = JSON.parse(
      Buffer.from(otpTicket, "base64url").toString("utf-8"),
    );
  } catch {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Format tiket OTP tidak valid.",
    });
  }

  // Cari data OTP di database
  const otps = await query<any>(
    `SELECT id, user_id, otp_hash, expires_at, verified_at, used_at
     FROM login_otps
     WHERE id = ? AND user_id = ?
     LIMIT 1`,
    [parsedTicket.otpId, parsedTicket.userId],
  );

  if (!otps || otps.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data OTP tidak ditemukan. Silakan login kembali.",
    });
  }

  const otpRecord = otps[0];

  if (otpRecord.used_at) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Kode OTP ini sudah digunakan. Silakan request kode OTP baru.",
    });
  }

  const now = new Date();
  const expiresAt = new Date(otpRecord.expires_at);

  if (now > expiresAt) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Kode OTP telah kedaluwarsa (berlaku 3 menit). Silakan kirim ulang OTP.",
    });
  }

  // Verifikasi hash OTP
  const isMatch = verifyOtpHash(otp, otpRecord.otp_hash);
  if (!isMatch) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Kode OTP yang Anda masukkan salah.",
    });
  }

  // Tandai OTP terverifikasi dan terpakai
  await execute(
    `UPDATE login_otps SET verified_at = NOW(), used_at = NOW() WHERE id = ?`,
    [otpRecord.id],
  );

  // Ambil profil user lengkap
  const users = await query<any>(
    `SELECT u.id, u.employee_id, u.role_id, u.name, u.username, u.email, u.cellphone,
            u.status, r.code AS role_code, r.name AS role_name,
            e.nip AS employee_nip, e.name AS employee_name,
            d.name AS department_name, p.name AS position_name
     FROM users u
     JOIN roles r ON r.id = u.role_id
     LEFT JOIN employees e ON e.id = u.employee_id
     LEFT JOIN departments d ON d.id = e.department_id
     LEFT JOIN positions p ON p.id = e.position_id
     WHERE u.id = ? AND u.deleted_at IS NULL
     LIMIT 1`,
    [parsedTicket.userId],
  );

  if (!users || users.length === 0 || users[0].status !== "active") {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: "Akun pengguna tidak aktif atau telah dihapus.",
    });
  }

  const user = users[0];
  const ip = getClientIp(event);
  const ua = getUserAgent(event);
  const sessionToken = generateSessionToken();

  // Hitung masa berlaku sesi
  const sessionDurationMs = rememberMe
    ? REMEMBER_ME_DAYS * 24 * 60 * 60 * 1000
    : INACTIVITY_TIMEOUT_MINUTES * 60 * 1000;
  const sessionExpiresAt = new Date(Date.now() + sessionDurationMs);

  // Buat session baru di database
  await execute(
    `INSERT INTO user_sessions (
      user_id, session_token, remember_me, ip_address, user_agent,
      last_activity_at, expires_at, created_at
    ) VALUES (?, ?, ?, ?, ?, NOW(), ?, NOW())`,
    [user.id, sessionToken, rememberMe ? 1 : 0, ip, ua, sessionExpiresAt],
  );

  // Update last_login_at di tabel users
  await execute(
    `UPDATE users SET last_login_at = NOW() WHERE id = ?`,
    [user.id],
  );

  // Simpan cookie sesi
  setSessionCookie(event, sessionToken, rememberMe);

  // Ambil daftar permissions untuk role pengguna
  const permissions = await query<any>(
    `SELECT m.code AS module_code, m.name AS module_name,
            rp.can_access, rp.can_create, rp.read_scope, rp.update_scope, rp.delete_scope
     FROM role_permissions rp
     JOIN modules m ON m.id = rp.module_id
     WHERE rp.role_id = ?
     ORDER BY m.sort_order ASC`,
    [user.role_id],
  );

  // Log activity
  await logActivity(event, {
    userId: user.id,
    moduleCode: "auth",
    action: "login",
    description: `User ${user.username} berhasil login dengan role ${user.role_code} (RememberMe: ${rememberMe})`,
    subjectType: "users",
    subjectId: user.id,
  });

  return {
    success: true,
    message: "Login berhasil! Sesi telah dibuat.",
    data: {
      token: sessionToken,
      tokenType: "Bearer",
      rememberMe,
      expiresAt: sessionExpiresAt.toISOString(),
      inactivityTimeoutMinutes: rememberMe ? null : INACTIVITY_TIMEOUT_MINUTES,
      user: {
        id: user.id,
        name: user.name,
        username: user.username,
        email: user.email,
        cellphone: user.cellphone,
        role: {
          id: user.role_id,
          code: user.role_code,
          name: user.role_name,
        },
        employee: user.employee_id
          ? {
              nip: user.employee_nip,
              name: user.employee_name,
              department: user.department_name,
              position: user.position_name,
            }
          : null,
      },
      permissions,
    },
  };
});
