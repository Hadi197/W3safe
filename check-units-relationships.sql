-- Check if wilayah and area tables exist and have data
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'wilayah') THEN 'wilayah table EXISTS' ELSE 'wilayah table MISSING' END as wilayah_table_status,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'areas') THEN 'areas table EXISTS' ELSE 'areas table MISSING' END as areas_table_status;

-- Check wilayah table structure and data
SELECT 'wilayah table columns:' as info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'wilayah' ORDER BY ordinal_position;

SELECT 'wilayah data:' as info;
SELECT id, nama, kode_wilayah FROM wilayah LIMIT 3;

-- Check areas table structure and data
SELECT 'areas table columns:' as info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'areas' ORDER BY ordinal_position;

SELECT 'areas data:' as info;
SELECT id, nama_area, kode_area FROM areas LIMIT 3;

-- Check units foreign key relationships
SELECT
    u.id as unit_id,
    u.nama_unit,
    u.wilayah_id,
    w.nama as wilayah_nama,
    u.area_id,
    a.nama_area as area_nama
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
LEFT JOIN areas a ON u.area_id = a.id
ORDER BY u.nama_unit
LIMIT 5;

-- Test simple units query without joins (what should work)
SELECT
    id,
    nama_unit,
    kode_unit,
    aktif
FROM units
WHERE aktif = true
ORDER BY nama_unit
LIMIT 5;
