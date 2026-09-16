import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  await requirePermission(event, "user", "read");

  const idParam = getRouterParam(event, "id");
  if (!idParam) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID user tidak valid.",
    });
  }

  const users = await query<any>(
    `SELECT 
      u.id, u.name, u.username, u.email, u.cellphone, u.status,
      u.role_id, r.code AS role_code, r.name AS role_name,
      u.employee_id, e.nip AS employee_nip, e.name AS employee_name,
      p.id AS position_id, p.name AS position_name,
      d.id AS department_id, d.name AS department_name,
      u.created_at, u.updated_at
    FROM users u
    JOIN roles r ON r.id = u.role_id
    LEFT JOIN employees e ON e.id = u.employee_id
    LEFT JOIN positions p ON p.id = e.position_id
    LEFT JOIN departments d ON d.id = e.department_id
    WHERE u.id = ? AND u.deleted_at IS NULL
    LIMIT 1`,
    [idParam],
  );

  if (users.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: `User dengan ID '${idParam}' tidak ditemukan.`,
    });
  }

  return {
    success: true,
    data: users[0],
  };
});
