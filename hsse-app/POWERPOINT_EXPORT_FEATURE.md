# Fitur Download PowerPoint - Monitoring Realisasi K3

## Overview
Fitur untuk mengunduh laporan monitoring realisasi program K3 dalam format PowerPoint (.pptx).

## Cara Menggunakan

1. **Buka halaman Monitoring Realisasi K3**
   - Navigasi ke menu "Monitoring Realisasi K3"

2. **Filter data (opsional)**
   - Pilih Unit (dropdown)
   - Pilih Tahun
   - Pilih Bulan

3. **Download PowerPoint**
   - Klik tombol "Download PPT" di header
   - File akan otomatis terunduh dengan nama:
     `Monitoring_K3_[Unit]_[Periode].pptx`

## Isi Presentasi

### Slide 1: Cover
- Judul: "MONITORING REALISASI PROGRAM K3"
- Unit/Area yang dipilih
- Periode monitoring
- Tanggal generate

### Slide 2: Ringkasan Statistik
Tabel berisi jumlah aktivitas per program:
- Safety Briefing
- Silent Inspection
- Safety Patrol
- Safety Forum
- Management Walkthrough
- Safety Induction
- Safety Drill
- Unsafe Action/Condition
- **TOTAL**

### Slide 3-6: Chart per Modul
Chart bar horizontal untuk Top 10 unit dengan aktivitas terbanyak:
- Safety Briefing per Unit
- Silent Inspection per Unit
- Safety Patrol per Unit
- Management Walkthrough per Unit

Setiap chart dilengkapi:
- Total aktivitas
- Rata-rata per unit

### Slide 7: Kesimpulan
Summary berisi:
- Total aktivitas K3
- Jumlah program
- Periode monitoring
- Unit yang dipantau

## Technical Details

### Library
- **pptxgenjs**: Library untuk generate file PowerPoint
- Install: `npm install pptxgenjs`

### Files
- **Service**: `/src/services/pptx-generator.service.ts`
- **View**: `/src/views/ProgramK3DashboardView.vue`

### File Structure
```
src/
├── services/
│   └── pptx-generator.service.ts          # Service untuk generate PPTX
└── views/
    └── ProgramK3DashboardView.vue         # Button & logic download
```

## Customization

### Mengubah Warna
Edit di `pptx-generator.service.ts`:
```typescript
// Background color
slide.background = { color: '1E3A8A' }  // Biru tua

// Chart colors
chartColors: ['2563EB', '3B82F6', '60A5FA', ...]  // Gradient biru
```

### Menambah Chart
Edit function `generateMonitoringK3Presentation()`:
```typescript
// Tambah chart baru ke chartData array
data.chartData.forEach((chart) => {
  this.addChartSlide(chart, data.periode)
})
```

### Mengubah Font
Edit setiap `addText()`:
```typescript
slide.addText('Title', {
  fontSize: 32,           // Ukuran font
  bold: true,            // Bold
  fontFace: 'Arial',     // Jenis font
  color: '1E3A8A'        // Warna (hex tanpa #)
})
```

## Browser Compatibility
✅ Chrome, Edge, Firefox, Safari
✅ Desktop & Mobile (download otomatis)

## Notes
- File size: ~100-200 KB (tergantung jumlah data)
- Generate time: 1-2 detik
- Format: PowerPoint 2007+ (.pptx)
- Compatible dengan: MS PowerPoint, Google Slides, LibreOffice Impress

## Future Enhancements
- [ ] Tambah chart pie untuk distribusi modul
- [ ] Export ke PDF
- [ ] Tambah logo perusahaan
- [ ] Custom template
- [ ] Watermark
- [ ] Export data ke Excel
