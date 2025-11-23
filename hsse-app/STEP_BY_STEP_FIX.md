# 🔧 Step-by-Step Silent Inspection Fix (AMAN & BERTAHAP)

## 📋 Langkah-Langkah Aman

### ✅ STEP 1: Backup Database (AMAN)

**Tujuan**: Backup data penting sebelum melakukan perubahan

```sql
-- Jalankan di Supabase SQL Editor
-- Backup data silent_inspection yang sudah ada
CREATE TABLE silent_inspection_backup AS
SELECT * FROM silent_inspection;

-- Cek backup berhasil
SELECT COUNT(*) as total_backup FROM silent_inspection_backup;
```

### ✅ STEP 2: Check Bucket Configuration (AMAN)

**Via Supabase Dashboard:**
1. Pergi ke **Storage** → `silent-inspection-photos`
2. **Verify Settings:**
   - ✅ **Public bucket**: `true`
   - ✅ **File size limit**: `1048576` (1MB) atau lebih
   - ✅ **Allowed MIME types**: `image/jpeg, image/png, image/jpg, image/webp`

**Jika ada yang salah:**
- Klik **Edit bucket** dan perbaiki

### ✅ STEP 3: Check Storage Policies (AMAN)

**Via Supabase Dashboard:**
1. Storage → `silent-inspection-photos` → **Policies** tab
2. **Cek ada 4 policies berikut:**

| Policy Name | Command | Who | Status |
|-------------|---------|-----|--------|
| `silent-inspection-insert` | INSERT | `authenticated` | ❓ Check |
| `silent-inspection-select` | SELECT | `public` | ❓ Check |
| `silent-inspection-update` | UPDATE | `authenticated` | ❓ Check |
| `silent-inspection-delete` | DELETE | `authenticated` | ❓ Check |

**Jika policies tidak lengkap, lanjut ke Step 4**

### ✅ STEP 4: Setup Missing Policies (AMAN)

**Jalankan SQL di Supabase SQL Editor:**

```sql
-- Step 4A: Drop existing policies (safe)
DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;
```

```sql
-- Step 4B: Create INSERT policy (paling penting untuk upload)
CREATE POLICY "silent-inspection-insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'silent-inspection-photos');
```

```sql
-- Step 4C: Create SELECT policy (untuk view foto)
CREATE POLICY "silent-inspection-select"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'silent-inspection-photos');
```

```sql
-- Step 4D: Create UPDATE policy (untuk modify)
CREATE POLICY "silent-inspection-update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'silent-inspection-photos')
WITH CHECK (bucket_id = 'silent-inspection-photos');
```

```sql
-- Step 4E: Create DELETE policy (untuk hapus)
CREATE POLICY "silent-inspection-delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'silent-inspection-photos');
```

### ✅ STEP 5: Test Manual Upload (AMAN)

**Via Supabase Dashboard:**
1. Storage → `silent-inspection-photos`
2. Klik **Upload** dan upload gambar kecil (contoh: 1KB PNG)
3. **Jika berhasil**: ✅ Policies OK, lanjut Step 6
4. **Jika gagal**: ❌ Lihat error message, check Step 4

### ✅ STEP 6: Test di Aplikasi (AMAN)

1. Jalankan aplikasi: `npm run dev`
2. Login ke aplikasi
3. Pergi ke **Silent Inspection**
4. Klik **Tambah Inspeksi**
5. Upload foto kecil (max 100KB)
6. Klik **Simpan**

**Monitor Browser Console:**
- ✅ **Berhasil**: Tidak ada error 400
- ❌ **Gagal**: Check error message

### ✅ STEP 7: Test dengan Data Real (AMAN)

1. Upload foto yang lebih besar (500KB-1MB)
2. Test berbagai format: JPG, PNG
3. Test edit existing record dengan foto baru
4. Test hapus foto

### 🚨 EMERGENCY ROLLBACK (jika ada masalah)

**Jika aplikasi rusak setelah perubahan:**

```sql
-- Restore data dari backup
INSERT INTO silent_inspection
SELECT * FROM silent_inspection_backup
ON CONFLICT (id) DO NOTHING;

-- Hapus backup table
DROP TABLE silent_inspection_backup;
```

## 📊 Status Check

**Checklist Aman:**

- [ ] **Step 1**: Backup database ✅
- [ ] **Step 2**: Bucket configuration check ✅
- [ ] **Step 3**: Policies check ✅
- [ ] **Step 4**: Policies setup (jika perlu) ❓
- [ ] **Step 5**: Manual upload test ❓
- [ ] **Step 6**: App upload test ❓
- [ ] **Step 7**: Real data test ❓

## 🛟 Troubleshooting Per Step

### Jika Step 4 Gagal
**Error: "permission denied for schema storage"**
- Pastikan menggunakan SQL Editor di Supabase Dashboard
- Pastikan akun punya admin access

### Jika Step 5 Gagal
**Error: "File type not allowed"**
- Check bucket MIME types configuration
- Tambahkan: `image/jpeg, image/png, image/jpg, image/webp`

### Jika Step 6 Gagal (masih 400 error)
**Check browser Network tab:**
- Request URL harus contain: `silent-inspection-photos`
- Response harus 200 (bukan 400)
- Jika masih 400, check authentication status

## 🔄 Alternative Approach (jika masih bermasalah)

### Option A: Recreate Bucket (RISKY - backup dulu!)

```sql
-- HATI-HATI: Ini hapus semua file di bucket!
DELETE FROM storage.objects WHERE bucket_id = 'silent-inspection-photos';
DELETE FROM storage.buckets WHERE id = 'silent-inspection-photos';
```

Kemudian recreate via Dashboard atau script.

### Option B: Debug Code Level

Check file `silent-inspection.service.ts`:
```typescript
// Pastikan bucket name benar
private bucketName = 'silent-inspection-photos'
```

## ✅ Success Criteria

**Upload berhasil jika:**
- ✅ Tidak ada error 400 di browser console
- ✅ Foto tersimpan di Supabase Storage
- ✅ URL foto bisa diakses
- ✅ Data inspection tersimpan meski foto gagal upload

---

**🎯 Start with Step 1 and proceed step-by-step. Stop if any step fails and report the error.**

