import { query, execute } from "#server/utils/database";

export interface AttendanceCalculationResult {
  durationHours: number;
  status: "terpenuhi" | "tidak_terpenuhi";
  remarksReason?: string;
}

export const VALID_LOCATIONS = ["Gedung Utama", "Gedung A", "Gedung B"] as const;

/**
 * Normalisasi nama lokasi gedung kantor
 */
export function normalizeLocation(location?: string | null): string | null {
  if (!location) return null;
  const trimmed = location.trim();
  const lower = trimmed.toLowerCase();

  if (lower.includes("utama")) return "Gedung Utama";
  if (lower.includes("gedung a") || lower === "a") return "Gedung A";
  if (lower.includes("gedung b") || lower === "b") return "Gedung B";

  return trimmed;
}

/**
 * Menghitung durasi jam kerja efektif dan status keterpenuhan presensi
 * sesuai aturan bisnis HRIS:
 * 1. Ada 3 gedung kantor: Gedung Utama, Gedung A, Gedung B
 * 2. Checkin dan checkout harus di lokasi yang sama
 * 3. Jam kerja normal 08:00 - 17:00, jam istirahat 12:00 - 13:00 (1 jam)
 * 4. Keterlambatan <= 15 menit (checkin <= 08:15:00) dihitung masuk normal
 * 5. Keterlambatan > 15 menit dihitung masuk halfday, namun durasi kerja minimal harus tetap 8 jam.
 * 6. Minimal jam kerja normal adalah 8 jam. Kurang dari 8 jam -> status "tidak_terpenuhi".
 *    Jika tidak terpenuhi, durasi dianggap nol (tidak menambah total durasi kehadiran bulanan).
 */
export function calculateAttendance(params: {
  attendanceType: "hadir" | "cuti" | "izin" | "unpaid_leave";
  attendanceDate: string; // YYYY-MM-DD
  checkinTime?: string | null; // HH:mm:ss atau ISO datetime
  checkoutTime?: string | null; // HH:mm:ss atau ISO datetime
  checkinLocation?: string | null;
  checkoutLocation?: string | null;
  verificationStatus?: string | null;
}): AttendanceCalculationResult {
  const {
    attendanceType,
    attendanceDate,
    checkinTime,
    checkoutTime,
    checkinLocation,
    checkoutLocation,
  } = params;

  // Untuk jenis selain hadir (cuti, izin, unpaid_leave)
  if (attendanceType !== "hadir") {
    return {
      durationHours: 0,
      status: "terpenuhi",
    };
  }

  // Jika waktu checkin atau checkout belum lengkap
  if (!checkinTime || !checkoutTime) {
    return {
      durationHours: 0,
      status: "tidak_terpenuhi",
      remarksReason: "Waktu checkin atau checkout tidak lengkap",
    };
  }

  const normCheckinLoc = normalizeLocation(checkinLocation);
  const normCheckoutLoc = normalizeLocation(checkoutLocation);

  // Aturan 3: Lokasi checkin & checkout harus sama
  if (!normCheckinLoc || !normCheckoutLoc || normCheckinLoc !== normCheckoutLoc) {
    return {
      durationHours: 0,
      status: "tidak_terpenuhi",
      remarksReason: `Lokasi checkin (${normCheckinLoc || "-"}) dan checkout (${normCheckoutLoc || "-"}) berbeda`,
    };
  }

  // Parse waktu checkin dan checkout
  const checkinDateObj = parseDateTime(attendanceDate, checkinTime);
  const checkoutDateObj = parseDateTime(attendanceDate, checkoutTime);

  if (!checkinDateObj || !checkoutDateObj || checkoutDateObj <= checkinDateObj) {
    return {
      durationHours: 0,
      status: "tidak_terpenuhi",
      remarksReason: "Rentang waktu checkin dan checkout tidak valid",
    };
  }

  // Hitung total durasi kotor dalam jam
  const grossHours = (checkoutDateObj.getTime() - checkinDateObj.getTime()) / (1000 * 60 * 60);

  // Hitung potongan jam istirahat (12:00 - 13:00)
  const breakStart = parseDateTime(attendanceDate, "12:00:00")!;
  const breakEnd = parseDateTime(attendanceDate, "13:00:00")!;

  let breakOverlapHours = 0;
  if (checkinDateObj < breakEnd && checkoutDateObj > breakStart) {
    const overlapStart = Math.max(checkinDateObj.getTime(), breakStart.getTime());
    const overlapEnd = Math.min(checkoutDateObj.getTime(), breakEnd.getTime());
    breakOverlapHours = Math.max(0, (overlapEnd - overlapStart) / (1000 * 60 * 60));
  }

  const netHours = Math.max(0, grossHours - breakOverlapHours);
  const roundedNetHours = Math.round(netHours * 10) / 10;

  // Cek jam checkin terhadap batas toleransi 08:15:00
  const checkinLimitTime = parseDateTime(attendanceDate, "08:15:00")!;
  const isLate = checkinDateObj > checkinLimitTime;

  // Aturan 6: Minimal jam kerja normal adalah 8 jam
  if (roundedNetHours < 8.0) {
    return {
      durationHours: roundedNetHours,
      status: "tidak_terpenuhi",
      remarksReason: `Durasi jam kerja efektif (${roundedNetHours} jam) kurang dari batas minimal 8 jam`,
    };
  }

  return {
    durationHours: roundedNetHours,
    status: "terpenuhi",
    remarksReason: isLate
      ? `Terlambat (masuk setelah 08:15), durasi kerja terpenuhi (${roundedNetHours} jam)`
      : undefined,
  };
}

function parseDateTime(dateStr: string, timeOrDateTime: string): Date | null {
  if (!timeOrDateTime) return null;
  const trimmed = timeOrDateTime.trim();

  // Jika format sudah full ISO / SQL datetime (misal "2026-09-16 08:00:00" atau "2026-09-16T08:00:00")
  if (trimmed.includes(" ") || trimmed.includes("T")) {
    const d = new Date(trimmed.replace(" ", "T"));
    return isNaN(d.getTime()) ? null : d;
  }

  // Jika format hanya waktu "HH:mm" atau "HH:mm:ss"
  const timeParts = trimmed.split(":");
  if (timeParts.length >= 2) {
    const hours = parseInt(timeParts[0], 10);
    const minutes = parseInt(timeParts[1], 10);
    const seconds = timeParts[2] ? parseInt(timeParts[2], 10) : 0;

    const [yearStr, monthStr, dayStr] = dateStr.split("-");
    if (!yearStr || !monthStr || !dayStr) return null;

    const d = new Date(
      parseInt(yearStr, 10),
      parseInt(monthStr, 10) - 1,
      parseInt(dayStr, 10),
      hours,
      minutes,
      seconds,
    );
    return isNaN(d.getTime()) ? null : d;
  }

  return null;
}

export function formatDateString(dateInput: any): string {
  if (!dateInput) return "";
  if (dateInput instanceof Date) {
    const year = dateInput.getFullYear();
    const month = String(dateInput.getMonth() + 1).padStart(2, "0");
    const day = String(dateInput.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }
  const str = String(dateInput).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(str)) {
    return str.substring(0, 10);
  }
  const d = new Date(str);
  if (!isNaN(d.getTime())) {
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }
  return str;
}

export function parseYearMonth(dateInput: any): { year: number; month: number } {
  if (!dateInput) {
    const now = new Date();
    return { year: now.getFullYear(), month: now.getMonth() + 1 };
  }

  if (dateInput instanceof Date) {
    return {
      year: dateInput.getFullYear(),
      month: dateInput.getMonth() + 1,
    };
  }

  const str = String(dateInput).trim();
  // YYYY-MM-DD
  if (/^\d{4}-\d{2}/.test(str)) {
    const parts = str.split("-");
    return {
      year: parseInt(parts[0], 10),
      month: parseInt(parts[1], 10),
    };
  }

  const d = new Date(str);
  if (!isNaN(d.getTime())) {
    return {
      year: d.getFullYear(),
      month: d.getMonth() + 1,
    };
  }

  const now = new Date();
  return { year: now.getFullYear(), month: now.getMonth() + 1 };
}

/**
 * Rekalkulasi rekapitulasi kehadiran bulanan pegawai pada tabel attendance_summaries
 */
export async function recalculateAttendanceSummary(
  employeeId: number,
  year: number,
  month: number,
) {
  // Ambil semua data kehadiran pegawai di bulan & tahun bersangkutan
  const startDate = `${year}-${String(month).padStart(2, "0")}-01`;
  const nextMonth = month === 12 ? 1 : month + 1;
  const nextYear = month === 12 ? year + 1 : year;
  const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

  const rows = await query<any>(
    `SELECT attendance_type, status, duration_hours, verification_status
     FROM attendances
     WHERE employee_id = ?
       AND attendance_date >= ?
       AND attendance_date < ?`,
    [employeeId, startDate, endDate],
  );

  let hadirCount = 0;
  let cutiCount = 0;
  let izinCount = 0;
  let unpaidLeaveCount = 0;

  for (const row of rows) {
    const isApproved =
      !row.verification_status ||
      row.verification_status.toLowerCase() === "disetujui" ||
      row.verification_status.toLowerCase() === "verified";

    if (row.attendance_type === "hadir") {
      // Hanya terhitung jika status terpenuhi dan disetujui
      if (row.status === "terpenuhi" && isApproved) {
        hadirCount += 1;
      }
    } else if (row.attendance_type === "cuti") {
      if (isApproved) cutiCount += 1;
    } else if (row.attendance_type === "izin") {
      if (isApproved) izinCount += 1;
    } else if (row.attendance_type === "unpaid_leave") {
      if (isApproved) unpaidLeaveCount += 1;
    }
  }

  // Standar kuota
  const kuotaCuti = 12;
  const kuotaIzin = 3;
  const kuotaUnpaidLeave = 5;
  const minimalHadirTarget = 20;

  // Status hadir: "Terpenuhi" jika mencapai kuota minimal kehadiran
  const statusHadir = hadirCount >= minimalHadirTarget ? "Terpenuhi" : "Tidak terpenuhi";

  // Upsert ke attendance_summaries
  await execute(
    `INSERT INTO attendance_summaries (
       employee_id, period_year, period_month,
       hadir, cuti, kuota_cuti, izin, kuota_izin,
       unpaid_leave, kuota_unpaid_leave, status_hadir, calculated_at
     ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
     ON DUPLICATE KEY UPDATE
       hadir = VALUES(hadir),
       cuti = VALUES(cuti),
       kuota_cuti = VALUES(kuota_cuti),
       izin = VALUES(izin),
       kuota_izin = VALUES(kuota_izin),
       unpaid_leave = VALUES(unpaid_leave),
       kuota_unpaid_leave = VALUES(kuota_unpaid_leave),
       status_hadir = VALUES(status_hadir),
       calculated_at = NOW()`,
    [
      employeeId,
      year,
      month,
      hadirCount,
      cutiCount,
      kuotaCuti,
      izinCount,
      kuotaIzin,
      unpaidLeaveCount,
      kuotaUnpaidLeave,
      statusHadir,
    ],
  );

  return {
    employeeId,
    year,
    month,
    hadir: hadirCount,
    cuti: cutiCount,
    kuotaCuti,
    izin: izinCount,
    kuotaIzin,
    unpaidLeave: unpaidLeaveCount,
    kuotaUnpaidLeave,
    statusHadir,
  };
}
