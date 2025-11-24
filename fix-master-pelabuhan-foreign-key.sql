-- Fix foreign key relationship for master_pelabuhan -> wilayah
-- This allows PostgREST to recognize the relationship for joins

-- First, check for any invalid wilayah_id values
SELECT id, wilayah_id
FROM master_pelabuhan
WHERE wilayah_id IS NOT NULL 
  AND wilayah_id NOT IN (SELECT id FROM wilayah);

-- Delete records with invalid wilayah_id references
-- (Cannot set to NULL because column is NOT NULL)
DELETE FROM master_pelabuhan
WHERE wilayah_id IS NOT NULL 
  AND wilayah_id NOT IN (SELECT id FROM wilayah);

-- Add foreign key constraint
ALTER TABLE master_pelabuhan 
ADD CONSTRAINT fk_master_pelabuhan_wilayah 
FOREIGN KEY (wilayah_id) 
REFERENCES wilayah(id) 
ON DELETE CASCADE;

-- Verify the constraint was created
SELECT tc.constraint_name, tc.table_name, kcu.column_name 
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'master_pelabuhan' 
  AND tc.constraint_type = 'FOREIGN KEY'
  AND kcu.column_name = 'wilayah_id';
