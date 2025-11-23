import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function testQueries() {
  console.log('Testing authentication...');

  const { error: authError } = await supabase.auth.signInWithPassword({
    email: 'admin2@w3safe.com',
    password: 'admin123'
  });

  if (authError) {
    console.log('❌ Auth error:', authError.message);
    return;
  }

  console.log('✅ Authentication successful');

  // Test units query
  console.log('\nTesting units query...');
  try {
    const { data: units, error } = await supabase
      .from('units')
      .select('id, kode, nama, tipe')
      .eq('aktif', true)
      .eq('tipe', 'unit')
      .limit(3);

    if (error) {
      console.log('❌ Units error:', error.message);
    } else {
      console.log('✅ Units query successful:', units?.length, 'records');
    }
  } catch (e) {
    console.log('❌ Units exception:', e);
  }

  // Test safety_briefing query
  console.log('\nTesting safety_briefing query...');
  try {
    const { data: briefings, error } = await supabase
      .from('safety_briefing')
      .select('id, nomor_briefing, tanggal, topik_briefing')
      .limit(3);

    if (error) {
      console.log('❌ Safety briefing error:', error.message);
    } else {
      console.log('✅ Safety briefing query successful:', briefings?.length, 'records');
    }
  } catch (e) {
    console.log('❌ Safety briefing exception:', e);
  }

  // Test silent_inspection query
  console.log('\nTesting silent_inspection query...');
  try {
    const { data: inspections, error } = await supabase
      .from('silent_inspection')
      .select('id, nomor_inspeksi, tanggal, area_inspeksi')
      .limit(3);

    if (error) {
      console.log('❌ Silent inspection error:', error.message);
    } else {
      console.log('✅ Silent inspection query successful:', inspections?.length, 'records');
    }
  } catch (e) {
    console.log('❌ Silent inspection exception:', e);
  }
}

testQueries();