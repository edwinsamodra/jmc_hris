export interface TransportCalculationInput {
  employmentType: "pkwtt" | "pkwt" | "magang" | string;
  distanceKm: number | null | undefined;
  attendanceDays: number;
  baseFare: number;
  minKm?: number;
  maxKm?: number;
  minWorkDays?: number;
}

export interface TransportCalculationResult {
  isEligible: boolean;
  eligibilityStatus: "eligible" | "not_eligible_employment_type" | "not_eligible_days" | "not_eligible_km";
  originalKm: number;
  roundedKm: number;
  effectiveKm: number;
  attendanceDays: number;
  baseFare: number;
  nominal: number;
  calculationNote: string;
}

/**
 * Aturan pembulatan km:
 * - Jika angka desimal di bawah 0.5 maka dibulatkan ke bawah
 * - Jika angka desimal adalah 0.5 ke atas maka dibulatkan ke atas
 * Contoh: 14.4 -> 14, 14.5 -> 15, 14.8 -> 15
 */
export function roundKm(km: number): number {
  if (km == null || isNaN(km) || km < 0) return 0;
  return Math.round(km);
}

/**
 * Menghitung tunjangan transport pegawai per periode bulanan
 * berdasarkan formula & aturan bisnis HRIS:
 * 1. Hanya pegawai tetap (pkwtt)
 * 2. Minimal hari masuk kerja >= minWorkDays (default 19 hari)
 * 3. Jarak > minKm (default 5 km), jarak <= 5 km tidak dihitung
 * 4. Jarak maksimal dicap di maxKm (default 25 km), kelebihan jarak tidak dihitung
 * 5. Formula: Nominal = baseFare * effectiveKm * attendanceDays
 */
export function calculateTransportAllowance(
  input: TransportCalculationInput,
): TransportCalculationResult {
  const {
    employmentType,
    distanceKm,
    attendanceDays,
    baseFare,
    minKm = 5,
    maxKm = 25,
    minWorkDays = 19,
  } = input;

  const rawKm = typeof distanceKm === "number" && !isNaN(distanceKm) ? Math.max(0, distanceKm) : 0;
  const rounded = roundKm(rawKm);
  const safeDays = Math.max(0, Math.floor(attendanceDays || 0));
  const safeFare = Math.max(0, baseFare || 0);

  // Aturan 1: Hanya pegawai tetap (pkwtt)
  if (employmentType !== "pkwtt") {
    return {
      isEligible: false,
      eligibilityStatus: "not_eligible_employment_type",
      originalKm: rawKm,
      roundedKm: rounded,
      effectiveKm: 0,
      attendanceDays: safeDays,
      baseFare: safeFare,
      nominal: 0,
      calculationNote: `Tidak berhak: Status kepegawaian '${employmentType.toUpperCase()}' bukan Pegawai Tetap (PKWTT).`,
    };
  }

  // Aturan 2: Minimal hari masuk kerja >= 19 hari kerja
  if (safeDays < minWorkDays) {
    return {
      isEligible: false,
      eligibilityStatus: "not_eligible_days",
      originalKm: rawKm,
      roundedKm: rounded,
      effectiveKm: 0,
      attendanceDays: safeDays,
      baseFare: safeFare,
      nominal: 0,
      calculationNote: `Tidak berhak: Kehadiran kerja (${safeDays} hari) kurang dari syarat minimal ${minWorkDays} hari kerja.`,
    };
  }

  // Aturan 3: Jarak <= 5 km tidak dihitung tunjangan
  if (rounded <= minKm) {
    return {
      isEligible: false,
      eligibilityStatus: "not_eligible_km",
      originalKm: rawKm,
      roundedKm: rounded,
      effectiveKm: 0,
      attendanceDays: safeDays,
      baseFare: safeFare,
      nominal: 0,
      calculationNote: `Tidak berhak: Jarak (${rounded} km) kurang dari atau sama dengan batas minimal ${minKm} km.`,
    };
  }

  // Aturan 4: Batas maksimal jarak yang dihitung adalah 25 km (cap limit)
  const effectiveKm = Math.min(rounded, maxKm);

  // Formula: base_fare * effectiveKm * attendanceDays
  const nominal = safeFare * effectiveKm * safeDays;

  const capNote = rounded > maxKm ? ` (jarak riil ${rounded} km dicap maksimal ${maxKm} km)` : "";

  return {
    isEligible: true,
    eligibilityStatus: "eligible",
    originalKm: rawKm,
    roundedKm: rounded,
    effectiveKm,
    attendanceDays: safeDays,
    baseFare: safeFare,
    nominal,
    calculationNote: `Berhak: Pegawai Tetap (PKWTT), jarak efektif ${effectiveKm} km${capNote}, kehadiran ${safeDays} hari kerja.`,
  };
}
