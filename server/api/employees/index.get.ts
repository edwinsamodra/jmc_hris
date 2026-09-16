import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { createError } from "h3";

function calculateTenure(joinedAt: string | Date | null): { years: number; months: number; text: string } {
  if (!joinedAt) return { years: 0, months: 0, text: "-" };
  const joinDate = new Date(joinedAt);
  if (isNaN(joinDate.getTime())) return { years: 0, months: 0, text: "-" };

  const today = new Date();
  let years = today.getFullYear() - joinDate.getFullYear();
  let months = today.getMonth() - joinDate.getMonth();

  if (today.getDate() < joinDate.getDate()) {
    months--;
  }

  if (months < 0) {
    years--;
    months += 12;
  }

  if (years < 0) {
    years = 0;
    months = 0;
  }

  const textParts: string[] = [];
  if (years > 0) textParts.push(`${years} Tahun`);
  if (months > 0 || textParts.length === 0) textParts.push(`${months} Bulan`);

  return {
    years,
    months,
    text: textParts.join(" "),
  };
}

export default defineEventHandler(async (event) => {
  // 1. RBAC Check (Readonly for manager_hrd, full read for admin_hrd)
  await requirePermission(event, "employee", "read");

  const queryParams = getQuery(event);
  const page = Math.max(1, parseInt(String(queryParams.page || "1"), 10) || 1);
  const perPage = Math.min(100, Math.max(1, parseInt(String(queryParams.perPage || queryParams.limit || "10"), 10) || 10));
  const offset = (page - 1) * perPage;

  const search = String(queryParams.search || "").trim();
  const positionFilter = queryParams.position || queryParams.positions;
  const employmentType = String(queryParams.employmentType || queryParams.contractType || "").trim();
  const status = String(queryParams.status || "").trim();
  const minTenure = queryParams.minTenure !== undefined && queryParams.minTenure !== "" ? Number(queryParams.minTenure) : null;
  const maxTenure = queryParams.maxTenure !== undefined && queryParams.maxTenure !== "" ? Number(queryParams.maxTenure) : null;

  const sortBy = String(queryParams.sortBy || "id").trim();
  const sortOrder = String(queryParams.sortOrder || "desc").toLowerCase() === "asc" ? "ASC" : "DESC";

  // Build WHERE conditions
  const whereClauses: string[] = ["e.deleted_at IS NULL"];
  const params: any[] = [];

  // Search by nama, nip, or jabatan
  if (search) {
    whereClauses.push("(e.name LIKE ? OR e.nip LIKE ? OR p.name LIKE ?)");
    const searchPattern = `%${search}%`;
    params.push(searchPattern, searchPattern, searchPattern);
  }

  // Filter Positions (supports single or multi-select array / comma-separated)
  if (positionFilter) {
    let positionList: string[] = [];
    if (Array.isArray(positionFilter)) {
      positionList = positionFilter.map(String).filter(Boolean);
    } else {
      positionList = String(positionFilter).split(",").map((s) => s.trim()).filter(Boolean);
    }

    if (positionList.length > 0) {
      // Check if positionList contains numbers (IDs) or strings (names/codes)
      const isNumeric = positionList.every((p) => !isNaN(Number(p)));
      if (isNumeric) {
        whereClauses.push(`e.position_id IN (${positionList.map(() => "?").join(",")})`);
        params.push(...positionList.map(Number));
      } else {
        whereClauses.push(`p.name IN (${positionList.map(() => "?").join(",")})`);
        params.push(...positionList);
      }
    }
  }

  // Filter Status Kontrak (employment_type)
  if (employmentType) {
    whereClauses.push("e.employment_type = ?");
    params.push(employmentType.toLowerCase());
  }

  // Filter Status Pegawai (active / inactive)
  if (status) {
    whereClauses.push("e.status = ?");
    params.push(status.toLowerCase());
  }

  // Filter Masa Kerja (min & max tahun)
  if (minTenure !== null && !isNaN(minTenure)) {
    whereClauses.push("TIMESTAMPDIFF(YEAR, e.joined_at, CURDATE()) >= ?");
    params.push(minTenure);
  }
  if (maxTenure !== null && !isNaN(maxTenure)) {
    whereClauses.push("TIMESTAMPDIFF(YEAR, e.joined_at, CURDATE()) <= ?");
    params.push(maxTenure);
  }

  const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(" AND ")}` : "";

  // Map sort column
  let orderColumn = "e.id";
  switch (sortBy) {
    case "nip":
      orderColumn = "e.nip";
      break;
    case "name":
    case "nama":
      orderColumn = "e.name";
      break;
    case "position":
    case "jabatan":
      orderColumn = "p.name";
      break;
    case "department":
    case "departemen":
      orderColumn = "d.name";
      break;
    case "joined_at":
    case "tanggalMasuk":
      orderColumn = "e.joined_at";
      break;
    case "experience":
    case "tenure":
    case "masaKerja":
      orderColumn = "e.joined_at"; // sorting by joined_at is inverse of tenure, handled below
      break;
    default:
      orderColumn = "e.id";
  }

  const finalSortOrder = (sortBy === "experience" || sortBy === "tenure" || sortBy === "masaKerja")
    ? (sortOrder === "ASC" ? "DESC" : "ASC")
    : sortOrder;

  // Count total items
  const countResult = await query<{ total: number }>(
    `SELECT COUNT(*) AS total
     FROM employees e
     JOIN positions p ON p.id = e.position_id
     JOIN departments d ON d.id = e.department_id
     ${whereSql}`,
    params,
  );
  const total = countResult[0]?.total || 0;

  // Fetch paginated items
  const rows = await query<any>(
    `SELECT
       e.id,
       e.nip,
       e.name,
       e.email,
       e.phone,
       e.photo_path,
       e.birth_place,
       e.birth_date,
       e.marital_status,
       e.children_count,
       e.joined_at,
       e.employment_type,
       e.gender,
       e.distance_km,
       e.full_address,
       e.status,
       e.created_at,
       e.updated_at,
       p.id AS position_id,
       p.name AS position_name,
       p.code AS position_code,
       p.position_type,
       d.id AS department_id,
       d.name AS department_name,
       d.code AS department_code,
       dt.id AS district_id,
       dt.name AS district_name,
       r.id AS regency_id,
       r.name AS regency_name,
       pr.id AS province_id,
       pr.name AS province_name
     FROM employees e
     JOIN positions p ON p.id = e.position_id
     JOIN departments d ON d.id = e.department_id
     LEFT JOIN districts dt ON dt.id = e.district_id
     LEFT JOIN regencies r ON r.id = dt.regency_id
     LEFT JOIN provinces pr ON pr.id = r.province_id
     ${whereSql}
     ORDER BY ${orderColumn} ${finalSortOrder}
     LIMIT ? OFFSET ?`,
    [...params, perPage, offset],
  );

  const items = rows.map((row) => {
    const tenure = calculateTenure(row.joined_at);
    let age: number | null = null;
    if (row.birth_date) {
      const bDate = new Date(row.birth_date);
      if (!isNaN(bDate.getTime())) {
        const today = new Date();
        age = today.getFullYear() - bDate.getFullYear();
        if (today.getMonth() < bDate.getMonth() || (today.getMonth() === bDate.getMonth() && today.getDate() < bDate.getDate())) {
          age--;
        }
      }
    }

    return {
      ...row,
      age,
      tenure_years: tenure.years,
      tenure_months: tenure.months,
      tenure_text: tenure.text,
      photo_url: row.photo_path || "/images/default-avatar.svg",
    };
  });

  return {
    success: true,
    data: {
      items,
      pagination: {
        total,
        page,
        perPage,
        totalPages: Math.ceil(total / perPage) || 1,
      },
    },
  };
});
