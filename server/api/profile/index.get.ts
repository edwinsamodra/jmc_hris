import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  // Verifikasi permission modul 'profile' action 'read'
  const auth = await requirePermission(event, "profile", "read");
  const currentUserId = auth.sessionUser.id;

  // Query data user lengkap beserta relasi role & pegawai (jika terhubung)
  const profiles = await query<any>(
    `SELECT 
      u.id AS user_id,
      u.name AS name,
      u.username AS username,
      u.email AS email,
      u.cellphone AS cellphone,
      u.status AS status,
      u.created_at AS user_created_at,
      u.updated_at AS user_updated_at,
      r.id AS role_id,
      r.code AS role_code,
      r.name AS role_name,
      r.description AS role_description,
      e.id AS employee_id,
      e.nip AS employee_nip,
      e.name AS employee_name,
      e.email AS employee_email,
      e.phone AS employee_phone,
      e.birth_place,
      e.birth_date,
      e.marital_status,
      e.children_count,
      e.joined_at,
      e.employment_type,
      e.gender,
      e.distance_km,
      e.full_address,
      e.status AS employee_status,
      p.id AS position_id,
      p.name AS position_name,
      p.position_type,
      d.id AS department_id,
      d.name AS department_name,
      dist.name AS district_name,
      reg.name AS regency_name,
      prov.name AS province_name
    FROM users u
    JOIN roles r ON r.id = u.role_id
    LEFT JOIN employees e ON e.id = u.employee_id
    LEFT JOIN positions p ON p.id = e.position_id
    LEFT JOIN departments d ON d.id = e.department_id
    LEFT JOIN districts dist ON dist.id = e.district_id
    LEFT JOIN regencies reg ON reg.id = dist.regency_id
    LEFT JOIN provinces prov ON prov.id = reg.province_id
    WHERE u.id = ? AND u.deleted_at IS NULL
    LIMIT 1`,
    [currentUserId],
  );

  if (!profiles || profiles.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data profil pengguna tidak ditemukan.",
    });
  }

  const row = profiles[0];

  // Susun response data terstruktur
  const profileData = {
    user: {
      id: row.user_id,
      name: row.name,
      username: row.username,
      email: row.email,
      cellphone: row.cellphone,
      status: row.status,
      createdAt: row.user_created_at,
      updatedAt: row.user_updated_at,
    },
    role: {
      id: row.role_id,
      code: row.role_code,
      name: row.role_name,
      description: row.role_description,
    },
    employee: row.employee_id
      ? {
          id: row.employee_id,
          nip: row.employee_nip,
          name: row.employee_name,
          email: row.employee_email,
          phone: row.employee_phone,
          birthPlace: row.birth_place,
          birthDate: row.birth_date,
          maritalStatus: row.marital_status,
          childrenCount: row.children_count,
          joinedAt: row.joined_at,
          employmentType: row.employment_type,
          gender: row.gender,
          distanceKm: row.distance_km,
          fullAddress: row.full_address,
          status: row.employee_status,
          position: row.position_id
            ? {
                id: row.position_id,
                name: row.position_name,
                type: row.position_type,
              }
            : null,
          department: row.department_id
            ? {
                id: row.department_id,
                name: row.department_name,
              }
            : null,
          location: {
            district: row.district_name || null,
            regency: row.regency_name || null,
            province: row.province_name || null,
          },
        }
      : null,
  };

  // Catat audit activity log
  await logActivity(event, {
    userId: currentUserId,
    moduleCode: "profile",
    action: "read",
    description: `Melihat data profil pengguna (${row.username})`,
    subjectType: "users",
    subjectId: currentUserId,
  });

  return {
    success: true,
    data: profileData,
  };
});
