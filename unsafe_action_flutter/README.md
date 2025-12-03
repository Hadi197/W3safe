# 📱 Unsafe Action/Condition - Flutter Mobile App

## Overview
Aplikasi Android native menggunakan Flutter untuk **modul Unsafe Action/Condition** dari sistem HSSE Management.

## Features
✅ **Real-time Reporting** - Lapor unsafe action/condition langsung dari lapangan  
✅ **Camera Integration** - Foto langsung dengan kamera smartphone  
✅ **GPS Location** - Auto-capture lokasi kejadian  
✅ **Offline Support** - Simpan draft offline, sync saat online  
✅ **Voice Notes** - Rekam catatan suara untuk dokumentasi  
✅ **Push Notifications** - Notifikasi real-time untuk update status  
✅ **Priority Management** - Set prioritas (Low, Medium, High, Critical)  
✅ **Status Tracking** - Track progress dari Draft → Closed  

## Tech Stack
- **Framework:** Flutter 3.16+
- **State Management:** Riverpod
- **Backend:** Supabase (PostgreSQL + Storage + Auth)
- **Local Storage:** Hive
- **Camera:** camera plugin
- **GPS:** geolocator plugin
- **Maps:** Google Maps Flutter
- **Network:** Dio with retry interceptor
- **Image Processing:** image_picker, image_cropper

## Architecture
```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── date_formatter.dart
│       ├── validators.dart
│       └── image_compressor.dart
├── data/
│   ├── models/
│   │   ├── unsafe_incident_model.dart
│   │   └── incident_stats_model.dart
│   ├── repositories/
│   │   ├── incident_repository.dart
│   │   └── photo_repository.dart
│   └── datasources/
│       ├── incident_remote_datasource.dart
│       └── incident_local_datasource.dart
├── domain/
│   ├── entities/
│   │   └── unsafe_incident.dart
│   └── usecases/
│       ├── create_incident.dart
│       ├── get_incidents.dart
│       └── upload_photos.dart
├── presentation/
│   ├── providers/
│   │   ├── incident_provider.dart
│   │   └── auth_provider.dart
│   ├── screens/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   ├── incident_list/
│   │   │   ├── incident_list_screen.dart
│   │   │   └── widgets/
│   │   ├── incident_form/
│   │   │   ├── incident_form_screen.dart
│   │   │   └── widgets/
│   │   ├── incident_detail/
│   │   │   ├── incident_detail_screen.dart
│   │   │   └── widgets/
│   │   └── camera/
│   │       └── camera_screen.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_overlay.dart
└── main.dart
```

## Database Schema
Tabel: `unsafe_action_condition`

**Key Fields:**
- `id`: UUID (Primary Key)
- `tanggal_kejadian`: DATE (Required)
- `waktu_kejadian`: TIME (Required)
- `lokasi_kejadian`: VARCHAR (Required)
- `unit_kerja`: VARCHAR (Required)
- `jenis_kejadian`: ENUM ('unsafe_action', 'unsafe_condition')
- `kategori`: VARCHAR (e.g., "Tidak Menggunakan APD", "Pencahayaan Kurang")
- `deskripsi_kejadian`: TEXT (Required)
- `pelapor_nama`: VARCHAR (Required)
- `pelapor_jabatan`: VARCHAR
- `pelapor_kontak`: VARCHAR
- `prioritas`: ENUM ('low', 'medium', 'high', 'critical')
- `severity_level`: INTEGER (1-5)
- `status`: ENUM ('draft', 'reported', 'investigating', 'resolved', 'closed')
- `foto_kejadian`: TEXT[] (Array of photo URLs)
- `video_kejadian`: TEXT[]
- `audio_catatan`: TEXT
- `latitude`: DECIMAL
- `longitude`: DECIMAL
- `tindakan_segera`: TEXT
- `area_diamankan`: BOOLEAN
- `korban_ada`: BOOLEAN
- `korban_jumlah`: INTEGER

## Setup Instructions

### Prerequisites
```bash
flutter --version  # Flutter 3.16+ required
dart --version     # Dart 3.2+ required
```

### Installation
```bash
# 1. Clone/navigate to project
cd unsafe_action_flutter

# 2. Install dependencies
flutter pub get

# 3. Setup Supabase credentials
# Edit lib/core/config/supabase_config.dart
# Add your SUPABASE_URL and SUPABASE_ANON_KEY

# 4. Run code generation (for Freezed/Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

### Environment Variables
Create `.env` file:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_MAPS_API_KEY=your-google-maps-key
```

## Usage

### 1. Login
- Email/password authentication via Supabase Auth
- Remember me option
- Biometric login (if supported)

### 2. Dashboard
- Statistics cards (Total, Unsafe Action, Unsafe Condition, Recent)
- Quick actions: New Report, Scan QR
- Recent incidents list

### 3. Create Report
**Step 1: Basic Info**
- Tanggal & Waktu (auto-fill current)
- Lokasi (manual + GPS button)
- Unit Kerja (dropdown)
- Jenis Kejadian (Unsafe Action / Unsafe Condition)
- Kategori (dynamic based on jenis)

**Step 2: Evidence**
- Camera capture (multiple photos)
- Gallery selection
- Voice recording
- Video recording

**Step 3: Details**
- Deskripsi kejadian (min 20 char)
- Penyebab diduga
- Potensi risiko
- Tindakan segera

**Step 4: Reporter Info**
- Nama pelapor (auto-fill from profile)
- Jabatan
- Kontak

**Step 5: Review & Submit**
- Preview all data
- Save as Draft / Submit

### 4. Incident List
- Filter: Jenis, Status, Prioritas, Date Range
- Search: By deskripsi, lokasi, pelapor
- Sort: Date, Priority, Status
- Pull to refresh
- Infinite scroll

### 5. Incident Detail
- Full info display
- Photo gallery viewer
- Timeline (Created → Reported → Investigating → Resolved → Closed)
- Action buttons: Edit (if draft), Delete (if allowed)
- Share report (PDF)

## API Endpoints (Supabase)

### Get All Incidents
```dart
final response = await supabase
  .from('unsafe_action_condition')
  .select()
  .order('created_at', ascending: false)
  .range(0, 19);
```

### Create Incident
```dart
final response = await supabase
  .from('unsafe_action_condition')
  .insert({
    'tanggal_kejadian': '2025-12-01',
    'waktu_kejadian': '14:30:00',
    'lokasi_kejadian': 'Dermaga Utama',
    'unit_kerja': 'Unit Banjarmasin',
    'jenis_kejadian': 'unsafe_condition',
    'kategori': 'Pencahayaan Kurang',
    'deskripsi_kejadian': 'Area bongkar muat gelap di malam hari',
    'pelapor_nama': 'Ahmad Rizki',
    'prioritas': 'high',
    'status': 'reported',
  })
  .select()
  .single();
```

### Upload Photo
```dart
final file = File('path/to/photo.jpg');
final fileName = 'unsafe_${DateTime.now().millisecondsSinceEpoch}.jpg';
final response = await supabase.storage
  .from('unsafe-action-condition-photos')
  .upload(fileName, file);

final publicUrl = supabase.storage
  .from('unsafe-action-condition-photos')
  .getPublicUrl(fileName);
```

### Update Incident
```dart
final response = await supabase
  .from('unsafe_action_condition')
  .update({'status': 'investigating'})
  .eq('id', incidentId);
```

## Screenshots
*(Coming soon)*

## Performance Optimization
- Image compression before upload (max 1MB per photo)
- Lazy loading for incident list
- Cached network images
- Debounced search input
- Pagination (20 items per page)
- Offline-first approach with Hive cache

## Security
- Row Level Security (RLS) enabled on Supabase
- JWT token refresh
- Secure storage for auth tokens
- Photo URL signed with expiry

## Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widgets/
```

## Build for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Install on Device
```bash
flutter install
```

## Future Enhancements
- [ ] Voice-to-text for deskripsi
- [ ] AI image classification (unsafe condition detection)
- [ ] Barcode/QR scanner for equipment ID
- [ ] Offline maps
- [ ] Multi-language support (EN/ID)
- [ ] Dark mode
- [ ] Export to PDF/Excel
- [ ] Push notification for status updates
- [ ] In-app chat with investigator

## Contributing
Contact: hadi.purwana@example.com

## License
Proprietary - HSSE Management System

## Version
**v1.0.0** - Initial Release (December 2025)

---

**Made with ❤️ using Flutter**
