-- =====================================================
-- ADD RELATIONSHIP COLUMNS TO UNITS TABLE & FIX WILAYAH TABLE
-- Add wilayah_id and area_id to units table for frontend compatibility
-- Add nama and aktif columns to wilayah table for frontend compatibility
-- =====================================================

-- Add nama and aktif columns to wilayah table for frontend compatibility
ALTER TABLE wilayah
ADD COLUMN IF NOT EXISTS nama VARCHAR(100),
ADD COLUMN IF NOT EXISTS aktif BOOLEAN DEFAULT true;

-- Update wilayah nama column to match nama_wilayah
UPDATE wilayah SET nama = nama_wilayah WHERE nama IS NULL;
UPDATE wilayah SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;

-- Add relationship columns to units table
ALTER TABLE units
ADD COLUMN IF NOT EXISTS wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS area_id UUID REFERENCES areas(id) ON DELETE SET NULL;
ALTER TABLE units
ADD COLUMN IF NOT EXISTS wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS area_id UUID REFERENCES areas(id) ON DELETE SET NULL;

-- Create indexes for the new columns
CREATE INDEX IF NOT EXISTS idx_units_wilayah_id ON units(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_units_area_id ON units(area_id);

-- Update units with their corresponding wilayah and area relationships
-- Area Jawa 1 units
UPDATE units SET
    wilayah_id = (SELECT id FROM wilayah WHERE kode_wilayah = 'WIL-01'),
    area_id = (SELECT id FROM areas WHERE kode_area = 'AREA-JAWA-1')
WHERE kode_unit IN ('UNIT-TANJUNG-PERAK', 'UNIT-GRESIK', 'UNIT-TANJUNG-WANGI', 'UNIT-TANJUNG-EMAS', 'UNIT-TANJUNG-INTAN');

-- Area Kalimantan 3 units
UPDATE units SET
    wilayah_id = (SELECT id FROM wilayah WHERE kode_wilayah = 'WIL-02'),
    area_id = (SELECT id FROM areas WHERE kode_area = 'AREA-KAL-3')
WHERE kode_unit IN ('UNIT-BANJARMASIN', 'UNIT-KOTABARU', 'UNIT-MEKAR-PUTIH', 'UNIT-BATULICIN', 'UNIT-SATUI-BUNATI', 'UNIT-SAMPIT', 'UNIT-KUMAI');

-- Area Bali Nusa Tenggara units
UPDATE units SET
    wilayah_id = (SELECT id FROM wilayah WHERE kode_wilayah = 'WIL-03'),
    area_id = (SELECT id FROM areas WHERE kode_area = 'AREA-BALI-NT')
WHERE kode_unit IN ('UNIT-BENOA', 'UNIT-CELUKAN-BAWANG', 'UNIT-LEMBAR', 'UNIT-TENAU-KUPANG');

-- Verify the changes
SELECT 'Relationship columns added to units table and wilayah table fixed successfully!' as status;

-- Show wilayah table with new columns
SELECT
    kode_wilayah,
    nama_wilayah,
    nama,
    aktif,
    status
FROM wilayah
ORDER BY nama_wilayah;

-- Show units with their relationships
SELECT
    u.kode_unit,
    u.nama_unit,
    w.nama_wilayah as wilayah,
    a.nama_area as area
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
LEFT JOIN areas a ON u.area_id = a.id
ORDER BY u.nama_unit;