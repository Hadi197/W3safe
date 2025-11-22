-- Check current data structure
SELECT 
    u.kode,
    u.nama,
    u.tipe,
    u.wilayah_id,
    u.area_id,
    w.nama as wilayah_nama,
    a.nama as area_nama
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
LEFT JOIN units a ON u.area_id = a.id
ORDER BY u.tipe DESC, w.nama, a.nama, u.nama;
