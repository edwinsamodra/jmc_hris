import { defineEventHandler, getQuery, createError } from "h3";
import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";

const MONTH_NAMES = [
  "",
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
];

export default defineEventHandler(async (event) => {
  // Validasi RBAC
  const { sessionUser } = await requirePermission(event, "transport_allowance", "read");

  const id = Number(event.context.params?.id);
  if (!id || isNaN(id)) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID periode tidak valid.",
    });
  }

  // Ambil metadata periode
  const periodRows = await query<any>(
    `SELECT p.id, p.period_year, p.period_month, p.total_recipients, p.total_amount, p.status,
            p.calculated_at, u.name AS calculated_by_name
     FROM transport_allowance_periods p
     LEFT JOIN users u ON u.id = p.calculated_by
     WHERE p.id = ?
     LIMIT 1`,
    [id]
  );

  if (periodRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Periode tunjangan transport tidak ditemukan.",
    });
  }

  const period = periodRows[0];
  const monthName = MONTH_NAMES[period.period_month] || `Bulan ${period.period_month}`;

  // Ambil parameter filter, sorting, dan pagination
  const queryParams = getQuery(event);
  const search = queryParams.search ? String(queryParams.search).trim() : "";
  const sortBy = String(queryParams.sort_by || "name").toLowerCase(); // name, km, hari, nominal
  const sortDir = String(queryParams.sort_dir || "asc").toLowerCase() === "desc" ? "DESC" : "ASC";
  const page = Math.max(1, Number(queryParams.page) || 1);
  const limit = Math.max(1, Math.min(100, Number(queryParams.limit) || 20));
  const offset = (page - 1) * limit;

  // Bangun query detail penerima
  let whereClauses = ["d.transport_allowance_period_id = ?"];
  let sqlParams: any[] = [id];

  if (search) {
    whereClauses.push("(e.name LIKE ? OR e.nip LIKE ?)");
    sqlParams.push(`%${search}%`, `%${search}%`);
  }

  // Mapping kolom sort
  let orderColumn = "e.name";
  if (sortBy === "km" || sortBy === "rounded_km") {
    orderColumn = "d.rounded_km";
  } else if (sortBy === "hari" || sortBy === "attendance_days") {
    orderColumn = "d.attendance_days";
  } else if (sortBy === "nominal") {
    orderColumn = "d.nominal";
  }

  // Hitung total data
  const countRows = await query<{ total: number }>(
    `SELECT COUNT(*) AS total
     FROM transport_allowance_details d
     JOIN employees e ON e.id = d.employee_id
     WHERE ${whereClauses.join(" AND ")}`,
    sqlParams
  );
  const total = Number(countRows[0]?.total || 0);

  // Ambil list detail penerima
  const details = await query<any>(
    `SELECT d.id, d.employee_id, e.nip, e.name AS employee_name, e.employment_type,
            d.base_fare, d.original_km, d.rounded_km, d.effective_km, d.attendance_days,
            d.nominal, d.eligibility_status, d.calculation_note, d.created_at
     FROM transport_allowance_details d
     JOIN employees e ON e.id = d.employee_id
     WHERE ${whereClauses.join(" AND ")}
     ORDER BY ${orderColumn} ${sortDir}
     LIMIT ? OFFSET ?`,
    [...sqlParams, limit, offset]
  );

  // Catat activity log
  await logActivity(event, {
    action: "read",
    module: "transport_allowance",
    details: `Melihat detail tunjangan transport periode ${monthName} ${period.period_year} (ID: ${id})`,
  });

  return {
    success: true,
    data: {
      period: {
        id: Number(period.id),
        period_year: Number(period.period_year),
        period_month: Number(period.period_month),
        month_name: monthName,
        period_label: `Bulan ${monthName} ${period.period_year}`,
        total_recipients: Number(period.total_recipients || 0),
        total_amount: Number(period.total_amount || 0),
        status: period.status || "draft",
        calculated_at: period.calculated_at,
        calculated_by_name: period.calculated_by_name || null,
      },
      recipients: details.map((d, index) => ({
        no: offset + index + 1,
        id: Number(d.id),
        employee_id: Number(d.employee_id),
        nip: d.nip,
        name: d.employee_name,
        employment_type: d.employment_type,
        base_fare: Number(d.base_fare),
        original_km: Number(d.original_km),
        km: Number(d.rounded_km),
        effective_km: Number(d.effective_km),
        hari: Number(d.attendance_days),
        nominal: Number(d.nominal),
        eligibility_status: d.eligibility_status,
        calculation_note: d.calculation_note,
      })),
    },
    meta: {
      total,
      page,
      limit,
      total_pages: Math.ceil(total / limit) || 1,
      sort_by: sortBy,
      sort_dir: sortDir.toLowerCase(),
    },
  };
});
