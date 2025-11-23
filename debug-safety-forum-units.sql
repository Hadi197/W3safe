-- Debug safety_forum and units relationship
-- Check why unit name is not showing

-- Check safety_forum data
SELECT
  sf.id,
  sf.nomor_forum,
  sf.unit_id,
  sf.lokasi,
  sf.status
FROM safety_forum sf
WHERE sf.id = '0253a239-7f3e-4636-a600-bc491eb00005';

-- Check units table data
SELECT
  u.id,
  u.nama_unit,
  u.kode_unit
FROM units u
LIMIT 5;

-- Check the join manually
SELECT
  sf.id,
  sf.nomor_forum,
  sf.unit_id,
  u.nama_unit as unit_name,
  u.kode_unit as unit_code,
  sf.lokasi,
  sf.status
FROM safety_forum sf
LEFT JOIN units u ON sf.unit_id = u.id
WHERE sf.id = '0253a239-7f3e-4636-a600-bc491eb00005';

-- Check if unit_id exists in units table
SELECT
  sf.unit_id,
  CASE
    WHEN u.id IS NOT NULL THEN 'EXISTS in units'
    ELSE 'DOES NOT EXIST in units'
  END as unit_exists,
  u.nama_unit
FROM safety_forum sf
LEFT JOIN units u ON sf.unit_id = u.id
WHERE sf.id = '0253a239-7f3e-4636-a600-bc491eb00005';
