/**
 * Image Compression Utility
 * Automatically compresses images larger than 1MB to ≤1MB
 */

export interface CompressionOptions {
  maxSizeMB?: number
  maxWidthOrHeight?: number
  quality?: number
  fileType?: string
}

export interface CompressionResult {
  file: File
  originalSize: number
  compressedSize: number
  compressionRatio: number
  wasCompressed: boolean
}

/**
 * Compress image file if it exceeds maxSizeMB
 * @param file - Image file to compress
 * @param options - Compression options
 * @returns Compressed file with metadata
 */
export async function compressImage(
  file: File,
  options: CompressionOptions = {}
): Promise<CompressionResult> {
  const {
    maxSizeMB = 1, // Default: compress if > 1MB
    maxWidthOrHeight = 1920, // Default: max dimension 1920px
    quality = 0.8, // Default: 80% quality
    fileType = 'image/jpeg' // Default: convert to JPEG
  } = options

  const originalSize = file.size
  const maxSizeBytes = maxSizeMB * 1024 * 1024

  // If file is already small enough, return as-is
  if (originalSize <= maxSizeBytes) {
    return {
      file,
      originalSize,
      compressedSize: originalSize,
      compressionRatio: 1,
      wasCompressed: false
    }
  }

  try {
    // Load image
    const image = await loadImage(file)
    
    // Calculate new dimensions while maintaining aspect ratio
    const { width, height } = calculateDimensions(
      image.width,
      image.height,
      maxWidthOrHeight
    )

    // Create canvas and draw resized image
    const canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height
    const ctx = canvas.getContext('2d')
    
    if (!ctx) {
      throw new Error('Failed to get canvas context')
    }

    // Use better image smoothing
    ctx.imageSmoothingEnabled = true
    ctx.imageSmoothingQuality = 'high'
    ctx.drawImage(image, 0, 0, width, height)

    // Try compression with progressively lower quality
    let compressedBlob = await canvasToBlob(canvas, fileType, quality)
    let currentQuality = quality

    // If still too large, reduce quality iteratively
    while (compressedBlob.size > maxSizeBytes && currentQuality > 0.1) {
      currentQuality -= 0.1
      compressedBlob = await canvasToBlob(canvas, fileType, currentQuality)
    }

    // Create new File from Blob
    const compressedFile = new File(
      [compressedBlob],
      file.name.replace(/\.[^.]+$/, '.jpg'), // Change extension to .jpg
      {
        type: fileType,
        lastModified: Date.now()
      }
    )

    const compressedSize = compressedFile.size

    return {
      file: compressedFile,
      originalSize,
      compressedSize,
      compressionRatio: originalSize / compressedSize,
      wasCompressed: true
    }
  } catch (error) {
    console.error('Image compression failed:', error)
    // Return original file if compression fails
    return {
      file,
      originalSize,
      compressedSize: originalSize,
      compressionRatio: 1,
      wasCompressed: false
    }
  }
}

/**
 * Load image from file
 */
function loadImage(file: File): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image()
    const url = URL.createObjectURL(file)

    img.onload = () => {
      URL.revokeObjectURL(url)
      resolve(img)
    }

    img.onerror = () => {
      URL.revokeObjectURL(url)
      reject(new Error('Failed to load image'))
    }

    img.src = url
  })
}

/**
 * Calculate new dimensions while maintaining aspect ratio
 */
function calculateDimensions(
  width: number,
  height: number,
  maxDimension: number
): { width: number; height: number } {
  if (width <= maxDimension && height <= maxDimension) {
    return { width, height }
  }

  const aspectRatio = width / height

  if (width > height) {
    return {
      width: maxDimension,
      height: Math.round(maxDimension / aspectRatio)
    }
  } else {
    return {
      width: Math.round(maxDimension * aspectRatio),
      height: maxDimension
    }
  }
}

/**
 * Convert canvas to Blob
 */
function canvasToBlob(
  canvas: HTMLCanvasElement,
  type: string,
  quality: number
): Promise<Blob> {
  return new Promise((resolve, reject) => {
    canvas.toBlob(
      (blob) => {
        if (blob) {
          resolve(blob)
        } else {
          reject(new Error('Failed to convert canvas to blob'))
        }
      },
      type,
      quality
    )
  })
}

/**
 * Format file size for display
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes'

  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))

  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

/**
 * Batch compress multiple images
 */
export async function compressImages(
  files: File[],
  options?: CompressionOptions
): Promise<CompressionResult[]> {
  return Promise.all(
    files.map(file => compressImage(file, options))
  )
}

/**
 * Validate if file is an image
 */
export function isImageFile(file: File): boolean {
  return file.type.startsWith('image/')
}

/**
 * Get compression stats summary
 */
export function getCompressionStats(results: CompressionResult[]): {
  totalOriginalSize: number
  totalCompressedSize: number
  totalSaved: number
  averageCompressionRatio: number
} {
  const totalOriginalSize = results.reduce((sum, r) => sum + r.originalSize, 0)
  const totalCompressedSize = results.reduce((sum, r) => sum + r.compressedSize, 0)
  const totalSaved = totalOriginalSize - totalCompressedSize
  const averageCompressionRatio = results.length > 0
    ? results.reduce((sum, r) => sum + r.compressionRatio, 0) / results.length
    : 1

  return {
    totalOriginalSize,
    totalCompressedSize,
    totalSaved,
    averageCompressionRatio
  }
}
