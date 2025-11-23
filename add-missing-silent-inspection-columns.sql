-- Add all missing columns to silent_inspection table
-- Frontend uses these columns but they don't exist in database

-- Add analysis columns
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS jumlah_temuan INTEGER DEFAULT 0;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS kategori_bahaya VARCHAR(100);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_critical INTEGER DEFAULT 0;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_major INTEGER DEFAULT 0;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_minor INTEGER DEFAULT 0;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS deskripsi_temuan TEXT;

-- Add risk assessment columns
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS tingkat_risiko VARCHAR(50);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS kondisi_housekeeping VARCHAR(100);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS penggunaan_apd VARCHAR(100);

-- Add follow-up columns
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS tindak_lanjut JSONB;
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS status_tindak_lanjut VARCHAR(50) DEFAULT 'pending';

-- Add verification columns
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS verified_by UUID REFERENCES pegawai(id);
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS verified_at TIMESTAMP WITH TIME ZONE;

-- Verify all columns were added
SELECT 'Added columns check:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name IN (
    'jumlah_temuan', 'kategori_bahaya', 'temuan_critical', 'temuan_major', 'temuan_minor',
    'deskripsi_temuan', 'tingkat_risiko', 'kondisi_housekeeping', 'penggunaan_apd',
    'tindak_lanjut', 'status_tindak_lanjut', 'verified_by', 'verified_at',
    'foto_kondisi_unsafe', 'foto_perilaku_unsafe'
  )
ORDER BY column_name;

-- Show complete silent_inspection structure
SELECT 'Complete silent_inspection structure:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;
