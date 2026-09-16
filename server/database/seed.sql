START TRANSACTION;

-- Master Wilayah
INSERT INTO provinces (code, name) VALUES ('32', 'Jawa Barat')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO regencies (province_id, code, name)
SELECT id, '3273', 'Kota Bandung' FROM provinces WHERE code = '32'
ON DUPLICATE KEY UPDATE name = VALUES(name), province_id = VALUES(province_id);

INSERT INTO districts (regency_id, code, name)
SELECT id, '3273010', 'Sukasari' FROM regencies WHERE code = '3273'
ON DUPLICATE KEY UPDATE name = VALUES(name), regency_id = VALUES(regency_id);

-- Master Departemen
INSERT INTO departments (code, name) VALUES
  ('HR', 'Human Resources'),
  ('ENG', 'Engineering'),
  ('FIN', 'Finance')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Master Jabatan
INSERT INTO positions (code, name, position_type) VALUES
  ('SUPERADMIN-STAFF', 'System Administrator', 'staf'),
  ('HR-MANAGER', 'HR Manager', 'manager'),
  ('HR-OFFICER', 'HR Officer', 'staf'),
  ('SOFTWARE-ENGINEER', 'Software Engineer', 'staf'),
  ('ACCOUNTANT', 'Accountant', 'staf')
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
  ('EMP-001', 'Ahmad Hermawan', 'ahmad@example.com', '081234567801',
   'Bandung', '1993-04-12', 'Menikah', 1, '2022-05-14',
   (SELECT id FROM positions WHERE code = 'HR-MANAGER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwtt', 'Laki-laki', 8.50,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active'),
  ('EMP-002', 'Dhea Angela', 'dhea@example.com', '081234567802',
   'Bandung', '1997-08-20', 'Belum Menikah', 0, '2024-01-08',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'pkwt', 'Perempuan', 5.25,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active'),
  ('EMP-003', 'Riko Salim', 'riko@example.com', '081234567803',
   'Cimahi', '2002-11-05', 'Belum Menikah', 0, '2026-07-01',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'magang', 'Laki-laki', 11.00,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active')
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email),
  position_id = VALUES(position_id), department_id = VALUES(department_id),
  employment_type = VALUES(employment_type), status = VALUES(status);

-- Data Users untuk 3 Role
-- Password:
-- 1. superadmin -> Admin#1234
-- 2. manager.hrd -> Manager#1234
-- 3. admin.hrd -> AdminHRD#1234
INSERT INTO users (
  employee_id, role_id, name, username, email, cellphone, password, status
) VALUES
  (
    NULL,
    (SELECT id FROM roles WHERE code = 'superadmin'),
    'Super Administrator',
    'superadmin',
    'superadmin@example.com',
    '081234567800',
    'e7141c972067503413abd7b04fce478f:297b40fc7a8fadb50e467af0d474d8364dec5d9e582f432f123202dc98f4227ce97ac7e3f62a6e330f7e3f3b577b7b2c157b8caf05d32a2ef5c8ecfa721b3ebc',
    'active'
  ),
  (
    (SELECT id FROM employees WHERE nip = 'EMP-001'),
    (SELECT id FROM roles WHERE code = 'manager_hrd'),
    'Ahmad Hermawan (Manager HRD)',
    'manager.hrd',
    'manager.hrd@example.com',
    '081234567801',
    '5899b788b2db6863ef44dde0a1e50eb8:be5175bdae4c61615136edf1d2353bac0fa6361d283c2bb8b98f5e53a9d1b9a5e693e9bc273b0aed821a78c9d46934e615c09df68777861960e6837e0f69941d',
    'active'
  ),
  (
    (SELECT id FROM employees WHERE nip = 'EMP-002'),
    (SELECT id FROM roles WHERE code = 'admin_hrd'),
    'Dhea Angela (Admin HRD)',
    'admin.hrd',
    'admin.hrd@example.com',
    '081234567802',
    '58e7ef837bddfe7346f635350f86bb9f:3c46b1a144b67cc6fcad52cd7e314093e3d984f0afc12cfcf087257c01bbf5f40080f2d0bb5811ffdb474a19414eaafac40f595a89815172b4fac4aadc90f627',
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
