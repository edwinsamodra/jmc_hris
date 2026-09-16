import { execute, query } from "#server/utils/database";

interface EmployeeInput {
  employeeNumber: string;
  name: string;
  email: string;
  phone?: string;
  joinDate: string;
  positionId: number;
  departmentId: number;
  districtId: number;
  employmentStatus: "pkwtt" | "pkwt" | "magang";
}

export default defineEventHandler(async (event) => {
  const body = await readBody<Partial<EmployeeInput>>(event);

  if (!body.employeeNumber || !body.name || !body.email) {
    throw createError({
      statusCode: 400,
      statusMessage: "Nomor pegawai, nama, dan email wajib diisi",
    });
  }

  if (!body.positionId || !body.departmentId || !body.districtId) {
    throw createError({
      statusCode: 400,
      statusMessage: "Jabatan, departemen, dan kecamatan wajib dipilih",
    });
  }

  const result = await execute(`
    INSERT INTO employees (
      nip, name, email, phone, joined_at, position_id, department_id,
      employment_type, district_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `, [
    body.employeeNumber,
    body.name,
    body.email,
    body.phone ?? null,
    body.joinDate ?? new Date().toISOString().slice(0, 10),
    body.positionId,
    body.departmentId,
    body.employmentStatus ?? "pkwt",
    body.districtId,
  ]);

  setResponseStatus(event, 201);

  const [employee] = await query("SELECT * FROM employees WHERE id = ?", [
    Number(result.insertId),
  ]);
  return employee;
});
