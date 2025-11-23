-- Check units table structure and data
-- Run this in Supabase SQL Editor

-- Check table schema
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;

-- Check sample data
SELECT * FROM units LIMIT 3;

-- Check if units table exists and has data
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE tablename = 'units';
