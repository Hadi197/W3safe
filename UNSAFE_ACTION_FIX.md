# Fix: Unsafe Action/Condition - Data Tidak Muncul di Web Edit Mode

## Masalah
Ketika data unsafe action/condition di-input dari Flutter dan berhasil disimpan, tetapi saat dilihat di web dalam mode edit:
- Banyak field kosong
- Foto tidak muncul

## Penyebab
1. **Mapping Field Tidak Konsisten**: Model Flutter menggunakan camelCase (contoh: `tanggalKejadian`) sedangkan database PostgreSQL menggunakan snake_case (contoh: `tanggal_kejadian`). Tanpa anotasi `@JsonKey`, data tidak ter-mapping dengan benar.

2. **Array Foto Tidak Di-Handle**: Fungsi edit di web tidak meng-handle array foto dengan benar saat data di-load.

## Solusi yang Sudah Diterapkan

### 1. Flutter Model Fix (`unsafe_incident_model.dart`)
Menambahkan anotasi `@JsonKey` untuk setiap field agar mapping antara camelCase (Dart) dan snake_case (Database) berjalan dengan benar:

```dart
@JsonKey(name: 'tanggal_kejadian') required DateTime tanggalKejadian,
@JsonKey(name: 'waktu_kejadian') required String waktuKejadian,
@JsonKey(name: 'lokasi_kejadian') required String lokasiKejadian,
@JsonKey(name: 'foto_kejadian') @Default([]) List<String> fotoKejadian,
// ... dan seterusnya untuk semua field
```

### 2. Web Edit Function Fix (`UnsafeActionConditionView.vue`)
Memperbaiki fungsi `editIncident` untuk:
- Mapping setiap field secara eksplisit
- Handle array foto dengan benar (pastikan selalu berupa array)
- Handle data yang null atau undefined

```javascript
const editIncident = (incident: any) => {
  selectedIncident.value = incident
  
  // Explicit mapping untuk setiap field
  formData.tanggal_kejadian = incident.tanggal_kejadian || ...
  formData.waktu_kejadian = incident.waktu_kejadian || ...
  
  // Handle photo array dengan benar
  if (Array.isArray(incident.foto_kejadian)) {
    formData.foto_kejadian = [...incident.foto_kejadian]
  } else if (incident.foto_kejadian) {
    formData.foto_kejadian = [incident.foto_kejadian]
  } else {
    formData.foto_kejadian = []
  }
  
  // ... mapping field lainnya
}
```

## Cara Testing

### 1. Test di Flutter
```bash
cd unsafe_action_flutter
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d <device-id>
```

Lakukan:
1. Buat laporan baru dengan lengkap (isi semua field + upload foto)
2. Submit
3. Cek di Supabase apakah data tersimpan dengan field name yang benar

### 2. Test di Web
1. Buka halaman Unsafe Action/Condition
2. Cari data yang baru di-input dari Flutter
3. Klik tombol Edit
4. Verifikasi:
   - ✅ Semua field terisi dengan benar
   - ✅ Foto muncul di preview
   - ✅ Bisa mengedit dan update data

## File yang Diubah

1. **Flutter**:
   - `unsafe_action_flutter/lib/data/models/unsafe_incident_model.dart`
   - Model di-rebuild dengan `build_runner`

2. **Web Vue**:
   - `hsse-app/src/views/hsse/UnsafeActionConditionView.vue`
   - Fungsi `editIncident` diperbaiki

## Catatan Penting

### Untuk Development Selanjutnya:
1. **Selalu gunakan `@JsonKey`** di Flutter saat field name berbeda dengan database
2. **Konsisten dengan naming convention**:
   - Database: `snake_case`
   - Dart/Flutter: `camelCase`
   - JavaScript/Vue: `snake_case` (ikuti DB)
3. **Handle array dengan hati-hati** - pastikan selalu check apakah data berupa array
4. **Testing end-to-end** setelah perubahan model

### Best Practice:
```dart
// Flutter Model - SELALU gunakan JsonKey untuk mapping
@JsonKey(name: 'database_field_name') String dartFieldName,

// Vue/Web - SELALU explicit mapping saat edit
formData.field_name = incident.field_name || defaultValue
```

## Hasil yang Diharapkan
- ✅ Data dari Flutter tersimpan dengan field name yang benar
- ✅ Data dapat dibaca dan di-edit dengan sempurna dari web
- ✅ Foto muncul di mode edit web
- ✅ Tidak ada field yang hilang atau kosong
