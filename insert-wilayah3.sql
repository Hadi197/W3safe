-- Insert Wilayah 3 if not exists (make sure ID matches your database)
INSERT INTO wilayah (id, kode, nama, created_at, updated_at)
VALUES (
    'd4cbbacd-f743-4372-8a46-372abaee759f',
    'W3',
    'Wilayah 3',
    NOW(),
    NOW()
)
ON CONFLICT (id) DO UPDATE
SET 
    kode = 'W3',
    nama = 'Wilayah 3',
    updated_at = NOW();

-- Verify insertion
SELECT id, kode, nama FROM wilayah WHERE kode = 'W3';
