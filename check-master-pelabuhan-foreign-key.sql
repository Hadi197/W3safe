-- Check existing foreign key constraints on master_pelabuhan
SELECT tc.constraint_name, tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
  ON tc.constraint_name = ccu.constraint_name
WHERE tc.table_name = 'master_pelabuhan' 
  AND tc.constraint_type = 'FOREIGN KEY';

-- Check for invalid wilayah_id values
SELECT id, wilayah_id, 'INVALID' as status
FROM master_pelabuhan
WHERE wilayah_id IS NOT NULL 
  AND wilayah_id NOT IN (SELECT id FROM wilayah)
UNION ALL
SELECT id, wilayah_id, 'VALID' as status
FROM master_pelabuhan
WHERE wilayah_id IS NOT NULL 
  AND wilayah_id IN (SELECT id FROM wilayah)
ORDER BY status;
