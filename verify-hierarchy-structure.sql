-- Lihat struktur hierarki lengkap: Wilayah 3 → Areas → Units
SELECT 
    CASE 
        WHEN area_id IS NULL AND nama LIKE '%Wilayah%' THEN '🏙️ WILAYAH'
        WHEN area_id IS NULL AND nama LIKE 'Area%' THEN '  🗺️ AREA'
        ELSE '    🏢 UNIT'
    END as level_icon,
    id,
    kode,
    nama,
    tipe,
    wilayah_id,
    area_id,
    aktif
FROM units
WHERE wilayah_id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
   OR id = 'd4cbbacd-f743-4372-8a46-372abaee759f'
ORDER BY 
    CASE 
        WHEN nama = 'Wilayah 3' THEN 1
        WHEN nama LIKE 'Area%' AND area_id IS NULL THEN 2
        ELSE 3
    END,
    nama;
