import { defineEventHandler, readBody, createError } from "h3";
import { execute, query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";

interface SettingPayload {
  base_fare: number;
  effective_start: string; // YYYY-MM-DD
  min_km?: number;
  max_km?: number;
  min_work_days?: number;
}

export default defineEventHandler(async (event) => {
  // Validasi RBAC: Admin HRD memiliki akses update/create setting
  const { sessionUser } = await requirePermission(event, "transport_setting", "create");

  const body = await readBody<SettingPayload>(event);

  if (!body) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Data konfigurasi setting wajib dikirimkan.",
    });
  }

  const baseFare = Number(body.base_fare);
  const effectiveStart = body.effective_start?.trim();
  const minKm = body.min_km != null ? Number(body.min_km) : 5;
  const maxKm = body.max_km != null ? Number(body.max_km) : 25;
  const minWorkDays = body.min_work_days != null ? Number(body.min_work_days) : 19;

  // Validasi input
  if (isNaN(baseFare) || baseFare < 0) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Tarif per km (base fare) harus berupa angka positif.",
    });
  }

  if (!effectiveStart || !/^\d{4}-\d{2}-\d{2}$/.test(effectiveStart)) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Format tanggal berlaku mulai tidak valid (harus YYYY-MM-DD).",
    });
  }

  if (isNaN(minKm) || minKm < 0) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Minimum kilometer harus berupa angka positif.",
    });
  }

  if (isNaN(maxKm) || maxKm < minKm) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Maksimum kilometer harus lebih besar atau sama dengan minimum kilometer.",
    });
  }

  if (isNaN(minWorkDays) || minWorkDays < 1) {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Minimal hari kerja harus berupa bilangan positif.",
    });
  }

  // Nonaktifkan setting aktif sebelumnya
  await execute(`UPDATE transport_allowance_settings SET is_active = 0 WHERE is_active = 1`);

  // Insert setting baru
  const result = await execute(
    `INSERT INTO transport_allowance_settings (
       base_fare, effective_start, min_km, max_km, min_work_days, is_active, created_by
     ) VALUES (?, ?, ?, ?, ?, 1, ?)`,
    [baseFare, effectiveStart, minKm, maxKm, minWorkDays, sessionUser.id]
  );

  const newId = Number(result.insertId);

  // Catat activity log
  await logActivity(event, {
    action: "update",
    module: "transport_setting",
    details: `Menyimpan setting tunjangan transport baru: Base Fare Rp ${baseFare.toLocaleString("id-ID")}, Berlaku Mulai: ${effectiveStart}, Min: ${minKm}km, Max: ${maxKm}km, Min Hari: ${minWorkDays}`,
  });

  return {
    success: true,
    message: "Pengaturan tunjangan transport berhasil disimpan.",
    data: {
      id: newId,
      base_fare: baseFare,
      effective_start: effectiveStart,
      min_km: minKm,
      max_km: maxKm,
      min_work_days: minWorkDays,
      is_active: true,
    },
  };
});
