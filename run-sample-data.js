import { executeSQL, testConnection } from './run-supabase-sql.js'

async function runSampleData() {
  console.log('🚀 Starting sample data insertion...\n')

  // Test connection first
  const connected = await testConnection()
  if (!connected) {
    console.error('❌ Cannot connect to Supabase. Aborting.')
    process.exit(1)
  }

  // SQL queries to run
  const queries = [
    // Create demo pegawai
    `INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status) VALUES
    ('Safety Inspector Demo', 'DEMO001', 'demo@safety.local', 'Safety Inspector', 'user', 'aktif')
    ON CONFLICT (nip) DO NOTHING;`,

    // Insert sample safety briefings
    `INSERT INTO safety_briefing (
      tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id,
      topik, materi, foto_dokumentasi,
      area_briefing, topik_briefing, materi_briefing,
      poin_poin_pembahasan, kesimpulan, foto_briefing,
      jenis_briefing, jumlah_peserta, status
    ) VALUES
    (
      CURRENT_DATE,
      '08:00:00',
      '08:30:00',
      (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1),
      (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
      'Bahaya Listrik di Area Kerja',
      'Penjelasan mengenai bahaya listrik, cara pencegahan, dan prosedur keselamatan saat bekerja di area yang memiliki instalasi listrik.',
      '["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"]'::jsonb,
      'Ruang Meeting Utama',
      'Bahaya Listrik di Area Kerja',
      'Penjelasan mengenai bahaya listrik, cara pencegahan, dan prosedur keselamatan saat bekerja di area yang memiliki instalasi listrik.',
      '["Identifikasi bahaya listrik", "Penggunaan APD yang benar", "Prosedur lockout/tagout", "Emergency response"]'::jsonb,
      'Semua peserta memahami pentingnya keselamatan listrik dan berkomitmen untuk menerapkan prosedur yang benar.',
      '["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"]'::jsonb,
      'rutin',
      25,
      'approved'
    ),
    (
      CURRENT_DATE - INTERVAL '1 day',
      '07:30:00',
      '08:00:00',
      (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 1),
      (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
      'Penggunaan APD yang Benar',
      'Panduan lengkap penggunaan Alat Pelindung Diri (APD) sesuai standar K3.',
      '["https://example.com/apd1.jpg"]'::jsonb,
      'Area Workshop',
      'Penggunaan APD yang Benar',
      'Panduan lengkap penggunaan Alat Pelindung Diri (APD) sesuai standar K3.',
      '["Jenis-jenis APD", "Cara penggunaan yang benar", "Pemeliharaan APD", "Konsekuensi tidak menggunakan APD"]'::jsonb,
      'Peserta telah dilatih dalam penggunaan APD dan memahami pentingnya alat pelindung ini.',
      '["https://example.com/apd1.jpg"]'::jsonb,
      'khusus',
      18,
      'approved'
    ),
    (
      CURRENT_DATE - INTERVAL '2 days',
      '08:00:00',
      NULL,
      (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 2),
      (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
      'Prosedur Evakuasi Darurat',
      'Simulasi dan penjelasan prosedur evakuasi saat terjadi keadaan darurat.',
      '["https://example.com/evakuasi1.jpg", "https://example.com/evakuasi2.jpg", "https://example.com/evakuasi3.jpg"]'::jsonb,
      'Lapangan Parkir',
      'Prosedur Evakuasi Darurat',
      'Simulasi dan penjelasan prosedur evakuasi saat terjadi keadaan darurat.',
      '["Jalur evakuasi", "Titik kumpul", "Prosedur alarm", "Peran petugas"]'::jsonb,
      'Drill evakuasi berhasil dilakukan dengan baik. Semua peserta memahami prosedur darurat.',
      '["https://example.com/evakuasi1.jpg", "https://example.com/evakuasi2.jpg", "https://example.com/evakuasi3.jpg"]'::jsonb,
      'follow_up',
      32,
      'draft'
    )
    ON CONFLICT DO NOTHING;`
  ]

  // Execute each query
  for (let i = 0; i < queries.length; i++) {
    console.log(`\n📝 Executing query ${i + 1}/${queries.length}...`)

    const result = await executeSQL(queries[i])

    if (!result.success) {
      console.error(`❌ Query ${i + 1} failed:`, result.error)
      return false
    }

    console.log(`✅ Query ${i + 1} completed successfully`)
  }

  // Verification query
  console.log('\n🔍 Verifying data insertion...')
  const verifyQuery = `
    SELECT
      'Demo Pegawai' as type,
      COUNT(*) as count
    FROM pegawai
    WHERE nip = 'DEMO001'

    UNION ALL

    SELECT
      'Safety Briefings' as type,
      COUNT(*) as count
    FROM safety_briefing

    UNION ALL

    SELECT
      'Approved Briefings' as type,
      COUNT(*) as count
    FROM safety_briefing
    WHERE status = 'approved'

    UNION ALL

    SELECT
      'Draft Briefings' as type,
      COUNT(*) as count
    FROM safety_briefing
    WHERE status = 'draft'
  `

  const verifyResult = await executeSQL(verifyQuery)

  if (verifyResult.success) {
    console.log('\n📊 Verification Results:')
    console.log('Demo pegawai created:', verifyResult.data?.[0]?.count || 0)
    console.log('Total safety briefings:', verifyResult.data?.[1]?.count || 0)
    console.log('Approved briefings:', verifyResult.data?.[2]?.count || 0)
    console.log('Draft briefings:', verifyResult.data?.[3]?.count || 0)
  }

  console.log('\n🎉 Sample data insertion completed!')
  return true
}

// Run the script
runSampleData().catch(console.error)
