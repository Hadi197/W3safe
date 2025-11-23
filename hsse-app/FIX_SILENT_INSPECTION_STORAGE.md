# 🔧 Fix Silent Inspection Storage Error

## ❌ Problem

Error saat upload foto di modul Silent Inspection:
```
POST https://oxskmrkzxkvifbappsic.supabase.co/storage/v1/object/silent-inspection-photos/... 400 (Bad Request)
```

## 🔍 Root Cause

Bucket `silent-inspection-photos` tidak ada di Supabase Storage atau tidak dikonfigurasi dengan benar.

## 🛠️ Solution

### Step 1: Buat Storage Bucket

1. Buka **Supabase Dashboard**
2. Pergi ke **Storage** (menu kiri)
3. Klik **Create a new bucket**
4. Isi form:
   - **Name**: `silent-inspection-photos`
   - ✅ **Public bucket** (centang)
   - **File size limit**: 1MB (default)
5. Klik **Create bucket**

### Step 2: Setup Storage Policies

1. Di halaman Storage, klik bucket `silent-inspection-photos`
2. Pergi ke tab **Policies**
3. Klik **SQL Editor** atau copy-paste SQL berikut:

```sql
-- Drop existing policies if any
DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;

-- Policy 1: Allow authenticated users to INSERT (upload)
CREATE POLICY "silent-inspection-insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Policy 2: Allow public to SELECT (view/download)
CREATE POLICY "silent-inspection-select"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'silent-inspection-photos');

-- Policy 3: Allow authenticated users to UPDATE
CREATE POLICY "silent-inspection-update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'silent-inspection-photos')
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Policy 4: Allow authenticated users to DELETE
CREATE POLICY "silent-inspection-delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'silent-inspection-photos');
```

### Step 3: Test Setup

1. Jalankan aplikasi: `npm run dev`
2. Login ke aplikasi
3. Pergi ke menu **Silent Inspection**
4. Klik **Tambah Inspeksi**
5. Upload foto di section "Foto Kondisi Unsafe" atau "Foto Perilaku Unsafe"
6. Simpan data

## 📋 File yang Diperbaiki

### `src/services/api/silent-inspection.service.ts`
- ✅ **Enhanced error handling** untuk upload photo
- ✅ **Better logging** untuk debugging
- ✅ **Optional inspectionId parameter**
- ✅ **Graceful failure handling**

### `src/views/hsse/SilentInspectionView.vue`
- ✅ **Error handling** untuk upload photo kondisi unsafe
- ✅ **Error handling** untuk upload photo perilaku unsafe
- ✅ **User-friendly alerts** ketika upload gagal
- ✅ **Continue saving data** meskipun upload photo gagal

## 🔧 Scripts Utility

### `setup-silent-inspection-storage.js`
Script untuk setup storage secara otomatis (butuh service role key).

### `check-silent-inspection-storage.js`
Script untuk cek apakah storage sudah dikonfigurasi dengan benar.

## 📝 Cara Menjalankan Scripts

```bash
# Setup storage otomatis (butuh service role key)
node setup-silent-inspection-storage.js

# Check storage setup
node check-silent-inspection-storage.js
```

## 🚨 Jika Masih Error

### Error: "Bucket not found"
- Pastikan bucket `silent-inspection-photos` sudah dibuat
- Periksa nama bucket (case-sensitive)

### Error: "Permission denied"
- Pastikan storage policies sudah dijalankan
- Pastikan user sudah login (authenticated)

### Error: "File too large"
- File maksimal 1MB per foto
- Compress foto sebelum upload

## ✅ Expected Result

Setelah setup selesai:
- ✅ Upload foto berhasil tanpa error 400
- ✅ Foto tersimpan di Supabase Storage
- ✅ URL foto bisa diakses publik
- ✅ Data tersimpan meskipun upload foto gagal (graceful degradation)

## 📞 Support

Jika masih ada masalah, check:
1. Browser console untuk error detail
2. Supabase Dashboard > Storage untuk status bucket
3. Network tab untuk request/response detail

