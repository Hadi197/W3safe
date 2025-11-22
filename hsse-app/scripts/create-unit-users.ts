/**
 * Script untuk membuat user berdasarkan data unit
 * Password semua user: @w3Safe
 * 
 * Usage:
 * 1. Install dependencies: npm install
 * 2. Set SUPABASE_SERVICE_ROLE_KEY di .env
 * 3. Run: npx tsx create-unit-users.ts
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.VITE_SUPABASE_URL || 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || ''

if (!supabaseServiceKey) {
  console.error('❌ SUPABASE_SERVICE_ROLE_KEY tidak ditemukan di environment variables')
  console.log('Set environment variable: SUPABASE_SERVICE_ROLE_KEY=your_service_role_key')
  process.exit(1)
}

// Create admin client dengan service role key
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const DEFAULT_PASSWORD = '@w3Safe'

async function createUnitUsers() {
  console.log('🔄 Mengambil data unit dari database...\n')

  // Get all active units
  const { data: units, error: unitsError } = await supabase
    .from('units')
    .select('id, kode, nama')
    .eq('aktif', true)
    .order('kode')

  if (unitsError) {
    console.error('❌ Error mengambil data unit:', unitsError)
    return
  }

  if (!units || units.length === 0) {
    console.log('⚠️  Tidak ada unit aktif ditemukan')
    return
  }

  console.log(`📊 Ditemukan ${units.length} unit aktif:\n`)
  
  const results = {
    success: [] as string[],
    skipped: [] as string[],
    errors: [] as string[]
  }

  for (const unit of units) {
    const username = unit.kode.toLowerCase()
    const email = `${username}@w3safe.local`
    
    console.log(`\n🔄 Membuat user untuk unit: ${unit.kode} - ${unit.nama}`)
    console.log(`   Username: ${username}`)
    console.log(`   Email: ${email}`)

    try {
      // Check if user already exists
      const { data: existingUsers } = await supabase.auth.admin.listUsers()
      const userExists = existingUsers?.users?.some(u => u.email === email)

      if (userExists) {
        console.log(`   ⏭️  User sudah ada, dilewati`)
        results.skipped.push(username)
        continue
      }

      // Create user dengan admin API
      const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
        email,
        password: DEFAULT_PASSWORD,
        email_confirm: true, // Auto-confirm email
        user_metadata: {
          username,
          unit_id: unit.id,
          unit_kode: unit.kode,
          unit_nama: unit.nama,
          role: 'unit_user'
        }
      })

      if (createError) {
        console.error(`   ❌ Error: ${createError.message}`)
        results.errors.push(`${username}: ${createError.message}`)
        continue
      }

      console.log(`   ✅ User berhasil dibuat!`)
      console.log(`   User ID: ${newUser.user?.id}`)
      results.success.push(username)

    } catch (error: any) {
      console.error(`   ❌ Exception: ${error.message}`)
      results.errors.push(`${username}: ${error.message}`)
    }
  }

  // Summary
  console.log('\n' + '='.repeat(60))
  console.log('📋 RINGKASAN PEMBUATAN USER')
  console.log('='.repeat(60))
  console.log(`✅ Berhasil dibuat: ${results.success.length}`)
  if (results.success.length > 0) {
    console.log('   ' + results.success.join(', '))
  }
  
  console.log(`\n⏭️  Dilewati (sudah ada): ${results.skipped.length}`)
  if (results.skipped.length > 0) {
    console.log('   ' + results.skipped.join(', '))
  }
  
  console.log(`\n❌ Gagal: ${results.errors.length}`)
  if (results.errors.length > 0) {
    results.errors.forEach(err => console.log(`   - ${err}`))
  }

  console.log('\n' + '='.repeat(60))
  console.log('🔐 Default Password untuk semua user: @w3Safe')
  console.log('='.repeat(60))
}

// Run script
createUnitUsers()
  .then(() => {
    console.log('\n✅ Script selesai')
    process.exit(0)
  })
  .catch((error) => {
    console.error('\n❌ Script error:', error)
    process.exit(1)
  })
