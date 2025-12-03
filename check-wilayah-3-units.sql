-- Check units in Wilayah 3
-- Run this in Supabase SQL Editor to verify data

-- Check all units and their wilayah from master_pelabuhan
SELECT 
  u.id,
  u.nama as unit_nama,
  u.kode as unit_kode,
  u.aktif as unit_aktif,
  w.nama as wilayah_nama,
  a.nama_area as area_nama
FROM units u
LEFT JOIN master_pelabuhan mp ON u.id = mp.unit_id
LEFT JOIN wilayah w ON mp.wilayah_id = w.id
LEFT JOIN areas a ON mp.area_id = a.id
ORDER BY w.nama, u.nama;

-- Check if Wilayah 3 exists
SELECT * FROM wilayah WHERE nama ILIKE '%wilayah 3%' OR kode ILIKE '%3%';

-- Check all units (active and inactive)
SELECT 
  id, 
  nama, 
  kode, 
  aktif,
  created_at
FROM units 
ORDER BY nama;

-- Check master_pelabuhan entries for Wilayah 3
SELECT 
  mp.*,
  w.nama as wilayah_nama,
  a.nama_area as area_nama,
  u.nama as unit_nama
FROM master_pelabuhan mp
JOIN wilayah w ON mp.wilayah_id = w.id
JOIN areas a ON mp.area_id = a.id
JOIN units u ON mp.unit_id = u.id
WHERE w.nama ILIKE '%wilayah 3%' OR w.kode ILIKE '%3%';
