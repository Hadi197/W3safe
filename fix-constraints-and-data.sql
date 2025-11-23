-- =====================================================
-- FIX CONSTRAINTS - Update unique constraints to use new column names
-- Run this in Supabase SQL Editor to fix constraint issues
-- =====================================================

-- Drop old constraints that reference old column names
DO $$
BEGIN
  -- Drop old units constraints
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'units' AND constraint_name = 'units_kode_unit_key') THEN
    ALTER TABLE units DROP CONSTRAINT units_kode_unit_key;
    RAISE NOTICE 'Dropped old units_kode_unit_key constraint';
  END IF;

  -- Drop old wilayah constraints
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'wilayah' AND constraint_name = 'wilayah_kode_wilayah_key') THEN
    ALTER TABLE wilayah DROP CONSTRAINT wilayah_kode_wilayah_key;
    RAISE NOTICE 'Dropped old wilayah_kode_wilayah_key constraint';
  END IF;

  -- Drop old pegawai constraints
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'pegawai' AND constraint_name = 'pegawai_nip_key') THEN
    ALTER TABLE pegawai DROP CONSTRAINT pegawai_nip_key;
    RAISE NOTICE 'Dropped old pegawai_nip_key constraint';
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'pegawai' AND constraint_name = 'pegawai_email_key') THEN
    ALTER TABLE pegawai DROP CONSTRAINT pegawai_email_key;
    RAISE NOTICE 'Dropped old pegawai_email_key constraint';
  END IF;

END $$;

-- Add new constraints for new column names
DO $$
BEGIN
  -- Add new units constraints
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'units' AND constraint_name = 'units_kode_key') THEN
    ALTER TABLE units ADD CONSTRAINT units_kode_key UNIQUE (kode);
    RAISE NOTICE 'Added new units_kode_key constraint';
  END IF;

  -- Add new wilayah constraints
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'wilayah' AND constraint_name = 'wilayah_kode_key') THEN
    ALTER TABLE wilayah ADD CONSTRAINT wilayah_kode_key UNIQUE (kode);
    RAISE NOTICE 'Added new wilayah_kode_key constraint';
  END IF;

  -- Add new pegawai constraints
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'pegawai' AND constraint_name = 'pegawai_nip_key') THEN
    ALTER TABLE pegawai ADD CONSTRAINT pegawai_nip_key UNIQUE (nip);
    RAISE NOTICE 'Added new pegawai_nip_key constraint';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'pegawai' AND constraint_name = 'pegawai_email_key') THEN
    ALTER TABLE pegawai ADD CONSTRAINT pegawai_email_key UNIQUE (email);
    RAISE NOTICE 'Added new pegawai_email_key constraint';
  END IF;

END $$;

-- Now insert sample data with correct column names
INSERT INTO units (kode, nama, lokasi, aktif, tipe) VALUES
('UNIT-001', 'Unit Produksi A', 'Gedung A Lantai 2', true, 'unit'),
('UNIT-002', 'Unit Produksi B', 'Gedung B Lantai 1', true, 'unit'),
('UNIT-003', 'Unit Maintenance', 'Workshop', true, 'unit')
ON CONFLICT (kode) DO NOTHING;

INSERT INTO wilayah (kode, nama, provinsi, kota, aktif) VALUES
('WIL-JKT-01', 'Wilayah Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', true),
('WIL-JKT-02', 'Wilayah Jakarta Selatan', 'DKI Jakarta', 'Jakarta Selatan', true)
ON CONFLICT (kode) DO NOTHING;

INSERT INTO pegawai (nip, nama_lengkap, email, phone, jabatan, unit_id, role, status) VALUES
('EMP-2024-001', 'Budi Santoso', 'budi.santoso@company.com', '081234567890', 'Safety Officer',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'user', 'aktif'),
('EMP-2024-002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HSE Manager',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'manager', 'aktif'),
('EMP-2024-003', 'Ahmad Hidayat', 'ahmad.hidayat@company.com', '081234567892', 'Admin',
  NULL, 'admin', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Verify the data insertion
SELECT 'Constraints fixed and sample data inserted successfully!' as status;
SELECT
  'units' as table_name, COUNT(*) as row_count FROM units
UNION ALL
SELECT 'wilayah', COUNT(*) FROM wilayah
UNION ALL
SELECT 'pegawai', COUNT(*) FROM pegawai;