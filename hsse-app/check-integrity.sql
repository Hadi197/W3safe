-- =====================================================
-- HSSE Database - Check Data Integrity Issues
-- =====================================================

-- Check if units have valid wilayah_id references
SELECT
    u.id,
    u.kode,
    u.nama,
    u.wilayah_id,
    w.kode as wilayah_kode,
    w.nama as wilayah_nama
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
WHERE u.wilayah_id IS NOT NULL;

-- Check for units with invalid wilayah references
SELECT
    u.id,
    u.kode,
    u.nama,
    u.wilayah_id
FROM units u
WHERE u.wilayah_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM wilayah w WHERE w.id = u.wilayah_id);

-- Check pegawai foreign keys
SELECT
    p.id,
    p.nip,
    p.nama,
    p.unit_id,
    p.wilayah_id,
    u.kode as unit_kode,
    w.kode as wilayah_kode
FROM pegawai p
LEFT JOIN units u ON p.unit_id = u.id
LEFT JOIN wilayah w ON p.wilayah_id = w.id;

-- Check for pegawai with invalid references
SELECT
    p.id,
    p.nip,
    p.nama,
    p.unit_id,
    p.wilayah_id
FROM pegawai p
WHERE (p.unit_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM units u WHERE u.id = p.unit_id))
   OR (p.wilayah_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM wilayah w WHERE w.id = p.wilayah_id));

-- Check table constraints
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE
    tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name IN ('units', 'pegawai', 'silent_inspection');