-- Check safety_patrol table relationships and constraints
-- This will help identify why PostgREST finds multiple relationships

-- Check all constraints on safety_patrol table
SELECT
    'All constraints on safety_patrol:' as info,
    tc.constraint_name,
    tc.constraint_type,
    CASE
        WHEN tc.constraint_type = 'FOREIGN KEY' THEN 'FK - references another table'
        WHEN tc.constraint_type = 'PRIMARY KEY' THEN 'PK - unique identifier'
        WHEN tc.constraint_type = 'CHECK' THEN 'Check - validates data'
        WHEN tc.constraint_type = 'UNIQUE' THEN 'Unique - no duplicates'
        ELSE tc.constraint_type
    END as description
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'safety_patrol'
ORDER BY tc.constraint_type, tc.constraint_name;

-- Check foreign key constraints in detail
SELECT
    'Foreign key details:' as info,
    tc.constraint_name,
    tc.constraint_type,
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
  AND tc.table_name = 'safety_patrol';

-- Check if there are any other columns that might reference units
SELECT
    'Columns that might reference units:' as info,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_patrol'
  AND (column_name LIKE '%unit%' OR column_name LIKE '%_id' OR data_type = 'uuid')
ORDER BY column_name;

-- Check units table constraints to see if there are reverse relationships
SELECT
    'Units table constraints:' as info,
    tc.constraint_name,
    tc.constraint_type,
    CASE WHEN tc.constraint_type = 'FOREIGN KEY' THEN 'References other table'
         WHEN tc.constraint_type = 'PRIMARY KEY' THEN 'Is referenced by others'
         ELSE tc.constraint_type END as relationship_type
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'units'
ORDER BY tc.constraint_type;

-- Check current data in safety_patrol
SELECT
    'Current safety_patrol data:' as info,
    COUNT(*) as total_records,
    COUNT(CASE WHEN unit_id IS NOT NULL THEN 1 END) as records_with_unit_id,
    COUNT(CASE WHEN unit_id IS NULL THEN 1 END) as records_without_unit_id
FROM safety_patrol;

-- Test the current API query to see what PostgREST sees
-- This simulates what the Vue component is trying to do
SELECT
    'API query test:' as info,
    sp.id,
    sp.nomor_patrol,
    sp.unit_id,
    u.nama_unit as unit_name
FROM safety_patrol sp
LEFT JOIN units u ON sp.unit_id = u.id
LIMIT 3;
