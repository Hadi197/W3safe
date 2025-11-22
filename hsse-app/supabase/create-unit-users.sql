-- Script untuk membuat user berdasarkan unit
-- Password semua user: @w3Safe

-- Langkah 1: Lihat semua unit yang aktif
SELECT kode, nama, id FROM units WHERE aktif = true ORDER BY kode;

-- Langkah 2: Insert users untuk setiap unit
-- Format username: kode unit (lowercase)
-- Format email: {kode}@w3safe.local
-- Password: @w3Safe (akan di-hash oleh Supabase Auth)

-- Note: Untuk membuat user di Supabase Auth, gunakan Supabase Dashboard atau API
-- Script ini hanya untuk referensi struktur data

-- Contoh struktur user yang akan dibuat:
-- 1. Username: wil1, Email: wil1@w3safe.local, Password: @w3Safe
-- 2. Username: wil2, Email: wil2@w3safe.local, Password: @w3Safe
-- dst...

-- Query untuk generate INSERT statement berdasarkan units
SELECT 
  'Username: ' || LOWER(kode) || 
  ', Email: ' || LOWER(kode) || '@w3safe.local' ||
  ', Nama: ' || nama AS user_info
FROM units 
WHERE aktif = true 
ORDER BY kode;

-- Untuk membuat user secara batch, gunakan Supabase Dashboard:
-- 1. Buka Supabase Dashboard > Authentication > Users
-- 2. Click "Invite User" atau "Add User"
-- 3. Masukkan email dan password untuk setiap unit
-- 4. Atau gunakan Supabase Management API untuk bulk create

-- Alternative: Buat script migration untuk insert ke auth.users
-- CATATAN: Ini memerlukan access ke auth schema dan password hashing

-- Template untuk manual creation di Dashboard:
/*
UNIT USERS TO CREATE:
=====================

Copy data dibawah untuk membuat user di Supabase Dashboard:

Username: wil1
Email: wil1@w3safe.local
Password: @w3Safe
Role: Unit Wilayah 1

Username: wil2
Email: wil2@w3safe.local
Password: @w3Safe
Role: Unit Wilayah 2

... (sesuaikan dengan hasil query diatas)
*/
