-- =====================================================
-- Confirm User Email
-- Run this in Supabase SQL Editor
-- =====================================================

-- Confirm the user purwana.hadi@gmail.com
-- Note: confirmed_at is a generated column and will be set automatically
UPDATE auth.users 
SET email_confirmed_at = NOW()
WHERE email = 'purwana.hadi@gmail.com';

-- Verify user is confirmed
SELECT 
    email,
    email_confirmed_at,
    confirmed_at,
    CASE 
        WHEN email_confirmed_at IS NOT NULL THEN '✅ Confirmed'
        ELSE '❌ Not Confirmed'
    END as status
FROM auth.users 
WHERE email = 'purwana.hadi@gmail.com';
