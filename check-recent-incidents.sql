-- Check recent unsafe_action_condition records
SELECT 
    id,
    jenis_kejadian,
    kategori,
    tanggal_kejadian,
    unit_id,
    unit_kerja,
    lokasi,
    deskripsi,
    nama_pelapor,
    status,
    created_at
FROM unsafe_action_condition
ORDER BY created_at DESC
LIMIT 10;

-- Check with unit name (join with units table)
SELECT 
    uac.id,
    uac.jenis_kejadian,
    uac.kategori,
    uac.tanggal_kejadian,
    uac.unit_id,
    u.nama as unit_nama,
    uac.unit_kerja,
    uac.lokasi,
    uac.deskripsi,
    uac.nama_pelapor,
    uac.status,
    uac.created_at
FROM unsafe_action_condition uac
LEFT JOIN units u ON u.id = uac.unit_id
ORDER BY uac.created_at DESC
LIMIT 10;

-- Count by unit (including Wilayah 3)
SELECT 
    u.nama as unit_nama,
    u.tipe,
    COUNT(uac.id) as jumlah_laporan
FROM units u
LEFT JOIN unsafe_action_condition uac ON uac.unit_id = u.id
WHERE u.wilayah_id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
   OR u.id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
GROUP BY u.id, u.nama, u.tipe
ORDER BY 
    CASE 
        WHEN u.nama = 'Wilayah 3' THEN 1
        WHEN u.nama LIKE 'Area%' THEN 2
        ELSE 3
    END,
    u.nama;
