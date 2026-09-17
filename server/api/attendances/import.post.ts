import { readMultipartFormData, readBody, createError } from "h3";
import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import {
  calculateAttendance,
  recalculateAttendanceSummary,
  normalizeLocation,
  parseYearMonth,
} from "#server/utils/attendance-calculator";

function parseCsvLine(line: string, delimiter: string = ","): string[] {
  const result: string[] = [];
  let current = "";
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const char = line[i];
    const nextChar = line[i + 1];

    if (char === '"') {
      if (inQuotes && nextChar === '"') {
        current += '"';
        i++; // skip escaped quote
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char === delimiter && !inQuotes) {
      result.push(current.trim());
      current = "";
    } else {
      current += char;
    }
  }
  result.push(current.trim());
  return result;
}

function parseDateInput(dateStr: any): string | null {
  if (!dateStr) return null;
  const str = String(dateStr).trim();

  // YYYY-MM-DD
  if (/^\d{4}-\d{2}-\d{2}$/.test(str)) {
    return str;
  }

  // DD/MM/YYYY or DD-MM-YYYY
  const ddmmyyyy = str.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
  if (ddmmyyyy) {
    const day = ddmmyyyy[1].padStart(2, "0");
    const month = ddmmyyyy[2].padStart(2, "0");
    const year = ddmmyyyy[3];
    return `${year}-${month}-${day}`;
  }

  const d = new Date(str);
  if (!isNaN(d.getTime())) {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${y}-${m}-${day}`;
  }

  return null;
}

export default defineEventHandler(async (event) => {
  // RBAC: create on attendance (Admin HRD only)
  const auth = await requirePermission(event, "attendance", "create");

  let csvContent = "";
  let originalFilename = "import-presensi.csv";

  // Cek apakah request multipart/form-data
  const contentType = event.node.req.headers["content-type"] || "";
  if (contentType.includes("multipart/form-data")) {
    const multipartData = await readMultipartFormData(event);
    if (!multipartData || multipartData.length === 0) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "File CSV tidak ditemukan pada form upload.",
      });
    }

    const fileItem = multipartData.find(
      (item) => item.name === "file" || item.filename,
    );

    if (!fileItem || !fileItem.data) {
      throw createError({
        statusCode: 400,
        statusMessage: "Bad Request",
        message: "File presensi wajib diunggah.",
      });
    }

    originalFilename = fileItem.filename || originalFilename;
    csvContent = fileItem.data.toString("utf-8");
  } else {
    // Alternatif JSON payload dengan `csvContent` string / base64
    const body = await readBody(event);
    if (body?.csvContent) {
      csvContent = String(body.csvContent);
      if (body.filename) originalFilename = String(body.filename);
    } else if (typeof body === "string") {
      csvContent = body;
    }
  }

  if (!csvContent || !csvContent.trim()) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Konten file CSV kosong atau tidak terbaca.",
    });
  }

  // Bersihkan UTF-8 BOM
  if (csvContent.charCodeAt(0) === 0xfeff) {
    csvContent = csvContent.slice(1);
  }

  const lines = csvContent
    .split(/\r?\n/)
    .map((l) => l.trim())
    .filter((l) => l.length > 0);

  if (lines.length < 2) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "File CSV harus memiliki baris header dan minimal 1 baris data presensi.",
    });
  }

  // Deteksi delimiter (, atau ;)
  const headerLine = lines[0];
  const delimiter = headerLine.includes(";") && !headerLine.includes(",") ? ";" : ",";
  const rawHeaders = parseCsvLine(headerLine, delimiter).map((h) =>
    h.toLowerCase().replace(/[\s_]+/g, "_"),
  );

  // Map header column indices
  const getColIdx = (keywords: string[]) => {
    return rawHeaders.findIndex((h) => keywords.some((k) => h.includes(k)));
  };

  const idxNip = getColIdx(["nip", "nomor_induk", "employee_number", "id_pegawai"]);
  const idxNama = getColIdx(["nama", "name"]);
  const idxTanggal = getColIdx(["tanggal", "tgl", "date"]);
  const idxJamMasuk = getColIdx(["jam_masuk", "checkin_time", "masuk", "checkin_at"]);
  const idxLokasiMasuk = getColIdx(["lokasi_masuk", "lokasi_checkin", "checkin_location", "lokasi"]);
  const idxJamPulang = getColIdx(["jam_pulang", "checkout_time", "pulang", "checkout_at"]);
  const idxLokasiPulang = getColIdx(["lokasi_pulang", "lokasi_checkout", "checkout_location"]);
  const idxJenis = getColIdx(["jenis_presensi", "attendance_type", "kehadiran", "jenis", "tipe"]);
  const idxStatusVerifikasi = getColIdx(["status_verifikasi", "verification_status", "verifikasi"]);
  const idxVerifikator = getColIdx(["verifikator", "verified_by_role", "verifikator_role"]);
  const idxKeterangan = getColIdx(["keterangan", "remarks", "catatan", "alasan"]);

  if (idxNip === -1 || idxTanggal === -1) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Header CSV harus memuat minimal kolom 'nip' dan 'tanggal'.",
    });
  }

  // Cache data pegawai aktif untuk pencocokan cepat
  const employeeRows = await query<any>(
    "SELECT id, nip, name FROM employees WHERE deleted_at IS NULL",
  );
  const employeeMapByNip = new Map<string, { id: number; nip: string; name: string }>();
  for (const emp of employeeRows) {
    employeeMapByNip.set(String(emp.nip).trim().toUpperCase(), emp);
  }

  // Inisialisasi catatan import di database
  const nowPeriod = parseYearMonth(new Date());
  const importRecord = await execute(
    `INSERT INTO attendance_imports (
       user_id, original_filename, period_year, period_month,
       status, total_rows, processed_rows, started_at
     ) VALUES (?, ?, ?, ?, 'processing', ?, 0, NOW())`,
    [
      auth.sessionUser.id,
      originalFilename,
      nowPeriod.year,
      nowPeriod.month,
      lines.length - 1,
    ],
  );
  const importId = importRecord.insertId;

  const errors: { row: number; nip?: string; message: string }[] = [];
  const affectedPeriods = new Map<string, { employeeId: number; year: number; month: number }>();
  let successCount = 0;

  // Proses baris-baris data
  for (let i = 1; i < lines.length; i++) {
    const rowNum = i + 1;
    const cols = parseCsvLine(lines[i], delimiter);

    const rawNip = String(cols[idxNip] || "").trim().toUpperCase();
    const rawTanggal = cols[idxTanggal] || "";

    if (!rawNip || !rawTanggal) {
      errors.push({ row: rowNum, message: "NIP atau Tanggal tidak boleh kosong" });
      continue;
    }

    const employee = employeeMapByNip.get(rawNip);
    if (!employee) {
      errors.push({
        row: rowNum,
        nip: rawNip,
        message: `Pegawai dengan NIP '${rawNip}' tidak terdaftar di sistem`,
      });
      continue;
    }

    const attendanceDate = parseDateInput(rawTanggal);
    if (!attendanceDate) {
      errors.push({
        row: rowNum,
        nip: rawNip,
        message: `Format tanggal '${rawTanggal}' tidak valid (gunakan YYYY-MM-DD atau DD/MM/YYYY)`,
      });
      continue;
    }

    // Normalisasi jenis kehadiran
    let attendanceType: "hadir" | "cuti" | "izin" | "unpaid_leave" = "hadir";
    const rawType = String(cols[idxJenis] || "hadir").trim().toLowerCase();
    if (rawType.includes("cuti")) attendanceType = "cuti";
    else if (rawType.includes("izin") || rawType.includes("ijin")) attendanceType = "izin";
    else if (rawType.includes("unpaid") || rawType.includes("tanpa gaji") || rawType.includes("di luar tanggungan"))
      attendanceType = "unpaid_leave";
    else attendanceType = "hadir";

    const checkinTime = idxJamMasuk !== -1 ? cols[idxJamMasuk] || null : null;
    const checkoutTime = idxJamPulang !== -1 ? cols[idxJamPulang] || null : null;
    const rawCheckinLoc = idxLokasiMasuk !== -1 ? cols[idxLokasiMasuk] || null : null;
    const rawCheckoutLoc = idxLokasiPulang !== -1 ? cols[idxLokasiPulang] || rawCheckinLoc : null;

    const checkinLocation = normalizeLocation(rawCheckinLoc);
    const checkoutLocation = normalizeLocation(rawCheckoutLoc);

    const verificationStatus = idxStatusVerifikasi !== -1 && cols[idxStatusVerifikasi]
      ? cols[idxStatusVerifikasi]
      : "Disetujui";
    const verifiedByRole = idxVerifikator !== -1 && cols[idxVerifikator]
      ? cols[idxVerifikator]
      : "HRD";
    const remarks = idxKeterangan !== -1 ? cols[idxKeterangan] || null : null;

    // Kalkulasi aturan bisnis
    const calcResult = calculateAttendance({
      attendanceType,
      attendanceDate,
      checkinTime,
      checkoutTime,
      checkinLocation,
      checkoutLocation,
      verificationStatus,
    });

    const checkinAt = checkinTime
      ? `${attendanceDate} ${checkinTime.length === 5 ? checkinTime + ":00" : checkinTime}`
      : null;
    const checkoutAt = checkoutTime
      ? `${attendanceDate} ${checkoutTime.length === 5 ? checkoutTime + ":00" : checkoutTime}`
      : null;

    const finalRemarks = remarks || calcResult.remarksReason || null;

    // Cek apakah data presensi tanggal tsb sudah ada untuk pegawai tsb
    const existingRows = await query<any>(
      "SELECT id FROM attendances WHERE employee_id = ? AND attendance_date = ? LIMIT 1",
      [employee.id, attendanceDate],
    );

    if (existingRows.length > 0) {
      await execute(
        `UPDATE attendances
         SET attendance_import_id = ?,
             checkin_at = ?,
             checkout_at = ?,
             checkin_location = ?,
             checkout_location = ?,
             attendance_type = ?,
             duration_hours = ?,
             status = ?,
             verification_status = ?,
             verified_by_role = ?,
             remarks = ?
         WHERE id = ?`,
        [
          importId,
          checkinAt,
          checkoutAt,
          checkinLocation,
          checkoutLocation,
          attendanceType,
          calcResult.durationHours,
          calcResult.status,
          verificationStatus,
          verifiedByRole,
          finalRemarks,
          existingRows[0].id,
        ],
      );
    } else {
      await execute(
        `INSERT INTO attendances (
           employee_id, attendance_import_id, attendance_date,
           checkin_at, checkout_at, checkin_location, checkout_location,
           attendance_type, duration_hours, status, verification_status,
           verified_by_role, remarks
         ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          employee.id,
          importId,
          attendanceDate,
          checkinAt,
          checkoutAt,
          checkinLocation,
          checkoutLocation,
          attendanceType,
          calcResult.durationHours,
          calcResult.status,
          verificationStatus,
          verifiedByRole,
          finalRemarks,
        ],
      );
    }

    successCount++;

    // Rekam periode untuk rekalkulasi summary
    const period = parseYearMonth(attendanceDate);
    const periodKey = `${employee.id}-${period.year}-${period.month}`;
    if (!affectedPeriods.has(periodKey)) {
      affectedPeriods.set(periodKey, {
        employeeId: employee.id,
        year: period.year,
        month: period.month,
      });
    }
  }

  // Rekalkulasi rekap bulanan untuk seluruh pegawai & periode yang terpengaruh
  for (const { employeeId, year, month } of affectedPeriods.values()) {
    await recalculateAttendanceSummary(employeeId, year, month);
  }

  // Update status import record
  const finalStatus = successCount > 0 ? "completed" : "failed";
  const errorMessage = errors.length > 0 ? JSON.stringify(errors.slice(0, 10)) : null;

  await execute(
    `UPDATE attendance_imports
     SET status = ?,
         processed_rows = ?,
         error_message = ?,
         finished_at = NOW()
     WHERE id = ?`,
    [finalStatus, successCount, errorMessage, importId],
  );

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "attendance",
    action: "create",
    description: `Import data presensi (${originalFilename}): ${successCount} berhasil, ${errors.length} gagal`,
    subjectType: "attendance_imports",
    subjectId: Number(importId),
    newValues: {
      import_id: importId,
      filename: originalFilename,
      total_rows: lines.length - 1,
      processed_rows: successCount,
      failed_rows: errors.length,
    },
  });

  return {
    success: successCount > 0,
    message:
      errors.length === 0
        ? `Berhasil mengimpor seluruh ${successCount} data presensi.`
        : `Proses import selesai. ${successCount} baris berhasil, ${errors.length} baris dilewati karena kendala validasi.`,
    data: {
      importId,
      filename: originalFilename,
      totalRows: lines.length - 1,
      successRows: successCount,
      failedRows: errors.length,
      errors,
    },
  };
});
