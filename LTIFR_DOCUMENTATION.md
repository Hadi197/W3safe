# Dokumentasi Laporan LTIFR (Lost Time Injury Frequency Rate)

## Definisi
LTIFR adalah indikator keselamatan kerja yang mengukur frekuensi kecelakaan kerja yang menyebabkan hilangnya waktu kerja per 1 juta jam kerja.

## Formula
```
LTIFR = (Jumlah LTI × 1.000.000) / Total Jam Kerja
```

## Field-field yang Dibutuhkan

### 1. Data Periode dan Lokasi
- **Periode Bulan** (periode_bulan) - Format: YYYY-MM
  - Contoh: 2025-01 untuk Januari 2025
  - Mandatory field
  
- **Unit** (unit_id) - Optional
  - Referensi ke tabel units
  - Jika kosong berarti data untuk semua unit

### 2. Data Kecelakaan
- **Jumlah LTI** (jumlah_lti) - Mandatory
  - Lost Time Injury: Kecelakaan yang menyebabkan pekerja tidak dapat bekerja minimal 1 hari kerja
  - Contoh: Tangan terjepit, tersandung material, terluka saat operasi mesin
  - Integer, minimal 0
  
- **Jumlah Fatality** (jumlah_fatality) - Optional
  - Kecelakaan fatal yang menyebabkan kematian
  - Integer, minimal 0
  
- **Jumlah Near Miss** (jumlah_near_miss) - Optional
  - Kejadian nyaris celaka yang tidak menyebabkan cedera
  - Berguna untuk analisis pencegahan
  - Integer, minimal 0

### 3. Data Jam Kerja
- **Jumlah Pekerja** (jumlah_pekerja) - Mandatory
  - Total jumlah pekerja aktif dalam periode tersebut
  - Integer, minimal 0
  
- **Hari Kerja** (hari_kerja) - Mandatory
  - Jumlah hari kerja efektif dalam periode (biasanya 20-26 hari per bulan)
  - Integer, minimal 0
  
- **Jam Kerja per Hari** (jam_kerja_per_hari) - Mandatory
  - Durasi jam kerja per hari (biasanya 8 jam)
  - Numeric(5,2), default 8.00
  - Bisa 7.5, 8, atau 12 untuk shift khusus
  
- **Total Jam Kerja** (total_jam_kerja) - Auto calculated
  - Formula: jumlah_pekerja × hari_kerja × jam_kerja_per_hari
  - Contoh: 150 pekerja × 22 hari × 8 jam = 26.400 jam

### 4. Hasil Perhitungan
- **LTIFR** (ltifr) - Auto calculated
  - Formula: (jumlah_lti × 1.000.000) / total_jam_kerja
  - Numeric(10,2)
  - Semakin kecil nilai LTIFR, semakin baik performa keselamatan kerja

### 5. Detail Tambahan
- **Deskripsi Kecelakaan** (deskripsi_kecelakaan) - Optional
  - Text area untuk menjelaskan detail kecelakaan yang terjadi
  - Contoh: "Kecelakaan kerja ringan: 1 pekerja terluka akibat tersandung material, 1 pekerja tangan terjepit"
  
- **Tindakan Perbaikan** (tindakan_perbaikan) - Optional
  - Text area untuk mencatat langkah-langkah perbaikan yang diambil
  - Contoh: "Penataan ulang area kerja, briefing keselamatan ditingkatkan, APD diperiksa rutin"

### 6. Metadata
- **Created By** (created_by) - Auto
  - User yang menginput data
  
- **Created At** (created_at) - Auto
  - Timestamp saat data dibuat
  
- **Updated At** (updated_at) - Auto
  - Timestamp saat data terakhir diupdate

## Contoh Perhitungan

### Contoh 1: Ada Kecelakaan
**Data:**
- Periode: Januari 2025
- Unit: Terminal Petikemas
- Jumlah Pekerja: 150 orang
- Hari Kerja: 22 hari
- Jam Kerja per Hari: 8 jam
- Jumlah LTI: 2 kejadian
- Jumlah Fatality: 0
- Jumlah Near Miss: 5 kejadian

**Perhitungan:**
- Total Jam Kerja = 150 × 22 × 8 = 26.400 jam
- LTIFR = (2 × 1.000.000) / 26.400 = **75.76**

**Interpretasi:** Terjadi 75.76 kecelakaan per 1 juta jam kerja

### Contoh 2: Tidak Ada Kecelakaan
**Data:**
- Periode: Februari 2025
- Unit: Terminal Curah Kering
- Jumlah Pekerja: 80 orang
- Hari Kerja: 20 hari
- Jam Kerja per Hari: 8 jam
- Jumlah LTI: 0 kejadian
- Jumlah Fatality: 0
- Jumlah Near Miss: 2 kejadian

**Perhitungan:**
- Total Jam Kerja = 80 × 20 × 8 = 12.800 jam
- LTIFR = (0 × 1.000.000) / 12.800 = **0.00**

**Interpretasi:** Tidak ada kecelakaan dalam periode tersebut (Zero Accident)

## Standar LTIFR
- **LTIFR < 1.0** : Sangat Baik (World Class)
- **LTIFR 1.0 - 5.0** : Baik
- **LTIFR 5.0 - 10.0** : Perlu Perbaikan
- **LTIFR > 10.0** : Buruk, Perlu Tindakan Segera

## Fitur Aplikasi

### Dashboard Statistics
- Total LTI (semua periode yang difilter)
- Total Fatality (semua periode yang difilter)
- Total Jam Kerja (akumulasi)
- Rata-rata LTIFR

### Filter
- Filter berdasarkan Periode Bulan
- Filter berdasarkan Unit
- Reset Filter

### CRUD Operations
- **Create**: Tambah data LTIFR baru
- **Read**: Lihat list dan detail data
- **Update**: Edit data existing
- **Delete**: Hapus data (hanya admin)

### Auto Calculation
- Total Jam Kerja dihitung otomatis saat input data pekerja/hari/jam
- LTIFR dihitung otomatis dari jumlah LTI dan total jam kerja
- Real-time calculation saat user mengisi form

### RLS (Row Level Security)
- **Admin & Manager**: Full access (CRUD)
- **User**: Read-only access
- Data security menggunakan Supabase RLS policies

## Manfaat Laporan LTIFR
1. **Monitoring Keselamatan Kerja**: Tracking tren kecelakaan dari waktu ke waktu
2. **Benchmarking**: Membandingkan performa antar unit atau periode
3. **Compliance**: Memenuhi requirement audit dan standar K3
4. **Decision Making**: Data untuk perbaikan program keselamatan kerja
5. **Prevention**: Analisis near miss untuk mencegah kecelakaan di masa depan

## Database Schema
```sql
CREATE TABLE ltifr_records (
    id UUID PRIMARY KEY,
    periode_bulan VARCHAR(7) NOT NULL,
    unit_id UUID REFERENCES units(id),
    jumlah_lti INTEGER NOT NULL DEFAULT 0,
    jumlah_fatality INTEGER NOT NULL DEFAULT 0,
    jumlah_near_miss INTEGER NOT NULL DEFAULT 0,
    jumlah_pekerja INTEGER NOT NULL DEFAULT 0,
    hari_kerja INTEGER NOT NULL DEFAULT 0,
    jam_kerja_per_hari NUMERIC(5,2) NOT NULL DEFAULT 8.00,
    total_jam_kerja INTEGER NOT NULL DEFAULT 0,
    ltifr NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    deskripsi_kecelakaan TEXT,
    tindakan_perbaikan TEXT,
    created_by UUID REFERENCES pegawai(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
