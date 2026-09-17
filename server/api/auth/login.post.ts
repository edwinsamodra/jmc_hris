import { readBody, createError } from "h3";
import { query, execute } from "#server/utils/database";
import {
  verifyPassword,
  generateOtpCode,
  hashOtp,
} from "#server/utils/auth-crypto";
import { getClientIp, getUserAgent, logActivity } from "#server/utils/auth-session";
import { verifyRecaptcha } from "#server/utils/recaptcha";

interface LoginRequestBody {
  identifier?: string; // username / email / cellphone
  username?: string;   // alias from form
  password?: string;
  captcha?: string;
  "g-recaptcha-response"?: string;
}

export default defineEventHandler(async (event) => {
  const body = await readBody<LoginRequestBody>(event);

  const identifier = (body?.identifier || body?.username || "").trim();
  const password = (body?.password || "").trim();
  const captcha = (body?.["g-recaptcha-response"] || body?.captcha || "").trim();

  // Validasi input
  if (!identifier) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Username / Email / Nomor HP wajib diisi.",
    });
  }

  if (!password) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Password wajib diisi.",
    });
  }

  // Validasi reCAPTCHA Google
  const recaptchaCheck = await verifyRecaptcha(captcha);
  if (!recaptchaCheck.success) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: recaptchaCheck.message || "Verifikasi reCAPTCHA tidak valid.",
    });
  }

  // Cari user berdasarkan username ATAU email ATAU cellphone
  const users = await query<any>(
    `SELECT u.id, u.employee_id, u.role_id, u.name, u.username, u.email, u.cellphone,
            u.password, u.status, r.code AS role_code, r.name AS role_name
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE (u.username = ? OR u.email = ? OR u.cellphone = ?)
       AND u.deleted_at IS NULL
     LIMIT 1`,
    [identifier, identifier, identifier],
  );

  if (!users || users.length === 0) {
    throw createError({
      statusCode: 401,
      statusMessage: "Unauthorized",
      message: "Kredensial yang Anda masukkan salah atau akun tidak ditemukan.",
    });
  }

  const user = users[0];

  // Periksa status akun
  if (user.status !== "active") {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: "Akun Anda berstatus nonaktif. Silakan hubungi Administrator.",
    });
  }

  // Verifikasi password
  const isPasswordValid = verifyPassword(password, user.password);
  if (!isPasswordValid) {
    throw createError({
      statusCode: 401,
      statusMessage: "Unauthorized",
      message: "Kredensial yang Anda masukkan salah atau password keliru.",
    });
  }

  // Target pengiriman OTP
  const sentTo = user.email || user.username;
  const otpCode = generateOtpCode(); // 4 digit OTP
  const hashedOtp = hashOtp(otpCode);
  const ip = getClientIp(event);
  const ua = getUserAgent(event);

  // Waktu berlaku: 3 menit
  const expiresAt = new Date(Date.now() + 3 * 60 * 1000);

  // Nonaktifkan/hapus OTP lama yang belum terpakai untuk user ini
  await execute(
    `UPDATE login_otps SET used_at = NOW() WHERE user_id = ? AND used_at IS NULL`,
    [user.id],
  );

  // Simpan OTP ke database
  const insertResult = await execute(
    `INSERT INTO login_otps (
      user_id, otp_hash, channel, sent_to, expires_at, ip_address, user_agent, created_at
    ) VALUES (?, ?, 'email', ?, ?, ?, ?, NOW())`,
    [user.id, hashedOtp, sentTo, expiresAt, ip, ua],
  );

  const otpTicket = Buffer.from(
    JSON.stringify({
      otpId: Number(insertResult.insertId),
      userId: user.id,
      sentTo,
      timestamp: Date.now(),
    }),
  ).toString("base64url");

  // Log activity
  await logActivity(event, {
    userId: user.id,
    moduleCode: "auth",
    action: "login",
    description: `Request OTP login untuk user ${user.username} (${user.role_name})`,
    subjectType: "users",
    subjectId: user.id,
  });

  // Kirim email OTP via Gmail SMTP (Nodemailer)
  await sendOtpEmail({
    to: sentTo,
    name: user.name,
    otpCode,
    expiresInMinutes: 3,
  });

  return {
    success: true,
    message: `Kode OTP 4-digit telah dikirimkan ke email ${sentTo}. Berlaku selama 3 menit.`,
    data: {
      otpTicket,
      sentTo,
      expiresInSeconds: 180,
      otpPreview: otpCode,
      user: {
        id: user.id,
        name: user.name,
        username: user.username,
        role: user.role_code,
      },
    },
  };
});
