# 📋 Panduan Membuat User untuk Setiap Unit

## 🎯 Tujuan
Membuat akun user untuk setiap unit yang ada di sistem HSSE dengan:
- **Username**: Berdasarkan kode unit (lowercase)
- **Email**: `{kode}@w3safe.local`
- **Password**: `@w3Safe` (sama untuk semua user)

---

## 📝 Langkah-langkah

### 1️⃣ Lihat Daftar Unit yang Perlu Dibuatkan User

Jalankan query ini di **Supabase SQL Editor**:

```sql
SELECT 
  ROW_NUMBER() OVER (ORDER BY kode) as no,
  kode as "Kode Unit",
  nama as "Nama Unit",
  LOWER(kode) as "Username",
  LOWER(kode) || '@w3safe.local' as "Email",
  '@w3Safe' as "Password"
FROM units 
WHERE aktif = true 
ORDER BY kode;
```

📸 **Screenshot hasil query** dan simpan untuk referensi

---

### 2️⃣ Buat User via Supabase Dashboard

Untuk **setiap unit** dari hasil query diatas:

1. **Buka Supabase Dashboard**:
   - URL: https://supabase.com/dashboard
   - Login dengan akun Anda
   - Pilih project: **HSSE App**

2. **Navigate ke Authentication**:
   - Click sidebar **Authentication**
   - Click tab **Users**

3. **Click tombol "Add user"** (pojok kanan atas)

4. **Isi form dengan data dari query**:
   
   ```
   📧 Email: wil1@w3safe.local     (sesuaikan dengan hasil query)
   🔐 Password: @w3Safe             (sama untuk semua)
   ✅ Auto Confirm User: CENTANG    (agar langsung aktif tanpa verify email)
   ```

5. **Click "Create user"**

6. **Ulangi langkah 3-5** untuk setiap unit lainnya

---

### 3️⃣ Tambah User Metadata (Opsional tapi Direkomendasikan)

Setelah user dibuat, tambahkan metadata untuk informasi tambahan:

1. Click user yang baru dibuat
2. Scroll ke bagian **User Metadata**
3. Click **Edit** 
4. Masukkan JSON berikut (sesuaikan dengan unit):

```json
{
  "username": "wil1",
  "unit_kode": "WIL1",
  "unit_nama": "Wilayah 1",
  "role": "unit_user"
}
```

5. Click **Save**

---

## 📊 Contoh Data User

Berdasarkan units yang ada, berikut contoh user yang perlu dibuat:

| No | Kode Unit | Username | Email | Password | Nama Unit |
|----|-----------|----------|-------|----------|-----------|
| 1  | WIL1      | wil1     | wil1@w3safe.local | @w3Safe | Wilayah 1 |
| 2  | WIL2      | wil2     | wil2@w3safe.local | @w3Safe | Wilayah 2 |
| 3  | WIL3      | wil3     | wil3@w3safe.local | @w3Safe | Wilayah 3 |
| 4  | UNIT1     | unit1    | unit1@w3safe.local | @w3Safe | Unit 1 |
| 5  | UNIT2     | unit2    | unit2@w3safe.local | @w3Safe | Unit 2 |
| ... | ... | ... | ... | ... | ... |

*(Sesuaikan dengan hasil query Step 1)*

---

## ✅ Verifikasi User Sudah Dibuat

### Check di Dashboard:
1. Buka **Authentication > Users**
2. Search email: `@w3safe.local`
3. Pastikan semua user sudah tercantum

### Test Login:
1. Logout dari akun admin
2. Login dengan salah satu user unit:
   - Email: `wil1@w3safe.local`
   - Password: `@w3Safe`
3. Jika berhasil login ✅ = User sudah dibuat dengan benar!

---

## 🔧 Troubleshooting

### ❌ "Email already in use"
- User sudah dibuat sebelumnya
- Skip dan lanjut ke unit berikutnya
- Untuk reset password, use "Reset Password" di Dashboard

### ❌ "Invalid email format"
- Pastikan format: `kode@w3safe.local` (lowercase)
- Tidak ada spasi atau karakter khusus

### ❌ "Password too weak"
- Password `@w3Safe` memenuhi requirement:
  - Min 6 karakter ✅
  - Ada huruf besar (S) ✅
  - Ada huruf kecil (w, a, f, e) ✅
  - Ada simbol (@) ✅

---

## 🔐 Password Policy

### Default Password: `@w3Safe`

**Karakteristik**:
- Length: 7 characters ✅
- Uppercase: S ✅
- Lowercase: w, a, f, e ✅  
- Special char: @ ✅
- Number: 3 ✅

**Security Recommendation**:
- ✅ Gunakan password ini untuk initial setup
- ⚠️ Minta user ganti password saat first login
- 🔒 Implementasi "Force Password Change" pada login pertama

---

## 📈 Next Steps

Setelah semua user dibuat:

### 1. Setup Row Level Security (RLS)
```sql
-- Contoh: User hanya bisa lihat data unit mereka sendiri
CREATE POLICY "Users can only view their own unit data"
ON safety_forum
FOR SELECT
USING (unit_id = (auth.jwt() -> 'user_metadata' ->> 'unit_id')::uuid);
```

### 2. Update Login Page
- [ ] Tambah hint: "Gunakan email unit Anda: {kode}@w3safe.local"
- [ ] Tambah "Forgot Password" link
- [ ] Implementasi "First Login - Change Password" flow

### 3. Create User Profile Page
- [ ] View profile info
- [ ] Change password form  
- [ ] View unit information
- [ ] Activity log

### 4. Role-Based Access Control
- [ ] Define roles: admin, unit_user, viewer
- [ ] Implement permission checks
- [ ] Restrict menu access per role

---

## 📞 Support

Jika ada masalah atau pertanyaan:
1. Check dokumentasi Supabase Auth: https://supabase.com/docs/guides/auth
2. Lihat error log di Dashboard > Logs
3. Test dengan akun admin terlebih dahulu

---

## 📝 Checklist

- [ ] Jalankan query Step 1 untuk lihat daftar unit
- [ ] Screenshot hasil query
- [ ] Buat user untuk setiap unit via Dashboard
- [ ] Tambah metadata untuk setiap user (optional)
- [ ] Test login dengan salah satu akun
- [ ] Verifikasi semua user tercantum di Dashboard
- [ ] Setup RLS policies
- [ ] Update login page dengan hint
- [ ] Plan implementasi change password feature

---

**Dibuat**: November 22, 2025  
**File Terkait**: 
- `supabase/generate-unit-users.sql` - Query untuk generate list
- `scripts/create-unit-users.ts` - Script otomatis (requires service role key)
- `docs/CREATE_UNIT_USERS.md` - Dokumentasi lengkap
