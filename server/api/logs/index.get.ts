import { getQuery } from "h3";
import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // Otorisasi RBAC: require 'read' on 'activity_log'
  await requirePermission(event, "activity_log", "read");

  const queryParams = getQuery(event);
  const search = String(queryParams.search || "").trim();
  const moduleCode = String(queryParams.module || "").trim();
  const action = String(queryParams.action || "").trim();
  const page = Math.max(1, Number(queryParams.page) || 1);
  const limit = Math.min(100, Math.max(1, Number(queryParams.limit) || 10));
  const offset = (page - 1) * limit;

  let whereSql = " WHERE 1=1";
  const params: any[] = [];

  if (search) {
    whereSql += ` AND (l.description LIKE ? OR u.name LIKE ? OR u.username LIKE ? OR l.ip_address LIKE ?)`;
    const searchParam = `%${search}%`;
    params.push(searchParam, searchParam, searchParam, searchParam);
  }

  if (moduleCode) {
    whereSql += ` AND l.module_code = ?`;
    params.push(moduleCode);
  }

  if (action) {
    whereSql += ` AND l.action = ?`;
    params.push(action);
  }

  // Total count
  const countRes = await query<any>(
    `SELECT COUNT(*) AS total
     FROM activity_logs l
     LEFT JOIN users u ON u.id = l.user_id
     ${whereSql}`,
    [...params],
  );

  const total = Number(countRes[0]?.total || 0);
  const totalPages = Math.ceil(total / limit) || 1;

  // Data rows
  const rows = await query<any>(
    `SELECT l.id, l.user_id, l.module_code, l.action, l.description,
            l.subject_type, l.subject_id, l.ip_address, l.user_agent,
            l.url, l.method, l.created_at,
            u.username, u.name AS user_name, u.email AS user_email,
            r.name AS role_name, r.code AS role_code
     FROM activity_logs l
     LEFT JOIN users u ON u.id = l.user_id
     LEFT JOIN roles r ON r.id = u.role_id
     ${whereSql}
     ORDER BY l.created_at DESC, l.id DESC
     LIMIT ? OFFSET ?`,
    [...params, limit, offset],
  );

  return {
    success: true,
    data: {
      items: rows,
      pagination: {
        page,
        limit,
        total,
        totalPages,
      },
    },
  };
});
