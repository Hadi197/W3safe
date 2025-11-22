-- Reset Units Data dengan Struktur Baru (Wilayah → Area → Unit)
-- Run this in Supabase SQL Editor
-- SEMUA DATA AKAN DI WILAYAH 3

-- 1. Delete all existing units (akan cascade delete ke pegawai juga, hati-hati!)
DELETE FROM units;

-- 2. Re-insert dengan struktur baru - SEMUA DI WILAYAH 3
-- Insert Areas (terkait langsung ke Wilayah 3, area_id = NULL)
WITH 
  wil3 AS (SELECT id FROM wilayah WHERE kode = 'WIL-3' LIMIT 1)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) VALUES
  ('AREA-JAWA1', 'Area Jawa 1', 'area', (SELECT id FROM wil3), NULL),
  ('AREA-KALIMANTAN3', 'Area Kalimantan 3', 'area', (SELECT id FROM wil3), NULL),
  ('AREA-BALINUSRA', 'Area Bali Nusatenggara', 'area', (SELECT id FROM wil3), NULL);

-- Insert Units - Area Jawa 1 (TETAP DI WILAYAH 3)
WITH 
  wil3 AS (SELECT id FROM wilayah WHERE kode = 'WIL-3' LIMIT 1),
  area_jawa AS (SELECT id FROM units WHERE kode = 'AREA-JAWA1' LIMIT 1)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) VALUES
  ('UNIT-TANJUNGPERAK', 'Tanjung Perak', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_jawa)),
  ('UNIT-GRESIK', 'Gresik', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_jawa)),
  ('UNIT-TANJUNGINTAN', 'Tanjung Intan', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_jawa));

-- Insert Units - Area Kalimantan 3 (WILAYAH 3)
WITH 
  wil3 AS (SELECT id FROM wilayah WHERE kode = 'WIL-3' LIMIT 1),
  area_kal AS (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) VALUES
  ('UNIT-BANJARMASIN', 'Banjarmasin', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-KOTABARU', 'Kotabaru', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-MEKARPUTIH', 'Mekar Putih', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-BATULICIN', 'Batulicin', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-SATUI', 'Satui', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-BUNATI', 'Bunati', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-SAMPIT', 'Sampit', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal)),
  ('UNIT-KUMAI', 'Kumai', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_kal));

-- Insert Units - Area Bali Nusatenggara (WILAYAH 3)
WITH 
  wil3 AS (SELECT id FROM wilayah WHERE kode = 'WIL-3' LIMIT 1),
  area_bali AS (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA' LIMIT 1)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) VALUES
  ('UNIT-BENOA', 'Benoa', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_bali)),
  ('UNIT-CELUKANBAWANG', 'Celukan Bawang', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_bali)),
  ('UNIT-LEMBAR', 'Lembar', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_bali)),
  ('UNIT-TENAUKUPANG', 'Tenau Kupang', 'unit', (SELECT id FROM wil3), (SELECT id FROM area_bali));

-- 3. Verify
SELECT 
    u.kode,
    u.nama,
    u.tipe,
    w.nama as wilayah,
    a.nama as area
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
LEFT JOIN units a ON u.area_id = a.id
ORDER BY w.nama, u.tipe DESC, a.nama, u.nama;
