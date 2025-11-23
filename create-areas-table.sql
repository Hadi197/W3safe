-- =====================================================
-- CREATE AREAS TABLE
-- Master table for areas/regions within wilayah
-- =====================================================

-- Create areas table
CREATE TABLE IF NOT EXISTS areas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    kode_area VARCHAR(20) UNIQUE NOT NULL,
    nama_area VARCHAR(100) NOT NULL,
    wilayah_id UUID NOT NULL REFERENCES wilayah(id) ON DELETE CASCADE,
    deskripsi TEXT,
    aktif BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Ensure unique combination of kode_area within wilayah
    UNIQUE(kode_area, wilayah_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_areas_wilayah_id ON areas(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_areas_aktif ON areas(aktif);
CREATE INDEX IF NOT EXISTS idx_areas_kode_area ON areas(kode_area);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_areas_updated_at
    BEFORE UPDATE ON areas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Enable read access for authenticated users" ON areas
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Enable insert for authenticated users" ON areas
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON areas
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users" ON areas
    FOR DELETE USING (auth.role() = 'authenticated');

-- Insert sample data
INSERT INTO areas (kode_area, nama_area, wilayah_id, deskripsi, aktif)
SELECT
    'AREA-JKT-01' as kode_area,
    'Jakarta Pusat' as nama_area,
    w.id as wilayah_id,
    'Area Jakarta Pusat' as deskripsi,
    true as aktif
FROM wilayah w
WHERE w.kode_wilayah = 'WIL-JKT-01'
ON CONFLICT (kode_area, wilayah_id) DO NOTHING;

INSERT INTO areas (kode_area, nama_area, wilayah_id, deskripsi, aktif)
SELECT
    'AREA-JKT-02' as kode_area,
    'Jakarta Utara' as nama_area,
    w.id as wilayah_id,
    'Area Jakarta Utara' as deskripsi,
    true as aktif
FROM wilayah w
WHERE w.kode_wilayah = 'WIL-JKT-02'
ON CONFLICT (kode_area, wilayah_id) DO NOTHING;

-- Verify the table creation
SELECT 'Areas table created successfully!' as status;
SELECT
    'areas' as table_name,
    COUNT(*) as total_areas,
    COUNT(CASE WHEN aktif = true THEN 1 END) as active_areas,
    COUNT(CASE WHEN aktif = false THEN 1 END) as inactive_areas
FROM areas;