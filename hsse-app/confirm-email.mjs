import { createClient } from '@supabase/supabase-js';

// Using service role key to bypass email confirmation
// Note: In production, never expose service role key in client code
const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Mzc2OTIwOCwiZXhwIjoyMDc5MzQ1MjA4fQ.example_service_role_key',
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

async function confirmUserEmail() {
  try {
    // Get user by email
    const { data: users, error: listError } = await supabase.auth.admin.listUsers();

    if (listError) {
      console.log('Error listing users:', listError.message);
      return;
    }

    const user = users.users.find(u => u.email === 'admin@w3safe.com');
    if (!user) {
      console.log('User not found');
      return;
    }

    // Confirm the user's email
    const { error: confirmError } = await supabase.auth.admin.updateUserById(user.id, {
      email_confirm: true
    });

    if (confirmError) {
      console.log('Error confirming email:', confirmError.message);
    } else {
      console.log('Email confirmed successfully!');
    }
  } catch (e) {
    console.log('Exception:', e);
  }
}

confirmUserEmail();