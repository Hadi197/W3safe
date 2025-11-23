-- =====================================================
-- ADD MISSING COLUMNS - Fix silent_inspection table
-- Run this in Supabase SQL Editor to add missing columns
-- =====================================================

-- Add nomor_inspeksi column to silent_inspection table
DO $$
BEGIN
  -- Add nomor_inspeksi column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'silent_inspection' AND column_name = 'nomor_inspeksi') THEN
    ALTER TABLE silent_inspection ADD COLUMN nomor_inspeksi VARCHAR(50) UNIQUE;
    RAISE NOTICE 'Added nomor_inspeksi column to silent_inspection table';
  END IF;

  -- Generate nomor_inspeksi values for existing records using a simpler approach
  UPDATE silent_inspection
  SET nomor_inspeksi = 'SI-' || TO_CHAR(tanggal, 'YYYY-MM-DD') || '-' || LPAD(RIGHT(id::text, 4), 3, '0')
  WHERE nomor_inspeksi IS NULL;

  RAISE NOTICE 'Generated nomor_inspeksi values for existing records';
END $$;

-- Add index for the new column
CREATE INDEX IF NOT EXISTS idx_silent_inspection_nomor ON silent_inspection(nomor_inspeksi);

-- Verify the changes
SELECT 'Missing columns added successfully!' as status;
SELECT
  'silent_inspection' as table_name,
  COUNT(*) as row_count,
  COUNT(nomor_inspeksi) as nomor_inspeksi_count
FROM silent_inspection;