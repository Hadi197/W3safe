-- Check silent_inspection table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;

-- Check if foto_kondisi_unsafe column exists
SELECT 'Does foto_kondisi_unsafe exist?' as check;
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name = 'foto_kondisi_unsafe';

-- Check what foto-related columns exist
SELECT 'Foto-related columns:' as info;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name LIKE '%foto%';

-- Check recent silent_inspection records
SELECT id, area_inspeksi, temuan, created_at
FROM silent_inspection
ORDER BY created_at DESC
LIMIT 3;
