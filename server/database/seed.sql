START TRANSACTION;

-- Master Wilayah
INSERT INTO provinces (code, name) VALUES
  ('31', 'DKI Jakarta'),
  ('32', 'Jawa Barat'),
  ('33', 'Jawa Tengah'),
  ('34', 'D.I. Yogyakarta'),
  ('35', 'Jawa Timur'),
  ('36', 'Banten')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO regencies (province_id, code, name) VALUES
  ((SELECT id FROM provinces WHERE code = '31'), '3171', 'Kota Jakarta Pusat'),
  ((SELECT id FROM provinces WHERE code = '31'), '3174', 'Kota Jakarta Selatan'),
  ((SELECT id FROM provinces WHERE code = '32'), '3273', 'Kota Bandung'),
  ((SELECT id FROM provinces WHERE code = '32'), '3277', 'Kota Cimahi'),
  ((SELECT id FROM provinces WHERE code = '32'), '3204', 'Kabupaten Bandung'),
  ((SELECT id FROM provinces WHERE code = '32'), '3276', 'Kota Depok'),
  ((SELECT id FROM provinces WHERE code = '33'), '3374', 'Kota Semarang'),
  ((SELECT id FROM provinces WHERE code = '33'), '3372', 'Kota Surakarta'),
  ((SELECT id FROM provinces WHERE code = '34'), '3471', 'Kota Yogyakarta'),
  ((SELECT id FROM provinces WHERE code = '34'), '3402', 'Kabupaten Bantul'),
  ((SELECT id FROM provinces WHERE code = '34'), '3404', 'Kabupaten Sleman'),
  ((SELECT id FROM provinces WHERE code = '34'), '3403', 'Kabupaten Gunungkidul'),
  ((SELECT id FROM provinces WHERE code = '34'), '3401', 'Kabupaten Kulon Progo'),
  ((SELECT id FROM provinces WHERE code = '35'), '3578', 'Kota Surabaya')
ON DUPLICATE KEY UPDATE name = VALUES(name), province_id = VALUES(province_id);

INSERT INTO districts (regency_id, code, name) VALUES
  -- Kota Bandung
  ((SELECT id FROM regencies WHERE code = '3273'), '3273010', 'Sukasari'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273020', 'Coblong'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273030', 'Cicendo'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273040', 'Sumur Bandung'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273050', 'Lengkong'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273060', 'Andir'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273070', 'Regol'),
  ((SELECT id FROM regencies WHERE code = '3273'), '3273080', 'Buahbatu'),
  -- Kota Yogyakarta
  ((SELECT id FROM regencies WHERE code = '3471'), '3471010', 'Danurejan'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471020', 'Gedongtengen'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471030', 'Gondokusuman'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471040', 'Jetis'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471050', 'Kotagede'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471060', 'Kraton'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471070', 'Mantrijeron'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471080', 'Mergangsan'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471090', 'Ngampilan'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471100', 'Pakualaman'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471110', 'Tegalrejo'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471120', 'Umbulharjo'),
  ((SELECT id FROM regencies WHERE code = '3471'), '3471130', 'Wirobrajan'),
  -- Kab. Bantul
  ((SELECT id FROM regencies WHERE code = '3402'), '3402010', 'Kasihan'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402020', 'Sewon'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402030', 'Banguntapan'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402040', 'Bantul'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402050', 'Bambanglipuro'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402060', 'Imogiri'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402070', 'Piyungan'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402080', 'Pundong'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402090', 'Sanden'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402100', 'Sedayu'),
  ((SELECT id FROM regencies WHERE code = '3402'), '3402110', 'Srandakan'),
  -- Kab. Sleman
  ((SELECT id FROM regencies WHERE code = '3404'), '3404010', 'Depok'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404020', 'Mlati'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404030', 'Gamping'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404040', 'Kalasan'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404050', 'Ngaglik'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404060', 'Seyegan'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404070', 'Tempel'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404080', 'Pakem'),
  ((SELECT id FROM regencies WHERE code = '3404'), '3404090', 'Prambanan'),
  -- Kab. Gunungkidul
  ((SELECT id FROM regencies WHERE code = '3403'), '3403010', 'Wonosari'),
  ((SELECT id FROM regencies WHERE code = '3403'), '3403020', 'Playen'),
  ((SELECT id FROM regencies WHERE code = '3403'), '3403030', 'Semanu'),
  -- Kab. Kulon Progo
  ((SELECT id FROM regencies WHERE code = '3401'), '3401010', 'Wates'),
  ((SELECT id FROM regencies WHERE code = '3401'), '3401020', 'Sentolo'),
  ((SELECT id FROM regencies WHERE code = '3401'), '3401030', 'Pengasih'),
  -- Jakarta Pusat & Selatan
  ((SELECT id FROM regencies WHERE code = '3171'), '3171010', 'Gambir'),
  ((SELECT id FROM regencies WHERE code = '3171'), '3171020', 'Menteng'),
  ((SELECT id FROM regencies WHERE code = '3171'), '3171030', 'Tanah Abang'),
  ((SELECT id FROM regencies WHERE code = '3171'), '3171040', 'Senen'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174010', 'Kebayoran Baru'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174020', 'Kebayoran Lama'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174030', 'Cilandak'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174040', 'Setiabudi'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174050', 'Tebet'),
  ((SELECT id FROM regencies WHERE code = '3174'), '3174060', 'Pasar Minggu'),
  -- Surabaya & Semarang
  ((SELECT id FROM regencies WHERE code = '3578'), '3578010', 'Gubeng'),
  ((SELECT id FROM regencies WHERE code = '3578'), '3578020', 'Wonokromo'),
  ((SELECT id FROM regencies WHERE code = '3578'), '3578030', 'Tegalsari'),
  ((SELECT id FROM regencies WHERE code = '3578'), '3578040', 'Genteng'),
  ((SELECT id FROM regencies WHERE code = '3374'), '3374010', 'Semarang Tengah'),
  ((SELECT id FROM regencies WHERE code = '3374'), '3374020', 'Semarang Barat'),
  ((SELECT id FROM regencies WHERE code = '3374'), '3374030', 'Semarang Selatan')
ON DUPLICATE KEY UPDATE name = VALUES(name), regency_id = VALUES(regency_id);

-- Master Departemen
INSERT INTO departments (code, name) VALUES
  ('HR', 'HRD'),
  ('MKT', 'Marketing'),
  ('PROD', 'Production'),
  ('EXEC', 'Executive'),
  ('COMM', 'Commissioner'),
  ('ENG', 'Engineering'),
  ('FIN', 'Finance')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Master Jabatan
INSERT INTO positions (code, name, position_type) VALUES
  ('SUPERADMIN-STAFF', 'System Administrator', 'staf'),
  ('HR-MANAGER', 'Manager HRD', 'manager'),
  ('HR-OFFICER', 'HR Officer', 'staf'),
  ('SOFTWARE-ENGINEER', 'Software Engineer', 'staf'),
  ('ACCOUNTANT', 'Akuntan', 'staf'),
  ('MARKETING-STAFF', 'Marketing Staff', 'staf'),
  ('PRODUCTION-MANAGER', 'Manager Produksi', 'manager'),
  ('INTERN-HR', 'Magang HRD', 'magang')
ON DUPLICATE KEY UPDATE name = VALUES(name), position_type = VALUES(position_type);

-- Master Roles
INSERT INTO roles (code, name, description) VALUES
  ('superadmin', 'Superadmin', 'Memiliki hak akses penuh untuk kelola user, role, profile, dashboard, dan modul log.'),
  ('manager_hrd', 'Manager HRD', 'Manajer HRD dengan akses monitoring dashboard, read data pegawai, read presensi, dan read-only tunjangan transport.'),
  ('admin_hrd', 'Admin HRD', 'Administrator HRD operasional dengan akses CRUD data pegawai, presensi, dan setting tunjangan transport.')
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description);

-- Master Modules
INSERT INTO modules (code, name, description, sort_order) VALUES
  ('auth', 'Login/Logout/Session', 'Modul autentikasi, OTP email, dan manajemen sesi pengguna', 1),
  ('role', 'Kelola Role', 'Melihat hak akses role berbasis RBAC', 2),
  ('user', 'Kelola User', 'Manajemen data user dan aktivasi akun', 3),
  ('profile', 'My Profile', 'Profil pengguna dan ganti password', 4),
  ('dashboard', 'Dashboard', 'Halaman dashboard utama sesuai role', 5),
  ('employee', 'Modul Data Pegawai', 'Pengelolaan data pegawai (biodata, riwayat, kontrak)', 6),
  ('attendance', 'Modul Presensi', 'Pengelolaan presensi harian, checkin/checkout, dan status', 7),
  ('transport_allowance', 'Modul Tunjangan Transport', 'Perhitungan dan monitoring tunjangan transport pegawai', 8),
  ('transport_setting', 'Setting Tunjangan Transport', 'Pengaturan besaran tarif dan aturan tunjangan transport', 9),
  ('activity_log', 'Modul Log', 'Pencatatan aktivitas audit log sistem', 10)
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description), sort_order = VALUES(sort_order);

-- Permissions: Superadmin
-- Matrix: Login(Y), Role(R), User(CRUD), Profile(RO,UO), Dashboard(R), Pegawai(-), Presensi(X), Tunjangan(-), Setting(-), Log(R)
INSERT INTO role_permissions (role_id, module_id, can_access, can_create, read_scope, update_scope, delete_scope)
SELECT r.id, m.id,
  CASE WHEN m.code IN ('auth', 'role', 'user', 'profile', 'dashboard', 'activity_log') THEN 1 ELSE 0 END,
  CASE WHEN m.code IN ('user') THEN 1 ELSE 0 END,
  CASE
    WHEN m.code IN ('role', 'user', 'dashboard', 'activity_log') THEN 'all'
    WHEN m.code IN ('profile') THEN 'own'
    ELSE 'no'
  END,
  CASE
    WHEN m.code IN ('user') THEN 'all'
    WHEN m.code IN ('profile') THEN 'own'
    ELSE 'no'
  END,
  CASE
    WHEN m.code IN ('user') THEN 'all'
    ELSE 'no'
  END
FROM roles r
CROSS JOIN modules m
WHERE r.code = 'superadmin'
ON DUPLICATE KEY UPDATE
  can_access = VALUES(can_access),
  can_create = VALUES(can_create),
  read_scope = VALUES(read_scope),
  update_scope = VALUES(update_scope),
  delete_scope = VALUES(delete_scope);

-- Permissions: Manager HRD
-- Matrix: Login(Y), Role(-), User(-), Profile(RO,UO), Dashboard(R), Pegawai(R), Presensi(R), Tunjangan(RO), Setting(-), Log(-)
INSERT INTO role_permissions (role_id, module_id, can_access, can_create, read_scope, update_scope, delete_scope)
SELECT r.id, m.id,
  CASE WHEN m.code IN ('auth', 'profile', 'dashboard', 'employee', 'attendance', 'transport_allowance') THEN 1 ELSE 0 END,
  0,
  CASE
    WHEN m.code IN ('dashboard', 'employee', 'attendance') THEN 'all'
    WHEN m.code IN ('profile', 'transport_allowance') THEN 'own'
    ELSE 'no'
  END,
  CASE
    WHEN m.code IN ('profile') THEN 'own'
    ELSE 'no'
  END,
  'no'
FROM roles r
CROSS JOIN modules m
WHERE r.code = 'manager_hrd'
ON DUPLICATE KEY UPDATE
  can_access = VALUES(can_access),
  can_create = VALUES(can_create),
  read_scope = VALUES(read_scope),
  update_scope = VALUES(update_scope),
  delete_scope = VALUES(delete_scope);

-- Permissions: Admin HRD
-- Matrix: Login(Y), Role(-), User(-), Profile(RO,UO), Dashboard(R), Pegawai(CRUD), Presensi(CRUD), Tunjangan(RO), Setting(CRUD), Log(-)
INSERT INTO role_permissions (role_id, module_id, can_access, can_create, read_scope, update_scope, delete_scope)
SELECT r.id, m.id,
  CASE WHEN m.code IN ('auth', 'profile', 'dashboard', 'employee', 'attendance', 'transport_allowance', 'transport_setting') THEN 1 ELSE 0 END,
  CASE WHEN m.code IN ('employee', 'attendance', 'transport_setting') THEN 1 ELSE 0 END,
  CASE
    WHEN m.code IN ('dashboard', 'employee', 'attendance', 'transport_setting') THEN 'all'
    WHEN m.code IN ('profile', 'transport_allowance') THEN 'own'
    ELSE 'no'
  END,
  CASE
    WHEN m.code IN ('employee', 'attendance', 'transport_setting') THEN 'all'
    WHEN m.code IN ('profile') THEN 'own'
    ELSE 'no'
  END,
  CASE
    WHEN m.code IN ('employee', 'attendance', 'transport_setting') THEN 'all'
    ELSE 'no'
  END
FROM roles r
CROSS JOIN modules m
WHERE r.code = 'admin_hrd'
ON DUPLICATE KEY UPDATE
  can_access = VALUES(can_access),
  can_create = VALUES(can_create),
  read_scope = VALUES(read_scope),
  update_scope = VALUES(update_scope),
  delete_scope = VALUES(delete_scope);

-- Master Pegawai
INSERT INTO employees (
  nip, name, email, phone, birth_place, birth_date, marital_status,
  children_count, joined_at, position_id, department_id, employment_type,
  gender, distance_km, district_id, full_address, status
) VALUES
  ('EMP-001', 'Ahmad Hermawan', 'ahmad@example.com', '+6281234567801',
   'Bandung', '1993-04-12', 'Menikah', 1, '2022-05-14',
   (SELECT id FROM positions WHERE code = 'HR-MANAGER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwtt', 'Laki-laki', 8.50,
   (SELECT id FROM districts WHERE code = '3273010'), 'Jl. Sukasari No. 12, Bandung', 'active'),

  ('EMP-002', 'Dhea Angela', 'dhea@example.com', '+6281234567802',
   'Bandung', '1997-08-20', 'Belum Menikah', 0, '2024-01-08',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwt', 'Perempuan', 5.25,
   (SELECT id FROM districts WHERE code = '3273010'), 'Jl. Dr. Setiabudi No. 45, Bandung', 'active'),

  ('EMP-003', 'Riko Salim', 'riko@example.com', '+6281234567803',
   'Cimahi', '2002-11-05', 'Belum Menikah', 0, '2026-07-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'magang', 'Laki-laki', 11.00,
   (SELECT id FROM districts WHERE code = '3273010'), 'Jl. Cihanjuang No. 88, Cimahi', 'active'),

  ('EMP-004', 'Budi Santoso', 'budi.santoso@example.com', '+6281234567804',
   'Yogyakarta', '1990-03-15', 'Menikah', 2, '2020-02-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 6.00,
   (SELECT id FROM districts WHERE code = '3471040'), 'Jl. Jetis Pasiraman No. 10, Yogyakarta', 'active'),

  ('EMP-005', 'Siti Rahmawati', 'siti.rahma@example.com', '+6281234567805',
   'Bantul', '1995-09-22', 'Menikah', 1, '2021-06-15',
   (SELECT id FROM positions WHERE code = 'ACCOUNTANT'),
   (SELECT id FROM departments WHERE code = 'FIN'), 'pkwtt', 'Perempuan', 4.50,
   (SELECT id FROM districts WHERE code = '3402010'), 'Jl. Kasihan Bantul No. 22', 'active'),

  ('EMP-006', 'Fajar Pratama', 'fajar.pratama@example.com', '+6281234567806',
   'Sleman', '1998-12-10', 'Belum Menikah', 0, '2023-03-01',
   (SELECT id FROM positions WHERE code = 'MARKETING-STAFF'),
   (SELECT id FROM departments WHERE code = 'MKT'), 'pkwt', 'Laki-laki', 7.80,
   (SELECT id FROM districts WHERE code = '3404010'), 'Jl. Kaliurang Km 5, Depok, Sleman', 'active'),

  ('EMP-007', 'Shani Ratnasari', 'shani.ratna@example.com', '+6281234567807',
   'Surabaya', '1992-05-18', 'Menikah', 2, '2019-11-01',
   (SELECT id FROM positions WHERE code = 'PRODUCTION-MANAGER'),
   (SELECT id FROM departments WHERE code = 'PROD'), 'pkwtt', 'Perempuan', 12.00,
   (SELECT id FROM districts WHERE code = '3471010'), 'Jl. Danurejan No. 15, Yogyakarta', 'active'),

  ('EMP-008', 'Reza Dewanto', 'reza.dewanto@example.com', '+6281234567808',
   'Jakarta', '1994-01-25', 'Belum Menikah', 0, '2022-09-10',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 9.20,
   (SELECT id FROM districts WHERE code = '3404020'), 'Jl. Magelang Km 7, Mlati, Sleman', 'active'),

  ('EMP-009', 'Gita Sekar Arum', 'gita.sekar@example.com', '+6281234567809',
   'Semarang', '1999-07-30', 'Belum Menikah', 0, '2024-04-15',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwt', 'Perempuan', 3.50,
   (SELECT id FROM districts WHERE code = '3471030'), 'Jl. Gondokusuman No. 8, Yogyakarta', 'active'),

  ('EMP-010', 'Dimas Anggara', 'dimas.anggara@example.com', '+6281234567810',
   'Bandung', '2001-02-14', 'Belum Menikah', 0, '2025-08-01',
   (SELECT id FROM positions WHERE code = 'INTERN-HR'),
   (SELECT id FROM departments WHERE code = 'HR'), 'magang', 'Laki-laki', 14.00,
   (SELECT id FROM districts WHERE code = '3402020'), 'Jl. Parangtritis Km 6, Sewon, Bantul', 'active'),

  ('EMP-011', 'Lestari Handayani', 'lestari.h@example.com', '+6281234567811',
   'Yogyakarta', '1991-10-05', 'Menikah', 3, '2018-04-01',
   (SELECT id FROM positions WHERE code = 'ACCOUNTANT'),
   (SELECT id FROM departments WHERE code = 'FIN'), 'pkwtt', 'Perempuan', 5.00,
   (SELECT id FROM districts WHERE code = '3471050'), 'Jl. Kotagede No. 34, Yogyakarta', 'active'),

  ('EMP-012', 'Bagus Prasetyo', 'bagus.p@example.com', '+6281234567812',
   'Surakarta', '1996-04-19', 'Belum Menikah', 0, '2023-08-20',
   (SELECT id FROM positions WHERE code = 'MARKETING-STAFF'),
   (SELECT id FROM departments WHERE code = 'MKT'), 'pkwt', 'Laki-laki', 8.10,
   (SELECT id FROM districts WHERE code = '3404030'), 'Jl. Wates Km 4, Gamping, Sleman', 'active'),

  ('EMP-013', 'Maya Indah Sari', 'maya.indah@example.com', '+6281234567813',
   'Malang', '1995-11-28', 'Menikah', 1, '2021-12-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Perempuan', 6.70,
   (SELECT id FROM districts WHERE code = '3471060'), 'Jl. Patehan Kidul, Kraton, Yogyakarta', 'active'),

  ('EMP-014', 'Hendra Gunawan', 'hendra.g@example.com', '+6281234567814',
   'Cirebon', '1989-08-14', 'Menikah', 2, '2017-05-15',
   (SELECT id FROM positions WHERE code = 'PRODUCTION-MANAGER'),
   (SELECT id FROM departments WHERE code = 'PROD'), 'pkwtt', 'Laki-laki', 10.50,
   (SELECT id FROM districts WHERE code = '3402030'), 'Jl. Gedongkuning No. 12, Banguntapan', 'active'),

  ('EMP-015', 'Nadia Safitri', 'nadia.safitri@example.com', '+6281234567815',
   'Jakarta', '2000-06-03', 'Belum Menikah', 0, '2025-01-10',
   (SELECT id FROM positions WHERE code = 'MARKETING-STAFF'),
   (SELECT id FROM departments WHERE code = 'MKT'), 'pkwt', 'Perempuan', 4.00,
   (SELECT id FROM districts WHERE code = '3471080'), 'Jl. Kolonel Sugiyono, Mergangsan', 'active'),

  ('EMP-016', 'Andi Nugroho', 'andi.nugroho@example.com', '+6281234567816',
   'Purwokerto', '1993-03-21', 'Menikah', 1, '2020-10-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 13.00,
   (SELECT id FROM districts WHERE code = '3404050'), 'Jl. Palagan Tentara Pelajar Km 9, Ngaglik', 'active'),

  ('EMP-017', 'Putri Ayu Lestari', 'putri.ayu@example.com', '+6281234567817',
   'Bogor', '1998-01-17', 'Belum Menikah', 0, '2024-07-01',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwt', 'Perempuan', 6.30,
   (SELECT id FROM districts WHERE code = '3471110'), 'Jl. Kyai Mojo No. 50, Tegalrejo', 'active'),

  ('EMP-018', 'Wahyu Hidayat', 'wahyu.h@example.com', '+6281234567818',
   'Magelang', '2002-09-12', 'Belum Menikah', 0, '2026-02-01',
   (SELECT id FROM positions WHERE code = 'INTERN-HR'),
   (SELECT id FROM departments WHERE code = 'HR'), 'magang', 'Laki-laki', 15.50,
   (SELECT id FROM districts WHERE code = '3404090'), 'Jl. Raya Solo Km 14, Prambanan', 'active'),

  ('EMP-019', 'Rina Kartika', 'rina.kartika@example.com', '+6281234567819',
   'Surabaya', '1994-07-08', 'Menikah', 1, '2022-01-15',
   (SELECT id FROM positions WHERE code = 'ACCOUNTANT'),
   (SELECT id FROM departments WHERE code = 'FIN'), 'pkwtt', 'Perempuan', 7.00,
   (SELECT id FROM districts WHERE code = '3471120'), 'Jl. Veteran No. 20, Umbulharjo', 'active'),

  ('EMP-020', 'Eko Saputra', 'eko.saputra@example.com', '+6281234567820',
   'Solo', '1991-12-25', 'Menikah', 2, '2019-08-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 9.00,
   (SELECT id FROM districts WHERE code = '3404040'), 'Jl. Solo Km 10, Kalasan, Sleman', 'active'),

  ('EMP-021', 'Dewi Sartika', 'dewi.sartika@example.com', '+6281234567821',
   'Bandung', '1996-05-02', 'Belum Menikah', 0, '2023-11-01',
   (SELECT id FROM positions WHERE code = 'MARKETING-STAFF'),
   (SELECT id FROM departments WHERE code = 'MKT'), 'pkwt', 'Perempuan', 5.80,
   (SELECT id FROM districts WHERE code = '3471130'), 'Jl. RE Martadinata, Wirobrajan', 'active'),

  ('EMP-022', 'Arif Wijaya', 'arif.wijaya@example.com', '+6281234567822',
   'Semarang', '1990-02-18', 'Menikah', 3, '2018-09-15',
   (SELECT id FROM positions WHERE code = 'PRODUCTION-MANAGER'),
   (SELECT id FROM departments WHERE code = 'PROD'), 'pkwtt', 'Laki-laki', 11.20,
   (SELECT id FROM districts WHERE code = '3402040'), 'Jl. Jenderal Sudirman No. 8, Bantul', 'active'),

  ('EMP-023', 'Tania Kusuma', 'tania.kusuma@example.com', '+6281234567823',
   'Jakarta', '1997-10-14', 'Belum Menikah', 0, '2024-03-01',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwt', 'Perempuan', 8.70,
   (SELECT id FROM districts WHERE code = '3404080'), 'Jl. Kaliurang Km 14, Pakem, Sleman', 'active'),

  ('EMP-024', 'Bayu Firmansyah', 'bayu.f@example.com', '+6281234567824',
   'Yogyakarta', '2003-04-20', 'Belum Menikah', 0, '2026-05-01',
   (SELECT id FROM positions WHERE code = 'INTERN-HR'),
   (SELECT id FROM departments WHERE code = 'HR'), 'magang', 'Laki-laki', 16.00,
   (SELECT id FROM districts WHERE code = '3401010'), 'Jl. Diponegoro, Wates, Kulon Progo', 'active'),

  ('EMP-025', 'Agus Triyono', 'agus.triyono@example.com', '+6281234567825',
   'Klaten', '1988-11-30', 'Menikah', 2, '2016-01-10',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 6.50,
   (SELECT id FROM districts WHERE code = '3471070'), 'Jl. DI Panjaitan, Mantrijeron', 'inactive')
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email),
  position_id = VALUES(position_id), department_id = VALUES(department_id),
  employment_type = VALUES(employment_type), status = VALUES(status);

-- Master Riwayat Pendidikan Pegawai
INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S1', 'Universitas Padjadjaran', 2015, 1 FROM employees e WHERE e.nip = 'EMP-001'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'SMA', 'SMAN 3 Bandung', 2011, 2 FROM employees e WHERE e.nip = 'EMP-001'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S1', 'Universitas Pendidikan Indonesia', 2019, 1 FROM employees e WHERE e.nip = 'EMP-002'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'SMA', 'SMAN 1 Bandung', 2015, 2 FROM employees e WHERE e.nip = 'EMP-002'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'SMK', 'SMKN 1 Cimahi', 2020, 1 FROM employees e WHERE e.nip = 'EMP-003'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S1', 'Universitas Gadjah Mada', 2012, 1 FROM employees e WHERE e.nip = 'EMP-004'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S1', 'Universitas Negeri Yogyakarta', 2017, 1 FROM employees e WHERE e.nip = 'EMP-005'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S1', 'UPN Veteran Yogyakarta', 2020, 1 FROM employees e WHERE e.nip = 'EMP-006'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

INSERT INTO employee_educations (employee_id, education_level, school_name, graduation_year, sort_order)
SELECT e.id, 'S2', 'Institut Teknologi Bandung', 2016, 1 FROM employees e WHERE e.nip = 'EMP-007'
ON DUPLICATE KEY UPDATE school_name = VALUES(school_name);

-- Data Users untuk 3 Role
-- Password:
-- superadmin, manager.hrd, admin.hrd -> Boleh@123
INSERT INTO users (
  employee_id, role_id, name, username, email, cellphone, password, status
) VALUES
  (
    NULL,
    (SELECT id FROM roles WHERE code = 'superadmin'),
    'Super Administrator',
    'superadmin',
    'superadmin@example.com',
    '+6281234567800',
    'ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad',
    'active'
  ),
  (
    (SELECT id FROM employees WHERE nip = 'EMP-001'),
    (SELECT id FROM roles WHERE code = 'manager_hrd'),
    'Ahmad Hermawan (Manager HRD)',
    'manager.hrd',
    'manager.hrd@example.com',
    '+6281234567801',
    'ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad',
    'active'
  ),
  (
    (SELECT id FROM employees WHERE nip = 'EMP-002'),
    (SELECT id FROM roles WHERE code = 'admin_hrd'),
    'Dhea Angela (Admin HRD)',
    'admin.hrd',
    'admin.hrd@example.com',
    '+6281234567802',
    'ecf5e61937c287f1f767c09cf3023f6c:1f7946e8f3aeb7a13db46d916c4288475c307cfe6193b6199d4dcea9dc98df522b61ae532031f6839e24df8e8d10993aeb123bb225971372a6cb666ce025fcad',
    'active'
  )
ON DUPLICATE KEY UPDATE
  role_id = VALUES(role_id),
  employee_id = VALUES(employee_id),
  name = VALUES(name),
  email = VALUES(email),
  cellphone = VALUES(cellphone),
  password = VALUES(password),
  status = VALUES(status);

-- Master Absensi
INSERT INTO attendances (
  employee_id, attendance_date, checkin_at, checkout_at,
  checkin_location, checkout_location, attendance_type,
  duration_hours, status, verification_status, remarks
) VALUES
  ((SELECT id FROM employees WHERE nip = 'EMP-001'), '2026-09-16',
   '2026-09-16 08:01:00', '2026-09-16 17:03:00', 'Kantor', 'Kantor',
   'hadir', 9.03, 'terpenuhi', 'verified', 'Hadir tepat waktu'),
  ((SELECT id FROM employees WHERE nip = 'EMP-002'), '2026-09-16',
   NULL, NULL, NULL, NULL, 'cuti', NULL, 'terpenuhi', 'verified', 'Cuti tahunan'),
  ((SELECT id FROM employees WHERE nip = 'EMP-003'), '2026-09-16',
   '2026-09-16 08:10:00', '2026-09-16 17:00:00', 'Kantor', 'Kantor',
   'hadir', 8.83, 'terpenuhi', 'verified', NULL)
ON DUPLICATE KEY UPDATE checkin_at = VALUES(checkin_at),
  checkout_at = VALUES(checkout_at), attendance_type = VALUES(attendance_type),
  duration_hours = VALUES(duration_hours), status = VALUES(status), remarks = VALUES(remarks);

COMMIT;
