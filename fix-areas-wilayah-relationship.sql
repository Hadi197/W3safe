-- ===================================================================
-- FIX AREAS - UPDATE WILAYAH_ID TO WILAYAH 3
-- ===================================================================

-- Update areas to link to Wilayah 3
UPDATE areas 
SET wilayah_id = 'd4cbbacd-f743-4372-8a46-372abaee759f', -- Wilayah 3
    updated_at = NOW()
WHERE kode_area IN ('AREA-JAWA-1', 'AREA-KAL-3', 'AREA-BALI-NT');

-- Verify the update
SELECT a.id, a.kode_area, a.nama_area, a.wilayah_id, w.nama as wilayah_nama
FROM areas a
LEFT JOIN wilayah w ON a.wilayah_id = w.id
WHERE a.kode_area IN ('AREA-JAWA-1', 'AREA-KAL-3', 'AREA-BALI-NT')
ORDER BY a.nama_area;
