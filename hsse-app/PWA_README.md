# PWA untuk Menu Unsafe Action/Condition

Progressive Web App (PWA) telah berhasil dibuat untuk menu Unsafe Action/Condition.

## Cara Mengakses

1. Jalankan aplikasi dengan `npm run dev` atau `npm run build && npx vite preview --host`
2. Buka browser dan akses: `http://localhost:4173/pwa/unsafe-action-condition`
3. Aplikasi akan terdeteksi sebagai PWA dan bisa di-install

## Fitur PWA

- **Installable**: Bisa di-install sebagai aplikasi native
- **Offline Support**: Service worker menyediakan caching
- **Standalone Mode**: Berjalan tanpa browser UI
- **Fast Loading**: Pre-cached assets

## Browser Support

- Chrome/Edge: Install prompt otomatis
- Firefox: Manual install via address bar
- Safari: Add to Home Screen

## Development

Untuk development PWA:
```bash
npm run dev  # Development server
npm run build  # Build untuk production
npm run preview  # Preview production build
```

PWA assets akan di-generate otomatis saat build.