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

  const idOrNip = getRouterParam(event, "id");
  if (!idOrNip) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID atau NIP pegawai diperlukan.",
    });
  }

  const isNumeric = /^\d+$/.test(idOrNip) && !idOrNip.startsWith("EMP-");

  // Query employee
  const employees = await query<any>(
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
       dt.code AS district_code,
       r.id AS regency_id,
       r.name AS regency_name,
       r.code AS regency_code,
       pr.id AS province_id,
       pr.name AS province_name,
       pr.code AS province_code
     FROM employees e
     JOIN positions p ON p.id = e.position_id
     JOIN departments d ON d.id = e.department_id
     LEFT JOIN districts dt ON dt.id = e.district_id
     LEFT JOIN regencies r ON r.id = dt.regency_id
     LEFT JOIN provinces pr ON pr.id = r.province_id
     WHERE (e.id = ? OR e.nip = ?) AND e.deleted_at IS NULL
     LIMIT 1`,
    [isNumeric ? Number(idOrNip) : 0, idOrNip],
  );

  if (!employees || employees.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: `Pegawai dengan identifier '${idOrNip}' tidak ditemukan.`,
    });
  }

  const employee = employees[0];

  // Query educations
  const educations = await query<any>(
    `SELECT
       id,
       education_level,
       school_name,
       graduation_year,
       sort_order
     FROM employee_educations
     WHERE employee_id = ?
     ORDER BY sort_order ASC, graduation_year DESC`,
    [employee.id],
  );

  const tenure = calculateTenure(employee.joined_at);
  let age: number | null = null;
  if (employee.birth_date) {
    const bDate = new Date(employee.birth_date);
    if (!isNaN(bDate.getTime())) {
      const today = new Date();
      age = today.getFullYear() - bDate.getFullYear();
      if (today.getMonth() < bDate.getMonth() || (today.getMonth() === bDate.getMonth() && today.getDate() < bDate.getDate())) {
        age--;
      }
    }
  }

  return {
    success: true,
    data: {
      ...employee,
      age,
      tenure_years: tenure.years,
      tenure_months: tenure.months,
      tenure_text: tenure.text,
      photo_url: employee.photo_path || "/images/default-avatar.svg",
      educations: educations || [],
    },
  };
});
