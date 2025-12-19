# Fix Foto Temuan Tidak Muncul di PDF Management Walkthrough

## 🎯 Masalah
Foto inputan temuan di Management Walkthrough tidak muncul di mode PDF (MW-2025-12-002 dan lainnya).

## 🔍 Root Cause
PDF generator (`managementWalkthroughPdfGenerator.ts`) hanya mengambil foto dari field `foto_walkthrough`, tetapi **foto temuan disimpan di dalam array `temuan_bahaya` dengan property `foto_urls`** pada setiap object temuan.

## ✅ Solusi yang Diimplementasikan

### 1. Tambah Section Baru: Dokumentasi Foto Temuan
File: `/hsse-app/src/utils/managementWalkthroughPdfGenerator.ts`

#### Perubahan:
Menambahkan section **"DOKUMENTASI FOTO TEMUAN"** setelah section detail temuan (Section VI) dan sebelum Action Items (Section VII).

#### Fitur:
- ✅ Loop semua temuan yang memiliki foto (`foto_urls`)
- ✅ Tampilkan info temuan: deskripsi, lokasi, tingkat risiko
- ✅ Load dan tampilkan setiap foto dari `foto_urls` array
- ✅ Support format JPEG dan PNG
- ✅ Auto resize foto dengan max width 180px dan max height 120px
- ✅ Center alignment untuk foto
- ✅ Auto page break jika space tidak cukup
- ✅ Error handling jika foto gagal load

#### Code Logic:
```typescript
// Section 6B: Foto Temuan
if (walkthrough.temuan_bahaya && Array.isArray(walkthrough.temuan_bahaya)) {
  // Filter hanya temuan yang punya foto
  const temuanWithPhotos = walkthrough.temuan_bahaya.filter((t: any) => 
    t.foto_urls && Array.isArray(t.foto_urls) && t.foto_urls.length > 0
  )

  if (temuanWithPhotos.length > 0) {
    // Loop setiap temuan dengan foto
    for (let temuanIdx = 0; temuanIdx < temuanWithPhotos.length; temuanIdx++) {
      const temuan = temuanWithPhotos[temuanIdx]
      const temuanNo = walkthrough.temuan_bahaya.indexOf(temuan) + 1
      
      // Display temuan info
      doc.text(`Temuan #${temuanNo}: ${temuan.deskripsi}`)
      doc.text(`Lokasi: ${temuan.lokasi}`)
      doc.text(`Tingkat Risiko: ${formatTingkatRisiko(temuan.tingkat_risiko)}`)
      
      // Load dan display setiap foto
      for (let i = 0; i < temuan.foto_urls.length; i++) {
        const photoUrl = temuan.foto_urls[i]
        const img = await loadImageForPDF(photoUrl)
        
        // Auto detect format (PNG or JPEG)
        const imageFormat = photoUrl.toLowerCase().includes('.png') ? 'PNG' : 'JPEG'
        doc.addImage(photoUrl, imageFormat, xOffset, yPos, finalWidth, finalHeight)
      }
    }
  }
}
```

### 2. Update Image Format Detection
Tambahkan support untuk format PNG di foto walkthrough dan foto temuan:

```typescript
// Before (hard-coded JPEG)
doc.addImage(photoUrl, 'JPEG', xOffset, yPos, finalWidth, finalHeight)

// After (auto detect)
const imageFormat = photoUrl.toLowerCase().includes('.png') ? 'PNG' : 'JPEG'
doc.addImage(photoUrl, imageFormat, xOffset, yPos, finalWidth, finalHeight)
```

### 3. Update Section VIII Title
Ubah title section VIII dari "DOKUMENTASI FOTO" menjadi "DOKUMENTASI FOTO WALKTHROUGH" untuk membedakan dengan foto temuan.

## 📊 Struktur Data

### Management Walkthrough Object:
```typescript
{
  id: "uuid",
  nomor_walkthrough: "MW-2025-12-002",
  tanggal_walkthrough: "2025-12-19",
  
  // Foto walkthrough umum
  foto_walkthrough: ["url1", "url2"],
  
  // Array temuan dengan foto
  temuan_bahaya: [
    {
      kategori: "unsafe_condition",
      deskripsi: "Lantai licin",
      lokasi: "Area produksi",
      tingkat_risiko: "tinggi",
      foto_urls: ["url1", "url2", "url3"]  // ← Ini yang sekarang ditampilkan
    },
    {
      kategori: "unsafe_act",
      deskripsi: "Tidak pakai APD",
      lokasi: "Gudang",
      tingkat_risiko: "kritis",
      foto_urls: ["url4", "url5"]
    }
  ]
}
```

## 🎨 PDF Output Structure

Sekarang PDF akan memiliki struktur:

1. **I. INFORMASI UMUM**
2. **II. TIM INSPEKSI**
3. **III. OBSERVASI KONDISI AREA**
4. **IV. OBSERVASI APD**
5. **V. OBSERVASI PERILAKU KERJA**
6. **VI. TEMUAN DAN OBSERVASI** (tabel temuan)
7. **DOKUMENTASI FOTO TEMUAN** ⬅️ **BARU!**
   - Temuan #1: [deskripsi]
     - Lokasi: [lokasi]
     - Tingkat Risiko: [risiko]
     - Foto 1 dari 3
     - [foto tampil]
     - Foto 2 dari 3
     - [foto tampil]
   - Temuan #2: [deskripsi]
     - ...
8. **VII. RENCANA TINDAK LANJUT**
9. **VIII. DOKUMENTASI FOTO WALKTHROUGH**
10. **IX. PENILAIAN DAN SCORING**
11. **X. RINGKASAN OBSERVASI**
12. **XI. REKOMENDASI**

## 🔧 Testing
Untuk test perubahan ini:

1. Buka Management Walkthrough dengan nomor: **MW-2025-12-002**
2. Pastikan ada temuan dengan foto di tab Temuan
3. Click button **Export PDF**
4. Verify foto temuan muncul di PDF dengan info yang benar

## ✨ Benefits

### Before:
❌ Foto temuan tidak muncul di PDF sama sekali
❌ User bingung kenapa foto yang diupload tidak ada di report

### After:
✅ Semua foto temuan muncul di PDF dengan info lengkap
✅ Foto dikelompokkan per temuan
✅ Info konteks (deskripsi, lokasi, risiko) ditampilkan
✅ Format foto auto detect (JPEG/PNG)
✅ Professional layout dengan proper spacing

## 📝 Notes

- Foto temuan akan ditampilkan **setelah** tabel detail temuan
- Foto walkthrough umum tetap ada di section tersendiri (Section VIII)
- Setiap foto di-resize otomatis agar tidak terlalu besar
- Maximum width: 180px, maximum height: 120px
- Foto di-center di halaman
- Auto page break untuk menghindari foto terpotong
- Error handling untuk foto yang gagal load

## 🚀 Next Steps (Optional Enhancement)

1. **Foto before-after**: Tambah indicator jika foto adalah "sebelum" atau "setelah" perbaikan
2. **Photo grid**: Display beberapa foto kecil dalam 1 row untuk hemat space
3. **Photo caption**: Tambah input caption untuk setiap foto
4. **Compress image**: Compress image sebelum insert ke PDF untuk reduce file size
5. **Watermark**: Tambah watermark "CONFIDENTIAL" atau logo perusahaan pada foto

## 📅 Change Log
- **2025-12-19**: Initial fix - Tambah section Dokumentasi Foto Temuan di PDF generator
