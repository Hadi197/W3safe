# Setup Storage Bucket untuk Safety Briefing Photos

## Langkah-langkah Setup di Supabase Dashboard:

### 1. Buat Storage Bucket

1. Login ke Supabase Dashboard: https://supabase.com/dashboard
2. Pilih project Anda
3. Klik **Storage** di menu kiri
4. Klik tombol **New bucket**
5. Isi form:
   - **Name**: `safety-briefing-photos`
   - **Public bucket**: ✅ Check (agar foto bisa diakses publik)
   - **File size limit**: 5MB (opsional)
   - **Allowed MIME types**: `image/jpeg,image/jpg,image/png,image/webp` (opsional)
6. Klik **Create bucket**

### 2. Setup Storage Policies (Opsional - untuk kontrol akses)

Jika ingin kontrol akses lebih detail, jalankan SQL berikut di SQL Editor:

```sql
-- Policy: Allow authenticated users to upload
CREATE POLICY "Allow authenticated users to upload safety briefing photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'safety-briefing-photos'
);

-- Policy: Allow public to read (karena bucket public)
CREATE POLICY "Allow public to read safety briefing photos"
ON storage.objects FOR SELECT
TO public
USING (
  bucket_id = 'safety-briefing-photos'
);

-- Policy: Allow authenticated users to delete their uploads
CREATE POLICY "Allow authenticated users to delete safety briefing photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'safety-briefing-photos'
);
```

### 3. Verifikasi Setup

Test upload foto melalui aplikasi:
1. Buka aplikasi HSSE
2. Masuk ke menu **Safety Briefing**
3. Klik **Tambah Safety Briefing**
4. Upload beberapa foto (single atau batch)
5. Simpan data
6. Cek di Supabase Dashboard > Storage > safety-briefing-photos

### 4. Setup Sudah Selesai!

Fitur yang sudah bisa digunakan:
- ✅ Upload foto single
- ✅ Upload foto batch (multiple files)
- ✅ Preview foto sebelum upload
- ✅ Hapus foto yang dipilih
- ✅ Edit: hapus foto lama, tambah foto baru
- ✅ Auto delete foto saat hapus data briefing
- ✅ Validasi ukuran file (max 5MB per file)

## Troubleshooting

### Error: "Bucket not found"
**Solusi**: Pastikan nama bucket di code sama dengan di dashboard: `safety-briefing-photos`

### Error: "Policy violation"
**Solusi**: Pastikan RLS policies sudah dibuat atau bucket di-set public

### Foto tidak bisa di-load
**Solusi**: 
1. Cek bucket di-set sebagai **Public**
2. Atau tambahkan policy untuk allow public read (lihat langkah 2)

### Upload gagal - file too large
**Solusi**: 
1. Set file size limit di bucket settings
2. Atau validasi ukuran di frontend (sudah ada: max 5MB)

## Struktur URL Foto

Format URL public foto yang ter-upload:
```
https://[PROJECT_ID].supabase.co/storage/v1/object/public/safety-briefing-photos/[BRIEFING_ID]_[TIMESTAMP]_[RANDOM].[EXT]
```

Contoh:
```
https://oxskmrkzxkvifbappsic.supabase.co/storage/v1/object/public/safety-briefing-photos/abc123_1732275600000_x7k9p2.jpg
```
