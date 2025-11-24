-- =====================================================
-- HSSE Database - Debug API Access Issues
-- =====================================================

-- Check if RLS is enabled and policies exist
SELECT
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN ('wilayah', 'units', 'pegawai', 'silent_inspection');

-- Check existing policies
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Try to select data directly (this should work if policies are correct)
SELECT id, kode, nama FROM wilayah LIMIT 1;
SELECT id, kode, nama, tipe FROM units LIMIT 1;
SELECT id, nip, nama FROM pegawai LIMIT 1;

-- Check for any constraint violations
SELECT
    conname,
    conrelid::regclass,
    confrelid::regclass,
    contype
FROM pg_constraint
WHERE conrelid IN (
    'wilayah'::regclass,
    'units'::regclass,
    'pegawai'::regclass,
    'silent_inspection'::regclass
);