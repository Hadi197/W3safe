-- =====================================================
-- FIX: Update RLS Policies untuk Development
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Allow authenticated users" ON units;
DROP POLICY IF EXISTS "Allow authenticated users" ON wilayah;
DROP POLICY IF EXISTS "Allow authenticated users" ON pegawai;
DROP POLICY IF EXISTS "Allow authenticated users" ON tamu_eksternal;
DROP POLICY IF EXISTS "Allow authenticated users" ON safety_briefing;
DROP POLICY IF EXISTS "Allow authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Allow authenticated users" ON safety_forum;
DROP POLICY IF EXISTS "Allow authenticated users" ON management_walkthrough;
DROP POLICY IF EXISTS "Allow authenticated users" ON safety_patrol;
DROP POLICY IF EXISTS "Allow authenticated users" ON safety_induction;
DROP POLICY IF EXISTS "Allow authenticated users" ON safety_drill;

-- Create new permissive policies for authenticated users
-- Master Tables
CREATE POLICY "Enable all for authenticated users" ON units
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON wilayah
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON pegawai
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON tamu_eksternal
FOR ALL USING (auth.uid() IS NOT NULL);

-- HSSE Transaction Tables
CREATE POLICY "Enable all for authenticated users" ON safety_briefing
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON silent_inspection
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON safety_forum
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON management_walkthrough
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON safety_patrol
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON safety_induction
FOR ALL USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable all for authenticated users" ON safety_drill
FOR ALL USING (auth.uid() IS NOT NULL);

-- Success message
SELECT 'RLS Policies updated successfully!' as message;
