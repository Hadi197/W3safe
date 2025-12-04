-- =============================================================================
-- AUTOMATIC USER CREATION FROM UNITS
-- Creates users automatically in auth.users based on units table
-- Password: password123 (for all users)
-- =============================================================================

-- Step 1: Enable required extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =============================================================================
-- Step 2: Create function to automatically create users from units
-- =============================================================================

CREATE OR REPLACE FUNCTION auto_create_unit_users()
RETURNS TABLE (
  no INTEGER,
  unit_kode TEXT,
  unit_nama TEXT,
  email TEXT,
  success BOOLEAN,
  message TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  unit_record RECORD;
  new_user_id UUID;
  encrypted_password TEXT;
  row_number INTEGER := 0;
BEGIN
  -- Encrypt password once (password123)
  encrypted_password := crypt('password123', gen_salt('bf'));
  
  -- Loop through all active units
  FOR unit_record IN 
    SELECT id, kode, nama 
    FROM units 
    WHERE aktif = true 
    ORDER BY kode
  LOOP
    BEGIN
      row_number := row_number + 1;
      
      -- Generate UUID for new user
      new_user_id := gen_random_uuid();
      
      -- Insert into auth.users
      INSERT INTO auth.users (
        id,
        instance_id,
        email,
        encrypted_password,
        email_confirmed_at,
        raw_app_meta_data,
        raw_user_meta_data,
        is_super_admin,
        role,
        aud,
        created_at,
        updated_at,
        confirmation_token,
        email_confirmed_at,
        recovery_token,
        email_change_token_new,
        email_change
      ) VALUES (
        new_user_id,
        '00000000-0000-0000-0000-000000000000',
        LOWER(unit_record.kode) || '@w3safe.local',
        encrypted_password,
        NOW(), -- email_confirmed_at (auto confirm)
        '{"provider":"email","providers":["email"]}',
        jsonb_build_object(
          'username', LOWER(unit_record.kode),
          'unit_kode', unit_record.kode,
          'unit_id', unit_record.id::TEXT,
          'unit_nama', unit_record.nama,
          'role', 'unit_user'
        ),
        FALSE,
        'authenticated',
        'authenticated',
        NOW(),
        NOW(),
        '',
        NOW(),
        '',
        '',
        ''
      );
      
      -- Insert into auth.identities
      INSERT INTO auth.identities (
        id,
        user_id,
        identity_data,
        provider,
        provider_id,
        last_sign_in_at,
        created_at,
        updated_at
      ) VALUES (
        gen_random_uuid(),
        new_user_id,
        jsonb_build_object(
          'sub', new_user_id::TEXT,
          'email', LOWER(unit_record.kode) || '@w3safe.local'
        ),
        'email',
        new_user_id::TEXT,
        NOW(),
        NOW(),
        NOW()
      );
      
      -- Return success
      no := row_number;
      unit_kode := unit_record.kode;
      unit_nama := unit_record.nama;
      email := LOWER(unit_record.kode) || '@w3safe.local';
      success := TRUE;
      message := '✅ User created successfully';
      RETURN NEXT;
      
    EXCEPTION WHEN unique_violation THEN
      -- User already exists
      no := row_number;
      unit_kode := unit_record.kode;
      unit_nama := unit_record.nama;
      email := LOWER(unit_record.kode) || '@w3safe.local';
      success := FALSE;
      message := '⚠️ User already exists';
      RETURN NEXT;
      
    WHEN OTHERS THEN
      -- Other errors
      no := row_number;
      unit_kode := unit_record.kode;
      unit_nama := unit_record.nama;
      email := LOWER(unit_record.kode) || '@w3safe.local';
      success := FALSE;
      message := '❌ Error: ' || SQLERRM;
      RETURN NEXT;
    END;
  END LOOP;
END;
$$;

-- =============================================================================
-- Step 3: Execute the function to create all users
-- =============================================================================

SELECT * FROM auto_create_unit_users();

-- =============================================================================
-- Step 4: Verify created users
-- =============================================================================

SELECT 
  u.email,
  u.created_at,
  u.email_confirmed_at,
  u.raw_user_meta_data->>'username' as username,
  u.raw_user_meta_data->>'unit_kode' as unit_kode,
  u.raw_user_meta_data->>'unit_nama' as unit_nama,
  u.raw_user_meta_data->>'role' as role,
  CASE 
    WHEN u.email_confirmed_at IS NOT NULL THEN '✅ Confirmed'
    ELSE '❌ Not Confirmed'
  END as status
FROM auth.users u
WHERE u.email LIKE '%@w3safe.local'
ORDER BY u.email;

-- =============================================================================
-- Step 5: Count created users
-- =============================================================================

SELECT 
  COUNT(*) as total_users,
  COUNT(*) FILTER (WHERE email_confirmed_at IS NOT NULL) as confirmed_users,
  COUNT(*) FILTER (WHERE email_confirmed_at IS NULL) as unconfirmed_users
FROM auth.users
WHERE email LIKE '%@w3safe.local';

-- =============================================================================
-- ALTERNATIVE: Simpler version without error handling
-- =============================================================================

/*
-- Simple bulk insert (use with caution)
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  role,
  aud,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
)
SELECT 
  gen_random_uuid(),
  '00000000-0000-0000-0000-000000000000',
  LOWER(kode) || '@w3safe.local',
  crypt('password123', gen_salt('bf')),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  jsonb_build_object(
    'username', LOWER(kode),
    'unit_kode', kode,
    'unit_id', id::TEXT,
    'unit_nama', nama,
    'role', 'unit_user'
  ),
  FALSE,
  'authenticated',
  'authenticated',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
FROM units
WHERE aktif = true
  AND LOWER(kode) || '@w3safe.local' NOT IN (
    SELECT email FROM auth.users
  );
*/

-- =============================================================================
-- CLEANUP: Drop function if needed
-- =============================================================================
-- DROP FUNCTION IF EXISTS auto_create_unit_users();

-- =============================================================================
-- NOTES:
-- =============================================================================
-- 
-- 1. Script ini akan membuat user otomatis untuk semua unit aktif
-- 2. Password default: password123 (sama untuk semua user)
-- 3. Email format: [kode_unit]@w3safe.local (huruf kecil)
-- 4. User langsung confirmed (email_confirmed_at diisi)
-- 5. Metadata berisi: username, unit_kode, unit_id, unit_nama, role
-- 
-- 6. Jika user sudah ada, akan skip dengan pesan "User already exists"
-- 7. Function dapat dijalankan ulang tanpa duplikasi data
-- 
-- 8. Untuk menghapus user yang sudah dibuat:
--    DELETE FROM auth.users WHERE email LIKE '%@w3safe.local';
--
-- 9. User dapat login langsung setelah dibuat dengan:
--    Email: [kode_unit]@w3safe.local
--    Password: password123
--
-- 10. User disarankan mengganti password menggunakan fitur 
--     "Ganti Password" di menu profile
--
-- =============================================================================

-- =============================================================================
-- TEST LOGIN
-- =============================================================================
-- Setelah menjalankan script, test dengan salah satu user:
-- 
-- Email: area-balinusra@w3safe.local
-- Password: password123
--
-- atau
--
-- Email: unit-banjarmasin@w3safe.local  
-- Password: password123
--
-- =============================================================================
