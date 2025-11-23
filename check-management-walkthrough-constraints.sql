-- Check management_walkthrough table constraints and structure
SELECT
    'management_walkthrough table constraints:' as info,
    tc.constraint_name,
    tc.constraint_type,
    CASE
        WHEN tc.constraint_type = 'CHECK' THEN 'Check constraint - validates data'
        WHEN tc.constraint_type = 'FOREIGN KEY' THEN 'Foreign key - references other table'
        WHEN tc.constraint_type = 'PRIMARY KEY' THEN 'Primary key - unique identifier'
        WHEN tc.constraint_type = 'UNIQUE' THEN 'Unique constraint'
        ELSE tc.constraint_type
    END as description
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'management_walkthrough'
ORDER BY tc.constraint_type, tc.constraint_name;

-- Get detailed check constraint definitions
SELECT
    'Check constraint details:' as info,
    con.conname as constraint_name,
    pg_get_constraintdef(con.oid) as constraint_definition
FROM pg_constraint con
JOIN pg_class rel ON rel.oid = con.conrelid
JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
WHERE rel.relname = 'management_walkthrough'
  AND con.contype = 'c'  -- Check constraints
ORDER BY con.conname;

-- Check table structure with nullable info
SELECT
    'Table structure:' as info,
    column_name,
    data_type,
    is_nullable,
    CASE
        WHEN is_nullable = 'NO' THEN 'REQUIRED - cannot be null'
        WHEN is_nullable = 'YES' THEN 'OPTIONAL - can be null'
        ELSE 'UNKNOWN'
    END as nullability_status
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position;

-- Check if there are default values
SELECT
    'Default values:' as info,
    column_name,
    column_default
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
  AND column_default IS NOT NULL
ORDER BY column_name;
