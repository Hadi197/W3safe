-- =====================================================
-- HSSE Database - Fix Remaining RLS Issues
-- =====================================================

-- Enable RLS on areas table (missing from advisor)
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;

-- Create policies for areas table
CREATE POLICY "public_read_areas" ON areas FOR SELECT USING (true);
CREATE POLICY "public_insert_areas" ON areas FOR INSERT WITH CHECK (true);
CREATE POLICY "public_update_areas" ON areas FOR UPDATE USING (true);

-- Fix the update_updated_at_column function search_path issue
-- This function should have a secure search_path
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Verify all tables have RLS enabled
SELECT
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN ('wilayah', 'units', 'pegawai', 'silent_inspection', 'areas')
ORDER BY tablename;