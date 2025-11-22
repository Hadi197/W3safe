# Image Auto-Compression & Camera Capture Implementation Guide

## Overview
- **Auto-Compression**: Foto >1MB otomatis dikompres menjadi ≤1MB sebelum upload
- **Camera Capture**: Tombol "Ambil Foto" untuk akses kamera langsung di HP
- **Gallery Selection**: Tombol "Pilih dari Galeri" untuk pilih foto existing

## Files Created
1. `/src/utils/imageCompressor.ts` - Core compression utility
2. `/src/composables/useImageCompression.ts` - Vue composable hook
3. `/src/utils/photoUploadHelpers.ts` - Photo upload UI helpers

## Key Features
- ✅ Auto-compress images >1MB to ≤1MB
- ✅ Direct camera capture on mobile devices (capture="environment")
- ✅ Gallery/file picker selection
- ✅ Dual button UI (Camera + Gallery)
- ✅ Maintains aspect ratio
- ✅ Progressive quality reduction
- ✅ Max dimension: 1920px
- ✅ Converts to JPEG for better compression
- ✅ Shows compression stats in console
- ✅ Fallback to original if compression fails

## Usage Example

### Before (without compression):
```typescript
const handlePhotoUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files) return

  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    // Validate size
    if (file.size > 5 * 1024 * 1024) {
      alert('File too large!')
      continue
    }
    // Upload file...
  }
}
```

### After (with auto-compression):
```typescript
import { useImageCompression } from '@/composables/useImageCompression'

const { compressSingleImage, formatFileSize } = useImageCompression()

const handlePhotoUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files) return

  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    if (!file) continue
    
    // Auto-compress if needed
    const result = await compressSingleImage(file)
    
    // Use compressed file for upload
    const compressedFile = result.file
    
    // Show info
    console.log(`Original: ${formatFileSize(result.originalSize)}`)
    console.log(`Compressed: ${formatFileSize(result.compressedSize)}`)
    
    // Upload compressedFile...
  }
}
```

## Implementation Checklist

### Modules to Update:
- [x] Safety Patrol ✅
- [x] Safety Drill ✅
- [x] Safety Briefing ✅
- [ ] Safety Induction
- [ ] Management Walkthrough
- [ ] Silent Inspection
- [ ] Safety Forum (has 3 upload inputs)
- [ ] Any other modules with photo upload

### For Each Module:
1. Import composable: `import { useImageCompression } from '@/composables/useImageCompression'`
2. Add to component: `const { compressSingleImage, formatFileSize } = useImageCompression()`
3. Update photo upload handlers to use `compressSingleImage(file)`
4. Add dual input (camera + gallery):
```vue
<!-- File input dari galeri -->
<input type="file" accept="image/*" multiple
  @change="handlePhotoUpload($event)"
  class="hidden"
  ref="fileInput"
/>
<!-- File input dari kamera -->
<input type="file" accept="image/*" capture="environment"
  @change="handlePhotoUpload($event)"
  class="hidden"
  ref="cameraInput"
/>
```
5. Add dual button UI:
```vue
<div class="flex gap-2">
  <button @click="$refs.cameraInput?.click()" class="flex-1 bg-green-600...">
    🎥 Ambil Foto
  </button>
  <button @click="$refs.fileInput?.click()" class="flex-1 bg-blue-600...">
    🖼️ Pilih dari Galeri
  </button>
</div>
```
6. Update help text: "📸 Ambil foto langsung atau pilih dari galeri. Foto akan dikompres otomatis jika >1MB"

## Camera Capture Attributes
- `capture="environment"` - Gunakan kamera belakang (default)
- `capture="user"` - Gunakan kamera depan (selfie)
- `accept="image/*"` - Hanya terima file gambar
- `multiple` - Allow multiple file selection (untuk galeri)

## Benefits
- **Storage savings**: ~70-90% reduction for large images
- **Faster uploads**: Smaller files = faster network transfer
- **Better UX**: Users don't need to manually compress
- **Cost savings**: Less storage and bandwidth usage

## Testing
1. Upload image <1MB → Should pass through unchanged
2. Upload image >1MB → Should auto-compress to ≤1MB
3. Check console for compression stats
4. Verify image quality is acceptable
5. Test with various formats (PNG, JPG, HEIC)
