-- Check existing Wilayah 3 data
SELECT id, kode, nama, regional FROM wilayah WHERE nama LIKE '%3%' OR kode LIKE '%3%';

-- Check existing areas
SELECT id, kode_area, nama_area, wilayah_id FROM areas ORDER BY nama_area;

-- Check existing units
SELECT id, kode, nama FROM units ORDER BY nama;
