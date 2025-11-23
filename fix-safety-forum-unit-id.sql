-- Fix unit_id for safety_forum record
-- Set the correct unit_id to link with "Unit Banjarmasin"

-- First, get the UUID of "Unit Banjarmasin"
SELECT id, nama_unit, kode_unit FROM units WHERE nama_unit = 'Unit Banjarmasin';

-- Then update the safety_forum record (replace 'UNIT-UUID-HERE' with actual UUID)
-- UPDATE safety_forum
-- SET unit_id = 'UNIT-UUID-HERE'
-- WHERE id = '0253a239-7f3e-4636-a600-bc491eb00005';

-- Or do it in one query:
UPDATE safety_forum
SET unit_id = (
    SELECT id FROM units
    WHERE nama_unit = 'Unit Banjarmasin'
    LIMIT 1
)
WHERE id = '0253a239-7f3e-4636-a600-bc491eb00005'
  AND unit_id IS NULL;

-- Verify the fix
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
