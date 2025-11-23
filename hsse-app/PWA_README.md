# PWA untuk Menu Unsafe Action/Condition

Progressive Web App (PWA) telah berhasil dibuat untuk menu Unsafe Action/Condition.

## Cara Mengakses

1. **Development**: Jalankan `npm run dev`
2. **Production**: `npm run build && npx vite preview --host`
3. **Akses PWA**: Buka `http://localhost:4173/pwa/unsafe-action-condition`

## 📱 Penggunaan di HP (Ponsel)

### Android (Chrome/Samsung Internet)
1. **Buka browser** dan akses: `http://localhost:4173/pwa/unsafe-action-condition`
2. **Install prompt** akan muncul otomatis setelah beberapa kunjungan
3. **Atau klik tombol "Install App"** yang muncul di kanan bawah
4. **Aplikasi akan ter-install** seperti app native di home screen

### iOS (Safari)
1. **Buka Safari** dan akses URL PWA
2. **Ketuk ikon Share** (panah ke atas)
3. **Pilih "Add to Home Screen"**
4. **Beri nama** dan ketuk "Add"
5. **Aplikasi muncul** di home screen

### **Mengapa Tidak Selalu Otomatis Install?**

PWA install prompt **TIDAK SELALU** muncul otomatis karena:

#### **🔍 Kriteria Browser untuk Menampilkan Prompt:**
- ✅ **HTTPS** (wajib untuk production)
- ✅ **Service Worker** terdaftar
- ✅ **Web App Manifest** valid
- ✅ **User engagement** (beberapa kunjungan/interaksi)
- ✅ **Tidak sudah terinstall**

#### **📊 Kapan Prompt Muncul:**
- Setelah user berinteraksi dengan web (klik, scroll, dll)
- Minimal 30 detik engagement
- Tidak muncul di setiap kunjungan
- Browser memutuskan kapan menampilkan

#### **🎯 Solusi Manual:**
- **Tombol Install** sudah tersedia di kanan bawah
- **Browser menu**: "Add to Home Screen" / "Install App"
- **Address bar**: Icon install di Chrome

### Fitur Mobile
- **Touch-friendly**: Semua tombol dan form dioptimasi untuk sentuhan
- **Responsive**: Layout menyesuaikan dengan ukuran layar
- **Offline Support**: Bisa digunakan tanpa koneksi internet
- **Native Feel**: Berjalan seperti aplikasi asli tanpa browser UI
- **Camera Access**: Mendukung upload foto dari kamera HP
- **GPS**: Bisa mengakses lokasi untuk pelaporan

## 🔧 Browser Support

- **Chrome/Edge**: Install prompt otomatis
- **Firefox**: Manual install via address bar
- **Safari**: Add to Home Screen
- **Samsung Internet**: Install prompt otomatis

## 📋 File yang Dibuat/Dimodifikasi:

- `vite.config.ts` - Konfigurasi PWA
- `src/router/index.ts` - Route PWA standalone
- `src/views/PWAUnsafeActionConditionView.vue` - Wrapper component
- `public/pwa-192x192.svg` - Icon PWA
- `index.html` - Meta tags untuk mobile PWA

## 🚀 Build & Deploy:

Aplikasi telah di-build dan di-push ke GitHub. PWA assets akan ter-generate otomatis saat build.

### **⚠️ Production Requirements:**
- **HTTPS wajib** - PWA hanya bekerja di HTTPS (kecuali localhost)
- **Service Worker** harus terdaftar dengan benar
- **Web App Manifest** harus accessible
- **Domain valid** untuk install prompt

### **🌐 Deploy ke Production:**
```bash
# Build untuk production
npm run build

# Deploy dist/ folder ke hosting dengan HTTPS
# Contoh: Vercel, Netlify, Firebase Hosting, dll.
```

## 📱 Tips Penggunaan di HP:

1. **Install dulu**: Install sebagai PWA untuk pengalaman terbaik
2. **Izin kamera**: Izinkan akses kamera untuk upload foto
3. **Izin lokasi**: Izinkan akses lokasi untuk pelaporan akurat
4. **Offline**: Aplikasi bisa digunakan offline setelah load pertama
5. **Update**: Aplikasi akan update otomatis saat ada versi baru

PWA ini memberikan pengalaman seperti aplikasi native untuk pelaporan unsafe action/condition di perangkat mobile! 📱✨