# Setup Silent Inspection Module

## 1. Setup Database

### Langkah 1: Buat Tabel Silent Inspection
1. Buka Supabase Dashboard
2. Pergi ke **SQL Editor**
3. Buka file: `database/migrations/create-silent-inspection-table.sql`
4. Copy semua isi file dan paste ke SQL Editor
5. Klik **Run** untuk mengeksekusi

File ini akan membuat:
- Tabel `silent_inspection` dengan semua field
- 7 indexes untuk performa query
- Trigger untuk auto-update `updated_at`
- RLS policies untuk authenticated users
- 1 data sample untuk testing

### Langkah 2: Buat Storage Bucket
1. Di Supabase Dashboard, pergi ke **Storage**
2. Klik **Create a new bucket**
3. Nama bucket: `silent-inspection-photos`
4. Pilih **Public bucket** (centang)
5. Klik **Create bucket**

### Langkah 3: Setup Storage Policies
1. Masih di **Storage**, klik bucket `silent-inspection-photos`
2. Pergi ke tab **Policies**
3. Buka file: `database/migrations/create-silent-inspection-storage-policies.sql`
4. Copy semua isi file
5. Pergi ke **SQL Editor** di Supabase
6. Paste dan klik **Run**

Policies yang dibuat:
- **INSERT**: Authenticated users bisa upload
- **SELECT**: Public bisa view (untuk preview foto)
- **UPDATE**: Authenticated users bisa update
- **DELETE**: Authenticated users bisa delete

## 2. Verifikasi Setup

### Test Database
Jalankan query ini di SQL Editor:
```sql
SELECT * FROM silent_inspection ORDER BY created_at DESC LIMIT 5;
```
Anda harus melihat 1 baris data sample.

### Test Storage
1. Pergi ke Storage > silent-inspection-photos
2. Bucket harus sudah ada dan kosong
3. Coba upload gambar manual untuk test
4. Pastikan bisa delete juga

## 3. Akses Aplikasi

1. Pastikan aplikasi sudah running: `npm run dev`
2. Login ke aplikasi
3. Klik menu **Silent Inspection** di sidebar
4. Anda akan melihat halaman dengan 1 data sample

## 4. Test Fitur

### Test CRUD
1. ✅ Klik "Tambah Inspeksi"
2. ✅ Isi form (minimal field required)
3. ✅ Simpan
4. ✅ Edit data
5. ✅ Hapus data

### Test Upload Foto
1. ✅ Klik "Tambah Inspeksi"
2. ✅ Upload foto di section "Foto Kondisi Unsafe"
3. ✅ Upload foto di section "Foto Perilaku Unsafe"
4. ✅ Preview harus muncul
5. ✅ Test remove foto sebelum save
6. ✅ Simpan
7. ✅ Klik link "X foto" di tabel
8. ✅ Lightbox viewer harus muncul
9. ✅ Test navigasi: arrows, thumbnails, keyboard (←, →, ESC)

### Test Filter
1. ✅ Filter by Unit
2. ✅ Filter by Tingkat Risiko
3. ✅ Filter by Status
4. ✅ Filter by Bulan
5. ✅ Search by Area

## 5. Field-field Penting

### Required Fields (wajib diisi):
- Tanggal Inspeksi
- Unit
- Waktu Mulai

### Auto-calculated:
- `jumlah_temuan` = critical + major + minor (otomatis)

### Enum Values:
- **Kategori Bahaya**: fisik_mekanik, kimia, biologis, ergonomi, psikososial, kombinasi
- **Tingkat Risiko**: rendah, sedang, tinggi, sangat_tinggi
- **Kondisi Housekeeping**: baik, cukup, buruk
- **Penggunaan APD**: baik, cukup, buruk
- **Status Tindak Lanjut**: open, in_progress, closed
- **Status**: draft, submitted, verified, closed

## 6. File yang Dibuat

```
hsse-app/
├── database/migrations/
│   ├── create-silent-inspection-table.sql          # ✅ Buat tabel
│   └── create-silent-inspection-storage-policies.sql # ✅ Storage policies
├── src/
│   ├── services/api/
│   │   └── silent-inspection.service.ts            # ✅ API service
│   └── views/hsse/
│       └── SilentInspectionView.vue                # ✅ UI component
└── src/router/index.ts                              # ✅ Updated route
```

## 7. Troubleshooting

### Error: "relation silent_inspection does not exist"
- Pastikan SQL migration sudah dijalankan
- Check di Supabase: Table Editor > silent_inspection harus ada

### Error: "bucket silent-inspection-photos not found"
- Pastikan bucket sudah dibuat di Storage
- Check nama bucket harus exact: `silent-inspection-photos`

### Error: "new row violates row-level security policy"
- Pastikan RLS policies sudah dibuat
- Pastikan user sudah login (authenticated)

### Foto tidak bisa diupload
- Check storage policies sudah dieksekusi
- Check file size max 1MB
- Check format: jpg, jpeg, png, webp

### Foto tidak muncul di viewer
- Check URL foto di database (harus public URL)
- Check bucket setting: harus Public bucket
- Check SELECT policy di storage

## 8. Next Steps

Modul Silent Inspection sudah lengkap dengan:
- ✅ CRUD operations
- ✅ Photo upload (kondisi & perilaku unsafe)
- ✅ Photo viewer with lightbox
- ✅ Filters (unit, risk, status, month)
- ✅ Auto-calculate total temuan
- ✅ RLS security

Jika ada field yang kurang atau perlu ditambah, tinggal:
1. Update SQL migration
2. Update TypeScript interface di service
3. Update form di Vue component
