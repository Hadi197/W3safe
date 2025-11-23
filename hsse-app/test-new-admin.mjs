import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function testNewAdminLogin() {
  console.log('Testing login with admin2@w3safe.com / admin123...');
  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: 'admin2@w3safe.com',
      password: 'admin123'
    });

    if (error) {
      console.log('❌ Login Error:', error.message);
    } else {
      console.log('✅ Login successful!');
      console.log('User:', data.user?.email);
      console.log('User metadata:', data.user?.user_metadata);
      console.log('Session exists:', !!data.session);

      // Test database access
      console.log('\nTesting database access...');
      const { data: units, error: unitsError } = await supabase
        .from('units')
        .select('id, kode, nama')
        .eq('aktif', true)
        .limit(5);

      if (unitsError) {
        console.log('❌ Database Error:', unitsError.message);
      } else {
        console.log('✅ Database access successful!');
        console.log('Units found:', units?.length || 0);
      }
    }
  } catch (e) {
    console.log('❌ Exception:', e);
  }
}

testNewAdminLogin();