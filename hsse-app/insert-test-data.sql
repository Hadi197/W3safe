-- =====================================================
-- TEMPORARY: Disable RLS and Insert Test Data
-- Run this in Supabase SQL Editor for TESTING ONLY
-- =====================================================

-- Disable RLS temporarily for testing
ALTER TABLE units DISABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah DISABLE ROW LEVEL SECURITY;
ALTER TABLE management_walkthrough DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_forum DISABLE ROW LEVEL SECURITY;

-- Insert wilayah
INSERT INTO wilayah (kode, nama, regional, aktif) VALUES
  ('WIL-3', 'Wilayah 3', 'Regional 3', true)
ON CONFLICT (kode) DO NOTHING;

-- Insert areas
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id, aktif) VALUES
  ('AREA-JAWA1', 'Area Jawa 1', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true),
  ('AREA-KALIMANTAN3', 'Area Kalimantan 3', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true),
  ('AREA-BALINUSRA', 'Area Bali Nusatenggara', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true)
ON CONFLICT (kode) DO NOTHING;

-- Insert units
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id, aktif) VALUES
  -- Area Jawa 1
  ('UNIT-TANJUNGPERAK', 'Tanjung Perak', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),
  ('UNIT-GRESIK', 'Gresik', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),
  ('UNIT-TANJUNGINTAN', 'Tanjung Intan', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),

  -- Area Kalimantan 3
  ('UNIT-BANJARMASIN', 'Banjarmasin', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-KOTABARU', 'Kotabaru', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-MEKARPUTIH', 'Mekar Putih', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-BATULICIN', 'Batulicin', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-SATUI', 'Satui', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-BUNATI', 'Bunati', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-SAMPIT', 'Sampit', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-KUMAI', 'Kumai', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),

  -- Area Bali Nusatenggara
  ('UNIT-BENOA', 'Benoa', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-CELUKANBAWANG', 'Celukan Bawang', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-LEMBAR', 'Lembar', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-TENAUKUPANG', 'Tenau Kupang', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true)
ON CONFLICT (kode) DO NOTHING;

-- Insert test Management Walkthrough data for November 2025
INSERT INTO management_walkthrough (
  nomor_walkthrough,
  tanggal_walkthrough,
  unit_id,
  area_inspeksi,
  pimpinan_walkthrough,
  status
) VALUES
  ('MW-2025-11-001', '2025-11-01', (SELECT id FROM units WHERE kode = 'UNIT-TANJUNGPERAK'), 'Area Produksi', 'John Doe', 'completed'),
  ('MW-2025-11-002', '2025-11-15', (SELECT id FROM units WHERE kode = 'UNIT-GRESIK'), 'Area Maintenance', 'Jane Smith', 'completed'),
  ('MW-2025-11-003', '2025-11-20', (SELECT id FROM units WHERE kode = 'UNIT-BANJARMASIN'), 'Area Operasional', 'Bob Wilson', 'completed')
ON CONFLICT (nomor_walkthrough) DO NOTHING;

-- Verify data
SELECT 'Data insertion completed successfully!' as status;