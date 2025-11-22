# 🚀 Cara Registrasi Semua 18 User Secara Otomatis

## ⚡ Quick Start (3 Langkah)

### 1️⃣ Dapatkan Service Role Key

1. **Buka Supabase Dashboard**: https://supabase.com/dashboard
2. **Login** dengan akun admin Anda
3. **Pilih project**: HSSE App (oxskmrkzxkvifbappsic)
4. **Navigate**: Settings > API
5. **Copy "service_role" key** (⚠️ BUKAN "anon" key!)
   - Key yang panjang (~200 karakter)
   - Starts with: `eyJhbGciOiJIUzI1NiIsInR5...`

### 2️⃣ Set Environment Variable

Di terminal, jalankan:

```bash
cd /Users/hadipurwana/Documents/PYTHON/HSSE/hsse-app

# Export service role key (ganti YOUR_SERVICE_ROLE_KEY dengan key yang di-copy)
export SUPABASE_SERVICE_ROLE_KEY="YOUR_SERVICE_ROLE_KEY"

# Verify (harus muncul key-nya)
echo $SUPABASE_SERVICE_ROLE_KEY
```

### 3️⃣ Jalankan Script Registrasi

```bash
npx tsx scripts/register-all-users.ts
```

**Script akan:**
- ✅ Membuat 18 user secara otomatis
- ✅ Auto-confirm email (tidak perlu verify)
- ✅ Set password: `@w3Safe` untuk semua user
- ✅ Tambah user metadata (username, nama, role)
- ✅ Skip user yang sudah ada
- ✅ Tampilkan summary hasil
- ✅ Simpan hasil ke `data/user-creation-results.json`

---

## 📋 User yang Akan Dibuat

**Total: 18 users**

### Area (3):
1. area-balinusra@w3safe.local
2. area-jawa1@w3safe.local
3. area-kalimantan3@w3safe.local

### Unit (15):
4. unit-banjarmasin@w3safe.local
5. unit-batulicin@w3safe.local
6. unit-benoa@w3safe.local
7. unit-bunati@w3safe.local
8. unit-celukanbawang@w3safe.local
9. unit-gresik@w3safe.local
10. unit-kotabaru@w3safe.local
11. unit-kumai@w3safe.local
12. unit-lembar@w3safe.local
13. unit-mekarputih@w3safe.local
14. unit-sampit@w3safe.local
15. unit-satui@w3safe.local
16. unit-tanjungintan@w3safe.local
17. unit-tanjungperak@w3safe.local
18. unit-tenaukupang@w3safe.local

**Password semua user**: `@w3Safe`

---

## 🧪 Testing Setelah Registrasi

### Test Login 1:
```
URL: http://localhost:5174/login
Email: unit-gresik@w3safe.local
Password: @w3Safe
```

### Test Login 2:
```
Email: area-balinusra@w3safe.local
Password: @w3Safe
```

**Expected**: ✅ Berhasil login dan redirect ke dashboard

---

## 📊 Output Script

Script akan menampilkan progress real-time:

```
================================================================================
🚀 MEMULAI REGISTRASI 18 USER
================================================================================
Total: 18 users
Password: @w3Safe

[01/18] 🔄 Membuat user: area-balinusra
     Email: area-balinusra@w3safe.local
     Nama: Area Bali Nusatenggara
     ✅ Berhasil dibuat!
     User ID: 12345678-...

[02/18] 🔄 Membuat user: area-jawa1
     ...
```

Dan summary di akhir:

```
================================================================================
📊 RINGKASAN HASIL REGISTRASI
================================================================================

✅ Berhasil dibuat: 18
   - area-balinusra (area-balinusra@w3safe.local)
   - area-jawa1 (area-jawa1@w3safe.local)
   - ...

⏭️  Dilewati (sudah ada): 0

❌ Gagal: 0

💾 Hasil disimpan ke: ./data/user-creation-results.json

================================================================================
🧪 TEST LOGIN
================================================================================
Coba login dengan salah satu user:

User 1:
  Email: unit-gresik@w3safe.local
  Password: @w3Safe

User 2:
  Email: area-balinusra@w3safe.local
  Password: @w3Safe

================================================================================
✅ SCRIPT SELESAI!
================================================================================
Total user aktif: 18
Semua user sudah auto-confirmed dan siap login!
```

---

## 🔧 Troubleshooting

### ❌ "SUPABASE_SERVICE_ROLE_KEY tidak ditemukan"
**Solusi:**
```bash
# Set environment variable dulu
export SUPABASE_SERVICE_ROLE_KEY="your_key_here"

# Verify
echo $SUPABASE_SERVICE_ROLE_KEY
```

### ❌ "Invalid API key"
**Penyebab**: Key yang di-copy salah atau expired

**Solusi:**
- Pastikan copy "service_role" key (bukan "anon")
- Copy ulang dari Dashboard
- Jangan ada spasi atau karakter tambahan

### ❌ "User already exists"
**Status**: ✅ Normal, user sudah dibuat sebelumnya

**Aksi**: Script akan skip otomatis

### ❌ "Connection timeout"
**Solusi:**
- Check internet connection
- Tunggu beberapa saat
- Jalankan ulang script (akan skip user yang sudah ada)

---

## 🔒 Security Notes

### ⚠️ Service Role Key = Super Admin
- **JANGAN** commit ke git
- **JANGAN** share ke siapa pun
- **HANYA** gunakan di local development
- **SIMPAN** dengan aman

### Keamanan Password
- Default password: `@w3Safe`
- ✅ Memenuhi requirement (7 char, uppercase, lowercase, special, number)
- ⚠️ **RECOMMENDED**: Implement "force password change" pada first login

---

## 📁 File Output

Setelah script selesai, akan generate:

**`data/user-creation-results.json`**:
```json
{
  "created_at": "2025-11-22T...",
  "total": 18,
  "success": 18,
  "skipped": 0,
  "errors": 0,
  "results": [
    {
      "username": "area-balinusra",
      "email": "area-balinusra@w3safe.local",
      "status": "success",
      "message": "User created successfully",
      "userId": "12345678-..."
    },
    ...
  ]
}
```

---

## ✅ Verification

### Check di Supabase Dashboard:
1. Authentication > Users
2. Search: `@w3safe.local`
3. Should show: **18 users**
4. Status: All confirmed ✅

### Check via SQL:
```sql
-- Di Supabase SQL Editor
SELECT 
  email,
  email_confirmed_at,
  raw_user_meta_data->>'username' as username,
  raw_user_meta_data->>'nama' as nama,
  created_at
FROM auth.users
WHERE email LIKE '%@w3safe.local'
ORDER BY created_at DESC;
```

---

## 🎯 Next Steps

Setelah semua user terdaftar:

### 1. Test Login
- [ ] Test 3-5 user berbeda
- [ ] Verify bisa akses dashboard
- [ ] Check data permission

### 2. Setup RLS (Row Level Security)
```sql
-- Contoh: User hanya bisa lihat data unit mereka
CREATE POLICY "users_see_own_unit_data"
ON safety_forum
FOR SELECT
USING (
  unit_id = (
    SELECT unit_id 
    FROM units 
    WHERE kode = (auth.jwt() -> 'user_metadata' ->> 'username')
    LIMIT 1
  )
);
```

### 3. Update UI
- [ ] Add username hint di login page
- [ ] Show unit name after login
- [ ] Implement "Change Password" feature
- [ ] Add "Forgot Password" flow

### 4. Documentation
- [ ] Send login credentials ke setiap unit
- [ ] Create user manual/guide
- [ ] Setup support channel

---

## 📞 Support

**File Terkait**:
- `scripts/register-all-users.ts` - Main script
- `data/users-to-create.csv` - User list (CSV)
- `CHECKLIST_18_USERS.md` - Manual checklist
- `docs/PANDUAN_BUAT_USER_UNIT.md` - Full documentation

**Jika ada masalah**: Check error message di terminal dan lihat troubleshooting section diatas.

---

**Created**: November 22, 2025  
**Script**: `scripts/register-all-users.ts`  
**Status**: Ready to run
