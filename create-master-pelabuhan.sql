-- =====================================================
-- CREATE MASTER PELABUHAN TABLE
-- Master table for managing ports/harbors with region, area, unit relationships
-- =====================================================

-- Create master_pelabuhan table
CREATE TABLE IF NOT EXISTS master_pelabuhan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    wilayah_id UUID NOT NULL REFERENCES wilayah(id) ON DELETE CASCADE,
    area_id UUID NOT NULL REFERENCES areas(id) ON DELETE CASCADE,
    unit_id UUID NOT NULL REFERENCES units(id) ON DELETE CASCADE,
    aktif BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Ensure unique combination of wilayah, area, unit
    UNIQUE(wilayah_id, area_id, unit_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_wilayah_id ON master_pelabuhan(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_area_id ON master_pelabuhan(area_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_unit_id ON master_pelabuhan(unit_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_aktif ON master_pelabuhan(aktif);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_master_pelabuhan_updated_at
    BEFORE UPDATE ON master_pelabuhan
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE master_pelabuhan ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Enable read access for authenticated users" ON master_pelabuhan
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Enable insert for authenticated users" ON master_pelabuhan
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON master_pelabuhan
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users" ON master_pelabuhan
    FOR DELETE USING (auth.role() = 'authenticated');

-- Insert sample data (linking existing wilayah, areas, units)
INSERT INTO master_pelabuhan (wilayah_id, area_id, unit_id, aktif)
SELECT
    w.id as wilayah_id,
    a.id as area_id,
    u.id as unit_id,
    true as aktif
FROM wilayah w
CROSS JOIN areas a
CROSS JOIN units u
WHERE w.kode_wilayah = 'WIL-JKT-01'
  AND a.kode_area = 'AREA-JKT-01'
  AND u.kode_unit IN ('UNIT-001', 'UNIT-002')
ON CONFLICT (wilayah_id, area_id, unit_id) DO NOTHING;

-- Verify the table creation
SELECT 'Master pelabuhan table created successfully!' as status;
SELECT
    'master_pelabuhan' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN aktif = true THEN 1 END) as active_records,
    COUNT(CASE WHEN aktif = false THEN 1 END) as inactive_records
FROM master_pelabuhan;