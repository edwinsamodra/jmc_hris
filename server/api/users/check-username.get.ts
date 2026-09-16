import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // Hanya user dengan hak create/update/read modul 'user' yang dapat memeriksa username
  await requirePermission(event, "user", "read");

  const urlQuery = getQuery(event);
  const username = typeof urlQuery.username === "string" ? urlQuery.username.trim().toLowerCase() : "";
  const excludeUserId = urlQuery.excludeUserId ? Number(urlQuery.excludeUserId) : null;

  if (!username) {
    return {
      success: true,
      available: false,
      message: "Username tidak boleh kosong.",
    };
  }

  let sql = `SELECT id FROM users WHERE username = ? AND deleted_at IS NULL`;
  const params: any[] = [username];

  if (excludeUserId) {
    sql += ` AND id != ?`;
    params.push(excludeUserId);
  }

  const existing = await query(sql, params);

  return {
    success: true,
    available: existing.length === 0,
    message: existing.length === 0 ? "Username tersedia." : "Username sudah digunakan.",
  };
});
