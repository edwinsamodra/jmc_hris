import { defineEventHandler } from "h3";
import { query } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";

export default defineEventHandler(async (event) => {
  // Validasi RBAC
  const { sessionUser } = await requirePermission(event, "transport_setting", "read");

  const settings = await query<any>(
    `SELECT id, base_fare, effective_start, min_km, max_km, min_work_days, is_active, created_at, updated_at
     FROM transport_allowance_settings
     WHERE is_active = 1
     ORDER BY effective_start DESC, id DESC
     LIMIT 1`
  );

  const activeSetting = settings.length > 0 ? settings[0] : null;

  // Catat activity log
  await logActivity(event, {
    action: "read",
    module: "transport_setting",
    details: "Melihat konfigurasi setting tunjangan transport aktif",
  });

  return {
    success: true,
    data: activeSetting
      ? {
          id: Number(activeSetting.id),
          base_fare: Number(activeSetting.base_fare),
          effective_start: activeSetting.effective_start,
          min_km: Number(activeSetting.min_km),
          max_km: Number(activeSetting.max_km),
          min_work_days: Number(activeSetting.min_work_days ?? 19),
          is_active: Boolean(activeSetting.is_active),
          created_at: activeSetting.created_at,
          updated_at: activeSetting.updated_at,
        }
      : null,
  };
});
