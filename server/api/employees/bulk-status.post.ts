import { query, execute } from "#server/utils/database";
import { requirePermission } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  // RBAC update permission
  const auth = await requirePermission(event, "employee", "update");

  const body = await readBody(event);
  if (!body || !Array.isArray(body.ids) || body.ids.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "Daftar ID pegawai tidak boleh kosong.",
    });
  }

  const targetStatus = String(body.status || "").toLowerCase();
  if (targetStatus !== "active" && targetStatus !== "inactive") {
    throw createError({
      statusCode: 422,
      statusMessage: "Unprocessable Entity",
      message: "Status harus bernilai 'active' atau 'inactive'.",
    });
  }

  const numericIds = body.ids.map(Number).filter((id) => !isNaN(id) && id > 0);
  if (numericIds.length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Bad Request",
      message: "ID pegawai tidak valid.",
    });
  }

  // Update status
  const placeholders = numericIds.map(() => "?").join(",");
  await execute(
    `UPDATE employees SET status = ?, updated_by = ? WHERE id IN (${placeholders}) AND deleted_at IS NULL`,
    [targetStatus, auth.sessionUser.id, ...numericIds],
  );

  // Audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "employee",
    action: "update",
    description: `Mengubah status massal ${numericIds.length} pegawai menjadi '${targetStatus}' (IDs: ${numericIds.join(", ")})`,
    subjectType: "employees",
    subjectId: numericIds[0],
    newValues: {
      affected_ids: numericIds,
      status: targetStatus,
    },
  });

  return {
    success: true,
    message: `Status ${numericIds.length} pegawai berhasil diubah menjadi '${targetStatus === "active" ? "Aktif" : "Nonaktif"}'.`,
    data: {
      affectedIds: numericIds,
      status: targetStatus,
    },
  };
});
