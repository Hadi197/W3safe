-- =====================================================
-- CREATE MASTER PELABUHAN SYSTEM WITH COMPLETE HIERARCHY
-- Wilayah -> Area -> Unit relationships for Indonesian ports
-- =====================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create wilayah table
CREATE TABLE IF NOT EXISTS wilayah (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_wilayah VARCHAR(20) UNIQUE NOT NULL,
  nama_wilayah VARCHAR(100) NOT NULL,
  provinsi VARCHAR(50),
  kota VARCHAR(50),
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

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

-- Create units table
CREATE TABLE IF NOT EXISTS units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_unit VARCHAR(20) UNIQUE NOT NULL,
  nama_unit VARCHAR(100) NOT NULL,
  lokasi VARCHAR(200),
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

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

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers
CREATE TRIGGER update_wilayah_updated_at
    BEFORE UPDATE ON wilayah
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_units_updated_at
    BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_areas_updated_at
    BEFORE UPDATE ON areas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_master_pelabuhan_updated_at
    BEFORE UPDATE ON master_pelabuhan
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_areas_wilayah_id ON areas(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_areas_aktif ON areas(aktif);
CREATE INDEX IF NOT EXISTS idx_areas_kode_area ON areas(kode_area);

CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_wilayah_id ON master_pelabuhan(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_area_id ON master_pelabuhan(area_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_unit_id ON master_pelabuhan(unit_id);
CREATE INDEX IF NOT EXISTS idx_master_pelabuhan_aktif ON master_pelabuhan(aktif);

-- Insert wilayah data (3 regions)
INSERT INTO wilayah (kode_wilayah, nama_wilayah, provinsi, status)
VALUES
    ('WIL-01', 'Wilayah 3', 'Jawa Timur', 'aktif'),
    ('WIL-02', 'Wilayah 3', 'Kalimantan Selatan', 'aktif'),
    ('WIL-03', 'Wilayah 3', 'Bali', 'aktif')
ON CONFLICT (kode_wilayah) DO NOTHING;

-- Insert areas data (3 areas)
INSERT INTO areas (kode_area, nama_area, wilayah_id, deskripsi, aktif)
SELECT
    'AREA-JAWA-1' as kode_area,
    'Area Jawa 1' as nama_area,
    w.id as wilayah_id,
    'Area Jawa 1 - Jawa Timur' as deskripsi,
    true as aktif
FROM wilayah w
WHERE w.kode_wilayah = 'WIL-01'
ON CONFLICT (kode_area, wilayah_id) DO NOTHING;

INSERT INTO areas (kode_area, nama_area, wilayah_id, deskripsi, aktif)
SELECT
    'AREA-KAL-3' as kode_area,
    'Area Kalimantan 3' as nama_area,
    w.id as wilayah_id,
    'Area Kalimantan 3 - Kalimantan Selatan' as deskripsi,
    true as aktif
FROM wilayah w
WHERE w.kode_wilayah = 'WIL-02'
ON CONFLICT (kode_area, wilayah_id) DO NOTHING;

INSERT INTO areas (kode_area, nama_area, wilayah_id, deskripsi, aktif)
SELECT
    'AREA-BALI-NT' as kode_area,
    'Area Bali Nusa Tenggara' as nama_area,
    w.id as wilayah_id,
    'Area Bali Nusa Tenggara' as deskripsi,
    true as aktif
FROM wilayah w
WHERE w.kode_wilayah = 'WIL-03'
ON CONFLICT (kode_area, wilayah_id) DO NOTHING;

-- Insert units data (all 16 units)
INSERT INTO units (kode_unit, nama_unit, lokasi, status)
VALUES
    -- Area Jawa 1 units
    ('UNIT-TANJUNG-PERAK', 'Unit Tanjung Perak', 'Surabaya', 'aktif'),
    ('UNIT-GRESIK', 'Unit Gresik', 'Gresik', 'aktif'),
    ('UNIT-TANJUNG-WANGI', 'Unit Tanjung Wangi', 'Tanjung Wangi', 'aktif'),
    ('UNIT-TANJUNG-EMAS', 'Unit Tanjung Emas', 'Semarang', 'aktif'),
    ('UNIT-TANJUNG-INTAN', 'Unit Tanjung Intan', 'Cirebon', 'aktif'),

    -- Area Kalimantan 3 units
    ('UNIT-BANJARMASIN', 'Unit Banjarmasin', 'Banjarmasin', 'aktif'),
    ('UNIT-KOTABARU', 'Unit Kotabaru', 'Kotabaru', 'aktif'),
    ('UNIT-MEKAR-PUTIH', 'Unit Mekar Putih', 'Mekar Putih', 'aktif'),
    ('UNIT-BATULICIN', 'Unit Batulicin', 'Batulicin', 'aktif'),
    ('UNIT-SATUI-BUNATI', 'Unit Satui/Bunati', 'Satui/Bunati', 'aktif'),
    ('UNIT-SAMPIT', 'Unit Sampit', 'Sampit', 'aktif'),
    ('UNIT-KUMAI', 'Unit Kumai', 'Kumai', 'aktif'),

    -- Area Bali Nusa Tenggara units
    ('UNIT-BENOA', 'Unit Benoa', 'Benoa', 'aktif'),
    ('UNIT-CELUKAN-BAWANG', 'Unit Celukan Bawang', 'Celukan Bawang', 'aktif'),
    ('UNIT-LEMBAR', 'Unit Lembar', 'Lembar', 'aktif'),
    ('UNIT-TENAU-KUPANG', 'Unit Tenau Kupang', 'Tenau Kupang', 'aktif')
ON CONFLICT (kode_unit) DO NOTHING;

-- Insert master_pelabuhan data (linking all relationships)
-- Area Jawa 1 units
INSERT INTO master_pelabuhan (wilayah_id, area_id, unit_id, aktif)
SELECT
    w.id as wilayah_id,
    a.id as area_id,
    u.id as unit_id,
    true as aktif
FROM wilayah w
CROSS JOIN areas a
CROSS JOIN units u
WHERE w.kode_wilayah = 'WIL-01'
  AND a.kode_area = 'AREA-JAWA-1'
  AND u.kode_unit IN ('UNIT-TANJUNG-PERAK', 'UNIT-GRESIK', 'UNIT-TANJUNG-WANGI', 'UNIT-TANJUNG-EMAS', 'UNIT-TANJUNG-INTAN')
ON CONFLICT (wilayah_id, area_id, unit_id) DO NOTHING;

-- Area Kalimantan 3 units
INSERT INTO master_pelabuhan (wilayah_id, area_id, unit_id, aktif)
SELECT
    w.id as wilayah_id,
    a.id as area_id,
    u.id as unit_id,
    true as aktif
FROM wilayah w
CROSS JOIN areas a
CROSS JOIN units u
WHERE w.kode_wilayah = 'WIL-02'
  AND a.kode_area = 'AREA-KAL-3'
  AND u.kode_unit IN ('UNIT-BANJARMASIN', 'UNIT-KOTABARU', 'UNIT-MEKAR-PUTIH', 'UNIT-BATULICIN', 'UNIT-SATUI-BUNATI', 'UNIT-SAMPIT', 'UNIT-KUMAI')
ON CONFLICT (wilayah_id, area_id, unit_id) DO NOTHING;

-- Area Bali Nusa Tenggara units
INSERT INTO master_pelabuhan (wilayah_id, area_id, unit_id, aktif)
SELECT
    w.id as wilayah_id,
    a.id as area_id,
    u.id as unit_id,
    true as aktif
FROM wilayah w
CROSS JOIN areas a
CROSS JOIN units u
WHERE w.kode_wilayah = 'WIL-03'
  AND a.kode_area = 'AREA-BALI-NT'
  AND u.kode_unit IN ('UNIT-BENOA', 'UNIT-CELUKAN-BAWANG', 'UNIT-LEMBAR', 'UNIT-TENAU-KUPANG')
ON CONFLICT (wilayah_id, area_id, unit_id) DO NOTHING;

-- Enable Row Level Security for master_pelabuhan
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

-- Verify the data creation
SELECT 'Master pelabuhan system created successfully!' as status;

-- Show summary of created data
SELECT
    'wilayah' as table_name,
    COUNT(*) as total_records
FROM wilayah
UNION ALL
SELECT
    'areas' as table_name,
    COUNT(*) as total_records
FROM areas
UNION ALL
SELECT
    'units' as table_name,
    COUNT(*) as total_records
FROM units
UNION ALL
SELECT
    'master_pelabuhan' as table_name,
    COUNT(*) as total_records
FROM master_pelabuhan;

-- Show detailed breakdown by area
SELECT
    w.nama_wilayah as wilayah,
    a.nama_area as area,
    COUNT(mp.id) as jumlah_unit,
    COUNT(CASE WHEN mp.aktif = true THEN 1 END) as unit_aktif
FROM master_pelabuhan mp
JOIN wilayah w ON mp.wilayah_id = w.id
JOIN areas a ON mp.area_id = a.id
GROUP BY w.nama_wilayah, a.nama_area
ORDER BY w.nama_wilayah, a.nama_area;