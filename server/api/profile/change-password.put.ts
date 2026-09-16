import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { hashPassword, verifyPassword } from "#server/utils/auth-crypto";
import { createError, readBody } from "h3";

export default defineEventHandler(async (event) => {
  // Otorisasi RBAC: modul 'profile' action 'update'
  const auth = await requirePermission(event, "profile", "update");
  const currentUserId = auth.sessionUser.id;

  const body = await readBody(event);
  const { currentPassword, newPassword, confirmPassword } = body || {};

  // 1. Validasi Keberadaan Field
  if (!currentPassword) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password saat ini (current password) wajib diisi.",
    });
  }

  if (!newPassword) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru wajib diisi.",
    });
  }

  if (!confirmPassword) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Konfirmasi password baru wajib diisi.",
    });
  }

  // 2. Validasi Kesamaan Konfirmasi Password
  if (newPassword !== confirmPassword) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Konfirmasi password baru tidak cocok dengan password baru.",
    });
  }

  // 3. Validasi Aturan Password Baru:
  // - Minimal 8 karakter
  // - Tidak boleh ada spasi
  // - Minimal 1 huruf besar
  // - Minimal 1 huruf kecil
  // - Minimal 1 karakter khusus / simbol
  if (newPassword.length < 8) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru harus memiliki panjang minimal 8 karakter.",
    });
  }

  if (/\s/.test(newPassword)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru tidak boleh mengandung spasi.",
    });
  }

  if (!/[A-Z]/.test(newPassword)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru harus mengandung minimal 1 huruf besar.",
    });
  }

  if (!/[a-z]/.test(newPassword)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru harus mengandung minimal 1 huruf kecil.",
    });
  }

  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(newPassword)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru harus mengandung minimal 1 karakter khusus / simbol.",
    });
  }

  // 4. Ambil hash password pengguna saat ini dari database
  const users = await query<any>(
    "SELECT id, username, password FROM users WHERE id = ? AND deleted_at IS NULL LIMIT 1",
    [currentUserId],
  );

  if (!users || users.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Akun pengguna tidak ditemukan.",
    });
  }

  const currentUser = users[0];

  // 5. Verifikasi kecocokan currentPassword
  const isMatch = verifyPassword(currentPassword, currentUser.password);
  if (!isMatch) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password saat ini tidak sesuai.",
    });
  }

  // 6. Cek jika password baru sama dengan password lama
  if (verifyPassword(newPassword, currentUser.password)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password baru tidak boleh sama dengan password saat ini.",
    });
  }

  // 7. Hash password baru & update database
  const newHashedPassword = hashPassword(newPassword);
  await execute(
    "UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?",
    [newHashedPassword, currentUserId],
  );

  // 8. Catat audit activity log
  await logActivity(event, {
    userId: currentUserId,
    moduleCode: "profile",
    action: "update",
    description: `Mengubah password akun (${currentUser.username})`,
    subjectType: "users",
    subjectId: currentUserId,
  });

  return {
    success: true,
    message: "Password berhasil diperbarui.",
  };
});
