-- Fix duplicate foreign key constraints in safety_patrol table
-- PostgREST error PGRST201 because of multiple FK relationships to units table

-- Check current FK constraints
SELECT
    'Current FK constraints to units:' as info,
    tc.constraint_name,
    kcu.column_name as local_column,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'safety_patrol'
  AND ccu.table_name = 'units';

-- Remove the automatically created FK constraint (keep the manually named one)
-- PostgreSQL auto-creates constraint with pattern: tablename_column_fkey
ALTER TABLE safety_patrol DROP CONSTRAINT IF EXISTS safety_patrol_unit_id_fkey;

-- Verify only one FK constraint remains
SELECT
    'Remaining FK constraints:' as info,
    tc.constraint_name,
    kcu.column_name as local_column,
    ccu.table_name AS referenced_table
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'safety_patrol'
  AND ccu.table_name = 'units';

-- Test the relationship works with only one FK
SELECT 'Testing relationship after fix:' as info;
SELECT
    sp.id,
    sp.nomor_patrol,
    sp.unit_id,
    u.nama_unit as unit_name
FROM safety_patrol sp
LEFT JOIN units u ON sp.unit_id = u.id
LIMIT 3;
