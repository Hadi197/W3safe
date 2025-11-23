-- Check if admin2@w3safe.com exists in pegawai table
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE email = 'admin2@w3safe.com';

-- Check all pegawai emails
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE email IS NOT NULL
ORDER BY email;

-- Check RLS policies for pegawai table
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'pegawai';
