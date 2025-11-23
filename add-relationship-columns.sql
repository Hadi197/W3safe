-- =====================================================
-- ADD MISSING RELATIONSHIP COLUMNS - Fix units table relationships
-- Run this in Supabase SQL Editor to add missing relationship columns
-- =====================================================

-- Add wilayah_id column to units table if it doesn't exist
DO $$
BEGIN
  -- Add wilayah_id column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'wilayah_id') THEN
    ALTER TABLE units ADD COLUMN wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added wilayah_id column to units table';
  END IF;

  -- Add area_id column if it doesn't exist (should already exist from previous migration)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'area_id') THEN
    ALTER TABLE units ADD COLUMN area_id UUID REFERENCES areas(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added area_id column to units table';
  END IF;

END $$;

-- Add index for the new wilayah_id column
CREATE INDEX IF NOT EXISTS idx_units_wilayah_id ON units(wilayah_id);

-- Update sample data to include wilayah relationships
UPDATE units SET wilayah_id = (
  SELECT id FROM wilayah WHERE kode = 'WIL-JKT-01' LIMIT 1
) WHERE kode IN ('UNIT-001', 'UNIT-002');

UPDATE units SET wilayah_id = (
  SELECT id FROM wilayah WHERE kode = 'WIL-JKT-02' LIMIT 1
) WHERE kode = 'UNIT-003';

-- Verify the changes
SELECT 'Relationship columns added successfully!' as status;
SELECT
  'units' as table_name,
  COUNT(*) as total_units,
  COUNT(wilayah_id) as units_with_wilayah,
  COUNT(area_id) as units_with_area
FROM units;