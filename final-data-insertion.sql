-- =====================================================
-- FINAL DATA INSERTION - Run this in Supabase SQL Editor
-- This script inserts sample data without authentication
-- =====================================================

-- Temporarily disable RLS for data insertion
ALTER TABLE units DISABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah DISABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai DISABLE ROW LEVEL SECURITY;

-- Clear any existing data first
DELETE FROM pegawai;
DELETE FROM wilayah;
DELETE FROM units;

-- Insert sample units
INSERT INTO units (kode, nama, lokasi, aktif, tipe) VALUES
('UNIT-001', 'Unit Produksi A', 'Gedung A Lantai 2', true, 'unit'),
('UNIT-002', 'Unit Produksi B', 'Gedung B Lantai 1', true, 'unit'),
('UNIT-003', 'Unit Maintenance', 'Workshop', true, 'unit');

-- Insert sample wilayah
INSERT INTO wilayah (kode, nama, provinsi, kota, aktif) VALUES
('WIL-JKT-01', 'Wilayah Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', true),
('WIL-JKT-02', 'Wilayah Jakarta Selatan', 'DKI Jakarta', 'Jakarta Selatan', true);

-- Insert sample pegawai (reference the unit we just inserted)
INSERT INTO pegawai (nip, nama_lengkap, email, phone, jabatan, unit_id, role, status) VALUES
('EMP-2024-001', 'Budi Santoso', 'budi.santoso@company.com', '081234567890', 'Safety Officer',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'user', 'aktif'),
('EMP-2024-002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HSE Manager',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'manager', 'aktif'),
('EMP-2024-003', 'Ahmad Hidayat', 'ahmad.hidayat@company.com', '081234567892', 'Admin',
  NULL, 'admin', 'aktif');

-- Re-enable RLS
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah ENABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai ENABLE ROW LEVEL SECURITY;

-- Verify the data insertion
SELECT 'Sample data inserted successfully!' as status;
SELECT
  'units' as table_name, COUNT(*) as row_count FROM units
UNION ALL
SELECT 'wilayah', COUNT(*) FROM wilayah
UNION ALL
SELECT 'pegawai', COUNT(*) FROM pegawai;