-- Verify admin2@w3safe.com exists as pegawai
SELECT 'Checking admin2@w3safe.com:' as info;
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE email = 'admin2@w3safe.com';

-- Add admin2@w3safe.com if not exists
INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES ('Administrator 2', 'ADMIN002', 'admin2@w3safe.com', 'System Administrator', 'user', 'aktif')
ON CONFLICT (email) DO NOTHING;

-- Verify silent_inspection table has foto columns
SELECT 'Foto columns in silent_inspection:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
  AND column_name IN ('foto_kondisi_unsafe', 'foto_perilaku_unsafe');

-- Show recent silent_inspection records
SELECT 'Recent silent inspections:' as info;
SELECT id, area_inspeksi, temuan, foto_kondisi_unsafe, foto_perilaku_unsafe, created_at
FROM silent_inspection
ORDER BY created_at DESC
LIMIT 3;

-- Test query that frontend uses
SELECT 'Test pegawai query:' as info;
SELECT id FROM pegawai WHERE email = 'admin2@w3safe.com';
