-- Add admin users as pegawai if they don't exist
-- This ensures that logged-in admin users can create silent inspections

-- Check current pegawai records
SELECT 'Current Pegawai Records:' as info;
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
ORDER BY created_at DESC;

-- Add admin2@w3safe.com as pegawai if not exists
INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES ('Admin User 2', 'ADMIN002', 'admin2@w3safe.com', 'Administrator', 'user', 'aktif')
ON CONFLICT (email) DO NOTHING;

-- Add other potential admin emails
INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES
  ('Admin User 1', 'ADMIN001', 'admin@w3safe.com', 'Administrator', 'user', 'aktif'),
  ('Unit Gresik', 'USR001', 'unit-gresik@w3safe.local', 'Unit User', 'user', 'aktif'),
  ('Area Bali Nusra', 'USR002', 'area-balinusra@w3safe.local', 'Area User', 'user', 'aktif')
ON CONFLICT (email) DO NOTHING;

-- Verify the additions
SELECT 'Updated Pegawai Records:' as info;
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE email IN ('admin2@w3safe.com', 'admin@w3safe.com', 'unit-gresik@w3safe.local', 'area-balinusra@w3safe.local')
ORDER BY email;
