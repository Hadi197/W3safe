# Perbaikan Tampilan Foto di Management Walkthrough

## 🎯 Masalah
Foto yang diupload di tab **Temuan** di modul **Management Walkthrough** tidak bisa ditampilkan/dilihat dengan baik. User hanya bisa klik foto dan membuka di tab baru.

## ✅ Solusi yang Diimplementasikan

### 1. Photo Viewer Modal
Menambahkan modal photo viewer yang interaktif dengan fitur:
- **Full screen display** - Foto ditampilkan di modal fullscreen dengan background hitam
- **Navigasi Previous/Next** - Button untuk navigasi antar foto
- **Thumbnail strip** - Preview semua foto di bagian bawah
- **Photo counter** - Menampilkan posisi foto saat ini (contoh: 2 / 5)
- **Keyboard navigation**:
  - `←` (Arrow Left) - Foto sebelumnya
  - `→` (Arrow Right) - Foto selanjutnya  
  - `Esc` - Tutup modal
- **Click thumbnail** - Langsung jump ke foto tertentu

### 2. Perubahan File
File yang dimodifikasi: `/hsse-app/src/views/ManagementWalkthroughView.vue`

#### a. Template Changes
Menambahkan Photo Viewer Modal di akhir template (sebelum `</template>`):
```vue
<!-- Photo Viewer Modal -->
<div v-if="showPhotoModal" class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-90">
  <!-- Close Button -->
  <!-- Previous/Next Buttons -->
  <!-- Photo Display with Counter -->
  <!-- Thumbnail Strip -->
</div>
```

#### b. State Variables
Menambahkan reactive state untuk photo modal:
```typescript
const showPhotoModal = ref(false)
const currentPhotos = ref<string[]>([])
const currentPhotoIndex = ref(0)
```

#### c. Functions
Mengubah dan menambahkan fungsi-fungsi:

**openPhotoViewer** - Membuka modal dengan foto yang dipilih:
```typescript
const openPhotoViewer = (photos: string[], startIndex: number) => {
  currentPhotos.value = photos
  currentPhotoIndex.value = startIndex
  showPhotoModal.value = true
}
```

**Navigation functions**:
```typescript
const nextPhoto = () => { /* Navigate to next photo */ }
const prevPhoto = () => { /* Navigate to previous photo */ }
const closePhotoModal = () => { /* Close modal and reset */ }
```

**Keyboard handler**:
```typescript
const handleKeyPress = (event: KeyboardEvent) => {
  if (!showPhotoModal.value) return
  
  if (event.key === 'ArrowLeft') prevPhoto()
  else if (event.key === 'ArrowRight') nextPhoto()
  else if (event.key === 'Escape') closePhotoModal()
}
```

#### d. Lifecycle Hooks
- **onMounted**: Menambahkan event listener untuk keyboard
- **onUnmounted**: Cleanup event listener

### 3. Cara Kerja

#### Flow Melihat Foto:
1. User upload foto di tab **Temuan** saat create/edit walkthrough
2. Foto disimpan di Supabase Storage bucket `safety-forum-photos/walkthrough/`
3. URL foto disimpan di array `foto_urls` dalam object temuan
4. Di tab **Detail** modal, foto ditampilkan sebagai thumbnail grid
5. User klik thumbnail → `openPhotoViewer(temuan.foto_urls, photoIdx)` dipanggil
6. Modal photo viewer terbuka dengan foto yang dipilih
7. User bisa navigasi dengan:
   - Klik button Previous/Next
   - Keyboard arrow keys
   - Klik thumbnail untuk jump ke foto tertentu
8. Klik X atau tekan Esc untuk tutup modal

## 📸 Fitur Photo Viewer

### UI Elements:
- ✅ **Close button (X)** di kanan atas
- ✅ **Previous button** di kiri (hanya muncul jika bukan foto pertama)
- ✅ **Next button** di kanan (hanya muncul jika bukan foto terakhir)
- ✅ **Photo counter** di tengah bawah foto
- ✅ **Thumbnail strip** di bagian bawah (jika ada >1 foto)
- ✅ **Hover effect** pada thumbnail - opacity berubah
- ✅ **Active indicator** - thumbnail yang sedang dilihat diberi border putih

### Responsive Design:
- Max height foto: 85vh (viewport height)
- Max width: 6xl (Tailwind)
- Object-fit: contain (foto tidak terpotong)
- Thumbnail grid: overflow-x-auto (bisa scroll horizontal)

## 🧪 Testing

### Test Cases:
1. ✅ Upload 1 foto → Klik → Modal terbuka, no navigation buttons
2. ✅ Upload multiple foto → Klik → Navigasi berfungsi
3. ✅ Keyboard navigation → Arrow keys berfungsi
4. ✅ ESC key → Modal tertutup
5. ✅ Klik thumbnail → Jump ke foto yang diklik
6. ✅ Klik close button → Modal tertutup
7. ✅ Photo counter → Menampilkan posisi dengan benar

## 📌 Catatan Penting

### Konsistensi dengan Modul Lain:
Photo viewer ini menggunakan pattern yang sama dengan:
- `SafetyBriefingView.vue` 
- `SilentInspectionView.vue`

Ini memastikan UX yang konsisten di seluruh aplikasi HSSE.

### Storage Path:
Foto temuan walkthrough disimpan di:
```
Bucket: safety-forum-photos
Path: walkthrough/{walkthroughId}/{timestamp}.{ext}
```

### Database Schema:
```typescript
interface Temuan {
  no: number
  kategori: string
  deskripsi: string
  lokasi: string
  tingkat_risiko: string
  status: string
  foto_urls: string[]  // Array URL foto
  uploading?: boolean
}
```

## ✨ Peningkatan UX

### Sebelum:
- Klik foto → Buka di tab baru
- Tidak bisa navigasi antar foto
- Harus tutup tab, buka foto lain

### Sesudah:
- Klik foto → Modal viewer
- Smooth navigation
- Keyboard support
- Thumbnail preview
- Photo counter
- Better user experience

## 🚀 Status
✅ **COMPLETED** - Photo viewer sudah berfungsi dengan baik di Management Walkthrough module.
