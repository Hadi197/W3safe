-- =====================================================
-- TEMPORARY: Disable RLS for Testing
-- ⚠️ Only use this for development/testing
-- Re-enable RLS later for production
-- =====================================================

ALTER TABLE units DISABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah DISABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai DISABLE ROW LEVEL SECURITY;
ALTER TABLE tamu_eksternal DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_briefing DISABLE ROW LEVEL SECURITY;
ALTER TABLE silent_inspection DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_forum DISABLE ROW LEVEL SECURITY;
ALTER TABLE management_walkthrough DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_patrol DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_induction DISABLE ROW LEVEL SECURITY;
ALTER TABLE safety_drill DISABLE ROW LEVEL SECURITY;

SELECT 'RLS disabled for all tables - FOR TESTING ONLY!' as message;
