-- COMPLETE FIX for Safety Briefing Foreign Keys
-- Run this SQL step by step in Supabase SQL Editor

-- ====================================================================
-- STEP 1: Drop the problematic check constraint
-- ====================================================================
ALTER TABLE safety_briefing 
DROP CONSTRAINT IF EXISTS chk_unit_or_wilayah;

-- ====================================================================
-- STEP 2: Make petugas_id and unit_id nullable (remove NOT NULL constraint)
-- ====================================================================
ALTER TABLE safety_briefing 
ALTER COLUMN petugas_id DROP NOT NULL;

ALTER TABLE safety_briefing 
ALTER COLUMN unit_id DROP NOT NULL;

-- ====================================================================
-- STEP 3: Check and clean invalid unit_id references
-- ====================================================================

-- Check how many invalid unit_id records exist
SELECT 
    COUNT(*) as invalid_unit_count,
    COUNT(DISTINCT unit_id) as distinct_invalid_units
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
WHERE sb.unit_id IS NOT NULL 
  AND u.id IS NULL;

-- Set invalid unit_id to NULL
UPDATE safety_briefing
SET unit_id = NULL
WHERE unit_id IS NOT NULL 
  AND unit_id NOT IN (SELECT id FROM units);

-- ====================================================================
-- STEP 4: Check and clean invalid petugas_id references
-- ====================================================================

-- Check how many invalid petugas_id records exist
SELECT 
    COUNT(*) as invalid_petugas_count,
    COUNT(DISTINCT petugas_id) as distinct_invalid_petugas
FROM safety_briefing sb
LEFT JOIN pegawai p ON sb.petugas_id = p.id
WHERE sb.petugas_id IS NOT NULL 
  AND p.id IS NULL;

-- Set invalid petugas_id to NULL
UPDATE safety_briefing
SET petugas_id = NULL
WHERE petugas_id IS NOT NULL 
  AND petugas_id NOT IN (SELECT id FROM pegawai);

-- ====================================================================
-- STEP 5: Now safely add foreign key constraints
-- ====================================================================

-- Add foreign key for unit
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_unit;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_unit
FOREIGN KEY (unit_id) 
REFERENCES units(id)
ON DELETE SET NULL;

-- Add foreign key for petugas
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_petugas;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_petugas
FOREIGN KEY (petugas_id) 
REFERENCES pegawai(id)
ON DELETE SET NULL;

-- ====================================================================
-- STEP 6: Verify the constraints were created successfully
-- ====================================================================
SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    CASE 
        WHEN tc.constraint_type = 'FOREIGN KEY' THEN ccu.table_name
        ELSE NULL
    END as references_table
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_name = 'safety_briefing'
  AND tc.constraint_type IN ('FOREIGN KEY', 'CHECK')
ORDER BY tc.constraint_type, tc.constraint_name;

-- ====================================================================
-- STEP 7: Verify no more invalid references exist
-- ====================================================================
SELECT 
    'Invalid units' as check_type,
    COUNT(*) as count
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
WHERE sb.unit_id IS NOT NULL AND u.id IS NULL

UNION ALL

SELECT 
    'Invalid petugas' as check_type,
    COUNT(*) as count
FROM safety_briefing sb
LEFT JOIN pegawai p ON sb.petugas_id = p.id
WHERE sb.petugas_id IS NOT NULL AND p.id IS NULL;
