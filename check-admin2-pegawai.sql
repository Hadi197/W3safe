-- Check if admin2@w3safe.com exists in pegawai table
SELECT id, nama, email, role, aktif
FROM pegawai
WHERE email = 'admin2@w3safe.com';

-- Get auth user id for admin2@w3safe.com from auth.users (if you have access)
-- SELECT id, email FROM auth.users WHERE email = 'admin2@w3safe.com';

-- If admin2 not in pegawai, insert it
-- First, get the auth user id, then insert into pegawai
-- Replace 'AUTH_USER_ID_HERE' with actual UUID from auth.users

-- Example insert (uncomment and replace ID after checking auth.users):
/*
INSERT INTO pegawai (id, nama, email, role, aktif, created_at, updated_at)
VALUES (
    'AUTH_USER_ID_HERE',  -- Replace with actual auth.users.id
    'Admin 2',
    'admin2@w3safe.com',
    'admin',
    true,
    NOW(),
    NOW()
)
ON CONFLICT (id) DO UPDATE
SET 
    email = 'admin2@w3safe.com',
    role = 'admin',
    aktif = true,
    updated_at = NOW();
*/

-- Alternative: If pegawai table uses different ID, create mapping
-- or use email-based lookup (which the Flutter code now does)
