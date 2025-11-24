-- Add foreign key constraint from master_pelabuhan to units
-- This enables PostgREST to recognize the relationship for joins

ALTER TABLE master_pelabuhan 
ADD CONSTRAINT fk_master_pelabuhan_unit 
FOREIGN KEY (unit_id) 
REFERENCES units(id)
ON DELETE CASCADE;

-- Verify the constraint was created
SELECT 
    tc.constraint_name, 
    tc.table_name, 
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
    AND tc.table_name = 'master_pelabuhan'
    AND kcu.column_name = 'unit_id';
