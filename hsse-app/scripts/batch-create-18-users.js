/**
 * Script untuk membuat 18 user unit secara batch
 * Data: Area dan Unit Bali Nusatenggara, Jawa 1, Kalimantan 3
 * Password: @w3Safe (sama untuk semua)
 */

const USERS_TO_CREATE = [
  {
    username: "area-balinusra",
    email: "area-balinusra@w3safe.local",
    nama: "Area Bali Nusatenggara"
  },
  {
    username: "area-jawa1",
    email: "area-jawa1@w3safe.local",
    nama: "Area Jawa 1"
  },
  {
    username: "area-kalimantan3",
    email: "area-kalimantan3@w3safe.local",
    nama: "Area Kalimantan 3"
  },
  {
    username: "unit-banjarmasin",
    email: "unit-banjarmasin@w3safe.local",
    nama: "Banjarmasin"
  },
  {
    username: "unit-batulicin",
    email: "unit-batulicin@w3safe.local",
    nama: "Batulicin"
  },
  {
    username: "unit-benoa",
    email: "unit-benoa@w3safe.local",
    nama: "Benoa"
  },
  {
    username: "unit-bunati",
    email: "unit-bunati@w3safe.local",
    nama: "Bunati"
  },
  {
    username: "unit-celukanbawang",
    email: "unit-celukanbawang@w3safe.local",
    nama: "Celukan Bawang"
  },
  {
    username: "unit-gresik",
    email: "unit-gresik@w3safe.local",
    nama: "Gresik"
  },
  {
    username: "unit-kotabaru",
    email: "unit-kotabaru@w3safe.local",
    nama: "Kotabaru"
  },
  {
    username: "unit-kumai",
    email: "unit-kumai@w3safe.local",
    nama: "Kumai"
  },
  {
    username: "unit-lembar",
    email: "unit-lembar@w3safe.local",
    nama: "Lembar"
  },
  {
    username: "unit-mekarputih",
    email: "unit-mekarputih@w3safe.local",
    nama: "Mekar Putih"
  },
  {
    username: "unit-sampit",
    email: "unit-sampit@w3safe.local",
    nama: "Sampit"
  },
  {
    username: "unit-satui",
    email: "unit-satui@w3safe.local",
    nama: "Satui"
  },
  {
    username: "unit-tanjungintan",
    email: "unit-tanjungintan@w3safe.local",
    nama: "Tanjung Intan"
  },
  {
    username: "unit-tanjungperak",
    email: "unit-tanjungperak@w3safe.local",
    nama: "Tanjung Perak"
  },
  {
    username: "unit-tenaukupang",
    email: "unit-tenaukupang@w3safe.local",
    nama: "Tenau Kupang"
  }
]

const DEFAULT_PASSWORD = "@w3Safe"

console.log('=' .repeat(80))
console.log('📋 DAFTAR USER YANG AKAN DIBUAT')
console.log('=' .repeat(80))
console.log(`Total: ${USERS_TO_CREATE.length} users`)
console.log(`Password: ${DEFAULT_PASSWORD} (SAMA UNTUK SEMUA)\n`)

console.log('No. | Username                | Email                                  | Nama Unit')
console.log('-'.repeat(80))

USERS_TO_CREATE.forEach((user, idx) => {
  const no = (idx + 1).toString().padStart(3)
  const username = user.username.padEnd(23)
  const email = user.email.padEnd(38)
  console.log(`${no} | ${username} | ${email} | ${user.nama}`)
})

console.log('\n' + '=' .repeat(80))
console.log('📝 INSTRUKSI PEMBUATAN USER')
console.log('=' .repeat(80))
console.log('\nCara 1: MANUAL via Supabase Dashboard (RECOMMENDED)')
console.log('----------------------------------------------------')
console.log('1. Buka: https://supabase.com/dashboard')
console.log('2. Pilih project HSSE')
console.log('3. Klik: Authentication > Users')
console.log('4. Untuk SETIAP user diatas, klik "Add user":')
console.log('   - Email: (dari kolom Email)')
console.log('   - Password: @w3Safe')
console.log('   - Auto Confirm User: ✅ CENTANG')
console.log('   - Click "Create user"')
console.log('\n5. (Optional) Tambah User Metadata untuk setiap user:')
console.log('   {')
console.log('     "username": "area-balinusra",')
console.log('     "nama": "Area Bali Nusatenggara",')
console.log('     "role": "unit_user"')
console.log('   }')

console.log('\n\nCara 2: Via Supabase Management API (Advanced)')
console.log('----------------------------------------------')
console.log('Requirements:')
console.log('- SUPABASE_SERVICE_ROLE_KEY dari Dashboard > Settings > API')
console.log('- Jalankan: scripts/create-batch-users-api.ts (script terpisah)')

console.log('\n\n' + '=' .repeat(80))
console.log('✅ CHECKLIST SETELAH PEMBUATAN USER')
console.log('=' .repeat(80))
console.log('- [ ] Total 18 users sudah dibuat')
console.log('- [ ] Test login dengan salah satu user:')
console.log('      Email: unit-gresik@w3safe.local')
console.log('      Password: @w3Safe')
console.log('- [ ] Verify di Dashboard > Authentication > Users')
console.log('- [ ] Setup Row Level Security (RLS) policies')
console.log('- [ ] Update login page dengan hint username')

console.log('\n\n' + '=' .repeat(80))
console.log('🔐 PASSWORD INFO')
console.log('=' .repeat(80))
console.log('Default Password: @w3Safe')
console.log('\nStrength:')
console.log('✅ 7 characters')
console.log('✅ Uppercase: S')
console.log('✅ Lowercase: w, a, f, e')
console.log('✅ Special char: @')
console.log('✅ Number: 3')
console.log('\n⚠️  SECURITY RECOMMENDATION:')
console.log('- Minta user ganti password saat first login')
console.log('- Implementasi "Force Password Change" feature')
console.log('- Enable 2FA untuk admin accounts')

console.log('\n\n✅ Script selesai! Gunakan data diatas untuk membuat user.')
console.log('📖 Baca: docs/PANDUAN_BUAT_USER_UNIT.md untuk instruksi lengkap\n')
