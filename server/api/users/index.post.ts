import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { hashPassword } from "#server/utils/auth-crypto";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  const auth = await requirePermission(event, "user", "create");
  const body = await readBody(event);

  const name = typeof body?.name === "string" ? body.name.trim() : "";
  const username = typeof body?.username === "string" ? body.username.trim().toLowerCase() : "";
  const password = typeof body?.password === "string" ? body.password : "";
  const roleId = Number(body?.roleId || body?.role_id);
  const employeeId = body?.employeeId || body?.employee_id ? Number(body.employeeId || body.employee_id) : null;
  const status = body?.status === "inactive" ? "inactive" : "active";

  // 1. Validasi Nama
  if (!name) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Nama pengguna wajib diisi.",
    });
  }

  // 2. Validasi Username: minimal 6 karakter, lowercase alfanumerik, tanpa spasi
  const usernameRegex = /^[a-z0-9]{6,}$/;
  if (!usernameRegex.test(username)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Username minimal 6 karakter, hanya boleh terdiri dari huruf kecil dan angka, tanpa spasi.",
    });
  }

  // Cek duplikasi username
  const existingUsername = await query(
    "SELECT id FROM users WHERE username = ? AND deleted_at IS NULL LIMIT 1",
    [username],
  );
  if (existingUsername.length > 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: `Username '${username}' sudah digunakan. Silakan gunakan username lain.`,
    });
  }

  // 3. Validasi Password: min 8 karakter, tanpa spasi, minimal 1 huruf besar, 1 huruf kecil, 1 simbol/karakter khusus
  if (!password || password.length < 8) {
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
  if (!/[A-Z]/.test(password)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password harus memiliki minimal 1 huruf besar (uppercase).",
    });
  }
  if (!/[a-z]/.test(password)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password harus memiliki minimal 1 huruf kecil (lowercase).",
    });
  }
  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Password harus memiliki minimal 1 karakter khusus / simbol.",
    });
  }

  // 4. Validasi Role
  if (!roleId || isNaN(roleId)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Role pengguna wajib dipilih.",
    });
  }
  const roleCheck = await query("SELECT id, name FROM roles WHERE id = ? LIMIT 1", [roleId]);
  if (roleCheck.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Role yang dipilih tidak valid.",
    });
  }

  // 5. Cek Pegawai jika employeeId diisi
  let email: string | null = null;
  let cellphone: string | null = null;
  if (employeeId) {
    const employeeCheck = await query<any>(
      "SELECT id, name, email, phone FROM employees WHERE id = ? AND deleted_at IS NULL LIMIT 1",
      [employeeId],
    );
    if (employeeCheck.length > 0) {
      email = employeeCheck[0].email || null;
      cellphone = employeeCheck[0].phone || null;
    }
  }

  // Hash password
  const hashedPassword = hashPassword(password);

  // Simpan ke database
  const insertResult = await execute(
    `INSERT INTO users (
      employee_id, role_id, name, username, email, cellphone, password, status, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())`,
    [employeeId, roleId, name, username, email, cellphone, hashedPassword, status],
  );

  const newUserId = Number(insertResult.insertId);

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "user",
    action: "create",
    description: `Membuat akun user baru '${username}' (${name}) dengan role '${roleCheck[0].name}'`,
    subjectType: "users",
    subjectId: newUserId,
    newValues: {
      id: newUserId,
      employee_id: employeeId,
      role_id: roleId,
      name,
      username,
      status,
    },
  });

  // Ambil data user yang baru dibuat
  const [createdUser] = await query<any>(
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
    [newUserId],
  );

  setResponseStatus(event, 201);
  return {
    success: true,
    message: "User baru berhasil ditambahkan.",
    data: createdUser,
  };
});
