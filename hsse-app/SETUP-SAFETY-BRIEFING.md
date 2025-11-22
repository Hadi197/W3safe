# 🚀 Setup Safety Briefing Module

## ✅ Yang Sudah Dibuat:

1. **Frontend Components**
   - ✅ SafetyBriefingView.vue - Full CRUD interface
   - ✅ Form dengan validasi lengkap
   - ✅ Upload foto single & batch
   - ✅ Preview foto sebelum upload
   - ✅ Tabel dengan filter & search
   - ✅ Status management (draft/approved/rejected)

2. **Backend Service**
   - ✅ safety-briefing.service.ts - Complete API service
   - ✅ Methods: getAll, getById, getByUnit, create, update, delete
   - ✅ Photo upload (single & batch)
   - ✅ Photo deletion
   - ✅ Statistics

3. **Router**
   - ✅ Route `/safety-briefing` sudah ditambahkan
   - ✅ Menu sidebar sudah ada

4. **SQL Migration**
   - ✅ create-safety-briefing-table.sql
   - ✅ Includes: table, indexes, triggers, RLS policies, sample data

## 📋 Yang Perlu Dilakukan (Manual Setup):

### Step 1: Buat Tabel Database

1. **Buka Supabase Dashboard**: https://supabase.com/dashboard
2. **Pilih project Anda** (oxskmrkzxkvifbappsic)
3. **Klik SQL Editor** di menu kiri
4. **Klik "New query"**
5. **Copy-paste isi file**: `create-safety-briefing-table.sql`
6. **Klik "Run"**
7. **Verifikasi**: Cek di Table Editor, tabel `safety_briefing` sudah ada

### Step 2: Buat Storage Bucket untuk Foto

1. **Klik Storage** di menu kiri
2. **Klik "New bucket"**
3. **Isi form**:
   - Name: `safety-briefing-photos`
   - Public bucket: ✅ **Check this** (penting!)
   - File size limit: `5` MB
   - Allowed MIME types: `image/jpeg,image/jpg,image/png,image/webp`
4. **Klik "Create bucket"**

### Step 3: Test Aplikasi

1. **Buka aplikasi**: http://localhost:5174
2. **Login** dengan akun Anda
3. **Klik menu "Safety Briefing"**
4. **Klik "Tambah Safety Briefing"**
5. **Isi form**:
   - Tanggal: Pilih tanggal hari ini
   - Unit: Pilih unit
   - Waktu Mulai: Contoh 08:00
   - Topik: "Test Safety Briefing"
   - Upload 1-3 foto
6. **Klik "Simpan"**
7. **Verifikasi**: Data muncul di tabel

## 🎯 Fitur Yang Tersedia:

### ✅ Upload Foto
- **Single upload**: Pilih 1 foto
- **Batch upload**: Pilih multiple foto sekaligus (Ctrl/Cmd + klik)
- **Preview**: Lihat preview sebelum upload
- **Remove**: Hapus foto yang tidak jadi di-upload
- **Validasi**: Max 5MB per file
- **Format**: JPG, PNG, WebP

### ✅ CRUD Operations
- **Create**: Tambah briefing baru
- **Read**: List dengan filter & search
- **Update**: Edit briefing (termasuk foto)
- **Delete**: Hapus briefing + foto otomatis terhapus

### ✅ Filter & Search
- Search by topik
- Filter by unit
- Filter by status (draft/approved/rejected)
- Filter by bulan

### ✅ Status Management
- **Draft**: Belum disetujui
- **Approved**: Sudah disetujui
- **Rejected**: Ditolak

## 📸 Screenshot Fitur Upload Foto:

Form upload memiliki:
- Button "Pilih Foto (Single/Batch)"
- Grid preview 2x4 untuk foto yang dipilih
- Button hapus (❌) di setiap foto (hover to show)
- Nama file di bawah setiap preview
- Section terpisah untuk "Foto yang sudah ada" (saat edit)

## 🐛 Troubleshooting:

### Database connection timeout saat migration
**Solusi**: Run migration manual di Supabase Dashboard > SQL Editor

### Bucket not found
**Solusi**: Cek nama bucket di dashboard harus: `safety-briefing-photos`

### Upload foto gagal
**Solusi**: 
1. Pastikan bucket sudah di-set **Public**
2. Pastikan ukuran file < 5MB
3. Pastikan format file: JPG/PNG/WebP

### Data tidak muncul
**Solusi**: 
1. Cek RLS policies sudah dibuat (dari SQL migration)
2. Pastikan sudah login sebagai authenticated user
3. Check browser console untuk error

## 🎉 Next Steps:

Setelah Safety Briefing selesai, modul HSSE lain yang bisa dibuat:
1. ⬜ Silent Inspection (inspeksi rutin dengan checklist)
2. ⬜ Safety Forum (forum diskusi K3)
3. ⬜ Management Walkthrough (kunjungan manajemen)
4. ⬜ Safety Patrol (patroli keamanan)
5. ⬜ Safety Induction (induksi keselamatan)
6. ⬜ Safety Drill (simulasi darurat)

Semua modul akan menggunakan pattern yang sama dengan Safety Briefing! 🚀
