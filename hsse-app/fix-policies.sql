-- =====================================================
-- HSSE Database - Fix RLS Policies
-- =====================================================

-- Drop all existing policies first
DROP POLICY IF EXISTS "Enable read access for all users" ON wilayah;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON wilayah;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON wilayah;

DROP POLICY IF EXISTS "Enable read access for all users" ON units;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON units;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON units;

DROP POLICY IF EXISTS "Enable read access for all users" ON pegawai;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON pegawai;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON pegawai;

DROP POLICY IF EXISTS "Enable read access for all users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON silent_inspection;

-- Recreate policies with correct syntax
CREATE POLICY "public_read_wilayah" ON wilayah FOR SELECT USING (true);
CREATE POLICY "public_insert_wilayah" ON wilayah FOR INSERT WITH CHECK (true);
CREATE POLICY "public_update_wilayah" ON wilayah FOR UPDATE USING (true);

CREATE POLICY "public_read_units" ON units FOR SELECT USING (true);
CREATE POLICY "public_insert_units" ON units FOR INSERT WITH CHECK (true);
CREATE POLICY "public_update_units" ON units FOR UPDATE USING (true);

CREATE POLICY "public_read_pegawai" ON pegawai FOR SELECT USING (true);
CREATE POLICY "public_insert_pegawai" ON pegawai FOR INSERT WITH CHECK (true);
CREATE POLICY "public_update_pegawai" ON pegawai FOR UPDATE USING (true);

CREATE POLICY "public_read_silent_inspection" ON silent_inspection FOR SELECT USING (true);
CREATE POLICY "public_insert_silent_inspection" ON silent_inspection FOR INSERT WITH CHECK (true);
CREATE POLICY "public_update_silent_inspection" ON silent_inspection FOR UPDATE USING (true);
CREATE POLICY "public_delete_silent_inspection" ON silent_inspection FOR DELETE USING (true);

-- Verify policies were created
SELECT
    schemaname,
    tablename,
    policyname,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;