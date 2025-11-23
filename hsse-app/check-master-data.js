import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://oxskmrkzxkvifbappsic.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'
);

async function checkMasterPelabuhanData() {
  console.log('Checking master_pelabuhan table data...');

  const { error: authError } = await supabase.auth.signInWithPassword({
    email: 'admin2@w3safe.com',
    password: 'admin123'
  });

  if (authError) {
    console.log('❌ Auth error:', authError.message);
    return;
  }

  console.log('✅ Authentication successful');

  // Check master_pelabuhan data
  const { data: masterData, error: masterError } = await supabase
    .from('master_pelabuhan')
    .select(`
      *,
      wilayah:wilayah_id (
        id,
        nama_wilayah,
        kode_wilayah
      ),
      area:area_id (
        id,
        nama_area,
        kode_area
      ),
      unit:unit_id (
        id,
        kode_unit,
        nama_unit,
        aktif
      )
    `)
    .limit(5);

  if (masterError) {
    console.log('❌ Master pelabuhan query error:', masterError.message);
  } else {
    console.log('✅ Master pelabuhan data:');
    console.table(masterData.map(item => ({
      wilayah: item.wilayah?.nama_wilayah,
      area: item.area?.nama_area,
      unit: item.unit?.nama_unit,
      aktif: item.aktif
    })));
  }
}

checkMasterPelabuhanData();