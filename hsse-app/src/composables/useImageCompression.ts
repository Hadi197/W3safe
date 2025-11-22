/**
 * Vue Composable for Image Compression
 * Easy-to-use hook for compressing images in Vue components
 */

import { ref } from 'vue'
import { 
  compressImage, 
  compressImages,
  formatFileSize,
  isImageFile,
  type CompressionOptions,
  type CompressionResult 
} from '@/utils/imageCompressor'

export function useImageCompression(options?: CompressionOptions) {
  const isCompressing = ref(false)
  const compressionProgress = ref(0)
  const compressionResults = ref<CompressionResult[]>([])

  /**
   * Compress single image file
   */
  const compressSingleImage = async (file: File): Promise<CompressionResult> => {
    if (!isImageFile(file)) {
      throw new Error('File is not an image')
    }

    isCompressing.value = true
    compressionProgress.value = 0

    try {
      const result = await compressImage(file, options)
      compressionProgress.value = 100
      
      // Show compression info
      if (result.wasCompressed) {
        console.log(
          `📸 Image compressed: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} ` +
          `(${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% smaller)`
        )
      }

      return result
    } finally {
      isCompressing.value = false
    }
  }

  /**
   * Compress multiple image files
   */
  const compressMultipleImages = async (files: File[]): Promise<CompressionResult[]> => {
    const imageFiles = files.filter(isImageFile)
    
    if (imageFiles.length === 0) {
      throw new Error('No valid image files found')
    }

    isCompressing.value = true
    compressionProgress.value = 0

    try {
      const results: CompressionResult[] = []
      
      for (let i = 0; i < imageFiles.length; i++) {
        const file = imageFiles[i]
        if (!file) continue
        const result = await compressImage(file, options)
        results.push(result)
        compressionProgress.value = Math.round(((i + 1) / imageFiles.length) * 100)
        
        if (result.wasCompressed) {
          console.log(
            `📸 Image ${i + 1}/${imageFiles.length} compressed: ` +
            `${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)}`
          )
        }
      }

      compressionResults.value = results
      return results
    } finally {
      isCompressing.value = false
      compressionProgress.value = 100
    }
  }

  /**
   * Handle file input change event with auto-compression
   */
  const handleFileChange = async (
    event: Event,
    onSuccess: (results: CompressionResult[]) => void,
    onError?: (error: Error) => void
  ) => {
    const input = event.target as HTMLInputElement
    const files = Array.from(input.files || [])

    if (files.length === 0) return

    try {
      const results = await compressMultipleImages(files)
      onSuccess(results)
    } catch (error) {
      console.error('Compression error:', error)
      if (onError) {
        onError(error as Error)
      }
    }
  }

  /**
   * Get compression summary message
   */
  const getCompressionSummary = (result: CompressionResult): string => {
    if (!result.wasCompressed) {
      return `Ukuran file sudah optimal (${formatFileSize(result.originalSize)})`
    }

    const savedPercentage = Math.round((1 - result.compressedSize / result.originalSize) * 100)
    return `Dikompres dari ${formatFileSize(result.originalSize)} menjadi ${formatFileSize(result.compressedSize)} (hemat ${savedPercentage}%)`
  }

  /**
   * Reset compression state
   */
  const reset = () => {
    isCompressing.value = false
    compressionProgress.value = 0
    compressionResults.value = []
  }

  return {
    // State
    isCompressing,
    compressionProgress,
    compressionResults,

    // Methods
    compressSingleImage,
    compressMultipleImages,
    handleFileChange,
    getCompressionSummary,
    reset,

    // Utilities
    formatFileSize,
    isImageFile
  }
}
