-- Check if Wilayah 3 exists in wilayah table
SELECT id, kode, nama 
FROM wilayah 
WHERE id = 'd4cbbacd-f743-4372-8a46-372abaee759f';

-- Check all wilayah records
SELECT id, kode, nama, created_at
FROM wilayah
ORDER BY nama;

-- Check areas for Wilayah 3
SELECT id, kode_area, nama_area, wilayah_id
FROM areas
WHERE wilayah_id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
ORDER BY nama_area;

-- Check units structure
SELECT id, kode, nama, tipe, wilayah_id, area_id, aktif
FROM units
WHERE wilayah_id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
ORDER BY nama
LIMIT 10;
