import { query, execute } from "#server/utils/database";
import { requirePermission, assertNotSuperadminEmployee } from "#server/utils/rbac";
import { logActivity } from "#server/utils/auth-session";
import { createError } from "h3";

export default defineEventHandler(async (event) => {
  // 1. RBAC Check (Admin HRD has delete permission, Manager HRD will get 403)
  const auth = await requirePermission(event, "employee", "delete");

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
    "SELECT id, nip, name, email, phone, position_id, department_id, status FROM employees WHERE (id = ? OR nip = ?) AND deleted_at IS NULL LIMIT 1",
    [isNumeric ? Number(idOrNip) : 0, idOrNip],
  );

  if (existingRows.length === 0) {
    throw createError({
      statusCode: 404,
      statusMessage: "Not Found",
      message: "Pegawai tidak ditemukan atau sudah dihapus.",
    });
  }

  const employee = existingRows[0];
  const targetEmployeeId = employee.id;

  // 2. Proteksi Khusus: Dilarang menghapus pegawai yang terasosiasi dengan akun Superadmin
  await assertNotSuperadminEmployee(targetEmployeeId);

  // Soft delete employee
  await execute("UPDATE employees SET deleted_at = NOW() WHERE id = ?", [targetEmployeeId]);

  // Catat audit log
  await logActivity(event, {
    userId: auth.sessionUser.id,
    moduleCode: "employee",
    action: "delete",
    description: `Menghapus data pegawai '${employee.name}' (NIP: ${employee.nip}, ID: ${targetEmployeeId})`,
    subjectType: "employees",
    subjectId: targetEmployeeId,
    oldValues: {
      id: employee.id,
      nip: employee.nip,
      name: employee.name,
      email: employee.email,
      phone: employee.phone,
      position_id: employee.position_id,
      department_id: employee.department_id,
      status: employee.status,
    },
  });

  return {
    success: true,
    message: `Data pegawai '${employee.name}' (NIP: ${employee.nip}) berhasil dihapus.`,
  };
});
