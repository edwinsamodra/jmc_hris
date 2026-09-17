import { defineEventHandler, getQuery } from "h3";
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
  // Validasi RBAC: Manager HRD & Admin HRD dapat membaca periode tunjangan
  const { sessionUser } = await requirePermission(event, "transport_allowance", "read");

  const queryParams = getQuery(event);
  const yearParam = queryParams.year ? Number(queryParams.year) : null;
  const search = queryParams.search ? String(queryParams.search).trim().toLowerCase() : "";
  const page = Math.max(1, Number(queryParams.page) || 1);
  const limit = Math.max(1, Math.min(100, Number(queryParams.limit) || 12));
  const offset = (page - 1) * limit;

  let whereClauses: string[] = [];
  let sqlParams: any[] = [];

  if (yearParam && !isNaN(yearParam)) {
    whereClauses.push("p.period_year = ?");
    sqlParams.push(yearParam);
  }

  const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(" AND ")}` : "";

  // Query data periode dari database
  const rows = await query<any>(
    `SELECT p.id, p.period_year, p.period_month, p.total_recipients, p.total_amount, p.status,
            p.calculated_at, u.name AS calculated_by_name
     FROM transport_allowance_periods p
     LEFT JOIN users u ON u.id = p.calculated_by
     ${whereSql}
     ORDER BY p.period_year DESC, p.period_month DESC`,
    sqlParams
  );

  // Ambil daftar tahun yang tersedia untuk filter dropdown
  const availableYearsRows = await query<{ period_year: number }>(
    `SELECT DISTINCT period_year FROM transport_allowance_periods ORDER BY period_year DESC`
  );

  let availableYears = availableYearsRows.map((r) => Number(r.period_year));
  const currentYear = new Date().getFullYear();
  if (!availableYears.includes(currentYear)) {
    availableYears = [currentYear, ...availableYears];
  }

  // Format data dan filter search nama bulan / status
  let formattedData = rows.map((item) => {
    const monthName = MONTH_NAMES[item.period_month] || `Bulan ${item.period_month}`;
    return {
      id: Number(item.id),
      period_year: Number(item.period_year),
      period_month: Number(item.period_month),
      month_name: monthName,
      period_label: `${monthName} ${item.period_year}`,
      total_recipients: Number(item.total_recipients || 0),
      total_amount: Number(item.total_amount || 0),
      status: item.status || "draft",
      calculated_at: item.calculated_at,
      calculated_by_name: item.calculated_by_name || null,
    };
  });

  if (search) {
    formattedData = formattedData.filter((item) =>
      item.month_name.toLowerCase().includes(search) ||
      item.period_label.toLowerCase().includes(search) ||
      String(item.period_year).includes(search) ||
      item.status.toLowerCase().includes(search)
    );
  }

  const total = formattedData.length;
  const paginatedData = formattedData.slice(offset, offset + limit);

  // Catat activity log
  await logActivity(event, {
    action: "read",
    module: "transport_allowance",
    details: `Melihat daftar periode tunjangan transport (tahun: ${yearParam || "semua"})`,
  });

  return {
    success: true,
    data: paginatedData,
    meta: {
      total,
      page,
      limit,
      total_pages: Math.ceil(total / limit) || 1,
      available_years: availableYears,
    },
  };
});
