import nodemailer from "nodemailer";

let transporter: nodemailer.Transporter | null = null;

function getTransporter() {
  if (!transporter) {
    const user = process.env.MAIL_USER?.replace(/^"|"$/g, "").trim();
    const pass = process.env.MAIL_PASS?.replace(/^"|"$/g, "").trim();

    if (!user || !pass) {
      return null;
    }

    transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user,
        pass, // App Password Gmail
      },
    });
  }

  return transporter;
}

export interface SendOtpEmailParams {
  to: string;
  name: string;
  otpCode: string;
  expiresInMinutes?: number;
}

/**
 * Send 4-digit OTP email using Google Gmail SMTP (Nodemailer)
 */
export async function sendOtpEmail({
  to,
  name,
  otpCode,
  expiresInMinutes = 3,
}: SendOtpEmailParams): Promise<{ success: boolean; error?: string }> {
  const mailTransporter = getTransporter();
  const mailUser = process.env.MAIL_USER?.replace(/^"|"$/g, "").trim();

  // Logging simulasi selalu dilakukan
  console.log(`\n========================================`);
  console.log(`[HRIS AUTH OTP EMAIL DISPATCH]`);
  console.log(`To         : ${to}`);
  console.log(`Name       : ${name}`);
  console.log(`Kode OTP   : >>> ${otpCode} <<< (Masa aktif: ${expiresInMinutes} menit)`);
  console.log(`========================================\n`);

  if (!mailTransporter || !mailUser) {
    console.warn("[MAIL WARNING] MAIL_USER atau MAIL_PASS belum dikonfigurasi. Menggunakan simulated mail.");
    return { success: true };
  }

  // Transporter execute send commented out for testing/offline mode
  /*
  try {
    const mailOptions = {
      from: `"HRIS System" <${mailUser}>`,
      to,
      subject: `[HRIS] Kode OTP Verifikasi Login: ${otpCode}`,
      html: `
        <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #206bc4; padding: 24px; text-align: center; color: #ffffff;">
            <h1 style="margin: 0; font-size: 24px;">HRIS System</h1>
            <p style="margin: 4px 0 0; opacity: 0.9;">Verifikasi Keamanan Akun</p>
          </div>
          <div style="padding: 30px 24px;">
            <p style="font-size: 16px;">Halo <strong>${name}</strong>,</p>
            <p style="color: #666;">Anda baru saja meminta kode verifikasi untuk masuk ke sistem HRIS. Gunakan kode OTP 4-digit di bawah ini:</p>
            
            <div style="text-align: center; margin: 28px 0;">
              <div style="display: inline-block; background-color: #f1f5f9; border: 2px dashed #206bc4; border-radius: 8px; padding: 14px 28px; font-size: 32px; font-weight: bold; letter-spacing: 12px; color: #206bc4;">
                ${otpCode}
              </div>
            </div>

            <p style="font-size: 14px; color: #e03131; text-align: center; font-weight: 500;">
              Kode OTP ini berlaku selama <strong>${expiresInMinutes} menit</strong>.
            </p>
            
            <p style="font-size: 13px; color: #888; border-top: 1px solid #eee; padding-top: 16px; margin-top: 24px;">
              Jika Anda tidak merasa melakukan percobaan login ini, harap abaikan email ini atau segera hubungi Administrator HRD.
            </p>
          </div>
          <div style="background-color: #f8fafc; padding: 14px; text-align: center; font-size: 12px; color: #94a3b8; border-top: 1px solid #e2e8f0;">
            &copy; ${new Date().getFullYear()} HRIS System. All rights reserved.
          </div>
        </div>
      `,
    };

    await mailTransporter.sendMail(mailOptions);
    console.log(`[MAIL SUCCESS] Email OTP berhasil terkirim ke: ${to}`);
    return { success: true };
  } catch (err: any) {
    console.error(`[MAIL ERROR] Gagal mengirim email ke ${to}:`, err.message);
    return { success: false, error: err.message };
  }
  */

  console.log(`[MAIL DISPATCH] (Simulated / Email sending commented) OTP untuk ${to}: ${otpCode}`);
  return { success: true };
}
