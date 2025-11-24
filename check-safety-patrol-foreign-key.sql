-- Check if foreign key constraint already exists
SELECT tc.constraint_name, tc.table_name, kcu.column_name 
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'safety_patrol' 
  AND tc.constraint_type = 'FOREIGN KEY'
  AND kcu.column_name = 'unit_id';

-- Check for any invalid unit_id values
SELECT id, nomor_patrol, unit_id, 'INVALID' as status
FROM safety_patrol
WHERE unit_id IS NOT NULL 
  AND unit_id NOT IN (SELECT id FROM units)
UNION ALL
SELECT id, nomor_patrol, unit_id, 'VALID' as status
FROM safety_patrol
WHERE unit_id IS NOT NULL 
  AND unit_id IN (SELECT id FROM units)
ORDER BY status;
