-- =============================================================================
-- SCRIPT: Membuat User untuk Setiap Unit
-- Password: @w3Safe (sama untuk semua user)
-- =============================================================================

-- Step 1: Lihat daftar unit aktif yang akan dibuatkan user
SELECT 
  ROW_NUMBER() OVER (ORDER BY kode) as no,
  kode as "Kode Unit",
  nama as "Nama Unit",
  LOWER(kode) as "Username",
  LOWER(kode) || '@w3safe.local' as "Email",
  '@w3Safe' as "Password"
FROM units 
WHERE aktif = true 
ORDER BY kode;

-- =============================================================================
-- INSTRUKSI PEMBUATAN USER:
-- =============================================================================
-- 
-- Cara 1: MANUAL via Supabase Dashboard (RECOMMENDED)
-- ----------------------------------------------------
-- 1. Copy hasil query diatas
-- 2. Buka Supabase Dashboard > Authentication > Users
-- 3. Untuk setiap baris, click "Add user":
--    - Email: (dari kolom Email)
--    - Password: @w3Safe
--    - Auto Confirm User: ✅ CENTANG
--    - User Metadata (optional):
--      {
--        "username": "wil1",
--        "unit_kode": "WIL1", 
--        "role": "unit_user"
--      }
-- 4. Click "Create user"
-- 5. Ulangi untuk setiap unit
--
-- Cara 2: Bulk via Supabase API (Advanced)
-- -----------------------------------------
-- Gunakan Supabase Management API atau script TypeScript
-- File: scripts/create-unit-users.ts
-- Requires: SUPABASE_SERVICE_ROLE_KEY
--
-- =============================================================================

-- Step 2: Generate formatted list untuk dokumentasi
SELECT 
  '| ' || ROW_NUMBER() OVER (ORDER BY kode) || 
  ' | ' || kode ||
  ' | ' || LOWER(kode) ||
  ' | ' || LOWER(kode) || '@w3safe.local' ||
  ' | @w3Safe | ' || nama || ' |' as "Table Row"
FROM units 
WHERE aktif = true 
ORDER BY kode;

-- =============================================================================
-- CONTOH USER YANG AKAN DIBUAT:
-- =============================================================================
-- 
-- | No | Kode | Username | Email | Password | Unit Nama |
-- |----|------|----------|-------|----------|-----------|
-- | 1  | WIL1 | wil1     | wil1@w3safe.local | @w3Safe | Wilayah 1 |
-- | 2  | WIL2 | wil2     | wil2@w3safe.local | @w3Safe | Wilayah 2 |
-- | 3  | UNIT1| unit1    | unit1@w3safe.local | @w3Safe | Unit 1 |
-- ... dst
--
-- =============================================================================

-- Step 3: Hitung total user yang akan dibuat
SELECT 
  COUNT(*) as "Total Users to Create",
  '@w3Safe' as "Default Password"
FROM units 
WHERE aktif = true;

-- =============================================================================
-- TESTING SETELAH USER DIBUAT:
-- =============================================================================
-- 
-- Test login dengan salah satu akun:
-- Email: wil1@w3safe.local
-- Password: @w3Safe
--
-- Jika berhasil login, user sudah dibuat dengan benar!
--
-- =============================================================================

-- Step 4: (Optional) Query untuk verify user sudah dibuat
-- Note: Ini hanya bisa dijalankan jika ada akses ke auth.users
-- Biasanya hanya bisa via Dashboard atau service role

-- SELECT 
--   u.email,
--   u.created_at,
--   u.raw_user_meta_data->>'username' as username
-- FROM auth.users u
-- WHERE u.email LIKE '%@w3safe.local'
-- ORDER BY u.email;
