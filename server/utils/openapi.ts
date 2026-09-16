export const openApiDocument = {
  openapi: "3.0.3",
  info: {
    title: "HRIS API",
    version: "1.0.0",
    description: "Dokumentasi API boilerplate HRIS berbasis Nuxt dan MariaDB.",
  },
  servers: [{ url: "/", description: "Server aktif" }],
  tags: [
    { name: "System", description: "Status layanan" },
    { name: "Dashboard", description: "Ringkasan data HRIS" },
    { name: "Employees", description: "Data pegawai" },
    { name: "Departments", description: "Data departemen" },
    { name: "Attendances", description: "Data absensi" },
  ],
  paths: {
    "/api/health": {
      get: {
        tags: ["System"],
        summary: "Periksa status API dan database",
        responses: {
          200: {
            description: "API dan database dapat diakses",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/Health" },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/dashboard": {
      get: {
        tags: ["Dashboard"],
        summary: "Ambil ringkasan dashboard",
        responses: {
          200: {
            description: "Ringkasan dan pegawai terbaru",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/Dashboard" },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/employees": {
      get: {
        tags: ["Employees"],
        summary: "Ambil daftar pegawai",
        responses: {
          200: {
            description: "Daftar pegawai aktif dan nonaktif yang belum dihapus",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/EmployeeListItem" },
                },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      post: {
        tags: ["Employees"],
        summary: "Tambah pegawai",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/CreateEmployee" },
              example: {
                employeeNumber: "EMP-004",
                name: "Budi Santoso",
                email: "budi@example.com",
                phone: "081234567804",
                joinDate: "2026-09-16",
                positionId: 1,
                departmentId: 1,
                districtId: 1,
                employmentStatus: "pkwt",
              },
            },
          },
        },
        responses: {
          201: {
            description: "Pegawai berhasil dibuat",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/EmployeeDetail" },
              },
            },
          },
          400: { $ref: "#/components/responses/BadRequest" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/employees/{id}": {
      get: {
        tags: ["Employees"],
        summary: "Ambil detail pegawai",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            description: "ID pegawai",
            schema: { type: "integer", minimum: 1 },
            example: 1,
          },
        ],
        responses: {
          200: {
            description: "Detail pegawai",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/EmployeeDetail" },
              },
            },
          },
          404: { $ref: "#/components/responses/NotFound" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/departments": {
      get: {
        tags: ["Departments"],
        summary: "Ambil daftar departemen",
        responses: {
          200: {
            description: "Daftar departemen beserta jumlah pegawai",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/Department" },
                },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/attendances": {
      get: {
        tags: ["Attendances"],
        summary: "Ambil daftar absensi",
        parameters: [
          {
            name: "date",
            in: "query",
            required: false,
            description: "Filter berdasarkan tanggal absensi",
            schema: { type: "string", format: "date" },
            example: "2026-09-16",
          },
        ],
        responses: {
          200: {
            description: "Daftar absensi",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/Attendance" },
                },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
  },
  components: {
    responses: {
      BadRequest: {
        description: "Data permintaan tidak lengkap atau tidak valid",
        content: {
          "application/json": { schema: { $ref: "#/components/schemas/Error" } },
        },
      },
      NotFound: {
        description: "Data tidak ditemukan",
        content: {
          "application/json": { schema: { $ref: "#/components/schemas/Error" } },
        },
      },
      ServerError: {
        description: "Kesalahan server atau koneksi database",
        content: {
          "application/json": { schema: { $ref: "#/components/schemas/Error" } },
        },
      },
    },
    schemas: {
      Health: {
        type: "object",
        required: ["status", "service", "database"],
        properties: {
          status: { type: "string", example: "ok" },
          service: { type: "string", example: "hris-api" },
          database: { type: "string", example: "connected" },
        },
      },
      EmploymentStatus: {
        type: "string",
        enum: ["pkwtt", "pkwt", "magang"],
      },
      EmployeeListItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          employeeNumber: { type: "string", example: "EMP-001" },
          name: { type: "string", example: "Ahmad Hermawan" },
          email: { type: "string", format: "email" },
          phone: { type: "string", nullable: true },
          joinDate: { type: "string", format: "date" },
          employmentStatus: { $ref: "#/components/schemas/EmploymentStatus" },
          status: { type: "string", enum: ["active", "inactive"] },
          departmentId: { type: "integer" },
          departmentName: { type: "string" },
          positionId: { type: "integer" },
          positionName: { type: "string" },
        },
      },
      EmployeeDetail: {
        type: "object",
        additionalProperties: true,
        properties: {
          id: { type: "integer", example: 1 },
          nip: { type: "string", example: "EMP-001" },
          name: { type: "string" },
          email: { type: "string", format: "email" },
          phone: { type: "string", nullable: true },
          joined_at: { type: "string", format: "date" },
          employment_type: { $ref: "#/components/schemas/EmploymentStatus" },
          department_name: { type: "string" },
          position_name: { type: "string" },
          district_name: { type: "string" },
          regency_name: { type: "string" },
          province_name: { type: "string" },
        },
      },
      CreateEmployee: {
        type: "object",
        required: [
          "employeeNumber", "name", "email", "positionId",
          "departmentId", "districtId",
        ],
        properties: {
          employeeNumber: { type: "string", maxLength: 50 },
          name: { type: "string", maxLength: 150 },
          email: { type: "string", format: "email", maxLength: 255 },
          phone: { type: "string", maxLength: 30 },
          joinDate: { type: "string", format: "date" },
          positionId: { type: "integer", minimum: 1 },
          departmentId: { type: "integer", minimum: 1 },
          districtId: { type: "integer", minimum: 1 },
          employmentStatus: { $ref: "#/components/schemas/EmploymentStatus" },
        },
      },
      Department: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          code: { type: "string", example: "HR" },
          name: { type: "string", example: "Human Resources" },
          employeeCount: { type: "integer", example: 1 },
        },
      },
      Attendance: {
        type: "object",
        properties: {
          id: { type: "integer" },
          date: { type: "string", format: "date" },
          checkIn: { type: "string", format: "date-time", nullable: true },
          checkOut: { type: "string", format: "date-time", nullable: true },
          attendanceType: {
            type: "string",
            enum: ["hadir", "cuti", "izin", "unpaid_leave"],
          },
          status: { type: "string", enum: ["terpenuhi", "tidak_terpenuhi"] },
          remarks: { type: "string", nullable: true },
          employeeId: { type: "integer" },
          employeeNumber: { type: "string" },
          employeeName: { type: "string" },
        },
      },
      Dashboard: {
        type: "object",
        properties: {
          summary: {
            type: "object",
            properties: {
              employees: { type: "integer", example: 3 },
              permanentEmployees: { type: "integer", example: 1 },
              contractEmployees: { type: "integer", example: 1 },
              interns: { type: "integer", example: 1 },
              departments: { type: "integer", example: 3 },
            },
          },
          recentEmployees: {
            type: "array",
            items: { $ref: "#/components/schemas/EmployeeListItem" },
          },
        },
      },
      Error: {
        type: "object",
        properties: {
          statusCode: { type: "integer", example: 400 },
          statusMessage: { type: "string", example: "Data tidak valid" },
        },
      },
    },
  },
} as const;

