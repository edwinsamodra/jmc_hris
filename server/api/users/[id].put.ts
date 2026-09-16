import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { hashPassword } from "#server/utils/auth-crypto";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  const auth = await requirePermission(event, "user", "update");
  const idParam = getRouterParam(event, "id");
  const targetUserId = Number(idParam);

  if (!targetUserId || isNaN(targetUserId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID user tidak valid.",
    });
  }

  // Cek user yang akan diupdate
  const existingRows = await query<any>(
    "SELECT * FROM users WHERE id = ? AND deleted_at IS NULL LIMIT 1",
    [targetUserId],
  );
  if (existingRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data user tidak ditemukan.",
    });
  }
  const oldUser = existingRows[0];

  const body = await readBody(event);
  const name = typeof body?.name === "string" ? body.name.trim() : oldUser.name;
  const username = typeof body?.username === "string" ? body.username.trim().toLowerCase() : oldUser.username;
  const password = typeof body?.password === "string" ? body.password : "";
  const roleId = body?.roleId || body?.role_id ? Number(body.roleId || body.role_id) : oldUser.role_id;
  const employeeId = body?.employeeId !== undefined || body?.employee_id !== undefined
    ? (body.employeeId || body.employee_id ? Number(body.employeeId || body.employee_id) : null)
    : oldUser.employee_id;
  const status = body?.status === "inactive" ? "inactive" : body?.status === "active" ? "active" : oldUser.status;

  // 1. Validasi Nama
  if (!name) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Nama pengguna tidak boleh kosong.",
    });
  }

  // 2. Validasi Username jika berubah
  if (username !== oldUser.username) {
    const usernameRegex = /^[a-z0-9]{6,}$/;
    if (!usernameRegex.test(username)) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "Username minimal 6 karakter, hanya boleh terdiri dari huruf kecil dan angka, tanpa spasi.",
      });
    }

    const dupCheck = await query(
      "SELECT id FROM users WHERE username = ? AND id != ? AND deleted_at IS NULL LIMIT 1",
      [username, targetUserId],
    );
    if (dupCheck.length > 0) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: `Username '${username}' sudah digunakan user lain.`,
      });
    }
  }

  // 3. Validasi Password jika diisi
  let hashedPassword = oldUser.password;
  if (password) {
    if (password.length < 8) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "Password minimal 8 karakter.",
      });
    }
    if (/\s/.test(password)) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "Password tidak boleh mengandung spasi.",
      });
    }
    if (!/[A-Z]/.test(password) || !/[a-z]/.test(password) || !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "Password harus mengandung kombinasi huruf besar, huruf kecil, dan simbol.",
      });
    }
    hashedPassword = hashPassword(password);
  }

  // 4. Validasi Role
  const roleCheck = await query("SELECT id, name FROM roles WHERE id = ? LIMIT 1", [roleId]);
  if (roleCheck.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Role yang dipilih tidak valid.",
    });
  }

  // 5. Relasi Pegawai
  let email = oldUser.email;
  let cellphone = oldUser.cellphone;
  if (employeeId && employeeId !== oldUser.employee_id) {
    const empRows = await query<any>(
      "SELECT id, email, phone FROM employees WHERE id = ? AND deleted_at IS NULL LIMIT 1",
      [employeeId],
    );
    if (empRows.length > 0) {
      email = empRows[0].email || null;
      cellphone = empRows[0].phone || null;
    }
  }

  // Update ke database
  await execute(
    `UPDATE users
     SET employee_id = ?, role_id = ?, name = ?, username = ?, email = ?, cellphone = ?, password = ?, status = ?, updated_at = NOW()
     WHERE id = ?`,
    [employeeId, roleId, name, username, email, cellphone, hashedPassword, status, targetUserId],
  );

  // Jika status diubah menjadi inactive, invalidate seluruh sesi user tersebut
  if (status === "inactive") {
    await execute(
      "UPDATE user_sessions SET logged_out_at = NOW() WHERE user_id = ? AND logged_out_at IS NULL",
      [targetUserId],
    );
  }

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "user",
    action: "update",
    description: `Memperbarui data user '${username}' (ID: ${targetUserId})`,
    subjectType: "users",
    subjectId: targetUserId,
    oldValues: {
      name: oldUser.name,
      username: oldUser.username,
      role_id: oldUser.role_id,
      status: oldUser.status,
    },
    newValues: {
      name,
      username,
      role_id: roleId,
      status,
    },
  });

  // Ambil data terbaru
  const [updatedUser] = await query<any>(
    `SELECT 
      u.id, u.name, u.username, u.email, u.cellphone, u.status,
      u.role_id, r.code AS role_code, r.name AS role_name,
      u.employee_id, e.nip AS employee_nip, e.name AS employee_name,
      p.name AS position_name, d.name AS department_name,
      u.created_at, u.updated_at
    FROM users u
    JOIN roles r ON r.id = u.role_id
    LEFT JOIN employees e ON e.id = u.employee_id
    LEFT JOIN positions p ON p.id = e.position_id
    LEFT JOIN departments d ON d.id = e.department_id
    WHERE u.id = ?`,
    [targetUserId],
  );

  return {
    success: true,
    message: "Data user berhasil diperbarui.",
    data: updatedUser,
  };
});
