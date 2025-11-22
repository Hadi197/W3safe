# Image Auto-Compression Implementation Guide

## Overview
Fitur kompresi otomatis untuk foto yang lebih dari 1MB, mengurangi ukuran file hingga ≤1MB sebelum upload.

## Files Created
1. `/src/utils/imageCompressor.ts` - Core compression utility
2. `/src/composables/useImageCompression.ts` - Vue composable hook

## Key Features
- ✅ Auto-compress images >1MB to ≤1MB
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
- [ ] Safety Patrol
- [ ] Safety Drill  
- [ ] Safety Induction
- [ ] Management Walkthrough
- [ ] Silent Inspection
- [ ] Safety Briefing
- [ ] Any other modules with photo upload

### For Each Module:
1. Import composable: `import { useImageCompression } from '@/composables/useImageCompression'`
2. Add to component: `const { compressSingleImage, formatFileSize } = useImageCompression()`
3. Update photo upload handlers to use `compressSingleImage(file)`
4. Update validation messages (no need to check 5MB anymore)
5. Update UI text: "Max 5MB" → "Foto akan dikompres otomatis jika >1MB"

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
