import { createClient } from '@supabase/supabase-js'
import * as fs from 'fs'

// Supabase credentials
const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || ''

if (!supabaseServiceKey) {
  console.error('❌ SUPABASE_SERVICE_ROLE_KEY tidak ditemukan!')
  console.log('\n📝 Cara mendapatkan Service Role Key:')
  console.log('1. Buka: https://supabase.com/dashboard')
  console.log('2. Pilih project HSSE')
  console.log('3. Klik: Settings > API')
  console.log('4. Copy "service_role" key (bukan anon key)')
  console.log('5. Export: export SUPABASE_SERVICE_ROLE_KEY="your_key_here"')
  console.log('6. Jalankan script lagi\n')
  process.exit(1)
}

// Create admin client
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const USERS_TO_CREATE = [
  { username: "area-balinusra", email: "area-balinusra@w3safe.local", nama: "Area Bali Nusatenggara" },
  { username: "area-jawa1", email: "area-jawa1@w3safe.local", nama: "Area Jawa 1" },
  { username: "area-kalimantan3", email: "area-kalimantan3@w3safe.local", nama: "Area Kalimantan 3" },
  { username: "unit-banjarmasin", email: "unit-banjarmasin@w3safe.local", nama: "Banjarmasin" },
  { username: "unit-batulicin", email: "unit-batulicin@w3safe.local", nama: "Batulicin" },
  { username: "unit-benoa", email: "unit-benoa@w3safe.local", nama: "Benoa" },
  { username: "unit-bunati", email: "unit-bunati@w3safe.local", nama: "Bunati" },
  { username: "unit-celukanbawang", email: "unit-celukanbawang@w3safe.local", nama: "Celukan Bawang" },
  { username: "unit-gresik", email: "unit-gresik@w3safe.local", nama: "Gresik" },
  { username: "unit-kotabaru", email: "unit-kotabaru@w3safe.local", nama: "Kotabaru" },
  { username: "unit-kumai", email: "unit-kumai@w3safe.local", nama: "Kumai" },
  { username: "unit-lembar", email: "unit-lembar@w3safe.local", nama: "Lembar" },
  { username: "unit-mekarputih", email: "unit-mekarputih@w3safe.local", nama: "Mekar Putih" },
  { username: "unit-sampit", email: "unit-sampit@w3safe.local", nama: "Sampit" },
  { username: "unit-satui", email: "unit-satui@w3safe.local", nama: "Satui" },
  { username: "unit-tanjungintan", email: "unit-tanjungintan@w3safe.local", nama: "Tanjung Intan" },
  { username: "unit-tanjungperak", email: "unit-tanjungperak@w3safe.local", nama: "Tanjung Perak" },
  { username: "unit-tenaukupang", email: "unit-tenaukupang@w3safe.local", nama: "Tenau Kupang" }
]

const DEFAULT_PASSWORD = '@w3Safe'

interface CreateResult {
  username: string
  email: string
  status: 'success' | 'skipped' | 'error'
  message: string
  userId?: string
}

async function createAllUsers() {
  console.log('=' .repeat(80))
  console.log('🚀 MEMULAI REGISTRASI 18 USER')
  console.log('=' .repeat(80))
  console.log(`Total: ${USERS_TO_CREATE.length} users`)
  console.log(`Password: ${DEFAULT_PASSWORD}\n`)

  const results: CreateResult[] = []

  for (let i = 0; i < USERS_TO_CREATE.length; i++) {
    const user = USERS_TO_CREATE[i]
    const no = (i + 1).toString().padStart(2, '0')
    
    console.log(`\n[${no}/${USERS_TO_CREATE.length}] 🔄 Membuat user: ${user.username}`)
    console.log(`     Email: ${user.email}`)
    console.log(`     Nama: ${user.nama}`)

    try {
      // Check if user already exists
      const { data: existingUsers } = await supabase.auth.admin.listUsers()
      const userExists = existingUsers?.users?.some(u => u.email === user.email)

      if (userExists) {
        console.log(`     ⏭️  User sudah ada, dilewati`)
        results.push({
          username: user.username,
          email: user.email,
          status: 'skipped',
          message: 'User already exists'
        })
        continue
      }

      // Create user dengan admin API
      const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
        email: user.email,
        password: DEFAULT_PASSWORD,
        email_confirm: true, // Auto-confirm, tidak perlu verify email
        user_metadata: {
          username: user.username,
          nama: user.nama,
          role: 'unit_user',
          created_via: 'batch_script',
          created_date: new Date().toISOString()
        }
      })

      if (createError) {
        console.log(`     ❌ Error: ${createError.message}`)
        results.push({
          username: user.username,
          email: user.email,
          status: 'error',
          message: createError.message
        })
        continue
      }

      console.log(`     ✅ Berhasil dibuat!`)
      console.log(`     User ID: ${newUser.user?.id}`)
      
      results.push({
        username: user.username,
        email: user.email,
        status: 'success',
        message: 'User created successfully',
        userId: newUser.user?.id
      })

      // Small delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 500))

    } catch (error: any) {
      console.log(`     ❌ Exception: ${error.message}`)
      results.push({
        username: user.username,
        email: user.email,
        status: 'error',
        message: error.message
      })
    }
  }

  // Summary
  console.log('\n' + '=' .repeat(80))
  console.log('📊 RINGKASAN HASIL REGISTRASI')
  console.log('=' .repeat(80))

  const success = results.filter(r => r.status === 'success')
  const skipped = results.filter(r => r.status === 'skipped')
  const errors = results.filter(r => r.status === 'error')

  console.log(`\n✅ Berhasil dibuat: ${success.length}`)
  if (success.length > 0) {
    success.forEach(r => console.log(`   - ${r.username} (${r.email})`))
  }

  console.log(`\n⏭️  Dilewati (sudah ada): ${skipped.length}`)
  if (skipped.length > 0) {
    skipped.forEach(r => console.log(`   - ${r.username} (${r.email})`))
  }

  console.log(`\n❌ Gagal: ${errors.length}`)
  if (errors.length > 0) {
    errors.forEach(r => console.log(`   - ${r.username}: ${r.message}`))
  }

  // Save results to JSON
  const outputPath = './data/user-creation-results.json'
  fs.writeFileSync(outputPath, JSON.stringify({
    created_at: new Date().toISOString(),
    total: USERS_TO_CREATE.length,
    success: success.length,
    skipped: skipped.length,
    errors: errors.length,
    results: results
  }, null, 2))

  console.log(`\n💾 Hasil disimpan ke: ${outputPath}`)

  // Testing info
  console.log('\n' + '=' .repeat(80))
  console.log('🧪 TEST LOGIN')
  console.log('=' .repeat(80))
  console.log('Coba login dengan salah satu user:')
  console.log('\nUser 1:')
  console.log(`  Email: ${USERS_TO_CREATE[8].email}`)
  console.log(`  Password: ${DEFAULT_PASSWORD}`)
  console.log('\nUser 2:')
  console.log(`  Email: ${USERS_TO_CREATE[0].email}`)
  console.log(`  Password: ${DEFAULT_PASSWORD}`)

  console.log('\n' + '=' .repeat(80))
  console.log('✅ SCRIPT SELESAI!')
  console.log('=' .repeat(80))
  console.log(`Total user aktif: ${success.length + skipped.length}`)
  console.log('Semua user sudah auto-confirmed dan siap login!\n')

  return results
}

// Run script
createAllUsers()
  .then(() => {
    process.exit(0)
  })
  .catch((error) => {
    console.error('\n❌ Fatal error:', error)
    process.exit(1)
  })
