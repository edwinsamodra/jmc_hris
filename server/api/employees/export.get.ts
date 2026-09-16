import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { createError, setHeader } from "h3";

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

function formatDateIndo(dateStr: any): string {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return String(dateStr);
  return d.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

export default defineEventHandler(async (event) => {
  // RBAC read permission
  await requirePermission(event, "employee", "read");

  const queryParams = getQuery(event);
  const format = String(queryParams.format || "csv").toLowerCase();
  const singleId = queryParams.id ? Number(queryParams.id) : null;
  const singleNip = queryParams.nip ? String(queryParams.nip) : null;

  // If single employee export
  if (singleId || singleNip) {
    const employees = await query<any>(
      `SELECT
         e.*,
         p.name AS position_name,
         d.name AS department_name,
         dt.name AS district_name,
         r.name AS regency_name,
         pr.name AS province_name
       FROM employees e
       JOIN positions p ON p.id = e.position_id
       JOIN departments d ON d.id = e.department_id
       LEFT JOIN districts dt ON dt.id = e.district_id
       LEFT JOIN regencies r ON r.id = dt.regency_id
       LEFT JOIN provinces pr ON pr.id = r.province_id
       WHERE (e.id = ? OR e.nip = ?) AND e.deleted_at IS NULL
       LIMIT 1`,
      [singleId || 0, singleNip || ""],
    );

    if (employees.length === 0) {
      throw createError({
        statusCode: 404,
        statusMessage: "Not Found",
        message: "Data pegawai tidak ditemukan.",
      });
    }

    const emp = employees[0];
    const educations = await query<any>(
      "SELECT education_level, school_name, graduation_year FROM employee_educations WHERE employee_id = ? ORDER BY sort_order ASC",
      [emp.id],
    );

    const tenure = calculateTenure(emp.joined_at);

    if (format === "json") {
      return { success: true, data: { ...emp, tenure: tenure.text, educations } };
    }

    // Return printable HTML for PDF render
    const eduRows = educations.map(
      (ed: any, idx: number) =>
        `<tr><td style="text-align:center;">${idx + 1}</td><td><strong>${ed.education_level}</strong></td><td>${ed.school_name}</td><td style="text-align:center;">${ed.graduation_year || "-"}</td></tr>`,
    ).join("");

    const html = `<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Detail Data Pegawai - ${emp.name}</title>
  <style>
    @page {
      size: A4 portrait;
      margin: 15mm 20mm 15mm 20mm;
    }
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      font-size: 13px;
      color: #1e293b;
      line-height: 1.5;
      margin: 0 auto;
      padding: 30px 45px;
      max-width: 900px;
      background: #ffffff;
    }
    .header {
      text-align: center;
      border-bottom: 2px solid #206bc4;
      padding-bottom: 14px;
      margin-bottom: 24px;
    }
    .header h1 {
      font-size: 20px;
      margin: 0;
      color: #206bc4;
      font-weight: 700;
      letter-spacing: 0.5px;
    }
    .header p {
      margin: 5px 0 0;
      color: #64748b;
      font-size: 12px;
    }
    .section-title {
      font-size: 13px;
      font-weight: 700;
      background: #f8fafc;
      color: #1e293b;
      padding: 7px 12px;
      margin: 20px 0 10px;
      border-left: 4px solid #206bc4;
      border-radius: 2px;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    table.data-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 12px;
    }
    table.data-table td {
      padding: 6px 10px;
      vertical-align: top;
      border-bottom: 1px solid #f1f5f9;
    }
    table.data-table td.label {
      width: 32%;
      font-weight: 600;
      color: #475569;
    }
    table.grid-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    table.grid-table th, table.grid-table td {
      border: 1px solid #e2e8f0;
      padding: 8px 12px;
      text-align: left;
    }
    table.grid-table th {
      background: #f8fafc;
      font-weight: 600;
      color: #334155;
    }
    .badge {
      display: inline-block;
      padding: 2px 10px;
      border-radius: 4px;
      font-size: 11px;
      font-weight: 600;
    }
    .badge-active { background: #dcfce7; color: #15803d; }
    .badge-inactive { background: #fee2e2; color: #b91c1c; }
    @media print {
      body {
        padding: 0;
        margin: 0;
        max-width: 100%;
      }
    }
  </style>
</head>
<body onload="window.print()">
  <div class="header">
    <h1>HRIS - LEMBAR DATA DETAIL PEGAWAI</h1>
    <p>Dicetak pada: ${formatDateIndo(new Date())}</p>
  </div>

  <div class="section-title">A. INFORMASI PRIBADI</div>
  <table class="data-table">
    <tr><td class="label">NIP</td><td>: <strong>${emp.nip}</strong></td></tr>
    <tr><td class="label">Nama Lengkap</td><td>: <strong>${emp.name}</strong></td></tr>
    <tr><td class="label">Email</td><td>: ${emp.email}</td></tr>
    <tr><td class="label">Nomor HP</td><td>: ${emp.phone || "-"}</td></tr>
    <tr><td class="label">Tempat, Tanggal Lahir</td><td>: ${emp.birth_place || "-"}, ${formatDateIndo(emp.birth_date)}</td></tr>
    <tr><td class="label">Status Pernikahan</td><td>: ${emp.marital_status || "-"}</td></tr>
    <tr><td class="label">Jumlah Anak</td><td>: ${emp.children_count}</td></tr>
    <tr><td class="label">Jarak Rumah - Kantor</td><td>: ${emp.distance_km || 0} km</td></tr>
    <tr><td class="label">Alamat Lengkap</td><td>: ${emp.full_address || "-"}</td></tr>
    <tr><td class="label">Wilayah (Kec/Kab/Prov)</td><td>: ${emp.district_name || "-"}, ${emp.regency_name || "-"}, ${emp.province_name || "-"}</td></tr>
  </table>

  <div class="section-title">B. INFORMASI KEPEGAWAIAN</div>
  <table class="data-table">
    <tr><td class="label">Tanggal Masuk</td><td>: ${formatDateIndo(emp.joined_at)}</td></tr>
    <tr><td class="label">Masa Kerja</td><td>: ${tenure.text}</td></tr>
    <tr><td class="label">Jabatan</td><td>: ${emp.position_name}</td></tr>
    <tr><td class="label">Departemen</td><td>: ${emp.department_name}</td></tr>
    <tr><td class="label">Status Kontrak</td><td>: ${String(emp.employment_type).toUpperCase()}</td></tr>
    <tr><td class="label">Status Kepegawaian</td><td>: <span class="badge ${emp.status === "active" ? "badge-active" : "badge-inactive"}">${emp.status === "active" ? "AKTIF" : "NONAKTIF"}</span></td></tr>
  </table>

  <div class="section-title">C. RIWAYAT PENDIDIKAN</div>
  <table class="grid-table">
    <thead>
      <tr><th style="width: 40px; text-align: center;">No</th><th style="width: 100px;">Jenjang</th><th>Nama Institusi / Sekolah</th><th style="width: 120px; text-align: center;">Tahun Lulus</th></tr>
    </thead>
    <tbody>
      ${eduRows.length > 0 ? eduRows : '<tr><td colspan="4" style="text-align: center; color: #64748b;">Tidak ada riwayat pendidikan.</td></tr>'}
    </tbody>
  </table>
</body>
</html>`;

    setHeader(event, "Content-Type", "text/html; charset=utf-8");
    return html;
  }

  // Export list of employees
  const employees = await query<any>(
    `SELECT
       e.id, e.nip, e.name, e.email, e.phone, e.joined_at, e.employment_type, e.status, e.distance_km,
       p.name AS position_name,
       d.name AS department_name,
       dt.name AS district_name,
       r.name AS regency_name,
       pr.name AS province_name
     FROM employees e
     JOIN positions p ON p.id = e.position_id
     JOIN departments d ON d.id = e.department_id
     LEFT JOIN districts dt ON dt.id = e.district_id
     LEFT JOIN regencies r ON r.id = dt.regency_id
     LEFT JOIN provinces pr ON pr.id = r.province_id
     WHERE e.deleted_at IS NULL
     ORDER BY e.id DESC`,
  );

  if (format === "excel" || format === "csv") {
    const csvHeaders = ["No", "NIP", "Nama", "Email", "Nomor HP", "Jabatan", "Departemen", "Tanggal Masuk", "Masa Kerja", "Status Kontrak", "Status Pegawai", "Wilayah", "Jarak (km)"];
    const csvRows = employees.map((emp, idx) => {
      const tenure = calculateTenure(emp.joined_at);
      return [
        idx + 1,
        `"${emp.nip}"`,
        `"${emp.name.replace(/"/g, '""')}"`,
        `"${emp.email}"`,
        `"${emp.phone || ""}"`,
        `"${emp.position_name}"`,
        `"${emp.department_name}"`,
        `"${formatDateIndo(emp.joined_at)}"`,
        `"${tenure.text}"`,
        `"${String(emp.employment_type).toUpperCase()}"`,
        `"${emp.status === "active" ? "Aktif" : "Nonaktif"}"`,
        `"${[emp.district_name, emp.regency_name, emp.province_name].filter(Boolean).join(", ")}"`,
        emp.distance_km || 0,
      ].join(",");
    });

    const csvContent = "\uFEFF" + [csvHeaders.join(","), ...csvRows].join("\r\n");
    const filename = `data-pegawai-${new Date().toISOString().slice(0, 10)}.csv`;

    setHeader(event, "Content-Type", "text/csv; charset=utf-8");
    setHeader(event, "Content-Disposition", `attachment; filename="${filename}"`);
    return csvContent;
  }

  // PDF / HTML Printable List
  const tableRows = employees.map((emp, idx) => {
    const tenure = calculateTenure(emp.joined_at);
    return `<tr>
      <td style="text-align:center;">${idx + 1}</td>
      <td><strong>${emp.nip}</strong></td>
      <td>${emp.name}</td>
      <td>${emp.position_name}</td>
      <td>${emp.department_name}</td>
      <td>${formatDateIndo(emp.joined_at)}</td>
      <td>${tenure.text}</td>
      <td>${String(emp.employment_type).toUpperCase()}</td>
      <td style="text-align:center;"><span class="badge ${emp.status === "active" ? "badge-active" : "badge-inactive"}">${emp.status === "active" ? "Aktif" : "Nonaktif"}</span></td>
    </tr>`;
  }).join("");

  const html = `<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Daftar Pegawai HRIS</title>
  <style>
    @page {
      size: A4 landscape;
      margin: 15mm 20mm 15mm 20mm;
    }
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      font-size: 11px;
      color: #1e293b;
      margin: 0 auto;
      padding: 30px 45px;
      max-width: 1080px;
      background: #ffffff;
    }
    .header {
      text-align: center;
      margin-bottom: 20px;
      border-bottom: 2px solid #206bc4;
      padding-bottom: 12px;
    }
    h2 {
      margin: 0 0 5px;
      color: #206bc4;
      font-size: 18px;
      font-weight: 700;
    }
    p.sub {
      margin: 0;
      color: #64748b;
      font-size: 11px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    th, td {
      border: 1px solid #cbd5e1;
      padding: 7px 10px;
    }
    th {
      background: #f1f5f9;
      text-align: left;
      font-weight: 600;
      color: #334155;
    }
    .badge {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 10px;
      font-weight: 600;
    }
    .badge-active { background: #dcfce7; color: #15803d; }
    .badge-inactive { background: #fee2e2; color: #b91c1c; }
    @media print {
      body {
        padding: 0;
        margin: 0;
        max-width: 100%;
      }
    }
  </style>
</head>
<body onload="window.print()">
  <div class="header">
    <h2>DAFTAR PEGAWAI HRIS</h2>
    <p class="sub">Total Data: ${employees.length} Pegawai | Tanggal Cetak: ${formatDateIndo(new Date())}</p>
  </div>
  <table>
    <thead>
      <tr>
        <th style="width:35px; text-align:center;">No</th>
        <th style="width:90px;">NIP</th>
        <th>Nama Pegawai</th>
        <th>Jabatan</th>
        <th>Departemen</th>
        <th style="width:95px;">Tanggal Masuk</th>
        <th style="width:90px;">Masa Kerja</th>
        <th style="width:75px;">Kontrak</th>
        <th style="width:70px; text-align:center;">Status</th>
      </tr>
    </thead>
    <tbody>
      ${tableRows}
    </tbody>
  </table>
</body>
</html>`;

  setHeader(event, "Content-Type", "text/html; charset=utf-8");
  return html;
});
