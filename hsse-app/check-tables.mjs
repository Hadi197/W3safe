import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function checkTables() {
  console.log('Checking existing tables...');
  const tables = ['units', 'wilayah', 'management_walkthrough', 'safety_forum', 'safety_briefing', 'silent_inspection'];

  for (const table of tables) {
    try {
      const result = await supabase.from(table).select('count').limit(1);
      console.log(`${table}: ${result.error ? 'MISSING' : 'EXISTS'}`);
    } catch (e) {
      console.log(`${table}: ERROR`);
    }
  }

  // Check units structure
  console.log('\nChecking units table structure...');
  try {
    const { data: units, error } = await supabase
      .from('units')
      .select('id, kode, nama, tipe, wilayah_id, area_id')
      .limit(3);

    if (error) {
      console.log('Units query error:', error.message);
    } else {
      console.log('Units sample:', units);
    }
  } catch (e) {
    console.log('Exception:', e);
  }
}

checkTables();