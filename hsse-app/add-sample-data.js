import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function addSampleData() {
  console.log('Adding sample data...');

  const { error: authError } = await supabase.auth.signInWithPassword({
    email: 'admin2@w3safe.com',
    password: 'admin123'
  });

  if (authError) {
    console.log('❌ Auth error:', authError.message);
    return;
  }

  // Get first unit for sample data
  const { data: units } = await supabase
    .from('units')
    .select('id, nama')
    .eq('aktif', true)
    .eq('tipe', 'unit')
    .limit(1);

  if (!units || units.length === 0) {
    console.log('❌ No units found');
    return;
  }

  const unitId = units[0].id;
  console.log('Using unit:', units[0].nama);

  // Add safety briefing sample
  console.log('Adding safety briefing sample...');
  const { error: briefingError } = await supabase
    .from('safety_briefing')
    .insert({
      nomor_briefing: 'SB-2024-001',
      tanggal: new Date().toISOString().split('T')[0],
      topik_briefing: 'Keselamatan Kerja di Area Produksi',
      unit_id: unitId,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    });

  if (briefingError) {
    console.log('❌ Safety briefing insert error:', briefingError.message);
  } else {
    console.log('✅ Safety briefing sample added');
  }

  // Add silent inspection sample
  console.log('Adding silent inspection sample...');
  const { error: inspectionError } = await supabase
    .from('silent_inspection')
    .insert({
      nomor_inspeksi: 'SI-2024-001',
      tanggal: new Date().toISOString().split('T')[0],
      jenis_inspeksi: 'silent',
      unit_id: unitId,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    });

  if (inspectionError) {
    console.log('❌ Silent inspection insert error:', inspectionError.message);
  } else {
    console.log('✅ Silent inspection sample added');
  }

  console.log('Sample data addition complete!');
}

addSampleData();