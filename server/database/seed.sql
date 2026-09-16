START TRANSACTION;

INSERT INTO provinces (code, name) VALUES ('32', 'Jawa Barat')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO regencies (province_id, code, name)
SELECT id, '3273', 'Kota Bandung' FROM provinces WHERE code = '32'
ON DUPLICATE KEY UPDATE name = VALUES(name), province_id = VALUES(province_id);

INSERT INTO districts (regency_id, code, name)
SELECT id, '3273010', 'Sukasari' FROM regencies WHERE code = '3273'
ON DUPLICATE KEY UPDATE name = VALUES(name), regency_id = VALUES(regency_id);

INSERT INTO departments (code, name) VALUES
  ('HR', 'Human Resources'), ('ENG', 'Engineering'), ('FIN', 'Finance')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO positions (code, name, position_type) VALUES
  ('HR-OFFICER', 'HR Officer', 'staf'),
  ('SOFTWARE-ENGINEER', 'Software Engineer', 'staf'),
  ('ACCOUNTANT', 'Accountant', 'staf')
ON DUPLICATE KEY UPDATE name = VALUES(name), position_type = VALUES(position_type);

INSERT INTO employees (
  nip, name, email, phone, birth_place, birth_date, marital_status,
  children_count, joined_at, position_id, department_id, employment_type,
  gender, distance_km, district_id, full_address, status
) VALUES
  ('EMP-001', 'Ahmad Hermawan', 'ahmad@example.com', '081234567801',
   'Bandung', '1993-04-12', 'Menikah', 1, '2022-05-14',
   (SELECT id FROM positions WHERE code = 'SOFTWARE-ENGINEER'),
   (SELECT id FROM departments WHERE code = 'ENG'), 'pkwtt', 'Laki-laki', 8.50,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active'),
  ('EMP-002', 'Dhea Angela', 'dhea@example.com', '081234567802',
   'Bandung', '1997-08-20', 'Belum Menikah', 0, '2024-01-08',
   (SELECT id FROM positions WHERE code = 'ACCOUNTANT'),
   (SELECT id FROM departments WHERE code = 'FIN'), 'pkwt', 'Perempuan', 5.25,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active'),
  ('EMP-003', 'Riko Salim', 'riko@example.com', '081234567803',
   'Cimahi', '2002-11-05', 'Belum Menikah', 0, '2026-07-01',
   (SELECT id FROM positions WHERE code = 'HR-OFFICER'),
   (SELECT id FROM departments WHERE code = 'HR'), 'magang', 'Laki-laki', 11.00,
   (SELECT id FROM districts WHERE code = '3273010'), 'Sukasari, Kota Bandung', 'active')
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email),
  position_id = VALUES(position_id), department_id = VALUES(department_id),
  employment_type = VALUES(employment_type), status = VALUES(status);

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
