-- Insert Wilayah 3 into units table (using 'area' as tipe since 'wilayah' is not allowed)
INSERT INTO units (id, kode, nama, tipe, wilayah_id, area_id, aktif, created_at, updated_at)
VALUES (
    'd4cbbacd-f743-4372-8a46-372abaee759f',
    'WILAYAH-3',
    'Wilayah 3',
    'area',
    'd4cbbacd-f743-4372-8a46-372abaee759f',
    NULL,
    true,
    NOW(),
    NOW()
)
ON CONFLICT (id) DO UPDATE
SET 
    kode = 'WILAYAH-3',
    nama = 'Wilayah 3',
    tipe = 'area',
    aktif = true,
    updated_at = NOW();

-- Verify insertion
SELECT id, kode, nama, tipe, wilayah_id, area_id, aktif
FROM units 
WHERE tipe IN ('wilayah', 'area')
ORDER BY 
    CASE 
        WHEN tipe = 'wilayah' THEN 1
        WHEN tipe = 'area' THEN 2
        ELSE 3
    END,
    nama;
