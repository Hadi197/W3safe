-- Add admin2@w3safe.com as pegawai
-- This user is trying to create silent inspection but doesn't have pegawai record

INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES ('Administrator 2', 'ADMIN002', 'admin2@w3safe.com', 'System Administrator', 'user', 'aktif')
ON CONFLICT (email) DO NOTHING;

-- Verify the addition
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE email = 'admin2@w3safe.com';

-- Show all pegawai records for reference
SELECT 'All Pegawai Records:' as info;
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
ORDER BY created_at DESC;
