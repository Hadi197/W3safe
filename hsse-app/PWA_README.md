# PWA untuk Menu Unsafe Action/Condition

Progressive Web App (PWA) telah berhasil dibuat untuk menu Unsafe Action/Condition.

## Cara Mengakses

1. **Development**: Jalankan `npm run dev`
2. **Production**: `npm run build && npx vite preview --host`
3. **Akses PWA**: Buka `http://localhost:4173/pwa/unsafe-action-condition`

## 📱 Penggunaan di HP (Ponsel)

### Android (Chrome/Samsung Internet)
1. Buka browser dan akses URL PWA
2. Ketuk ikon "Install" atau "Add to Home Screen" yang muncul
3. Aplikasi akan ter-install seperti app native
4. Buka dari home screen seperti aplikasi biasa

### iOS (Safari)
1. Buka Safari dan akses URL PWA
2. Ketuk ikon "Share" (panah ke atas)
3. Pilih "Add to Home Screen"
4. Berikan nama dan ketuk "Add"
5. Aplikasi akan muncul di home screen

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

## 📱 Tips Penggunaan di HP:

1. **Install dulu**: Install sebagai PWA untuk pengalaman terbaik
2. **Izin kamera**: Izinkan akses kamera untuk upload foto
3. **Izin lokasi**: Izinkan akses lokasi untuk pelaporan akurat
4. **Offline**: Aplikasi bisa digunakan offline setelah load pertama
5. **Update**: Aplikasi akan update otomatis saat ada versi baru

PWA ini memberikan pengalaman seperti aplikasi native untuk pelaporan unsafe action/condition di perangkat mobile! 📱✨