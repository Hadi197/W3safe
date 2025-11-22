/**
 * Script untuk generate list user yang perlu dibuat
 * Output: JSON file dengan list user untuk import manual
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3NjMxNzUsImV4cCI6MjA0NjMzOTE3NX0.L8v7LU9ZwNY_eZDGTH7T_RqmyKtS1MZwYPXQ7WL5g0I'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const DEFAULT_PASSWORD = '@w3Safe'

async function generateUserList() {
  console.log('🔄 Mengambil data unit dari database...\n')

  const { data: units, error } = await supabase
    .from('units')
    .select('id, kode, nama, tipe')
    .eq('aktif', true)
    .order('kode')

  if (error) {
    console.error('❌ Error:', error)
    return
  }

  if (!units || units.length === 0) {
    console.log('⚠️  Tidak ada unit aktif')
    return
  }

  console.log(`📊 Ditemukan ${units.length} unit aktif\n`)
  console.log('=' .repeat(80))
  console.log('DAFTAR USER YANG PERLU DIBUAT')
  console.log('=' .repeat(80))
  console.log('Password untuk semua user: @w3Safe\n')

  const userList = units.map(unit => {
    const username = unit.kode.toLowerCase()
    const email = `${username}@w3safe.local`
    
    return {
      username,
      email,
      password: DEFAULT_PASSWORD,
      unit_id: unit.id,
      unit_kode: unit.kode,
      unit_nama: unit.nama,
      unit_tipe: unit.tipe,
      role: 'unit_user'
    }
  })

  // Print table format
  console.log('No. | Kode Unit | Username | Email | Unit Nama')
  console.log('-'.repeat(80))
  
  userList.forEach((user, idx) => {
    console.log(`${(idx + 1).toString().padStart(3)}. | ${user.unit_kode.padEnd(9)} | ${user.username.padEnd(8)} | ${user.email.padEnd(25)} | ${user.unit_nama}`)
  })

  console.log('\n' + '='.repeat(80))
  console.log(`Total: ${userList.length} users`)
  console.log('='.repeat(80))

  // Save to JSON file
  const fs = await import('fs')
  const outputPath = './unit-users-to-create.json'
  
  fs.writeFileSync(outputPath, JSON.stringify(userList, null, 2))
  console.log(`\n✅ List user disimpan ke: ${outputPath}`)
  
  // Create SQL format
  console.log('\n📋 SQL FORMAT (untuk copy-paste):')
  console.log('=' .repeat(80))
  console.log('-- Copy commands dibawah untuk create user via Supabase Dashboard SQL Editor')
  console.log('-- Atau gunakan melalui Authentication > Users (Add User)\n')
  
  userList.forEach((user, idx) => {
    console.log(`-- ${idx + 1}. ${user.unit_nama}`)
    console.log(`-- Email: ${user.email}`)
    console.log(`-- Password: ${DEFAULT_PASSWORD}`)
    console.log(`-- Username: ${user.username}`)
    console.log()
  })

  return userList
}

generateUserList()
  .then(() => {
    console.log('\n✅ Script selesai')
    process.exit(0)
  })
  .catch(error => {
    console.error('❌ Error:', error)
    process.exit(1)
  })
