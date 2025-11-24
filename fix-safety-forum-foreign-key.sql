-- Fix safety_forum foreign key relationship with units
-- This will enable Supabase to recognize the relationship for joins

-- First, check if unit_id column exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'safety_forum'
        AND column_name = 'unit_id'
    ) THEN
        ALTER TABLE safety_forum ADD COLUMN unit_id UUID;
        RAISE NOTICE 'Column unit_id added to safety_forum';
    ELSE
        RAISE NOTICE 'Column unit_id already exists in safety_forum';
    END IF;
END $$;

-- Check for invalid unit_id references before adding constraint
SELECT 
    'Invalid unit_id found' as status,
    COUNT(*) as invalid_count
FROM safety_forum sf
WHERE sf.unit_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM units u WHERE u.id = sf.unit_id);

-- Clean up invalid unit_id references (set to NULL)
UPDATE safety_forum
SET unit_id = NULL
WHERE unit_id IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM units u WHERE u.id = unit_id);

-- Drop existing constraint if it exists (to recreate it properly)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_safety_forum_unit'
        AND table_name = 'safety_forum'
    ) THEN
        ALTER TABLE safety_forum DROP CONSTRAINT fk_safety_forum_unit;
        RAISE NOTICE 'Existing foreign key constraint dropped';
    END IF;
END $$;

-- Add the foreign key constraint
ALTER TABLE safety_forum
ADD CONSTRAINT fk_safety_forum_unit
FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_safety_forum_unit_id ON safety_forum(unit_id);

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
AND tc.table_name = 'safety_forum'
AND kcu.column_name = 'unit_id';

-- Also check if there are other missing foreign keys
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_forum'
AND column_name LIKE '%_id'
ORDER BY ordinal_position;
