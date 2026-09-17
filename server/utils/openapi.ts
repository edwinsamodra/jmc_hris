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
    { name: "Employees", description: "Modul pengelolaan data pegawai (CRUD, filter, search, bulk action, export)" },
    { name: "Wilayah", description: "Master data wilayah dan pencarian kecamatan autocomplete" },
    { name: "Departments", description: "Data departemen" },
    { name: "Attendances", description: "Modul Presensi: Rekapitulasi bulanan seluruh pegawai, riwayat detail harian, import CSV, template download, dan CRUD presensi" },
    { name: "Roles", description: "Manajemen data role dan hak akses modul (RBAC)" },
    { name: "Users", description: "Manajemen data user pengguna sistem" },
    { name: "Positions", description: "Master data jabatan pegawai" },
    { name: "Transport Allowance", description: "Modul Tunjangan Transport: Rekapitulasi periode, detail penerima sortable, dan trigger kalkulasi sistem" },
    { name: "Transport Settings", description: "Setting Tunjangan Transport: Pengaturan base fare, tanggal berlaku mulai, batas min/max km, dan syarat hari kerja" },
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
    "/api/wilayah/districts": {
      get: {
        tags: ["Wilayah"],
        summary: "Pencarian autocomplete kecamatan (minimal 3 karakter)",
        parameters: [
          {
            name: "q",
            in: "query",
            required: true,
            description: "Kata kunci nama kecamatan atau kabupaten (min. 3 karakter)",
            schema: { type: "string", example: "sukasari" },
          },
        ],
        responses: {
          200: {
            description: "Daftar kecamatan yang cocok beserta data kabupaten dan provinsi",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "array",
                      items: { $ref: "#/components/schemas/DistrictSearchResult" },
                    },
                  },
                },
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
        summary: "Ambil daftar pegawai dengan paginasi, search, sorting, dan multi-filter",
        parameters: [
          { name: "page", in: "query", required: false, schema: { type: "integer", default: 1 } },
          { name: "perPage", in: "query", required: false, schema: { type: "integer", default: 10 } },
          { name: "search", in: "query", required: false, description: "Cari berdasarkan nama, NIP, atau jabatan", schema: { type: "string" } },
          { name: "positions", in: "query", required: false, description: "Filter multi-select ID atau nama jabatan (comma-separated)", schema: { type: "string" } },
          { name: "employmentType", in: "query", required: false, description: "Filter status kontrak (pkwtt, pkwt, magang)", schema: { type: "string", enum: ["pkwtt", "pkwt", "magang"] } },
          { name: "status", in: "query", required: false, description: "Filter status kepegawaian", schema: { type: "string", enum: ["active", "inactive"] } },
          { name: "minTenure", in: "query", required: false, description: "Masa kerja minimal (tahun)", schema: { type: "number" } },
          { name: "maxTenure", in: "query", required: false, description: "Masa kerja maksimal (tahun)", schema: { type: "number" } },
          { name: "sortBy", in: "query", required: false, schema: { type: "string", enum: ["nip", "name", "position", "joined_at", "experience"] } },
          { name: "sortOrder", in: "query", required: false, schema: { type: "string", enum: ["asc", "desc"], default: "desc" } },
        ],
        responses: {
          200: {
            description: "Daftar data pegawai berpaginasi",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "object",
                      properties: {
                        items: {
                          type: "array",
                          items: { $ref: "#/components/schemas/EmployeeListItem" },
                        },
                        pagination: { $ref: "#/components/schemas/PaginationMeta" },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/Unauthorized" },
          403: { $ref: "#/components/responses/Forbidden" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      post: {
        tags: ["Employees"],
        summary: "Tambah data pegawai baru (Khusus Admin HRD)",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/EmployeeCreatePayload" },
            },
          },
        },
        responses: {
          200: {
            description: "Pegawai berhasil ditambahkan",
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
                        id: { type: "integer", example: 4 },
                        nip: { type: "string", example: "19900101001" },
                        name: { type: "string", example: "Budi Santoso" },
                        email: { type: "string", example: "budi@example.com" },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/Unauthorized" },
          403: { $ref: "#/components/responses/Forbidden" },
          409: { description: "NIP atau Email sudah terdaftar" },
          422: { description: "Validasi form data pegawai gagal" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/employees/bulk-status": {
      post: {
        tags: ["Employees"],
        summary: "Ubah status kepegawaian secara massal (active/inactive)",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["ids", "status"],
                properties: {
                  ids: { type: "array", items: { type: "integer" } },
                  status: { type: "string", enum: ["active", "inactive"] },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Status pegawai berhasil diubah" },
          403: { $ref: "#/components/responses/Forbidden" },
        },
      },
    },
    "/api/employees/bulk-delete": {
      post: {
        tags: ["Employees"],
        summary: "Hapus data pegawai secara massal dengan verifikasi proteksi Superadmin",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["ids"],
                properties: {
                  ids: { type: "array", items: { type: "integer" } },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Pegawai berhasil dihapus secara massal" },
          403: { description: "Dilarang menghapus pegawai yang terhubung dengan akun Superadmin" },
        },
      },
    },
    "/api/employees/export": {
      get: {
        tags: ["Employees"],
        summary: "Export daftar pegawai (Excel/CSV/PDF) atau cetak detail satu pegawai",
        parameters: [
          { name: "format", in: "query", schema: { type: "string", enum: ["excel", "csv", "pdf", "json"], default: "csv" } },
          { name: "id", in: "query", description: "ID pegawai spesifik untuk export PDF profil", schema: { type: "integer" } },
          { name: "nip", in: "query", description: "NIP pegawai spesifik untuk export PDF profil", schema: { type: "string" } },
        ],
        responses: {
          200: { description: "File unduhan atau template cetak HTML/PDF" },
          403: { $ref: "#/components/responses/Forbidden" },
        },
      },
    },
    "/api/employees/{id}": {
      get: {
        tags: ["Employees"],
        summary: "Ambil detail data pegawai lengkap beserta riwayat pendidikan",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            description: "ID atau NIP pegawai",
            schema: { type: "string" },
          },
        ],
        responses: {
          200: {
            description: "Detail data pegawai dan pendidikan",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: { $ref: "#/components/schemas/EmployeeDetail" },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/Unauthorized" },
          403: { $ref: "#/components/responses/Forbidden" },
          404: { $ref: "#/components/responses/ServerError" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      put: {
        tags: ["Employees"],
        summary: "Perbarui data pegawai dan sinkronisasi riwayat pendidikan (Admin HRD)",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "string" },
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
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                    data: {
                      type: "object",
                      properties: {
                        id: { type: "integer" },
                        nip: { type: "string" },
                        name: { type: "string" },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/Unauthorized" },
          403: { $ref: "#/components/responses/Forbidden" },
          404: { $ref: "#/components/responses/ServerError" },
          422: { description: "Validasi update gagal" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      delete: {
        tags: ["Employees"],
        summary: "Hapus data pegawai secara soft delete (Proteksi data Superadmin)",
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "string" },
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
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                  },
                },
              },
            },
          },
          401: { $ref: "#/components/responses/Unauthorized" },
          403: { description: "Forbidden: Manager HRD dilarang hapus / Pegawai terhubung dengan akun Superadmin" },
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
    "/api/attendances/summary": {
      get: {
        tags: ["Attendances"],
        summary: "Dapatkan rekapitulasi presensi seluruh pegawai (default N-1 bulan berjalan)",
        parameters: [
          { name: "year", in: "query", required: false, schema: { type: "integer", example: 2026 }, description: "Tahun periode (default: tahun N-1 bulan)" },
          { name: "month", in: "query", required: false, schema: { type: "integer", example: 8 }, description: "Bulan periode (1-12, default: N-1 bulan berjalan)" },
          { name: "search", in: "query", required: false, schema: { type: "string" }, description: "Pencarian nama/NIP/jabatan pegawai" },
          { name: "page", in: "query", required: false, schema: { type: "integer", default: 1 } },
          { name: "limit", in: "query", required: false, schema: { type: "integer", default: 10 } },
        ],
        responses: {
          200: { description: "Daftar rekapitulasi presensi pegawai per periode" },
          401: { description: "Belum login" },
          403: { description: "Tidak memiliki hak akses ke modul presensi" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/attendances/{id}": {
      get: {
        tags: ["Attendances"],
        summary: "Dapatkan riwayat presensi harian & statistik bulanan pegawai berdasarkan ID pegawai",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, description: "ID Pegawai" },
          { name: "year", in: "query", required: false, schema: { type: "integer", example: 2026 } },
          { name: "month", in: "query", required: false, schema: { type: "integer", example: 8 } },
        ],
        responses: {
          200: { description: "Detail presensi pegawai dan statistik kehadiran bulanan" },
          401: { description: "Belum login" },
          403: { description: "Tidak memiliki hak akses" },
          404: { description: "Pegawai tidak ditemukan" },
        },
      },
      put: {
        tags: ["Attendances"],
        summary: "Perbarui data catatan presensi harian pegawai (Khusus Admin HRD)",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, description: "ID Record Presensi" },
        ],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                properties: {
                  attendance_date: { type: "string", format: "date", example: "2026-08-03" },
                  attendance_type: { type: "string", enum: ["hadir", "cuti", "izin", "unpaid_leave"], example: "hadir" },
                  checkin_location: { type: "string", enum: ["Gedung Utama", "Gedung A", "Gedung B"], example: "Gedung Utama" },
                  checkout_location: { type: "string", enum: ["Gedung Utama", "Gedung A", "Gedung B"], example: "Gedung Utama" },
                  checkin_time: { type: "string", example: "08:00:00" },
                  checkout_time: { type: "string", example: "17:00:00" },
                  verification_status: { type: "string", enum: ["Disetujui", "Ditolak"], example: "Disetujui" },
                  verified_by_role: { type: "string", enum: ["Lead", "Manager", "HRD"], example: "HRD" },
                  remarks: { type: "string", example: "Keterangan revisi presensi" },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Data presensi berhasil diperbarui dan rekap bulanan disinkronkan" },
          401: { description: "Belum login" },
          403: { description: "Hanya Admin HRD yang memiliki hak akses CUD presensi" },
          404: { description: "Data presensi tidak ditemukan" },
        },
      },
      delete: {
        tags: ["Attendances"],
        summary: "Hapus catatan presensi harian pegawai (Khusus Admin HRD)",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, description: "ID Record Presensi" },
        ],
        responses: {
          200: { description: "Data presensi berhasil dihapus dan rekap bulanan disinkronkan" },
          401: { description: "Belum login" },
          403: { description: "Hanya Admin HRD yang berhak menghapus data presensi" },
          404: { description: "Data presensi tidak ditemukan" },
        },
      },
    },
    "/api/attendances": {
      get: {
        tags: ["Attendances"],
        summary: "Ambil daftar data presensi pegawai (Filter Query)",
        parameters: [
          { name: "date", in: "query", required: false, schema: { type: "string", format: "date", example: "2026-09-16" } },
          { name: "departmentId", in: "query", required: false, schema: { type: "integer", example: 1 } },
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
      post: {
        tags: ["Attendances"],
        summary: "Tambah data presensi harian manual dengan validasi aturan jam kerja (Khusus Admin HRD)",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["employee_id", "attendance_date", "attendance_type"],
                properties: {
                  employee_id: { type: "integer", example: 1 },
                  attendance_date: { type: "string", format: "date", example: "2026-08-03" },
                  attendance_type: { type: "string", enum: ["hadir", "cuti", "izin", "unpaid_leave"], example: "hadir" },
                  checkin_location: { type: "string", enum: ["Gedung Utama", "Gedung A", "Gedung B"], example: "Gedung Utama" },
                  checkout_location: { type: "string", enum: ["Gedung Utama", "Gedung A", "Gedung B"], example: "Gedung Utama" },
                  checkin_time: { type: "string", example: "08:00:00" },
                  checkout_time: { type: "string", example: "17:00:00" },
                  verification_status: { type: "string", enum: ["Disetujui", "Ditolak"], default: "Disetujui" },
                  verified_by_role: { type: "string", enum: ["Lead", "Manager", "HRD"], default: "HRD" },
                  remarks: { type: "string", example: "Tepat waktu" },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Data presensi berhasil disimpan dan rekap dihitung ulang" },
          401: { description: "Belum login" },
          403: { description: "Akses ditolak (Hanya Admin HRD)" },
          422: { description: "Validasi data gagal" },
        },
      },
    },
    "/api/attendances/template": {
      get: {
        tags: ["Attendances"],
        summary: "Unduh file template CSV untuk import presensi pegawai",
        responses: {
          200: {
            description: "File CSV template siap pakai dengan header kolom dan baris sampel",
            content: {
              "text/csv": {
                schema: { type: "string", format: "binary" },
              },
            },
          },
        },
      },
    },
    "/api/attendances/import": {
      post: {
        tags: ["Attendances"],
        summary: "Upload dan proses import data presensi berbasis CSV (Khusus Admin HRD)",
        requestBody: {
          required: true,
          content: {
            "multipart/form-data": {
              schema: {
                type: "object",
                required: ["file"],
                properties: {
                  file: { type: "string", format: "binary", description: "File presensi berekstensi .csv" },
                },
              },
            },
            "application/json": {
              schema: {
                type: "object",
                required: ["csvContent"],
                properties: {
                  filename: { type: "string", example: "data-presensi-agustus.csv" },
                  csvContent: { type: "string", description: "Konten teks CSV mentah" },
                },
              },
            },
          },
        },
        responses: {
          200: { description: "Import berhasil diproses dengan statistik baris sukses/gagal" },
          400: { description: "File CSV tidak ditemukan" },
          403: { description: "Akses ditolak (Hanya Admin HRD)" },
          422: { description: "Format CSV tidak valid" },
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
    "/api/positions": {
      get: {
        tags: ["Positions"],
        summary: "Ambil daftar master data jabatan pegawai",
        responses: {
          200: {
            description: "Daftar jabatan pegawai",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: { $ref: "#/components/schemas/PositionItem" },
                },
              },
            },
          },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/users/check-username": {
      get: {
        tags: ["Users"],
        summary: "Pemeriksaan ketersediaan username unik secara realtime",
        parameters: [
          { name: "username", in: "query", required: true, schema: { type: "string" }, example: "john_doe" },
          { name: "excludeUserId", in: "query", required: false, schema: { type: "integer" } },
        ],
        responses: {
          200: {
            description: "Status ketersediaan username",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    available: { type: "boolean", example: true },
                    message: { type: "string", example: "Username tersedia." },
                  },
                },
              },
            },
          },
        },
      },
    },
    "/api/users/employee-options": {
      get: {
        tags: ["Users"],
        summary: "Pencarian dan daftar pilihan pegawai aktif untuk tautan akun user",
        description: "Digunakan pada modal Tambah/Edit User untuk mencari pegawai berdasarkan Nama atau NIP, dan mengembalikan data jabatan serta departemen untuk autofill form.",
        security: [{ bearerAuth: [] }, { cookieAuth: [] }],
        parameters: [
          { name: "q", in: "query", required: false, schema: { type: "string" }, description: "Kata kunci pencarian nama pegawai atau NIP" },
        ],
        responses: {
          200: {
            description: "Daftar pegawai aktif yang tersedia",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "array",
                      items: {
                        type: "object",
                        properties: {
                          id: { type: "integer", example: 1 },
                          nip: { type: "string", example: "EMP-001" },
                          name: { type: "string", example: "Ahmad Hermawan" },
                          email: { type: "string", example: "ahmad@example.com" },
                          phone: { type: "string", example: "+6281234567801" },
                          position_id: { type: "integer", example: 13 },
                          position_name: { type: "string", example: "Manager HRD" },
                          department_id: { type: "integer", example: 1 },
                          department_name: { type: "string", example: "HRD" },
                          linked_user_id: { type: "integer", nullable: true, example: 2 },
                          linked_username: { type: "string", nullable: true, example: "manager.hrd" },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
          401: { description: "Sesi tidak valid atau belum login" },
          403: { description: "Tidak memiliki hak akses modul user" },
        },
      },
    },
    "/api/users": {
      get: {
        tags: ["Users"],
        summary: "Daftar user pengguna aplikasi (hanya Superadmin)",
        parameters: [
          { name: "q", in: "query", required: false, schema: { type: "string" }, description: "Pencarian nama / username / pegawai" },
          { name: "role_id", in: "query", required: false, schema: { type: "integer" } },
          { name: "status", in: "query", required: false, schema: { type: "string", enum: ["active", "inactive"] } },
        ],
        responses: {
          200: {
            description: "Daftar user pengguna",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "array",
                      items: { $ref: "#/components/schemas/UserItem" },
                    },
                  },
                },
              },
            },
          },
          401: { description: "Sesi tidak valid" },
          403: { description: "Tidak memiliki hak akses kelola user" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
      post: {
        tags: ["Users"],
        summary: "Buat akun user baru",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/UserCreatePayload" },
            },
          },
        },
        responses: {
          201: {
            description: "User baru berhasil dibuat",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string", example: "User baru berhasil ditambahkan." },
                    data: { $ref: "#/components/schemas/UserItem" },
                  },
                },
              },
            },
          },
          400: { description: "Validasi gagal (username duplikat/format salah/password tidak sesuai rule)" },
          401: { description: "Sesi tidak valid" },
          403: { description: "Tidak memiliki izin create user" },
          500: { $ref: "#/components/responses/ServerError" },
        },
      },
    },
    "/api/users/{id}": {
      get: {
        tags: ["Users"],
        summary: "Ambil detail user berdasarkan ID",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, example: 1 },
        ],
        responses: {
          200: {
            description: "Detail user",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: { $ref: "#/components/schemas/UserItem" },
                  },
                },
              },
            },
          },
          404: { description: "User tidak ditemukan" },
        },
      },
      put: {
        tags: ["Users"],
        summary: "Perbarui data user (nama, username, role, status, optional password)",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, example: 1 },
        ],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: "#/components/schemas/UserUpdatePayload" },
            },
          },
        },
        responses: {
          200: {
            description: "User berhasil diperbarui",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                    data: { $ref: "#/components/schemas/UserItem" },
                  },
                },
              },
            },
          },
          400: { description: "Data tidak valid" },
          404: { description: "User tidak ditemukan" },
        },
      },
      delete: {
        tags: ["Users"],
        summary: "Hapus (soft delete) akun user (kecuali akun diri sendiri)",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" }, example: 2 },
        ],
        responses: {
          200: {
            description: "User berhasil dihapus",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                  },
                },
              },
            },
          },
          400: { description: "Dilarang menghapus akun sendiri" },
          404: { description: "User tidak ditemukan" },
        },
      },
    },
    "/api/transport/settings": {
      get: {
        tags: ["Transport Settings"],
        summary: "Ambil konfigurasi setting tarif tunjangan transport aktif",
        responses: {
          200: {
            description: "Data setting aktif berhasil diambil",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "object",
                      nullable: true,
                      properties: {
                        id: { type: "integer", example: 1 },
                        base_fare: { type: "number", example: 5000 },
                        effective_start: { type: "string", format: "date", example: "2026-01-01" },
                        min_km: { type: "number", example: 5 },
                        max_km: { type: "number", example: 25 },
                        min_work_days: { type: "integer", example: 19 },
                        is_active: { type: "boolean", example: true },
                        created_at: { type: "string", format: "date-time" },
                        updated_at: { type: "string", format: "date-time" },
                      },
                    },
                  },
                },
              },
            },
          },
          403: { description: "Forbidden - Tidak memiliki hak akses" },
        },
      },
      post: {
        tags: ["Transport Settings"],
        summary: "Simpan konfigurasi baru setting tarif tunjangan transport",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["base_fare", "effective_start"],
                properties: {
                  base_fare: { type: "number", example: 5000, description: "Tarif rupiah per kilometer" },
                  effective_start: { type: "string", format: "date", example: "2026-01-01" },
                  min_km: { type: "number", example: 5, default: 5 },
                  max_km: { type: "number", example: 25, default: 25 },
                  min_work_days: { type: "integer", example: 19, default: 19 },
                },
              },
            },
          },
        },
        responses: {
          200: {
            description: "Pengaturan berhasil disimpan",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    message: { type: "string" },
                    data: { type: "object" },
                  },
                },
              },
            },
          },
          422: { description: "Data tidak valid" },
          403: { description: "Forbidden" },
        },
      },
    },
    "/api/transport/periods": {
      get: {
        tags: ["Transport Allowance"],
        summary: "Ambil daftar rekapitulasi periode tunjangan transport bulanan",
        parameters: [
          { name: "year", in: "query", required: false, schema: { type: "integer", example: 2026 } },
          { name: "search", in: "query", required: false, schema: { type: "string" } },
          { name: "page", in: "query", required: false, schema: { type: "integer", default: 1 } },
          { name: "limit", in: "query", required: false, schema: { type: "integer", default: 12 } },
        ],
        responses: {
          200: {
            description: "Daftar periode berhasil diambil",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "array",
                      items: {
                        type: "object",
                        properties: {
                          id: { type: "integer", example: 1 },
                          period_year: { type: "integer", example: 2026 },
                          period_month: { type: "integer", example: 8 },
                          month_name: { type: "string", example: "Agustus" },
                          period_label: { type: "string", example: "Agustus 2026" },
                          total_recipients: { type: "integer", example: 1 },
                          total_amount: { type: "number", example: 945000 },
                          status: { type: "string", enum: ["draft", "calculated", "locked"], example: "calculated" },
                        },
                      },
                    },
                    meta: {
                      type: "object",
                      properties: {
                        total: { type: "integer" },
                        page: { type: "integer" },
                        limit: { type: "integer" },
                        total_pages: { type: "integer" },
                        available_years: { type: "array", items: { type: "integer" } },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
    "/api/transport/periods/{id}": {
      get: {
        tags: ["Transport Allowance"],
        summary: "Ambil detail periode dan daftar hasil perhitungan tunjangan transport penerima",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" } },
          { name: "search", in: "query", required: false, schema: { type: "string" } },
          { name: "sort_by", in: "query", required: false, schema: { type: "string", enum: ["name", "km", "hari", "nominal"], default: "name" } },
          { name: "sort_dir", in: "query", required: false, schema: { type: "string", enum: ["asc", "desc"], default: "asc" } },
          { name: "page", in: "query", required: false, schema: { type: "integer", default: 1 } },
          { name: "limit", in: "query", required: false, schema: { type: "integer", default: 20 } },
        ],
        responses: {
          200: {
            description: "Detail periode dan list penerima",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    success: { type: "boolean", example: true },
                    data: {
                      type: "object",
                      properties: {
                        period: { type: "object" },
                        recipients: {
                          type: "array",
                          items: {
                            type: "object",
                            properties: {
                              no: { type: "integer" },
                              id: { type: "integer" },
                              nip: { type: "string", example: "EMP-001" },
                              name: { type: "string", example: "Ahmad Hermawan" },
                              km: { type: "number", example: 9 },
                              hari: { type: "integer", example: 21 },
                              nominal: { type: "number", example: 945000 },
                              eligibility_status: { type: "string", example: "eligible" },
                            },
                          },
                        },
                      },
                    },
                    meta: { type: "object" },
                  },
                },
              },
            },
          },
          404: { description: "Periode tidak ditemukan" },
        },
      },
    },
    "/api/transport/periods/{id}/calculate": {
      post: {
        tags: ["Transport Allowance"],
        summary: "Memicu kalkulasi tunjangan transport otomatis untuk seluruh pegawai tetap di periode tersebut",
        parameters: [
          { name: "id", in: "path", required: true, schema: { type: "integer" } },
        ],
        responses: {
          200: {
            description: "Perhitungan berhasil diselesaikan",
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
                        period_id: { type: "integer" },
                        total_recipients: { type: "integer" },
                        total_amount: { type: "number" },
                      },
                    },
                  },
                },
              },
            },
          },
          403: { description: "Forbidden" },
          404: { description: "Periode tidak ditemukan" },
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
      PaginationMeta: {
        type: "object",
        properties: {
          total: { type: "integer", example: 45 },
          page: { type: "integer", example: 1 },
          perPage: { type: "integer", example: 10 },
          totalPages: { type: "integer", example: 5 },
        },
      },
      DistrictSearchResult: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          district_code: { type: "string", example: "3273010" },
          district_name: { type: "string", example: "Sukasari" },
          regency_id: { type: "integer", example: 1 },
          regency_code: { type: "string", example: "3273" },
          regency_name: { type: "string", example: "Kota Bandung" },
          province_id: { type: "integer", example: 1 },
          province_code: { type: "string", example: "32" },
          province_name: { type: "string", example: "Jawa Barat" },
          full_location: { type: "string", example: "Sukasari, Kota Bandung, Jawa Barat" },
        },
      },
      EmployeeEducationItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          education_level: { type: "string", example: "S1" },
          school_name: { type: "string", example: "Universitas Padjadjaran" },
          graduation_year: { type: "integer", example: 2015 },
          sort_order: { type: "integer", example: 1 },
        },
      },
      EmployeeListItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          nip: { type: "string", example: "EMP-001" },
          name: { type: "string", example: "Ahmad Hermawan" },
          email: { type: "string", example: "ahmad@example.com" },
          phone: { type: "string", example: "+6281234567801" },
          photo_url: { type: "string", example: "/uploads/employees/emp_1.jpg" },
          joined_at: { type: "string", format: "date", example: "2022-05-14" },
          tenure_years: { type: "integer", example: 3 },
          tenure_months: { type: "integer", example: 4 },
          tenure_text: { type: "string", example: "3 Tahun 4 Bulan" },
          employment_type: {
            type: "string",
            enum: ["pkwtt", "pkwt", "magang"],
            example: "pkwtt",
          },
          status: {
            type: "string",
            enum: ["active", "inactive"],
            example: "active",
          },
          department_id: { type: "integer", example: 1 },
          department_name: { type: "string", example: "HRD" },
          position_id: { type: "integer", example: 13 },
          position_name: { type: "string", example: "Manager HRD" },
          position_type: { type: "string", example: "manager" },
          district_name: { type: "string", example: "Sukasari" },
          regency_name: { type: "string", example: "Kota Bandung" },
          province_name: { type: "string", example: "Jawa Barat" },
        },
      },
      EmployeeDetail: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          nip: { type: "string", example: "EMP-001" },
          name: { type: "string", example: "Ahmad Hermawan" },
          email: { type: "string", example: "ahmad@example.com" },
          phone: { type: "string", example: "+6281234567801" },
          photo_url: { type: "string", example: "/uploads/employees/emp_1.jpg" },
          birth_place: { type: "string", example: "Bandung" },
          birth_date: { type: "string", format: "date", example: "1993-04-12" },
          age: { type: "integer", example: 33 },
          marital_status: { type: "string", example: "Menikah" },
          children_count: { type: "integer", example: 1 },
          joined_at: { type: "string", format: "date", example: "2022-05-14" },
          tenure_years: { type: "integer", example: 4 },
          tenure_months: { type: "integer", example: 2 },
          tenure_text: { type: "string", example: "4 Tahun 2 Bulan" },
          position_id: { type: "integer", example: 13 },
          position_name: { type: "string", example: "Manager HRD" },
          position_code: { type: "string", example: "HR-MANAGER" },
          department_id: { type: "integer", example: 1 },
          department_name: { type: "string", example: "HRD" },
          department_code: { type: "string", example: "HR" },
          employment_type: { type: "string", example: "pkwtt" },
          gender: { type: "string", example: "Laki-laki" },
          distance_km: { type: "number", example: 8.5 },
          district_id: { type: "integer", example: 1 },
          district_name: { type: "string", example: "Sukasari" },
          regency_id: { type: "integer", example: 1 },
          regency_name: { type: "string", example: "Kota Bandung" },
          province_id: { type: "integer", example: 1 },
          province_name: { type: "string", example: "Jawa Barat" },
          full_address: { type: "string", example: "Sukasari, Kota Bandung" },
          status: { type: "string", example: "active" },
          educations: {
            type: "array",
            items: { $ref: "#/components/schemas/EmployeeEducationItem" },
          },
        },
      },
      EmployeeCreatePayload: {
        type: "object",
        required: [
          "nip",
          "name",
          "email",
          "phone",
          "birth_place",
          "birth_date",
          "marital_status",
          "children_count",
          "joined_at",
          "position_id",
          "department_id",
          "employment_type",
          "district_id",
          "full_address",
          "distance_km",
        ],
        properties: {
          nip: { type: "string", example: "199001010001", description: "Minimal 8 digit angka tanpa spasi" },
          name: { type: "string", example: "Budi Santoso", description: "Hanya huruf, angka, tanda petik atas, dan spasi" },
          email: { type: "string", example: "budi.santoso@example.com" },
          phone: { type: "string", example: "+6281234567890", description: "Format internasional (+62...)" },
          birth_place: { type: "string", example: "Yogyakarta" },
          birth_date: { type: "string", format: "date", example: "1990-05-15" },
          marital_status: { type: "string", enum: ["Menikah", "Belum Menikah"], example: "Menikah" },
          children_count: { type: "integer", example: 2, description: "Maksimal 2 digit (0-99)" },
          joined_at: { type: "string", format: "date", example: "2023-01-10" },
          position_id: { type: "integer", example: 2 },
          department_id: { type: "integer", example: 2 },
          employment_type: {
            type: "string",
            enum: ["pkwtt", "pkwt", "magang"],
            example: "pkwtt",
          },
          gender: {
            type: "string",
            enum: ["Laki-laki", "Perempuan"],
            example: "Laki-laki",
          },
          distance_km: { type: "number", example: 7, description: "Maksimal 2 digit (0-99)" },
          district_id: { type: "integer", example: 25, description: "ID kecamatan dari endpoint /api/wilayah/districts" },
          full_address: { type: "string", example: "Jl. Bantul Km 5, Kasihan" },
          status: {
            type: "string",
            enum: ["active", "inactive"],
            example: "active",
          },
          photo: { type: "string", description: "Data URI base64 atau path file gambar" },
          educations: {
            type: "array",
            items: {
              type: "object",
              properties: {
                education_level: { type: "string", example: "S1" },
                school_name: { type: "string", example: "Universitas Gadjah Mada" },
                graduation_year: { type: "integer", example: 2012 },
              },
            },
          },
        },
      },
      EmployeeUpdatePayload: {
        type: "object",
        properties: {
          nip: { type: "string", example: "199001010001" },
          name: { type: "string", example: "Budi Santoso" },
          email: { type: "string", example: "budi.santoso@example.com" },
          phone: { type: "string", example: "+6281234567890" },
          birth_place: { type: "string", example: "Yogyakarta" },
          birth_date: { type: "string", format: "date", example: "1990-05-15" },
          marital_status: { type: "string", example: "Menikah" },
          children_count: { type: "integer", example: 2 },
          joined_at: { type: "string", format: "date", example: "2023-01-10" },
          position_id: { type: "integer", example: 2 },
          department_id: { type: "integer", example: 2 },
          employment_type: { type: "string", example: "pkwtt" },
          gender: { type: "string", example: "Laki-laki" },
          distance_km: { type: "number", example: 7 },
          district_id: { type: "integer", example: 25 },
          full_address: { type: "string", example: "Jl. Bantul Km 5, Kasihan" },
          status: { type: "string", example: "active" },
          photo: { type: "string" },
          educations: {
            type: "array",
            items: {
              type: "object",
              properties: {
                education_level: { type: "string" },
                school_name: { type: "string" },
                graduation_year: { type: "integer" },
              },
            },
          },
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
      PositionItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          code: { type: "string", example: "HR-OFFICER" },
          name: { type: "string", example: "HR Officer" },
          positionType: { type: "string", example: "staf" },
        },
      },
      UserItem: {
        type: "object",
        properties: {
          id: { type: "integer", example: 1 },
          name: { type: "string", example: "Ahmad Hermawan" },
          username: { type: "string", example: "ahmadhermawan" },
          email: { type: "string", example: "ahmad@example.com", nullable: true },
          cellphone: { type: "string", example: "081234567801", nullable: true },
          status: { type: "string", enum: ["active", "inactive"], example: "active" },
          role_id: { type: "integer", example: 2 },
          role_code: { type: "string", example: "manager_hrd" },
          role_name: { type: "string", example: "Manager HRD" },
          employee_id: { type: "integer", example: 1, nullable: true },
          employee_nip: { type: "string", example: "EMP-001", nullable: true },
          employee_name: { type: "string", example: "Ahmad Hermawan", nullable: true },
          position_id: { type: "integer", example: 2, nullable: true },
          position_name: { type: "string", example: "HR Manager", nullable: true },
          department_id: { type: "integer", example: 1, nullable: true },
          department_name: { type: "string", example: "Human Resources", nullable: true },
          created_at: { type: "string", format: "date-time" },
          updated_at: { type: "string", format: "date-time" },
        },
      },
      UserCreatePayload: {
        type: "object",
        required: ["name", "username", "password", "role_id"],
        properties: {
          name: { type: "string", example: "Ahmad Hermawan" },
          username: { type: "string", example: "ahmadhermawan", description: "Min 6 char, lowercase alfanumerik tanpa spasi" },
          password: { type: "string", example: "Rahasia#123", description: "Min 8 char, uppercase, lowercase, simbol" },
          role_id: { type: "integer", example: 2 },
          employee_id: { type: "integer", example: 1, nullable: true },
          status: { type: "string", enum: ["active", "inactive"], default: "active" },
        },
      },
      UserUpdatePayload: {
        type: "object",
        properties: {
          name: { type: "string" },
          username: { type: "string" },
          password: { type: "string", description: "Kosongkan jika tidak ingin mengubah password" },
          role_id: { type: "integer" },
          employee_id: { type: "integer", nullable: true },
          status: { type: "string", enum: ["active", "inactive"] },
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
