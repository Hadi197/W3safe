import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function testLogin() {
  console.log('Testing login with admin@w3safe.com / admin123...');
  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: 'admin@w3safe.com',
      password: 'admin123'
    });

    if (error) {
      console.log('❌ Login Error:', error.message);
      console.log('Error details:', error);
    } else {
      console.log('✅ Login successful!');
      console.log('User:', data.user?.email);
      console.log('User metadata:', data.user?.user_metadata);
      console.log('Session exists:', !!data.session);
    }
  } catch (e) {
    console.log('❌ Exception:', e);
  }
}

testLogin();