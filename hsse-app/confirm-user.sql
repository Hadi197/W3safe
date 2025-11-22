-- Confirm user email untuk login
-- Run this in Supabase SQL Editor

UPDATE auth.users 
SET email_confirmed_at = NOW()
WHERE email = 'purwana.hadi@gmail.com';

-- Verify user status
SELECT id, email, email_confirmed_at, created_at 
FROM auth.users 
WHERE email = 'purwana.hadi@gmail.com';
