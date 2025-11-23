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

-- Check specific columns that might exist
SELECT
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'units' AND column_name = 'nama'
    ) THEN 'nama column exists' ELSE 'nama column does NOT exist' END as nama_check,

    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'units' AND column_name = 'nama_unit'
    ) THEN 'nama_unit column exists' ELSE 'nama_unit column does NOT exist' END as nama_unit_check,

    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'units' AND column_name = 'unit_name'
    ) THEN 'unit_name column exists' ELSE 'unit_name column does NOT exist' END as unit_name_check;

-- Check if units table exists and has data
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE tablename = 'units';
