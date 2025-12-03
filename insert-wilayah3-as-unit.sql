-- =====================================================
-- INSERT WILAYAH 3 AS UNIT
-- Add Wilayah 3 as a unit so it appears in unit dropdown
-- =====================================================

-- Get Wilayah 3 ID first
-- d4cbbacd-f743-4372-8a46-372abaee759f

-- Insert Wilayah 3 as a unit
INSERT INTO units (id, kode, nama, tipe, wilayah_id, area_id, aktif, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'W3',
    'Wilayah 3',
    'wilayah',
    'd4cbbacd-f743-4372-8a46-372abaee759f', -- wilayah_id points to itself
    NULL, -- no area for wilayah level
    true,
    NOW(),
    NOW()
)
ON CONFLICT DO NOTHING;

-- Verify the insert
SELECT id, kode, nama, tipe, wilayah_id, area_id 
FROM units 
WHERE nama = 'Wilayah 3';
