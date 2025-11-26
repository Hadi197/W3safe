-- ALTER TABLE to add missing columns to safety_drill table
-- These columns exist in the TypeScript interface but not in the database

-- Add evaluation/scoring columns
ALTER TABLE safety_drill
ADD COLUMN IF NOT EXISTS penilaian_kesiapan NUMERIC,
ADD COLUMN IF NOT EXISTS penilaian_response NUMERIC,
ADD COLUMN IF NOT EXISTS penilaian_koordinasi NUMERIC,
ADD COLUMN IF NOT EXISTS penilaian_komunikasi NUMERIC,
ADD COLUMN IF NOT EXISTS penilaian_evakuasi NUMERIC,
ADD COLUMN IF NOT EXISTS penilaian_peralatan NUMERIC;

-- Add total scoring columns
ALTER TABLE safety_drill
ADD COLUMN IF NOT EXISTS skor_total NUMERIC,
ADD COLUMN IF NOT EXISTS skor_maksimal NUMERIC,
ADD COLUMN IF NOT EXISTS persentase_keberhasilan NUMERIC(5,2);

-- Add target/benchmark columns
ALTER TABLE safety_drill
ADD COLUMN IF NOT EXISTS target_waktu_evakuasi INTEGER,
ADD COLUMN IF NOT EXISTS selisih_waktu INTEGER,
ADD COLUMN IF NOT EXISTS target_tercapai BOOLEAN;

-- Add detail columns (if not already covered by existing columns)
ALTER TABLE safety_drill
ADD COLUMN IF NOT EXISTS detail_temuan JSONB,
ADD COLUMN IF NOT EXISTS detail_korban JSONB;

-- Verification query to check if columns were added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'safety_drill' 
AND column_name IN (
  'penilaian_kesiapan', 'penilaian_response', 'penilaian_koordinasi', 
  'penilaian_komunikasi', 'penilaian_evakuasi', 'penilaian_peralatan',
  'skor_total', 'skor_maksimal', 'persentase_keberhasilan',
  'target_waktu_evakuasi', 'selisih_waktu', 'target_tercapai',
  'detail_temuan', 'detail_korban'
)
ORDER BY column_name;
