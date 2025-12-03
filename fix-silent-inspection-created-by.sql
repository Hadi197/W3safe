-- Fix Silent Inspection created_by foreign key constraint
-- This allows created_by to use Supabase Auth UUID without requiring pegawai reference

-- Drop the foreign key constraint on created_by
ALTER TABLE silent_inspection 
DROP CONSTRAINT IF EXISTS silent_inspection_created_by_fkey;

-- Verify the constraint is removed
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'silent_inspection'
    AND tc.constraint_type = 'FOREIGN KEY';
