-- =====================================================
-- Check RLS Policies for silent_inspection table
-- =====================================================

-- 1. Check if RLS is enabled
SELECT 
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename = 'silent_inspection';

-- 2. Check all RLS policies
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
    AND tablename = 'silent_inspection';

-- 3. Check table permissions
SELECT 
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'public'
    AND table_name = 'silent_inspection';

-- 4. Test manual update (run as authenticated user)
-- Replace <INSPECTION_ID> with actual ID
/*
UPDATE silent_inspection
SET 
    foto_kondisi_unsafe = ARRAY['https://example.com/test1.jpg', 'https://example.com/test2.jpg'],
    foto_perilaku_unsafe = ARRAY['https://example.com/test3.jpg']
WHERE id = '<INSPECTION_ID>'
RETURNING id, foto_kondisi_unsafe, foto_perilaku_unsafe;
*/
