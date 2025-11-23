-- =====================================================
-- DANGER: DELETE UNITS AND WILAYAH TABLES
-- WARNING: This will permanently delete all data in units and wilayah tables
-- and all related records due to CASCADE constraints
-- =====================================================

-- IMPORTANT: BACKUP YOUR DATA FIRST!
-- This script will delete:
-- 1. All records in units table
-- 2. All records in wilayah table
-- 3. All records in related tables that reference these (pegawai, etc.)
-- 4. All foreign key constraints and indexes

-- Step 1: Drop units table with CASCADE (will delete related records)
DROP TABLE IF EXISTS units CASCADE;

-- Step 2: Drop wilayah table with CASCADE (will delete related records)
DROP TABLE IF EXISTS wilayah CASCADE;

-- Verify tables are deleted
SELECT 'Checking if tables still exist...' as status;

-- Check if units table exists
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public'
            AND table_name = 'units'
        ) THEN 'units table still exists'
        ELSE 'units table successfully deleted'
    END as units_status;

-- Check if wilayah table exists
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public'
            AND table_name = 'wilayah'
        ) THEN 'wilayah table still exists'
        ELSE 'wilayah table successfully deleted'
    END as wilayah_status;

-- Show remaining tables in the database
SELECT
    'Remaining tables in public schema:' as info,
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name;