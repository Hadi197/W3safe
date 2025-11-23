-- Add foto_kondisi_unsafe column to silent_inspection table
-- This column is used by frontend but missing from database schema

ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS foto_kondisi_unsafe JSONB;

-- Also add foto_perilaku_unsafe column if needed
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS foto_perilaku_unsafe JSONB;

-- Verify columns were added
SELECT 'Added columns check:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name IN ('foto_kondisi_unsafe', 'foto_perilaku_unsafe');

-- Show current silent_inspection structure
SELECT 'Silent inspection columns:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;
