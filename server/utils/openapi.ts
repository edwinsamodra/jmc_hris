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
    { name: "Auth", description: "Autentikasi, OTP email, sesi login & logout" },
    { name: "Dashboard", description: "Ringkasan data HRIS" },
    { name: "Employees", description: "Data pegawai" },
    { name: "Departments", description: "Data departemen" },
    { name: "Attendances", description: "Data absensi" },
    { name: "Roles", description: "Manajemen data role dan hak akses modul (RBAC)" },
  ],
  paths: {
    "/api/auth/google": {
      get: {
        tags: ["Auth"],
        summary: "Inisiasi login Single Sign-On (SSO) Google OAuth",
        responses: {
          302: { description: "Redirect ke halaman persetujuan akun Google" },
        },
      },
    },
    "/api/auth/callback/google": {
      get: {
        tags: ["Auth"],
        summary: "Callback redirect dari Google OAuth setelah otorisasi",
        parameters: [
          { name: "code", in: "query", required: true, schema: { type: "string" } },
          { name: "state", in: "query", required: false, schema: { type: "string" } },
        ],
        responses: {
          302: { description: "Redirect ke dashboard jika berhasil atau ke /login jika akun tidak terdaftar" },
        },
      },
    },
    "/api/auth/login": {
      post: {
        tags: ["Auth"],
        summary: "Kirim kredensial dan verifikasi reCAPTCHA Enterprise untuk memicu OTP email 4-digit",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["identifier", "password"],
                properties: {
                  identifier: {
                    type: "string",
                    example: "superadmin",
                    description: "Username, Email, atau Nomor HP",
                  },
                  password: {
                    type: "string",
                    example: "Admin#1234",
                    description: "Password pengguna (scrypt verified)",
                  },
                  captcha: {
                    type: "string",
                    example: "enterprise-action-token",
                    description: "Token hasil eksekusi Google reCAPTCHA Enterprise",
                  },
                  "g-recaptcha-response": {
                    type: "string",
                    description: "Alias parameter token Google reCAPTCHA",
                  },
                },
              },
            },
          },
        },
        responses: {
          200: {
            description: "OTP berhasil dibuat dan dikirim ke email",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                    data: {
                      type: "object",
                      properties: {
                        otpTicket: { type: "string" },
                        sentTo: { type: "string", example: "superadmin@example.com" },
                        expiresInSeconds: { type: "integer", example: 180 },
                        user: {
                          type: "object",
                          properties: {
                            id: { type: "integer" },
                            name: { type: "string" },
                            username: { type: "string" },
                            role: { type: "string" },
                          },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/ServerError" },
          422: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/auth/verify-otp": {
      post: {
        tags: ["Auth"],
        summary: "Verifikasi kode OTP 4-digit dan terbitkan session token (Inactivity 3 menit / Remember me)",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["otpTicket", "otp"],
                properties: {
                  otpTicket: { type: "string", description: "Tiket dari response /api/auth/login" },
                  otp: { type: "string", example: "1234", description: "Kode OTP 4 digit" },
                  rememberMe: { type: "boolean", example: false },
                },
              },
            },
          },
        },
        responses: {
          200: {
            description: "Verifikasi berhasil, sesi aktif dibuat",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                    data: {
                      type: "object",
                      properties: {
                        token: { type: "string" },
                        tokenType: { type: "string", example: "Bearer" },
                        rememberMe: { type: "boolean" },
                        expiresAt: { type: "string" },
                        inactivityTimeoutMinutes: { type: "integer", nullable: true },
                        user: { type: "object" },
                        permissions: { type: "array", items: { type: "object" } },
                      },
                    },
                  },
                },
              },
            },
          },
          400: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/auth/resend-otp": {
      post: {
        tags: ["Auth"],
        summary: "Kirim ulang kode OTP 4-digit baru",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["otpTicket"],
                properties: {
                  otpTicket: { type: "string" },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Kode OTP baru telah dikirimkan" },
        },
      },
    },
    "/api/auth/me": {
      get: {
        tags: ["Auth"],
        summary: "Ambil profil user login, role, info pegawai, dan hak akses modul",
        responses: {
          200: { description: "Informasi user dan sesi aktif" },
          401: { description: "Sesi tidak valid atau telah kedaluwarsa (inactivity 3 menit)" },
        },
      },
    },
    "/api/auth/logout": {
      post: {
        tags: ["Auth"],
        summary: "Logout sesi aktif dan invalidasi token",
        responses: {
          200: { description: "Logout berhasil" },
        },
      },
    },
    "/api/logs": {
      get: {
        tags: ["System"],
        summary: "Dapatkan daftar riwayat log aktivitas pengguna dan sistem (Login, Logout, CRUD)",
        parameters: [
          { name: "page", in: "query", required: false, schema: { type: "integer", default: 1 } },
          { name: "limit", in: "query", required: false, schema: { type: "integer", default: 10 } },
          { name: "search", in: "query", required: false, schema: { type: "string" } },
          { name: "module", in: "query", required: false, schema: { type: "string" } },
          { name: "action", in: "query", required: false, schema: { type: "string", enum: ["login", "logout", "create", "read", "update", "delete"] } },
        ],
        responses: {
          200: { description: "Daftar log aktivitas dan metadata paginasi" },
          401: { description: "Sesi tidak valid" },
          403: { description: "Tidak memiliki hak akses modul log" },
        },
      },
    },
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
        summary: "Tambah data pegawai baru",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/EmployeeCreatePayload" },
            },
          },
        },
        responses: {
          201: {
            description: "Pegawai berhasil ditambahkan",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    id: { type: "integer", example: 4 },
                    status: { type: "string", example: "created" },
                  },
                },
              },
            },
          },
          400: { $ref: "#/components/responses/ServerError" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/employees/{id}": {
      get: {
        tags: ["Employees"],
        summary: "Ambil detail data pegawai",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "integer" },
          },
        ],
        responses: {
          200: {
            description: "Detail data pegawai",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/EmployeeDetail" },
              },
            },
          },
          404: { $ref: "#/components/responses/ServerError" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      put: {
        tags: ["Employees"],
        summary: "Perbarui data pegawai",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "integer" },
          },
        ],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/EmployeeUpdatePayload" },
            },
          },
        },
        responses: {
          200: {
            description: "Data pegawai berhasil diperbarui",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    id: { type: "integer", example: 1 },
                    status: { type: "string", example: "updated" },
                  },
                },
              },
            },
          },
          400: { $ref: "#/components/responses/ServerError" },
          404: { $ref: "#/components/responses/ServerError" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      delete: {
        tags: ["Employees"],
        summary: "Hapus data pegawai secara soft delete",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "integer" },
          },
        ],
        responses: {
          200: {
            description: "Pegawai berhasil dihapus",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    id: { type: "integer", example: 1 },
                    status: { type: "string", example: "deleted" },
                  },
                },
              },
            },
          },
          404: { $ref: "#/components/responses/ServerError" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/departments": {
      get: {
        tags: ["Departments"],
        summary: "Ambil daftar departemen aktif",
        responses: {
          200: {
            description: "Daftar departemen",
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
        summary: "Ambil data absensi",
        parameters: [
          {
            name: "date",
            in: "query",
            required: false,
            schema: { type: "string", format: "date", example: "2026-09-16" },
          },
          {
            name: "departmentId",
            in: "query",
            required: false,
            schema: { type: "integer", example: 1 },
          },
        ],
        responses: {
          200: {
            description: "Daftar absensi pegawai",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/AttendanceListItem" },
                },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/roles": {
      get: {
        tags: ["Roles"],
        summary: "Ambil daftar semua role pengguna",
        parameters: [
          {
            name: "q",
            in: "query",
            required: false,
            schema: { type: "string" },
            description: "Pencarian nama/kode/deskripsi role",
          },
        ],
        responses: {
          200: {
            description: "Daftar role pengguna",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "array",
                      items: { $ref: "#/components/schemas/RoleItem" },
                    },
                  },
                },
              },
            },
          },
          401: { description: "Sesi tidak valid / belum login" },
          403: { description: "Tidak memiliki hak akses ke modul role (hanya Superadmin)" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/roles/{id}": {
      get: {
        tags: ["Roles"],
        summary: "Ambil detail informasi role dan matriks hak akses seluruh modul",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "string" },
            description: "ID atau Code Role",
            example: "1",
          },
        ],
        responses: {
          200: {
            description: "Detail role dan permissions modul",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "object",
                      properties: {
                        role: { $ref: "#/components/schemas/RoleItem" },
                        permissions: {
                          type: "array",
                          items: { $ref: "#/components/schemas/RolePermissionItem" },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { description: "Sesi tidak valid / belum login" },
          403: { description: "Tidak memiliki hak akses ke modul role (hanya Superadmin)" },
          404: { description: "Role tidak ditemukan" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
  },
  components: {
    responses: {
      ServerError: {
        description: "Terjadi kesalahan",
        content: {
          "application/json": {
            schema: { $ref: "#/components/schemas/Error" },
          },
        },
      },
    },
    schemas: {
      Health: {
        type: "object",
        properties: {
          status: { type: "string", example: "ok" },
          service: { type: "string", example: "hris-api" },
          database: { type: "string", example: "connected" },
        },
      },
      Department: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          code: { type: "string", example: "HR" },
          name: { type: "string", example: "Human Resources" },
        },
      },
      EmployeeListItem: {
        type: "object",
        properties: {
          id: { type: "integer" },
          employeeNumber: { type: "string", example: "EMP-001" },
          name: { type: "string", example: "Ahmad Hermawan" },
          email: { type: "string", example: "ahmad@example.com" },
          phone: { type: "string", example: "081234567801" },
          joinDate: { type: "string", format: "date", example: "2022-05-14" },
          employmentStatus: {
            type: "string",
            enum: ["pkwtt", "pkwt", "magang"],
            example: "pkwtt",
          },
          status: {
            type: "string",
            enum: ["active", "inactive"],
            example: "active",
          },
          departmentId: { type: "integer", example: 1 },
          departmentName: { type: "string", example: "Human Resources" },
          positionId: { type: "integer", example: 1 },
          positionName: { type: "string", example: "HR Manager" },
        },
      },
      EmployeeDetail: {
        type: "object",
        properties: {
          id: { type: "integer" },
          nip: { type: "string" },
          name: { type: "string" },
          email: { type: "string" },
          phone: { type: "string" },
          birthPlace: { type: "string" },
          birthDate: { type: "string", format: "date" },
          maritalStatus: { type: "string" },
          childrenCount: { type: "integer" },
          joinedAt: { type: "string", format: "date" },
          positionId: { type: "integer" },
          positionName: { type: "string" },
          departmentId: { type: "integer" },
          departmentName: { type: "string" },
          employmentType: { type: "string" },
          gender: { type: "string" },
          distanceKm: { type: "number" },
          districtId: { type: "integer" },
          fullAddress: { type: "string" },
          status: { type: "string" },
        },
      },
      EmployeeCreatePayload: {
        type: "object",
        required: [
          "nip",
          "name",
          "email",
          "phone",
          "birthPlace",
          "birthDate",
          "maritalStatus",
          "childrenCount",
          "joinedAt",
          "positionId",
          "departmentId",
          "employmentType",
          "gender",
          "distanceKm",
          "districtId",
          "fullAddress",
        ],
        properties: {
          nip: { type: "string", example: "EMP-004" },
          name: { type: "string", example: "Budi Santoso" },
          email: { type: "string", example: "budi@example.com" },
          phone: { type: "string", example: "+6281234567890" },
          birthPlace: { type: "string", example: "Bandung" },
          birthDate: { type: "string", format: "date", example: "1995-03-15" },
          maritalStatus: { type: "string", example: "Belum Menikah" },
          childrenCount: { type: "integer", example: 0 },
          joinedAt: { type: "string", format: "date", example: "2026-09-01" },
          positionId: { type: "integer", example: 1 },
          departmentId: { type: "integer", example: 1 },
          employmentType: {
            type: "string",
            enum: ["pkwtt", "pkwt", "magang"],
            example: "pkwt",
          },
          gender: {
            type: "string",
            enum: ["Laki-laki", "Perempuan"],
            example: "Laki-laki",
          },
          distanceKm: { type: "number", example: 4.5 },
          districtId: { type: "integer", example: 1 },
          fullAddress: { type: "string", example: "Jl. Sukasari No. 12" },
          status: {
            type: "string",
            enum: ["active", "inactive"],
            example: "active",
          },
        },
      },
      EmployeeUpdatePayload: {
        type: "object",
        properties: {
          nip: { type: "string" },
          name: { type: "string" },
          email: { type: "string" },
          phone: { type: "string" },
          birthPlace: { type: "string" },
          birthDate: { type: "string", format: "date" },
          maritalStatus: { type: "string" },
          childrenCount: { type: "integer" },
          joinedAt: { type: "string", format: "date" },
          positionId: { type: "integer" },
          departmentId: { type: "integer" },
          employmentType: { type: "string" },
          gender: { type: "string" },
          distanceKm: { type: "number" },
          districtId: { type: "integer" },
          fullAddress: { type: "string" },
          status: { type: "string" },
        },
      },
      AttendanceListItem: {
        type: "object",
        properties: {
          id: { type: "integer" },
          attendanceDate: { type: "string", format: "date" },
          checkinAt: { type: "string", format: "date-time", nullable: true },
          checkoutAt: { type: "string", format: "date-time", nullable: true },
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
      RoleItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          code: { type: "string", example: "superadmin" },
          name: { type: "string", example: "Superadmin" },
          description: {
            type: "string",
            example: "Memiliki hak akses penuh untuk kelola user, role, profile, dashboard, dan modul log.",
          },
          created_at: { type: "string", format: "date-time" },
          updated_at: { type: "string", format: "date-time" },
        },
      },
      RolePermissionItem: {
        type: "object",
        properties: {
          module_id: { type: "integer", example: 1 },
          module_code: { type: "string", example: "auth" },
          module_name: { type: "string", example: "Login/Logout/Session" },
          module_description: { type: "string", example: "Modul autentikasi, OTP email, dan manajemen sesi pengguna" },
          sort_order: { type: "integer", example: 1 },
          can_access: { type: "integer", example: 1 },
          can_create: { type: "integer", example: 0 },
          read_scope: { type: "string", enum: ["all", "own", "no"], example: "all" },
          update_scope: { type: "string", enum: ["all", "own", "no"], example: "no" },
          delete_scope: { type: "string", enum: ["all", "own", "no"], example: "no" },
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
