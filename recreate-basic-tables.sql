-- =====================================================
-- RECREATE BASIC TABLES - wilayah, units, areas
-- Run this first before creating master_pelabuhan
-- =====================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Recreate wilayah table
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

-- Recreate units table
CREATE TABLE IF NOT EXISTS units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_unit VARCHAR(20) UNIQUE NOT NULL,
  nama_unit VARCHAR(100) NOT NULL,
  lokasi VARCHAR(200),
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate areas table
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

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_wilayah_updated_at
    BEFORE UPDATE ON wilayah
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_units_updated_at
    BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_areas_updated_at
    BEFORE UPDATE ON areas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_areas_wilayah_id ON areas(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_areas_aktif ON areas(aktif);
CREATE INDEX IF NOT EXISTS idx_areas_kode_area ON areas(kode_area);

-- Insert sample data for wilayah
INSERT INTO wilayah (kode_wilayah, nama_wilayah, provinsi, kota, status)
VALUES
    ('WIL-JKT-01', 'Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', 'aktif'),
    ('WIL-JKT-02', 'Jakarta Utara', 'DKI Jakarta', 'Jakarta Utara', 'aktif')
ON CONFLICT (kode_wilayah) DO NOTHING;

-- Insert sample data for units
INSERT INTO units (kode_unit, nama_unit, lokasi, status)
VALUES
    ('UNIT-001', 'Unit Terminal Peti Kemas', 'Jakarta International Container Terminal', 'aktif'),
    ('UNIT-002', 'Unit Bongkar Muat Curah', 'Bulk Cargo Terminal', 'aktif'),
    ('UNIT-003', 'Unit Container Yard', 'Container Storage Yard', 'aktif')
ON CONFLICT (kode_unit) DO NOTHING;

-- Insert sample data for areas
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

-- Verify tables creation
SELECT 'Basic tables recreated successfully!' as status;
SELECT
    'wilayah' as table_name,
    COUNT(*) as total_records
FROM wilayah
UNION ALL
SELECT
    'units' as table_name,
    COUNT(*) as total_records
FROM units
UNION ALL
SELECT
    'areas' as table_name,
    COUNT(*) as total_records
FROM areas;