-- =====================================================
-- Disable Email Confirmation Requirement
-- FOR DEVELOPMENT ONLY
-- Run this in Supabase SQL Editor
-- =====================================================

-- Note: Actual email confirmation settings are in Supabase Dashboard
-- Go to: Authentication > Settings > Email Auth
-- Disable "Confirm email" option

-- But we can confirm all existing users:
UPDATE auth.users 
SET email_confirmed_at = NOW(),
    confirmed_at = NOW()
WHERE email_confirmed_at IS NULL;

-- Create a function to auto-confirm new users (optional)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE auth.users
  SET email_confirmed_at = NOW(),
      confirmed_at = NOW()
  WHERE id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to auto-confirm new users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

SELECT '✅ All users confirmed and auto-confirm enabled!' as message;
