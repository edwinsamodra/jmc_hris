import { readBody, createError } from "h3";
import { query, execute } from "#server/utils/database";
import { generateOtpCode, hashOtp } from "#server/utils/auth-crypto";
import { getClientIp, getUserAgent, logActivity } from "#server/utils/auth-session";

interface ResendOtpRequestBody {
  otpTicket?: string;
}

export default defineEventHandler(async (event) => {
  const body = await readBody<ResendOtpRequestBody>(event);
  const otpTicket = (body?.otpTicket || "").trim();

  if (!otpTicket) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Tiket OTP diperlukan untuk mengirim ulang.",
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

  // Ambil user
  const users = await query<any>(
    `SELECT u.id, u.name, u.username, u.email, u.status, r.code AS role_code
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE u.id = ? AND u.deleted_at IS NULL
     LIMIT 1`,
    [parsedTicket.userId],
  );

  if (!users || users.length === 0 || users[0].status !== "active") {
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: "Pengguna tidak aktif atau tidak ditemukan.",
    });
  }

  const user = users[0];
  const sentTo = user.email || user.username;
  const otpCode = generateOtpCode();
  const hashedOtp = hashOtp(otpCode);
  const ip = getClientIp(event);
  const ua = getUserAgent(event);
  const expiresAt = new Date(Date.now() + 3 * 60 * 1000);

  // Invalidate OTP lama
  await execute(
    `UPDATE login_otps SET used_at = NOW() WHERE user_id = ? AND used_at IS NULL`,
    [user.id],
  );

  // Insert OTP baru
  const insertResult = await execute(
    `INSERT INTO login_otps (
      user_id, otp_hash, channel, sent_to, expires_at, ip_address, user_agent, created_at
    ) VALUES (?, ?, 'email', ?, ?, ?, ?, NOW())`,
    [user.id, hashedOtp, sentTo, expiresAt, ip, ua],
  );

  const newOtpTicket = Buffer.from(
    JSON.stringify({
      otpId: Number(insertResult.insertId),
      userId: user.id,
      sentTo,
      timestamp: Date.now(),
    }),
  ).toString("base64url");

  await logActivity(event, {
    userId: user.id,
    moduleCode: "auth",
    action: "login",
    description: `Kirim ulang OTP login untuk user ${user.username}`,
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
    message: `Kode OTP baru 4-digit telah dikirimkan ke email ${sentTo}.`,
    data: {
      otpTicket: newOtpTicket,
      sentTo,
      expiresInSeconds: 180,
      otpPreview: process.env.NODE_ENV !== "production" ? otpCode : undefined,
    },
  };
});
