-- Add remaining missing columns to silent_inspection table
-- Frontend uses these columns but they don't exist in database

-- Add compliance score column
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS skor_kepatuhan DECIMAL(5,2) DEFAULT 0;

-- Add any other missing columns that might be used
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS nomor_inspeksi VARCHAR(100);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS waktu_mulai TIME;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS waktu_selesai TIME;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS jenis_inspeksi VARCHAR(100);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS fokus_inspeksi JSONB;

-- Verify all columns were added
SELECT 'Remaining columns added:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name IN (
    'skor_kepatuhan', 'nomor_inspeksi', 'waktu_mulai', 'waktu_selesai',
    'jenis_inspeksi', 'fokus_inspeksi'
  )
ORDER BY column_name;

-- Show final silent_inspection structure
SELECT 'Final silent_inspection structure:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;

-- Test query that should now work
SELECT 'Test silent inspection query:' as info;
SELECT id, area_inspeksi, skor_kepatuhan, jumlah_temuan, foto_kondisi_unsafe
FROM silent_inspection
ORDER BY created_at DESC
LIMIT 1;
