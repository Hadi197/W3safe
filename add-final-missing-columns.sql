-- Add the final missing columns to silent_inspection table
-- Frontend uses these columns but they don't exist in database

-- Add corrective action column
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS tindakan_korektif TEXT;

-- Add any other potential missing columns that might be referenced
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS fokus_inspeksi JSONB; -- if not already added
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS checklist JSONB; -- if not already added

-- Verify all critical columns exist
SELECT 'Final column check:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name IN (
    'tindakan_korektif', 'fokus_inspeksi', 'checklist', 'rekomendasi',
    'skor_kepatuhan', 'jumlah_temuan', 'foto_kondisi_unsafe'
  )
ORDER BY column_name;

-- Show the complete column list to ensure everything is there
SELECT 'Complete silent_inspection columns:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;
