# Cara Membuat User untuk Setiap Unit

## Metode 1: Menggunakan Script TypeScript (Otomatis)

### Persiapan:

1. **Dapatkan Service Role Key dari Supabase Dashboard:**
   - Buka [Supabase Dashboard](https://supabase.com/dashboard)
   - Pilih project Anda
   - Klik Settings > API
   - Copy **service_role key** (secret key)

2. **Set Environment Variable:**

   ```bash
   # Di terminal, export service role key
   export SUPABASE_SERVICE_ROLE_KEY="your_service_role_key_here"
   ```

   Atau buat file `.env.local`:
   ```
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
   ```

3. **Install dependencies jika belum:**
   ```bash
   npm install
   ```

4. **Jalankan script:**
   ```bash
   cd /Users/hadipurwana/Documents/PYTHON/HSSE/hsse-app
   npx tsx scripts/create-unit-users.ts
   ```

### Output Script:

Script akan:
- ✅ Membaca semua unit aktif dari database
- ✅ Membuat user untuk setiap unit dengan format:
  - **Username**: kode unit (lowercase)
  - **Email**: `{kode}@w3safe.local`
  - **Password**: `@w3Safe`
- ✅ Skip user yang sudah ada
- ✅ Menampilkan summary hasil

---

## Metode 2: Manual via Supabase Dashboard

### Langkah-langkah:

1. **Buka Supabase Dashboard:**
   - Buka https://supabase.com/dashboard
   - Pilih project Anda
   - Klik **Authentication** > **Users**

2. **Buka SQL Editor untuk melihat list unit:**
   ```sql
   SELECT kode, nama FROM units WHERE aktif = true ORDER BY kode;
   ```

3. **Untuk setiap unit, buat user:**
   - Click tombol **"Add user"** atau **"Invite user"**
   - Isi form:
     - **Email**: `{kode_unit}@w3safe.local` (contoh: wil1@w3safe.local)
     - **Password**: `@w3Safe`
     - **Auto Confirm User**: ✅ (centang)
   - Click **Create user**

4. **Tambahkan metadata (optional):**
   - Click user yang baru dibuat
   - Edit **User Metadata**
   - Tambahkan:
     ```json
     {
       "username": "wil1",
       "unit_kode": "WIL1",
       "unit_nama": "Nama Unit",
       "role": "unit_user"
     }
     ```

---

## Metode 3: Bulk Import via SQL (Manual)

Jalankan query ini di Supabase SQL Editor:

```sql
-- Step 1: Lihat semua unit yang perlu dibuatkan user
SELECT 
  LOWER(kode) as username,
  LOWER(kode) || '@w3safe.local' as email,
  nama as unit_nama
FROM units 
WHERE aktif = true 
ORDER BY kode;
```

Kemudian buat user satu per satu di Dashboard menggunakan data dari query diatas.

---

## Format User yang Dibuat

| Unit Kode | Username | Email | Password | Role |
|-----------|----------|-------|----------|------|
| WIL1 | wil1 | wil1@w3safe.local | @w3Safe | unit_user |
| WIL2 | wil2 | wil2@w3safe.local | @w3Safe | unit_user |
| ... | ... | ... | @w3Safe | unit_user |

---

## Testing Login

Setelah user dibuat, test login dengan:

1. **Email**: `wil1@w3safe.local` (sesuaikan dengan kode unit)
2. **Password**: `@w3Safe`

---

## Troubleshooting

### Error: "SUPABASE_SERVICE_ROLE_KEY tidak ditemukan"
- Pastikan environment variable sudah di-set dengan benar
- Check dengan: `echo $SUPABASE_SERVICE_ROLE_KEY`

### Error: "User already exists"
- User sudah dibuat sebelumnya
- Script akan skip otomatis
- Untuk reset password, gunakan Dashboard

### Error: "Connection timeout"
- Network issue atau service role key tidak valid
- Check internet connection
- Verify service role key di Dashboard

---

## Password Policy

- **Default Password**: `@w3Safe`
- **Format**: 
  - Minimal 6 karakter ✅
  - Mengandung huruf besar ✅
  - Mengandung huruf kecil ✅
  - Mengandung simbol (@) ✅
- **Rekomendasi**: User diminta ganti password saat first login

---

## Next Steps

Setelah user dibuat:

1. ✅ Test login dengan salah satu akun
2. ✅ Setup Row Level Security (RLS) untuk membatasi akses per unit
3. ✅ Buat halaman profile untuk user ganti password
4. ✅ Implementasi role-based access control (RBAC)
