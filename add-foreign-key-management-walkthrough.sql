-- Add foreign key constraint for management_walkthrough table
-- This fixes the "Could not find a relationship" error when joining with units table

-- Check if constraint already exists
DO $$
BEGIN
    -- Check if the foreign key constraint already exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_management_walkthrough_unit'
          AND table_name = 'management_walkthrough'
    ) THEN
        -- Add the foreign key constraint
        ALTER TABLE management_walkthrough
        ADD CONSTRAINT fk_management_walkthrough_unit
        FOREIGN KEY (unit_id) REFERENCES units(id);

        RAISE NOTICE 'Added foreign key constraint fk_management_walkthrough_unit';
    ELSE
        RAISE NOTICE 'Foreign key constraint fk_management_walkthrough_unit already exists';
    END IF;
END $$;

-- Verify the constraint was added
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'management_walkthrough';

-- Test a simple join query to verify it works
SELECT 'Testing join query...' as test;
SELECT
    mw.id,
    mw.nomor_walkthrough,
    mw.unit_id,
    u.nama_unit as unit_name
FROM management_walkthrough mw
LEFT JOIN units u ON mw.unit_id = u.id
LIMIT 3;
