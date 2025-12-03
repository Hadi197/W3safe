# Update Log - Flutter HSSE App

## Update 1 Desember 2025

### ✅ Perubahan Database Integration

#### 1. Model Updates
- **UnsafeIncidentModel**
  - ✅ Ditambahkan field `unitId` untuk foreign key ke tabel `units`
  - ✅ Field `unitKerja` tetap dipertahankan untuk backward compatibility
  - ✅ Semua field sudah sesuai dengan schema database:
    - `penyebab_diduga`
    - `potensi_risiko`
    - `korban_jumlah`
    - `investigasi_dilakukan`
    - `temuan_investigasi`
    - `rekomendasi_koreksi`

#### 2. New Models
- **UnitModel** - Model untuk tabel `units`
  - `id` (UUID)
  - `kode_unit` (VARCHAR)
  - `nama_unit` (VARCHAR)
  - `lokasi` (VARCHAR)
  - `status` (aktif/nonaktif)
  - `created_at`, `updated_at`

#### 3. Data Sources
- **UnitRemoteDatasource** - Service untuk fetch units dari Supabase
  - `getUnits()` - Get all units dengan filter status
  - `getUnitById()` - Get unit by ID

#### 4. Form Updates (IncidentFormScreen)
- ✅ Unit Kerja dropdown sekarang load dari database real-time
- ✅ Loading state saat fetch units
- ✅ Tambahan field baru:
  - **Penyebab Diduga** (textarea)
  - **Potensi Risiko** (textarea)
  - **Jumlah Korban** (number input, muncul jika checkbox "Ada korban" dicentang)

#### 5. Database Fields Mapping

| Form Field | Database Column | Type | Status |
|------------|----------------|------|--------|
| Tanggal Kejadian | tanggal_kejadian | DATE | ✅ |
| Waktu Kejadian | waktu_kejadian | TIME | ✅ |
| Lokasi | lokasi_kejadian | VARCHAR | ✅ |
| Unit Kerja | unit_kerja | VARCHAR | ✅ |
| Unit ID | unit_id | UUID | ✅ NEW |
| Jenis Kejadian | jenis_kejadian | VARCHAR | ✅ |
| Kategori | kategori | VARCHAR | ✅ |
| Deskripsi | deskripsi_kejadian | TEXT | ✅ |
| Penyebab Diduga | penyebab_diduga | TEXT | ✅ NEW |
| Potensi Risiko | potensi_risiko | TEXT | ✅ NEW |
| Pelapor Nama | pelapor_nama | VARCHAR | ✅ |
| Pelapor Jabatan | pelapor_jabatan | VARCHAR | ✅ |
| Pelapor Kontak | pelapor_kontak | VARCHAR | ✅ |
| Tindakan Segera | tindakan_segera | TEXT | ✅ |
| Area Diamankan | area_diamankan | BOOLEAN | ✅ |
| Korban Ada | korban_ada | BOOLEAN | ✅ |
| Jumlah Korban | korban_jumlah | INTEGER | ✅ NEW |
| Foto | foto_kejadian | TEXT[] | ✅ |
| Prioritas | prioritas | VARCHAR | ✅ |
| Latitude | latitude | DECIMAL | ✅ |
| Longitude | longitude | DECIMAL | ✅ |
| Status | status | VARCHAR | ✅ |

### 📱 Build Info
- **APK Name**: `hsse.apk`
- **Size**: 55 MB
- **Location**: `build/app/outputs/apk/release/hsse.apk`
- **Version**: 1.0.0+1
- **Build Date**: 1 Desember 2025

### 🔄 Next Steps
1. ✅ Model dan form sudah sinkron dengan database
2. ✅ Unit data fetch dari database real-time
3. ⏳ Implementasi save data ke Supabase
4. ⏳ Implementasi upload foto ke Supabase Storage
5. ⏳ Implementasi GPS location capture
6. ⏳ Testing integrasi penuh

### 📝 Catatan
- Form sudah memiliki semua field sesuai schema database
- Dropdown unit kerja menggunakan data real dari tabel `units`
- Validasi form sudah lengkap
- Ready untuk implementasi save ke database
