-- =============================================================================
-- SCRIPT: Membuat User Berdasarkan Nama Unit
-- Password Default: password123 (untuk semua user)
-- Format Email: [kode_unit]@w3safe.local
-- =============================================================================

-- Step 1: Preview user yang akan dibuat
-- Lihat daftar unit dan format email/username yang akan digunakan
SELECT 
  ROW_NUMBER() OVER (ORDER BY u.kode) as no,
  u.id as unit_id,
  u.kode as unit_kode,
  u.nama as unit_nama,
  LOWER(u.kode) as username,
  LOWER(u.kode) || '@w3safe.local' as email,
  'password123' as password,
  a.nama_area as area,
  w.nama as wilayah
FROM units u
LEFT JOIN areas a ON u.area_id = a.id
LEFT JOIN wilayah w ON a.wilayah_id = w.id
WHERE u.aktif = true
ORDER BY u.kode;

-- =============================================================================
-- Step 2: Generate script untuk create user via Supabase Auth API
-- =============================================================================
-- 
-- INSTRUKSI PEMBUATAN USER:
-- 
-- Cara 1: MANUAL via Supabase Dashboard (PALING MUDAH)
-- ------------------------------------------------------
-- 1. Buka Supabase Dashboard
-- 2. Pergi ke: Authentication > Users
-- 3. Klik tombol "Add user" / "Create new user"
-- 4. Untuk setiap unit di tabel atas, buat user dengan:
--    • Email: [kode_unit]@w3safe.local (huruf kecil)
--    • Password: password123
--    • ✅ CENTANG "Auto Confirm User"
--    • User Metadata (JSON):
--      {
--        "username": "wil1",
--        "unit_kode": "WIL1",
--        "unit_id": "[copy dari kolom unit_id]",
--        "role": "unit_user"
--      }
-- 5. Klik "Create user"
-- 6. Ulangi untuk setiap unit
--
-- Cara 2: Bulk Create via SQL Function (ADVANCED)
-- ------------------------------------------------
-- Gunakan fungsi di bawah ini (memerlukan service role key)
--
-- =============================================================================

-- Step 3: Hitung total user yang akan dibuat
SELECT 
  COUNT(*) as total_users_to_create,
  'password123' as default_password,
  COUNT(*) || ' user accounts will be created' as note
FROM units 
WHERE aktif = true;

-- =============================================================================
-- Step 4: Generate formatted list untuk dokumentasi / checklist
-- =============================================================================
SELECT 
  '- [ ] ' || 
  kode || 
  ' (' || nama || ')' ||
  ' → Email: ' || LOWER(kode) || '@w3safe.local' ||
  ' | Password: password123' as checklist
FROM units 
WHERE aktif = true 
ORDER BY kode;

-- =============================================================================
-- CONTOH USER YANG AKAN DIBUAT:
-- =============================================================================
-- 
-- Email: wil1@w3safe.local    | Password: password123 | Unit: Wilayah 1
-- Email: wil2@w3safe.local    | Password: password123 | Unit: Wilayah 2  
-- Email: bjm@w3safe.local     | Password: password123 | Unit: Banjarmasin
-- Email: kotabaru@w3safe.local| Password: password123 | Unit: Kotabaru
-- ... dst
--
-- =============================================================================

-- =============================================================================
-- Step 5: VERIFIKASI setelah user dibuat
-- =============================================================================
-- Query untuk cek user yang sudah dibuat (via SQL Editor di Supabase)
-- Note: Query ini hanya bisa dijalankan dengan service role

-- Uncomment query di bawah untuk verifikasi:
/*
SELECT 
  u.email,
  u.created_at,
  u.email_confirmed_at,
  u.raw_user_meta_data->>'username' as username,
  u.raw_user_meta_data->>'unit_kode' as unit_kode,
  u.raw_user_meta_data->>'role' as role,
  CASE 
    WHEN u.email_confirmed_at IS NOT NULL THEN '✅ Confirmed'
    ELSE '❌ Not Confirmed'
  END as status
FROM auth.users u
WHERE u.email LIKE '%@w3safe.local'
ORDER BY u.email;
*/

-- =============================================================================
-- Step 6: TESTING LOGIN
-- =============================================================================
-- 
-- Setelah membuat semua user, test login dengan salah satu akun:
-- 
-- Contoh:
-- Email: wil1@w3safe.local
-- Password: password123
--
-- Jika berhasil login, berarti user sudah dibuat dengan benar!
--
-- =============================================================================

-- =============================================================================
-- OPTIONAL: Create Bulk Users Function (Advanced)
-- =============================================================================
-- Fungsi ini memerlukan extension dan permissions khusus
-- Hanya untuk advanced users yang familiar dengan Supabase Auth

/*
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to bulk create users
CREATE OR REPLACE FUNCTION create_unit_users()
RETURNS TABLE (
  unit_kode TEXT,
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
BEGIN
  -- Password yang sama untuk semua: password123
  encrypted_password := crypt('password123', gen_salt('bf'));
  
  FOR unit_record IN 
    SELECT id, kode, nama 
    FROM units 
    WHERE aktif = true 
    ORDER BY kode
  LOOP
    BEGIN
      -- Generate UUID for new user
      new_user_id := gen_random_uuid();
      
      -- Insert into auth.users
      INSERT INTO auth.users (
        id,
        instance_id,
        email,
        encrypted_password,
        email_confirmed_at,
        created_at,
        updated_at,
        raw_user_meta_data,
        role,
        aud
      ) VALUES (
        new_user_id,
        '00000000-0000-0000-0000-000000000000',
        LOWER(unit_record.kode) || '@w3safe.local',
        encrypted_password,
        NOW(),
        NOW(),
        NOW(),
        jsonb_build_object(
          'username', LOWER(unit_record.kode),
          'unit_kode', unit_record.kode,
          'unit_id', unit_record.id::TEXT,
          'role', 'unit_user'
        ),
        'authenticated',
        'authenticated'
      );
      
      -- Insert into auth.identities
      INSERT INTO auth.identities (
        id,
        user_id,
        identity_data,
        provider,
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
        NOW(),
        NOW()
      );
      
      unit_kode := unit_record.kode;
      email := LOWER(unit_record.kode) || '@w3safe.local';
      success := TRUE;
      message := 'User created successfully';
      RETURN NEXT;
      
    EXCEPTION WHEN OTHERS THEN
      unit_kode := unit_record.kode;
      email := LOWER(unit_record.kode) || '@w3safe.local';
      success := FALSE;
      message := SQLERRM;
      RETURN NEXT;
    END;
  END LOOP;
END;
$$;

-- Execute function to create users
-- SELECT * FROM create_unit_users();
*/

-- =============================================================================
-- NOTES PENTING:
-- =============================================================================
-- 
-- 1. Password default adalah: password123
--    User disarankan mengganti password setelah login pertama kali
--    menggunakan fitur "Ganti Password" di menu profile
--
-- 2. Format email: [kode_unit]@w3safe.local (huruf kecil semua)
--    Contoh: WIL1 → wil1@w3safe.local
--
-- 3. Auto-confirm user harus dicentang agar user langsung bisa login
--    tanpa perlu verifikasi email
--
-- 4. Metadata user berisi informasi:
--    - username: untuk display name
--    - unit_kode: kode unit yang bersangkutan
--    - unit_id: ID unit untuk keperluan filtering data
--    - role: role user (default: unit_user)
--
-- 5. Pastikan table units sudah terisi dengan lengkap sebelum
--    menjalankan script ini
--
-- =============================================================================
