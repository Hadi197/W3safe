-- Fix foreign key relationships for silent_inspection table
-- Run this in Supabase SQL Editor

-- First, check current foreign keys
SELECT
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'silent_inspection'
ORDER BY tc.table_name;

-- Add missing foreign key constraints if they don't exist
DO $$
BEGIN
  -- Add foreign key for inspector_id if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'silent_inspection'
      AND constraint_name LIKE '%inspector_id%'
  ) THEN
    ALTER TABLE silent_inspection
    ADD CONSTRAINT fk_silent_inspection_inspector
    FOREIGN KEY (inspector_id) REFERENCES pegawai(id) ON DELETE RESTRICT;
    RAISE NOTICE 'Added foreign key constraint for inspector_id';
  END IF;

  -- Add foreign key for verified_by if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'silent_inspection'
      AND constraint_name LIKE '%verified_by%'
  ) THEN
    ALTER TABLE silent_inspection
    ADD CONSTRAINT fk_silent_inspection_verified_by
    FOREIGN KEY (verified_by) REFERENCES pegawai(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added foreign key constraint for verified_by';
  END IF;

  -- Add foreign key for unit_id if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'silent_inspection'
      AND constraint_name LIKE '%unit_id%'
  ) THEN
    ALTER TABLE silent_inspection
    ADD CONSTRAINT fk_silent_inspection_unit
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added foreign key constraint for unit_id';
  END IF;

END $$;

-- Verify the constraints were added
SELECT
  tc.table_name,
  tc.constraint_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'silent_inspection'
ORDER BY tc.table_name;