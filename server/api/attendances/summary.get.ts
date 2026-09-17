import { getQuery, createError } from "h3";
import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // RBAC: read permission on 'attendance' (Admin HRD & Manager HRD allowed)
  await requirePermission(event, "attendance", "read");

  const queryParams = getQuery(event);

  // Default N-1 bulan berjalan (1 bulan sebelum bulan sekarang)
  const now = new Date();
  let defaultYear = now.getFullYear();
  let defaultMonth = now.getMonth(); // 0-indexed: jika Sept (8), maka N-1 adalah Agustus (7), jadi defaultMonth = 8
  if (defaultMonth === 0) {
    defaultMonth = 12;
    defaultYear -= 1;
  }

  const year = parseInt(String(queryParams.year || defaultYear), 10);
  const month = parseInt(String(queryParams.month || defaultMonth), 10);
  const search = String(queryParams.search || "").trim();
  const page = Math.max(1, parseInt(String(queryParams.page || "1"), 10));
  const limit = Math.min(100, Math.max(1, parseInt(String(queryParams.limit || "10"), 10)));
  const offset = (page - 1) * limit;

  let whereSql = " WHERE e.deleted_at IS NULL AND e.status = 'active'";
  const params: any[] = [year, month];

  if (search) {
    whereSql += " AND (e.name LIKE ? OR e.nip LIKE ? OR p.name LIKE ?)";
    const searchParam = `%${search}%`;
    params.push(searchParam, searchParam, searchParam);
  }

  // Count total employees
  const countSql = `
    SELECT COUNT(*) AS total
    FROM employees e
    LEFT JOIN positions p ON p.id = e.position_id
    ${whereSql}
  `;
  const countRes = await query<any>(countSql, params.slice(2));
  const total = Number(countRes[0]?.total || 0);
  const totalPages = Math.ceil(total / limit) || 1;

  // Query summary per employee
  const dataSql = `
    SELECT 
      e.id AS employee_id,
      e.nip,
      e.name AS employee_name,
      p.name AS position_name,
      d.name AS department_name,
      COALESCE(s.hadir, 0) AS hadir,
      COALESCE(s.status_hadir, CASE WHEN COALESCE(s.hadir, 0) >= 20 THEN 'Terpenuhi' ELSE 'Tidak terpenuhi' END) AS status_hadir,
      COALESCE(s.cuti, 0) AS cuti,
      COALESCE(s.kuota_cuti, 12) AS kuota_cuti,
      COALESCE(s.izin, 0) AS izin,
      COALESCE(s.kuota_izin, 3) AS kuota_izin,
      COALESCE(s.unpaid_leave, 0) AS unpaid_leave,
      COALESCE(s.kuota_unpaid_leave, 5) AS kuota_unpaid_leave
    FROM employees e
    LEFT JOIN positions p ON p.id = e.position_id
    LEFT JOIN departments d ON d.id = e.department_id
    LEFT JOIN attendance_summaries s 
      ON s.employee_id = e.id AND s.period_year = ? AND s.period_month = ?
    ${whereSql}
    ORDER BY e.name ASC
    LIMIT ? OFFSET ?
  `;

  const rows = await query<any>(dataSql, [...params, limit, offset]);

  // Format 1 digit decimal untuk output sesuai spesifikasi
  const items = rows.map((row: any, idx: number) => ({
    no: offset + idx + 1,
    employeeId: row.employee_id,
    nip: row.nip,
    nama: row.employee_name,
    jabatan: row.position_name || "-",
    departemen: row.department_name || "-",
    hadir: Number(Number(row.hadir).toFixed(1)),
    statusHadir: row.status_hadir === "Terpenuhi" ? "Terpenuhi" : "Tidak terpenuhi",
    cuti: Number(Number(row.cuti).toFixed(1)),
    kuotaCuti: Number(Number(row.kuota_cuti).toFixed(1)),
    izin: Number(Number(row.izin).toFixed(1)),
    kuotaIzin: Number(Number(row.kuota_izin).toFixed(1)),
    unpaidLeave: Number(Number(row.unpaid_leave).toFixed(1)),
    kuotaUnpaidLeave: Number(Number(row.kuota_unpaid_leave).toFixed(1)),
  }));

  return {
    success: true,
    data: {
      period: {
        year,
        month,
      },
      items,
      pagination: {
        page,
        limit,
        total,
        totalPages,
      },
    },
  };
});
