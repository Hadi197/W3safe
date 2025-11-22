-- Script untuk membuat user wilayah3
-- Jalankan di Supabase SQL Editor

-- Cara 1: Menggunakan auth.users (memerlukan pgcrypto extension)
-- Pastikan pgcrypto extension sudah aktif
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert user baru
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'wilayah3@w3safe.local',
  crypt('@W3safe', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"username":"wilayah3"}',
  now(),
  now(),
  '',
  '',
  '',
  ''
)
RETURNING id, email, raw_user_meta_data;

-- Cara 2: Atau gunakan Supabase Dashboard
-- 1. Buka Supabase Dashboard
-- 2. Pergi ke Authentication > Users
-- 3. Click "Invite User" atau "Add User"
-- 4. Email: wilayah3@w3safe.local
-- 5. Password: @W3safe
-- 6. Auto Confirm User: ✓ (centang)
