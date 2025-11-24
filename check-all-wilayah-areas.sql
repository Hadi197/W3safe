-- Check all wilayah to understand the structure
SELECT id, kode, nama, regional FROM wilayah ORDER BY kode;

-- Check all areas to see which wilayah they belong to
SELECT a.id, a.kode_area, a.nama_area, a.wilayah_id, w.nama as wilayah_nama
FROM areas a
LEFT JOIN wilayah w ON a.wilayah_id = w.id
ORDER BY a.nama_area;
