import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // Verifikasi izin akses modul dashboard
  const { sessionUser } = await requirePermission(event, "dashboard", "read");

  const roleCode = sessionUser.role_code;

  // Khusus Admin HRD: Ambil data analitik lengkap (widgets, charts, 5 pegawai terbaru)
  if (roleCode === "admin_hrd") {
    // 1. Total statistik & hitung per jenis kepegawaian
    const counts = await query<any>(`
      SELECT 
        COUNT(*) AS total_pegawai,
        SUM(CASE WHEN employment_type = 'pkwt' THEN 1 ELSE 0 END) AS total_pkwt,
        SUM(CASE WHEN employment_type = 'pkwtt' THEN 1 ELSE 0 END) AS total_pkwtt,
        SUM(CASE WHEN employment_type = 'magang' THEN 1 ELSE 0 END) AS total_magang,
        SUM(CASE WHEN gender = 'Laki-laki' THEN 1 ELSE 0 END) AS total_laki,
        SUM(CASE WHEN gender = 'Perempuan' THEN 1 ELSE 0 END) AS total_perempuan
      FROM employees
      WHERE status = 'active'
    `);

    const stat = counts[0] || {
      total_pegawai: 0,
      total_pkwt: 0,
      total_pkwtt: 0,
      total_magang: 0,
      total_laki: 0,
      total_perempuan: 0,
    };

    // 2. Data 5 Pegawai dengan tanggal masuk paling baru
    const recentEmployees = await query<any>(`
      SELECT 
        e.id,
        e.nip,
        e.name,
        e.employment_type,
        e.joined_at,
        p.name AS position_name,
        d.name AS department_name
      FROM employees e
      LEFT JOIN positions p ON p.id = e.position_id
      LEFT JOIN departments d ON d.id = e.department_id
      ORDER BY e.joined_at DESC, e.id DESC
      LIMIT 5
    `);

    return {
      success: true,
      data: {
        role: roleCode,
        stats: {
          totalPegawai: Number(stat.total_pegawai) || 0,
          totalPkwt: Number(stat.total_pkwt) || 0,
          totalPkwtt: Number(stat.total_pkwtt) || 0,
          totalMagang: Number(stat.total_magang) || 0,
        },
        charts: {
          employmentType: {
            series: [
              Number(stat.total_pkwt) || 0,
              Number(stat.total_pkwtt) || 0,
              Number(stat.total_magang) || 0,
            ],
            labels: ["PKWT", "PKWTT", "Magang"],
          },
          gender: {
            series: [
              Number(stat.total_laki) || 0,
              Number(stat.total_perempuan) || 0,
            ],
            labels: ["Laki-laki", "Perempuan"],
          },
        },
        recentEmployees: recentEmployees.map((emp) => ({
          id: emp.id,
          nip: emp.nip,
          name: emp.name,
          position: emp.position_name || "-",
          department: emp.department_name || "-",
          joinedAt: emp.joined_at ? new Date(emp.joined_at).toISOString().split("T")[0] : "-",
          employmentType: (emp.employment_type || "").toUpperCase(),
        })),
      },
    };
  }

  // Sisanya (Superadmin dan Manager HRD): Cuma pesan sambutan tanpa data tambahan
  return {
    success: true,
    data: {
      role: roleCode,
    },
  };
});
