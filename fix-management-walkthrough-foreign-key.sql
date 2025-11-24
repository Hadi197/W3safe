-- Fix management_walkthrough foreign key relationship with units
-- This will enable Supabase to recognize the relationship for joins

-- First, check if unit_id column exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'management_walkthrough'
        AND column_name = 'unit_id'
    ) THEN
        ALTER TABLE management_walkthrough ADD COLUMN unit_id UUID;
        RAISE NOTICE 'Column unit_id added to management_walkthrough';
    ELSE
        RAISE NOTICE 'Column unit_id already exists in management_walkthrough';
    END IF;
END $$;

-- Check for invalid unit_id references before adding constraint
SELECT 
    'Invalid unit_id found' as status,
    COUNT(*) as invalid_count
FROM management_walkthrough mw
WHERE mw.unit_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM units u WHERE u.id = mw.unit_id);

-- Clean up invalid unit_id references (set to NULL)
UPDATE management_walkthrough
SET unit_id = NULL
WHERE unit_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM units u WHERE u.id = unit_id);

-- Drop existing constraint if it exists (to recreate it properly)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_management_walkthrough_unit'
        AND table_name = 'management_walkthrough'
    ) THEN
        ALTER TABLE management_walkthrough DROP CONSTRAINT fk_management_walkthrough_unit;
        RAISE NOTICE 'Existing foreign key constraint dropped';
    END IF;
END $$;

-- Add the foreign key constraint
ALTER TABLE management_walkthrough
ADD CONSTRAINT fk_management_walkthrough_unit
FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_unit_id ON management_walkthrough(unit_id);

-- Verify the constraint
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_name = 'management_walkthrough'
AND kcu.column_name = 'unit_id';
