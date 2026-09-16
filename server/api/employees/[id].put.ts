import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";
import fs from "node:fs";
import path from "node:path";

function parseDateInput(dateStr: any): string | null {
  if (!dateStr) return null;
  const str = String(dateStr).trim();

  if (/^\d{4}-\d{2}-\d{2}$/.test(str)) {
    return str;
  }

  const ddmmyyyy = str.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
  if (ddmmyyyy) {
    const day = ddmmyyyy[1].padStart(2, "0");
    const month = ddmmyyyy[2].padStart(2, "0");
    const year = ddmmyyyy[3];
    return `${year}-${month}-${day}`;
  }

  const d = new Date(str);
  if (!isNaN(d.getTime())) {
    return d.toISOString().slice(0, 10);
  }
  return null;
}

function saveBase64Image(dataUriOrBase64: string): string | null {
  if (!dataUriOrBase64 || !dataUriOrBase64.startsWith("data:image/")) {
    return null;
  }

  const matches = dataUriOrBase64.match(/^data:image\/(png|jpeg|jpg);base64,(.+)$/i);
  if (!matches) {
    return null;
  }

  const ext = matches[1].toLowerCase() === "jpeg" ? "jpg" : matches[1].toLowerCase();
  const buffer = Buffer.from(matches[2], "base64");
  const fileName = `emp_${Date.now()}_${Math.random().toString(36).substring(2, 8)}.${ext}`;
  const uploadDir = path.resolve(process.cwd(), "public/uploads/employees");

  if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
  }

  fs.writeFileSync(path.join(uploadDir, fileName), buffer);
  return `/uploads/employees/${fileName}`;
}

export default defineEventHandler(async (event) => {
  // 1. RBAC check (Admin HRD has update permission, Manager HRD will get 403)
  const auth = await requirePermission(event, "employee", "update");

  const idOrNip = getRouterParam(event, "id");
  if (!idOrNip) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Parameter ID pegawai tidak valid.",
    });
  }

  const isNumeric = /^\d+$/.test(idOrNip) && !idOrNip.startsWith("EMP-");

  // Check if employee exists
  const existingRows = await query<any>(
    `SELECT * FROM employees WHERE (id = ? OR nip = ?) AND deleted_at IS NULL LIMIT 1`,
    [isNumeric ? Number(idOrNip) : 0, idOrNip],
  );

  if (existingRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Data pegawai tidak ditemukan atau sudah dihapus.",
    });
  }

  const existingEmp = existingRows[0];
  const targetEmployeeId = existingEmp.id;

  const body = await readBody(event);
  if (!body) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Data request tidak boleh kosong.",
    });
  }

  const nip = String(body.nip !== undefined ? body.nip : existingEmp.nip).trim();
  const name = String(body.name || body.nama || existingEmp.name).trim();
  const email = String(body.email || existingEmp.email).trim().toLowerCase();
  const phone = String(body.phone || body.nomor_hp || existingEmp.phone).trim();
  const birthPlace = String(body.birth_place || body.tempat_lahir || existingEmp.birth_place).trim();
  const birthDateRaw = body.birth_date !== undefined ? body.birth_date : (body.tanggal_lahir || existingEmp.birth_date);
  const birthDate = parseDateInput(birthDateRaw);
  const maritalStatus = String(body.marital_status || body.status_kawin || existingEmp.marital_status || "Belum Menikah").trim();
  const childrenCount = Number(body.children_count !== undefined ? body.children_count : (body.jumlah_anak !== undefined ? body.jumlah_anak : existingEmp.children_count));
  const joinedAtRaw = body.joined_at !== undefined ? body.joined_at : (body.tanggal_masuk || existingEmp.joined_at);
  const joinedAt = parseDateInput(joinedAtRaw);
  const positionId = Number(body.position_id || body.jabatan_id || existingEmp.position_id);
  const departmentId = Number(body.department_id || body.departemen_id || existingEmp.department_id);
  const employmentType = String(body.employment_type || body.status_kontrak || existingEmp.employment_type || "pkwtt").trim().toLowerCase();
  const districtId = Number(body.district_id || body.kecamatan_id || existingEmp.district_id);
  const fullAddress = String(body.full_address || body.alamat_lengkap || existingEmp.full_address).trim();
  const distanceKm = Number(body.distance_km !== undefined ? body.distance_km : (body.jarak_kantor !== undefined ? body.jarak_kantor : existingEmp.distance_km));
  const status = String(body.status || existingEmp.status || "active").trim().toLowerCase() === "inactive" ? "inactive" : "active";
  const gender = String(body.gender || existingEmp.gender || "Laki-laki").trim();
  const educations = Array.isArray(body.educations || body.pendidikan) ? (body.educations || body.pendidikan) : null;
  const photo = body.photo !== undefined ? body.photo : body.foto;

  // --- VALIDATION RULES ---
  if (!nip || !/^\d{8,}$/.test(nip)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "NIP harus berupa angka minimal 8 karakter tanpa spasi.",
    });
  }

  if (!name || !/^[a-zA-Z0-9\s'’`]+$/.test(name)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Nama hanya boleh mengandung huruf, angka, tanda petik atas ('), dan spasi.",
    });
  }

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Format email tidak valid.",
    });
  }

  if (!phone || !/^\+[0-9]{8,15}$/.test(phone)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Nomor HP harus menggunakan format internasional, contoh: +6282218458888.",
    });
  }

  if (!birthPlace) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Tempat lahir wajib diisi.",
    });
  }

  if (!birthDate) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Format tanggal lahir tidak valid.",
    });
  }

  if (!joinedAt) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Format tanggal masuk tidak valid.",
    });
  }

  if (isNaN(distanceKm) || distanceKm < 0 || distanceKm > 99) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Jarak rumah ke kantor harus berupa angka 0 hingga 99 km.",
    });
  }

  if (isNaN(childrenCount) || childrenCount < 0 || childrenCount > 99) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Jumlah anak harus berupa angka 0 hingga 99.",
    });
  }

  if (!positionId) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Jabatan wajib dipilih.",
    });
  }

  if (!departmentId) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Departemen wajib dipilih.",
    });
  }

  if (!districtId) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Kecamatan wajib dipilih.",
    });
  }

  if (!fullAddress) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Alamat lengkap wajib diisi.",
    });
  }

  // Validasi Riwayat Pendidikan jika diberikan
  if (educations !== null && educations.length > 0) {
    for (let i = 0; i < educations.length; i++) {
      const edu = educations[i];
      const level = String(edu.education_level || edu.jenjang || "").trim();
      const school = String(edu.school_name || edu.nama_sekolah || "").trim();
      const gradYear = Number(edu.graduation_year || edu.tahun_lulus || 0);

      if (!level) {
        throw createError({
          statusCode: 422,
          statusMessage: "Unprocessable Entity",
          message: `Riwayat pendidikan baris ke-${i + 1}: Jenjang pendidikan wajib dipilih.`,
        });
      }

      if (!school) {
        throw createError({
          statusCode: 422,
          statusMessage: "Unprocessable Entity",
          message: `Riwayat pendidikan baris ke-${i + 1}: Nama sekolah / perguruan tinggi wajib diisi.`,
        });
      }

      if (!gradYear || isNaN(gradYear) || gradYear < 1950 || gradYear > 2099) {
        throw createError({
          statusCode: 422,
          statusMessage: "Unprocessable Entity",
          message: `Riwayat pendidikan baris ke-${i + 1}: Tahun kelulusan wajib diisi berupa 4 digit tahun yang valid (1950 - 2099).`,
        });
      }
    }
  }

  // Cek keunikan NIP jika berubah
  const dupNip = await query<any>(
    "SELECT id FROM employees WHERE nip = ? AND id != ? AND deleted_at IS NULL LIMIT 1",
    [nip, targetEmployeeId],
  );
  if (dupNip.length > 0) {
    throw createError({
      statusCode: 409,
      statusMessage: "Conflict",
      message: `NIP '${nip}' sudah digunakan oleh pegawai lain.`,
    });
  }

  // Cek keunikan Email jika berubah
  const dupEmail = await query<any>(
    "SELECT id FROM employees WHERE email = ? AND id != ? AND deleted_at IS NULL LIMIT 1",
    [email, targetEmployeeId],
  );
  if (dupEmail.length > 0) {
    throw createError({
      statusCode: 409,
      statusMessage: "Conflict",
      message: `Email '${email}' sudah digunakan oleh pegawai lain.`,
    });
  }

  // Process photo
  let photoPath = existingEmp.photo_path;
  if (typeof photo === "string" && photo.startsWith("data:image/")) {
    photoPath = saveBase64Image(photo);
  } else if (typeof photo === "string") {
    photoPath = photo;
  }

  const formattedMaritalStatus = maritalStatus.toLowerCase().includes("tidak") || maritalStatus.toLowerCase().includes("belum")
    ? "Belum Menikah"
    : "Menikah";

  // Update employee record
  await execute(
    `UPDATE employees SET
       nip = ?,
       name = ?,
       email = ?,
       phone = ?,
       photo_path = ?,
       birth_place = ?,
       birth_date = ?,
       marital_status = ?,
       children_count = ?,
       joined_at = ?,
       position_id = ?,
       department_id = ?,
       employment_type = ?,
       gender = ?,
       distance_km = ?,
       district_id = ?,
       full_address = ?,
       status = ?,
       updated_by = ?
     WHERE id = ?`,
    [
      nip,
      name,
      email,
      phone,
      photoPath,
      birthPlace,
      birthDate,
      formattedMaritalStatus,
      childrenCount,
      joinedAt,
      positionId,
      departmentId,
      employmentType,
      gender,
      distanceKm,
      districtId,
      fullAddress,
      status,
      auth.sessionUser.id,
      targetEmployeeId,
    ],
  );

  // Sync educations if provided
  if (educations !== null) {
    await execute("DELETE FROM employee_educations WHERE employee_id = ?", [targetEmployeeId]);
    for (let i = 0; i < educations.length; i++) {
      const edu = educations[i];
      const level = String(edu.education_level || edu.jenjang || "").trim();
      const school = String(edu.school_name || edu.nama_sekolah || "").trim();
      const gradYear = Number(edu.graduation_year || edu.tahun_lulus || 0);

      if (level || school) {
        await execute(
          `INSERT INTO employee_educations (
             employee_id, education_level, school_name, graduation_year, sort_order
           ) VALUES (?, ?, ?, ?, ?)`,
          [targetEmployeeId, level || "-", school || "-", gradYear || null, i + 1],
        );
      }
    }
  }

  // Audit Log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "employee",
    action: "update",
    description: `Mengubah data pegawai '${name}' (NIP: ${nip}, ID: ${targetEmployeeId})`,
    subjectType: "employees",
    subjectId: targetEmployeeId,
    oldValues: {
      nip: existingEmp.nip,
      name: existingEmp.name,
      email: existingEmp.email,
      phone: existingEmp.phone,
      position_id: existingEmp.position_id,
      department_id: existingEmp.department_id,
      status: existingEmp.status,
    },
    newValues: {
      nip,
      name,
      email,
      phone,
      position_id: positionId,
      department_id: departmentId,
      status,
    },
  });

  return {
    success: true,
    message: `Data pegawai '${name}' berhasil diperbarui.`,
    data: {
      id: targetEmployeeId,
      nip,
      name,
      email,
    },
  };
});
