-- Check if dummy pegawai exists
SELECT id, nama, email, role 
FROM pegawai 
WHERE id = 'c1f3e4d5-6a7b-8c9d-0e1f-2a3b4c5d6e7f';

-- If not exists, insert dummy pegawai for testing
INSERT INTO pegawai (id, nama, email, role, aktif, created_at, updated_at)
VALUES (
    'c1f3e4d5-6a7b-8c9d-0e1f-2a3b4c5d6e7f',
    'Admin Testing',
    'admin.test@pelindo.co.id',
    'admin',
    true,
    NOW(),
    NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Verify
SELECT id, nama, email, role FROM pegawai WHERE email LIKE '%test%';
