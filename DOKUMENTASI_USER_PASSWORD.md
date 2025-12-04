# Dokumentasi Manajemen User & Password

## 📋 Daftar Isi
1. [Daftar User yang Sudah Dibuat](#daftar-user-yang-sudah-dibuat)
2. [Informasi Login](#informasi-login)
3. [Cara Login](#cara-login)
4. [Cara Mengganti Password](#cara-mengganti-password)
5. [Troubleshooting](#troubleshooting)
6. [Untuk Administrator](#untuk-administrator)

---

## 👥 Daftar User yang Sudah Dibuat

Total: **20 users** telah berhasil dibuat pada tanggal **4 Desember 2025**

### Area Users (3)
| No | Unit Kode | Nama Unit | Email |
|----|-----------|-----------|-------|
| 1 | AREA-BALINUSRA | Area Bali Nusatenggara | area-balinusra@w3safe.local |
| 2 | AREA-JAWA1 | Area Jawa 1 | area-jawa1@w3safe.local |
| 3 | AREA-KALIMANTAN3 | Area Kalimantan 3 | area-kalimantan3@w3safe.local |

### Unit Users (16)
| No | Unit Kode | Nama Unit | Email |
|----|-----------|-----------|-------|
| 4 | UNIT-BANJARMASIN | Banjarmasin | unit-banjarmasin@w3safe.local |
| 5 | UNIT-BATULICIN | Batulicin | unit-batulicin@w3safe.local |
| 6 | UNIT-BENOA | Benoa | unit-benoa@w3safe.local |
| 7 | UNIT-CELUKANBAWANG | Celukan Bawang | unit-celukanbawang@w3safe.local |
| 8 | UNIT-GRESIK | Gresik | unit-gresik@w3safe.local |
| 9 | UNIT-KOTABARU | Kotabaru | unit-kotabaru@w3safe.local |
| 10 | UNIT-KUMAI | Kumai | unit-kumai@w3safe.local |
| 11 | UNIT-LEMBAR | Lembar | unit-lembar@w3safe.local |
| 12 | UNIT-MEKARPUTIH | Mekar Putih | unit-mekarputih@w3safe.local |
| 13 | UNIT-SAMPIT | Sampit | unit-sampit@w3safe.local |
| 14 | UNIT-SATUI-BUNATI | Satui/Bunati | unit-satui-bunati@w3safe.local |
| 15 | UNIT-TANJUNGEMAS | Tanjung Emas | unit-tanjungemas@w3safe.local |
| 16 | UNIT-TANJUNGINTAN | Tanjung Intan | unit-tanjungintan@w3safe.local |
| 17 | UNIT-TANJUNGPERAK | Tanjung Perak | unit-tanjungperak@w3safe.local |
| 18 | UNIT-TANJUNGWANGI | Tanjung Wangi | unit-tanjungwangi@w3safe.local |
| 19 | UNIT-TENAUKUPANG | Tenau Kupang | unit-tenaukupang@w3safe.local |

### Wilayah Users (1)
| No | Unit Kode | Nama Unit | Email |
|----|-----------|-----------|-------|
| 20 | WILAYAH-3 | Wilayah 3 | wilayah-3@w3safe.local |

---

## 🔐 Informasi Login

### Password Default
Semua user dibuat dengan password default yang **sama**:

```
password123
```

> ⚠️ **PENTING**: Setiap user **HARUS** mengganti password setelah login pertama kali untuk keamanan!

### Format Email
Email format: `[kode-unit-huruf-kecil]@w3safe.local`

Contoh:
- Unit: AREA-BALINUSRA → Email: `area-balinusra@w3safe.local`
- Unit: UNIT-GRESIK → Email: `unit-gresik@w3safe.local`

---

## 🚀 Cara Login

### Web Application
1. Buka browser dan akses: `https://your-app-url.com`
2. Masukkan **Email** sesuai daftar di atas
3. Masukkan **Password**: `password123`
4. Klik tombol **"Login"**
5. Setelah berhasil login, **SEGERA GANTI PASSWORD**

### Mobile Application (Flutter)
1. Buka aplikasi W3safe di smartphone
2. Pada halaman login, masukkan:
   - **Email**: sesuai daftar di atas
   - **Password**: `password123`
3. Tap tombol **"Login"**
4. Setelah berhasil login, **SEGERA GANTI PASSWORD**

---

## 🔄 Cara Mengganti Password

### Via Web
1. Login ke aplikasi web
2. Klik **nama user** di pojok kanan atas
3. Pilih menu **"Ganti Password"**
4. Isi form:
   - **Password Saat Ini**: `password123`
   - **Password Baru**: [password baru Anda, min. 6 karakter]
   - **Konfirmasi Password Baru**: [ulangi password baru]
5. Klik tombol **"Ganti Password"**
6. Password berhasil diganti! ✅

### Via Mobile (Coming Soon)
Fitur ganti password di mobile sedang dalam pengembangan.
Sementara gunakan web untuk mengganti password.

---

## ❗ Troubleshooting

### Tidak Bisa Login
**Problem**: Email atau password salah
**Solution**: 
- Pastikan email ditulis dengan **huruf kecil semua**
- Pastikan tidak ada spasi di awal atau akhir email/password
- Password default adalah `password123` (tanpa spasi)

### Lupa Password (Setelah Diganti)
**Problem**: Lupa password yang sudah diganti
**Solution**: 
- Hubungi administrator untuk reset password
- Administrator dapat reset via Supabase Dashboard

### Email Tidak Ditemukan
**Problem**: System bilang "User tidak ditemukan"
**Solution**: 
- Cek kembali email, pastikan sesuai dengan daftar di dokumentasi ini
- Pastikan format email benar: `[kode-unit]@w3safe.local`

### Password Tidak Bisa Diganti
**Problem**: Error saat ganti password
**Solution**: 
- Pastikan password baru minimal 6 karakter
- Pastikan "Password Baru" dan "Konfirmasi Password Baru" sama persis
- Pastikan "Password Saat Ini" benar

---

## 👨‍💼 Untuk Administrator

### Membuat User Baru
Gunakan script SQL: `auto-create-users-from-units.sql`

```sql
-- Jalankan function untuk membuat user baru
SELECT * FROM auto_create_unit_users();
```

### Reset Password User
Via Supabase Dashboard:
1. Buka Supabase Dashboard
2. Pergi ke: **Authentication > Users**
3. Cari user yang ingin di-reset
4. Klik **"..."** (titik tiga) di sebelah kanan user
5. Pilih **"Reset Password"**
6. User akan menerima email reset password

Atau via SQL:
```sql
-- Update password user tertentu
-- (Memerlukan akses ke auth.users)
UPDATE auth.users
SET encrypted_password = crypt('password_baru_123', gen_salt('bf'))
WHERE email = 'unit-gresik@w3safe.local';
```

### Melihat Daftar User
```sql
-- Query untuk melihat semua user
SELECT 
  email,
  created_at,
  email_confirmed_at,
  raw_user_meta_data->>'username' as username,
  raw_user_meta_data->>'unit_kode' as unit_kode,
  raw_user_meta_data->>'unit_nama' as unit_nama,
  raw_user_meta_data->>'role' as role,
  CASE 
    WHEN email_confirmed_at IS NOT NULL THEN '✅ Confirmed'
    ELSE '❌ Not Confirmed'
  END as status
FROM auth.users
WHERE email LIKE '%@w3safe.local'
ORDER BY email;
```

### Menghapus User
```sql
-- HATI-HATI! Ini akan menghapus user secara permanen
DELETE FROM auth.users 
WHERE email = 'unit-gresik@w3safe.local';

-- Atau hapus semua user unit
-- DELETE FROM auth.users WHERE email LIKE '%@w3safe.local';
```

### Menonaktifkan User
```sql
-- Set banned_until untuk menonaktifkan user
UPDATE auth.users
SET banned_until = '2099-12-31 23:59:59'
WHERE email = 'unit-gresik@w3safe.local';

-- Aktifkan kembali
UPDATE auth.users
SET banned_until = NULL
WHERE email = 'unit-gresik@w3safe.local';
```

---

## 📊 Statistik User

- **Total Users**: 20
- **Area Users**: 3
- **Unit Users**: 16
- **Wilayah Users**: 1
- **Password Default**: password123
- **Status**: Semua user confirmed ✅
- **Created Date**: 4 Desember 2025

---

## 🔒 Kebijakan Password

### Password Requirements
- Minimal **6 karakter**
- Disarankan kombinasi huruf besar, kecil, angka, dan simbol
- Tidak boleh sama dengan password lama
- Tidak boleh terlalu mudah ditebak (contoh: 123456, password, nama unit)

### Password Best Practices
- ✅ Gunakan password yang berbeda untuk setiap akun
- ✅ Ganti password secara berkala (minimal 3 bulan sekali)
- ✅ Jangan share password ke orang lain
- ✅ Jangan simpan password di tempat yang mudah diakses
- ❌ Jangan gunakan password yang sama dengan akun lain
- ❌ Jangan catat password di sticky notes atau kertas
- ❌ Jangan share screenshot login ke group chat

---

## 📞 Kontak Support

Jika ada masalah terkait login atau password, hubungi:
- **IT Support**: [contact info]
- **Email**: [support email]
- **Phone**: [phone number]

---

## 📝 Change Log

### 4 Desember 2025
- ✅ 20 user berhasil dibuat
- ✅ Semua user confirmed
- ✅ Password default: password123
- ✅ Fitur ganti password tersedia di web

---

**Dokumen ini terakhir diupdate: 4 Desember 2025**
