import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function createNewAdminUser() {
  console.log('Creating new admin user...');
  try {
    const { data, error } = await supabase.auth.signUp({
      email: 'admin2@w3safe.com',
      password: 'admin123',
      options: {
        data: {
          full_name: 'Administrator',
          role: 'admin'
        }
      }
    });

    if (error) {
      console.log('❌ Signup Error:', error.message);
    } else {
      console.log('✅ User created successfully!');
      console.log('Email:', data.user?.email);
      console.log('User ID:', data.user?.id);
      console.log('Email confirmed:', data.user?.email_confirmed_at ? 'Yes' : 'No');
    }
  } catch (e) {
    console.log('❌ Exception:', e);
  }
}

createNewAdminUser();