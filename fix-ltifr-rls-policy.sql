-- Fix LTIFR RLS Policies
-- Drop existing policies
DROP POLICY IF EXISTS "Authenticated users can view LTIFR records" ON ltifr_records;
DROP POLICY IF EXISTS "Authenticated users can insert LTIFR records" ON ltifr_records;
DROP POLICY IF EXISTS "Authenticated users can update LTIFR records" ON ltifr_records;
DROP POLICY IF EXISTS "Authenticated users can delete LTIFR records" ON ltifr_records;

-- Create new policies with correct syntax
CREATE POLICY "Authenticated users can view LTIFR records"
    ON ltifr_records FOR SELECT
    USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can insert LTIFR records"
    ON ltifr_records FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update LTIFR records"
    ON ltifr_records FOR UPDATE
    USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete LTIFR records"
    ON ltifr_records FOR DELETE
    USING (auth.uid() IS NOT NULL);

-- Verify policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'ltifr_records';
