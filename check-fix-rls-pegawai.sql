-- Check and fix RLS policies for pegawai table

-- Check current RLS policies
SELECT 'Current RLS Policies for pegawai:' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'pegawai';

-- Enable RLS if not already enabled
ALTER TABLE pegawai ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Allow authenticated users" ON pegawai;

-- Create proper RLS policy
CREATE POLICY "Allow authenticated users on pegawai"
ON pegawai
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Verify RLS is enabled
SELECT 'RLS Status:' as info;
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE tablename = 'pegawai';

-- Test query as authenticated user
SELECT 'Test Query Result:' as info;
SELECT COUNT(*) as pegawai_count FROM pegawai;
