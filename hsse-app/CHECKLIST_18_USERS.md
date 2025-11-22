# ✅ Checklist Pembuatan 18 User Unit

**Password semua user**: `@w3Safe`

---

## 📋 Progress: 0/18 Users Created

### Area (3 users)
- [ ] **area-balinusra** → area-balinusra@w3safe.local → Area Bali Nusatenggara
- [ ] **area-jawa1** → area-jawa1@w3safe.local → Area Jawa 1
- [ ] **area-kalimantan3** → area-kalimantan3@w3safe.local → Area Kalimantan 3

### Unit (15 users)
- [ ] **unit-banjarmasin** → unit-banjarmasin@w3safe.local → Banjarmasin
- [ ] **unit-batulicin** → unit-batulicin@w3safe.local → Batulicin
- [ ] **unit-benoa** → unit-benoa@w3safe.local → Benoa
- [ ] **unit-bunati** → unit-bunati@w3safe.local → Bunati
- [ ] **unit-celukanbawang** → unit-celukanbawang@w3safe.local → Celukan Bawang
- [ ] **unit-gresik** → unit-gresik@w3safe.local → Gresik
- [ ] **unit-kotabaru** → unit-kotabaru@w3safe.local → Kotabaru
- [ ] **unit-kumai** → unit-kumai@w3safe.local → Kumai
- [ ] **unit-lembar** → unit-lembar@w3safe.local → Lembar
- [ ] **unit-mekarputih** → unit-mekarputih@w3safe.local → Mekar Putih
- [ ] **unit-sampit** → unit-sampit@w3safe.local → Sampit
- [ ] **unit-satui** → unit-satui@w3safe.local → Satui
- [ ] **unit-tanjungintan** → unit-tanjungintan@w3safe.local → Tanjung Intan
- [ ] **unit-tanjungperak** → unit-tanjungperak@w3safe.local → Tanjung Perak
- [ ] **unit-tenaukupang** → unit-tenaukupang@w3safe.local → Tenau Kupang

---

## 🚀 Langkah Pembuatan

### 1. Buka Supabase Dashboard
- URL: https://supabase.com/dashboard
- Login dengan akun admin
- Pilih project: **HSSE App**

### 2. Navigate ke Users
- Click sidebar: **Authentication**
- Click tab: **Users**

### 3. Untuk SETIAP user diatas:

**a. Click tombol "Add user"** (pojok kanan atas)

**b. Isi form:**
```
Email: [dari list diatas]
Password: @w3Safe
Auto Confirm User: ✅ (CENTANG)
```

**c. Click "Create user"**

**d. (Optional) Tambah User Metadata:**
- Click user yang baru dibuat
- Scroll ke "User Metadata"
- Click "Edit"
- Masukkan:
```json
{
  "username": "area-balinusra",
  "nama": "Area Bali Nusatenggara",
  "role": "unit_user"
}
```
- Click "Save"

**e. Centang checkbox** pada checklist diatas

---

## ✅ Testing

Setelah semua user dibuat, test login:

### Test User 1:
```
Email: unit-gresik@w3safe.local
Password: @w3Safe
```

### Test User 2:
```
Email: area-balinusra@w3safe.local
Password: @w3Safe
```

**Expected Result**: ✅ Berhasil login dan redirect ke dashboard

---

## 📊 Verification

### Check di Dashboard:
1. Authentication > Users
2. Search: `@w3safe.local`
3. Should show: **18 users**

### Check di SQL Editor:
```sql
-- Jika ada akses ke auth schema
SELECT 
  email,
  created_at,
  raw_user_meta_data->>'username' as username,
  raw_user_meta_data->>'nama' as nama
FROM auth.users
WHERE email LIKE '%@w3safe.local'
ORDER BY email;
```

---

## 🔒 Security Next Steps

- [ ] Setup Row Level Security (RLS) policies
- [ ] Restrict data access per unit
- [ ] Implement "Change Password" feature
- [ ] Force password change on first login
- [ ] Setup session timeout
- [ ] Add activity logging

---

## 📁 File Referensi

| File | Purpose |
|------|---------|
| `data/users-to-create.csv` | CSV format untuk import |
| `scripts/batch-create-18-users.js` | Display script |
| `docs/PANDUAN_BUAT_USER_UNIT.md` | Full documentation |

---

## 🆘 Troubleshooting

### Error: "Email already in use"
- User sudah dibuat sebelumnya
- Skip dan lanjut ke user berikutnya

### Error: "Invalid email format"
- Pastikan email format: `username@w3safe.local`
- Tidak ada spasi atau typo

### Error: "Password too weak"
- Pastikan password: `@w3Safe` (case-sensitive)
- Harus persis sama dengan yang tertulis

---

**Created**: November 22, 2025  
**Status**: Not Started  
**Last Updated**: -
