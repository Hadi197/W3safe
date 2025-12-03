# 🎯 SETUP GUIDE - Flutter Unsafe Action/Condition App

## Quick Start

### 1. Install Flutter
```bash
# Check Flutter installation
flutter --version

# If not installed, visit: https://flutter.dev/docs/get-started/install
```

### 2. Setup Project
```bash
# Navigate to project directory
cd unsafe_action_flutter

# Get dependencies
flutter pub get

# Run code generation for Freezed models
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure Supabase
```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your Supabase credentials
nano .env
```

Add your credentials:
```env
SUPABASE_URL=https://xxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GOOGLE_MAPS_API_KEY=AIzaSyXxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 4. Run the App
```bash
# List available devices
flutter devices

# Run on Android emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## Project Structure
```
unsafe_action_flutter/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── supabase_config.dart          # Supabase configuration
│   │   ├── constants/
│   │   │   └── app_constants.dart             # App-wide constants
│   │   └── theme/
│   │       └── app_theme.dart                 # App theme & colors
│   ├── data/
│   │   ├── models/
│   │   │   └── unsafe_incident_model.dart     # Data models with Freezed
│   │   ├── datasources/
│   │   │   └── incident_remote_datasource.dart # Supabase API calls
│   │   └── repositories/
│   │       └── incident_repository.dart       # Repository pattern
│   ├── presentation/
│   │   └── screens/
│   │       ├── splash/
│   │       │   └── splash_screen.dart         # Splash screen
│   │       └── home/
│   │           └── home_screen.dart           # Home dashboard
│   └── main.dart                               # App entry point
├── pubspec.yaml                                 # Dependencies
├── .env                                         # Environment variables (gitignored)
└── README.md                                    # Documentation
```

## Features Implemented

### ✅ Core Infrastructure
- Clean architecture (Data, Domain, Presentation layers)
- Supabase integration for backend
- State management with Riverpod
- Freezed for immutable models
- Environment variable configuration

### ✅ UI Screens
- **Splash Screen**: Animated app intro
- **Home Screen**: Dashboard with statistics, quick actions, recent incidents

### 🔄 In Progress
- Incident list screen with filters
- Incident create/edit form
- Incident detail view
- Camera integration for photo capture
- GPS location tracking

### 📋 To Do
- Offline support with Hive
- Push notifications
- Audio recording
- PDF export
- Unit tests
- Integration tests

## Dependencies

### Core
- `flutter_riverpod`: ^2.4.9 - State management
- `supabase_flutter`: ^2.0.0 - Backend & Auth

### UI/UX
- `google_fonts`: ^6.1.0 - Typography
- `flutter_svg`: ^2.0.9 - SVG support
- `cached_network_image`: ^3.3.0 - Image caching
- `shimmer`: ^3.0.0 - Loading effects

### Camera & Media
- `camera`: ^0.10.5+7 - Camera access
- `image_picker`: ^1.0.5 - Gallery picker
- `image_cropper`: ^5.0.1 - Image cropping
- `permission_handler`: ^11.1.0 - Permissions

### Location
- `geolocator`: ^10.1.0 - GPS location
- `geocoding`: ^2.1.1 - Address lookup
- `google_maps_flutter`: ^2.5.0 - Maps

### Storage
- `hive`: ^2.2.3 - Local NoSQL database
- `shared_preferences`: ^2.2.2 - Key-value storage

### Utils
- `intl`: ^0.18.1 - Date formatting
- `logger`: ^2.0.2+1 - Logging
- `uuid`: ^4.2.2 - UUID generation

## Build Commands

### Debug Build
```bash
flutter build apk --debug
flutter build ios --debug
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

### Install APK
```bash
# Install debug APK on connected device
flutter install

# Install specific APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Troubleshooting

### Issue: "flutter: command not found"
**Solution:**
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or add to ~/.zshrc
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: "Supabase initialization failed"
**Solution:**
1. Check `.env` file exists and has correct credentials
2. Verify Supabase URL format: `https://xxxxx.supabase.co`
3. Ensure anon key is complete (starts with `eyJ...`)

### Issue: "Build runner failed"
**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: "Android licenses not accepted"
**Solution:**
```bash
flutter doctor --android-licenses
# Accept all licenses by typing 'y'
```

### Issue: "CocoaPods not installed" (iOS)
**Solution:**
```bash
sudo gem install cocoapods
pod setup
```

## Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/models/unsafe_incident_model_test.dart

# With coverage
flutter test --coverage
```

### Run Integration Tests
```bash
flutter test integration_test/app_test.dart
```

## Performance

### Analyze Code
```bash
flutter analyze
```

### Check Performance
```bash
flutter run --profile
```

## Documentation

### Generate API Docs
```bash
dart doc .
```

## Next Steps

1. **Add remaining screens:**
   - Incident list with filters
   - Create/edit incident form
   - Detail view with photo gallery

2. **Implement camera:**
   - Take photos with camera
   - Select from gallery
   - Compress before upload

3. **Add GPS:**
   - Auto-detect location
   - Show on map
   - Manual location picker

4. **Offline support:**
   - Save drafts locally
   - Sync when online
   - Queue photos for upload

5. **Testing:**
   - Unit tests for models
   - Widget tests for screens
   - Integration tests for flows

## Support

For questions or issues:
- Email: support@hsse-app.com
- GitHub: https://github.com/your-repo
- Documentation: [Link to full docs]

---

**Happy Coding! 🚀**
