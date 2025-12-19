import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
import type { ManagementWalkthrough } from '@/services/management-walkthrough.service'

/**
 * Generate formal PDF report for Management Walkthrough
 * Includes 11 sections with photo documentation
 */
export async function generateManagementWalkthroughPDF(walkthrough: ManagementWalkthrough) {
  const doc = new jsPDF()
  const pageWidth = doc.internal.pageSize.getWidth()
  const pageHeight = doc.internal.pageSize.getHeight()
  let yPos = 20

  // Helper function to check if we need a new page
  const checkPageBreak = (needed: number) => {
    if (yPos + needed > pageHeight - 20) {
      doc.addPage()
      yPos = 20
      return true
    }
    return false
  }

  // Header with Logo placeholder
  doc.setFontSize(16)
  doc.setFont('helvetica', 'bold')
  doc.text('LAPORAN MANAGEMENT WALKTHROUGH', pageWidth / 2, yPos, { align: 'center' })
  yPos += 8

  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  doc.text('PT. Perusahaan - Departemen K3', pageWidth / 2, yPos, { align: 'center' })
  yPos += 15

  // Horizontal line
  doc.setLineWidth(0.5)
  doc.line(14, yPos, pageWidth - 14, yPos)
  yPos += 10

  // Section 1: Informasi Umum
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('I. INFORMASI UMUM', 14, yPos)
  yPos += 8

  const infoData = [
    ['Nomor Walkthrough', walkthrough.nomor_walkthrough || '-'],
    ['Tanggal', formatDate(walkthrough.tanggal_walkthrough || '')],
    ['Waktu Pelaksanaan', `${walkthrough.waktu_mulai || '-'} s/d ${walkthrough.waktu_selesai || '-'}`],
    ['Area Inspeksi', walkthrough.area_inspeksi || '-'],
    ['Unit/Departemen', `${walkthrough.unit?.nama || '-'} / ${walkthrough.departemen || '-'}`],
    ['Jenis Walkthrough', formatJenis(walkthrough.jenis_walkthrough)],
    ['Status', formatStatus(walkthrough.status)]
  ]

  autoTable(doc, {
    startY: yPos,
    head: [],
    body: infoData,
    theme: 'plain',
    styles: { fontSize: 10, cellPadding: 2 },
    columnStyles: {
      0: { fontStyle: 'bold', cellWidth: 50 },
      1: { cellWidth: 'auto' }
    }
  })

  yPos = (doc as any).lastAutoTable.finalY + 10

  // Section 2: Tim Inspeksi
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('II. TIM INSPEKSI', 14, yPos)
  yPos += 8

  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  doc.text(`Pimpinan Walkthrough: ${walkthrough.pimpinan_walkthrough || '-'}`, 14, yPos)
  yPos += 6
  doc.text(`Jumlah Anggota Tim: ${walkthrough.jumlah_tim || 0} orang`, 14, yPos)
  yPos += 6

  if (walkthrough.anggota_tim && walkthrough.anggota_tim.length > 0) {
    doc.text('Anggota Tim:', 14, yPos)
    yPos += 5
    walkthrough.anggota_tim.forEach((member, idx) => {
      checkPageBreak(6)
      doc.text(`   ${idx + 1}. ${member}`, 14, yPos)
      yPos += 5
    })
  }
  yPos += 5

  // Section 3: Kondisi Area
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('III. OBSERVASI KONDISI AREA', 14, yPos)
  yPos += 8

  const kondisiData = [
    ['Housekeeping', formatKondisi(walkthrough.kondisi_housekeeping)],
    ['Pencahayaan', formatKondisi(walkthrough.kondisi_pencahayaan)],
    ['Ventilasi', formatKondisi(walkthrough.kondisi_ventilasi)],
    ['Akses Jalan', formatKondisi(walkthrough.kondisi_akses_jalan)]
  ]

  autoTable(doc, {
    startY: yPos,
    head: [['Aspek', 'Kondisi']],
    body: kondisiData,
    theme: 'grid',
    styles: { fontSize: 10 },
    headStyles: { fillColor: [66, 139, 202], textColor: 255, fontStyle: 'bold' }
  })

  yPos = (doc as any).lastAutoTable.finalY + 10

  // Section 4: Observasi APD
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('IV. OBSERVASI ALAT PELINDUNG DIRI (APD)', 14, yPos)
  yPos += 8

  const apdData = [
    ['Tingkat Kepatuhan APD', `${walkthrough.kepatuhan_apd || 0}%`],
    ['APD Tersedia', walkthrough.apd_tersedia ? 'Ya' : 'Tidak'],
    ['APD Kondisi Baik', walkthrough.apd_kondisi_baik ? 'Ya' : 'Tidak'],
    ['APD Digunakan Benar', walkthrough.apd_digunakan_benar ? 'Ya' : 'Tidak']
  ]

  autoTable(doc, {
    startY: yPos,
    head: [],
    body: apdData,
    theme: 'plain',
    styles: { fontSize: 10, cellPadding: 2 },
    columnStyles: {
      0: { fontStyle: 'bold', cellWidth: 60 },
      1: { cellWidth: 'auto' }
    }
  })

  yPos = (doc as any).lastAutoTable.finalY + 5

  if (walkthrough.apd_tidak_sesuai && walkthrough.apd_tidak_sesuai.length > 0) {
    checkPageBreak(20)
    doc.setFont('helvetica', 'bold')
    doc.text('APD Tidak Sesuai:', 14, yPos)
    yPos += 5
    doc.setFont('helvetica', 'normal')
    walkthrough.apd_tidak_sesuai.forEach((item, idx) => {
      checkPageBreak(5)
      doc.text(`   ${idx + 1}. ${item}`, 14, yPos)
      yPos += 5
    })
  }
  yPos += 5

  // Section 5: Observasi Perilaku
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('V. OBSERVASI PERILAKU KERJA', 14, yPos)
  yPos += 8

  const perilakuData = [
    ['Pekerja Diamati', `${walkthrough.pekerja_diamati || 0} orang`],
    ['Perilaku Aman', `${walkthrough.perilaku_aman || 0} kejadian`],
    ['Perilaku Tidak Aman', `${walkthrough.perilaku_tidak_aman || 0} kejadian`],
    ['Pekerja Diwawancara', `${walkthrough.jumlah_pekerja_diwawancara || 0} orang`],
    ['Aware Prosedur', walkthrough.pekerja_aware_prosedur ? 'Ya' : 'Tidak']
  ]

  autoTable(doc, {
    startY: yPos,
    head: [],
    body: perilakuData,
    theme: 'plain',
    styles: { fontSize: 10, cellPadding: 2 },
    columnStyles: {
      0: { fontStyle: 'bold', cellWidth: 60 },
      1: { cellWidth: 'auto' }
    }
  })

  yPos = (doc as any).lastAutoTable.finalY + 10

  // Section 6: Temuan
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('VI. TEMUAN DAN OBSERVASI', 14, yPos)
  yPos += 8

  const temuanSummary = [
    ['Temuan Kritis', walkthrough.temuan_kritis || 0],
    ['Temuan Mayor', walkthrough.temuan_mayor || 0],
    ['Temuan Minor', walkthrough.temuan_minor || 0],
    ['Temuan Observasi', walkthrough.temuan_observasi || 0],
    ['Total Temuan', walkthrough.jumlah_temuan || 0]
  ]

  autoTable(doc, {
    startY: yPos,
    head: [['Kategori', 'Jumlah']],
    body: temuanSummary,
    theme: 'grid',
    styles: { fontSize: 10 },
    headStyles: { fillColor: [217, 83, 79], textColor: 255, fontStyle: 'bold' }
  })

  yPos = (doc as any).lastAutoTable.finalY + 8

  // Detail Temuan
  if (walkthrough.temuan_bahaya && Array.isArray(walkthrough.temuan_bahaya)) {
    const temuanData = walkthrough.temuan_bahaya.map((t: any, idx: number) => [
      idx + 1,
      t.kategori || '-',
      t.deskripsi || '-',
      t.lokasi || '-',
      formatTingkatRisiko(t.tingkat_risiko)
    ])

    if (temuanData.length > 0) {
      checkPageBreak(40)
      doc.setFont('helvetica', 'bold')
      doc.text('Detail Temuan:', 14, yPos)
      yPos += 5

      autoTable(doc, {
        startY: yPos,
        head: [['No', 'Kategori', 'Deskripsi', 'Lokasi', 'Risiko']],
        body: temuanData,
        theme: 'grid',
        styles: { fontSize: 9 },
        headStyles: { fillColor: [91, 192, 222], textColor: 0, fontStyle: 'bold' },
        columnStyles: {
          0: { cellWidth: 10 },
          1: { cellWidth: 25 },
          2: { cellWidth: 60 },
          3: { cellWidth: 40 },
          4: { cellWidth: 25 }
        }
      })

      yPos = (doc as any).lastAutoTable.finalY + 10
    }
  }

  // Section 6B: Foto Temuan
  if (walkthrough.temuan_bahaya && Array.isArray(walkthrough.temuan_bahaya)) {
    const temuanWithPhotos = walkthrough.temuan_bahaya.filter((t: any) => 
      t.foto_urls && Array.isArray(t.foto_urls) && t.foto_urls.length > 0
    )

    if (temuanWithPhotos.length > 0) {
      checkPageBreak(40)
      doc.setFontSize(12)
      doc.setFont('helvetica', 'bold')
      doc.text('DOKUMENTASI FOTO TEMUAN', 14, yPos)
      yPos += 8

      // Loop through each temuan with photos
      for (let temuanIdx = 0; temuanIdx < temuanWithPhotos.length; temuanIdx++) {
        const temuan = temuanWithPhotos[temuanIdx]
        const temuanNo = walkthrough.temuan_bahaya.indexOf(temuan) + 1
        
        checkPageBreak(30)
        doc.setFontSize(10)
        doc.setFont('helvetica', 'bold')
        doc.text(`Temuan #${temuanNo}: ${temuan.deskripsi || 'Tidak ada deskripsi'}`, 14, yPos)
        yPos += 5
        
        doc.setFont('helvetica', 'normal')
        doc.setFontSize(9)
        if (temuan.lokasi) {
          doc.text(`Lokasi: ${temuan.lokasi}`, 14, yPos)
          yPos += 5
        }
        if (temuan.tingkat_risiko) {
          doc.text(`Tingkat Risiko: ${formatTingkatRisiko(temuan.tingkat_risiko)}`, 14, yPos)
          yPos += 5
        }
        yPos += 3

        // Load and add photos for this temuan
        for (let i = 0; i < temuan.foto_urls.length; i++) {
          const photoUrl = temuan.foto_urls[i]
          
          if (!photoUrl) continue
          
          try {
            // Check if we need new page
            checkPageBreak(100)

            doc.setFontSize(8)
            doc.setFont('helvetica', 'italic')
            doc.text(`Foto ${i + 1} dari ${temuan.foto_urls.length}:`, 14, yPos)
            yPos += 5

            // Add image to PDF
            const img = await loadImageForPDF(photoUrl)
            const imgWidth = 180 // Max width in PDF
            const imgHeight = (img.height * imgWidth) / img.width
            const maxHeight = 120 // Max height to avoid too large images

            const finalHeight = imgHeight > maxHeight ? maxHeight : imgHeight
            const finalWidth = imgHeight > maxHeight ? (img.width * maxHeight) / img.height : imgWidth

            // Center the image
            const xOffset = (pageWidth - finalWidth) / 2

            // Detect image format
            const imageFormat = photoUrl.toLowerCase().includes('.png') ? 'PNG' : 'JPEG'
            doc.addImage(photoUrl, imageFormat, xOffset, yPos, finalWidth, finalHeight)
            yPos += finalHeight + 8
          } catch (error) {
            console.error(`Error loading photo ${i + 1} for temuan #${temuanNo}:`, error)
            doc.setFontSize(8)
            doc.setFont('helvetica', 'italic')
            doc.text(`[Foto ${i + 1} tidak dapat dimuat]`, 14, yPos)
            yPos += 8
          }
        }
        yPos += 5
      }
    }
  }

  // Section 7: Action Items
  checkPageBreak(40)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('VII. RENCANA TINDAK LANJUT (ACTION ITEMS)', 14, yPos)
  yPos += 8

  const actionSummary = [
    ['Total Action Items', walkthrough.jumlah_action_item || 0],
    ['Selesai', walkthrough.action_selesai || 0],
    ['In Progress', walkthrough.action_progress || 0],
    ['Belum Mulai', walkthrough.action_belum_mulai || 0]
  ]

  autoTable(doc, {
    startY: yPos,
    head: [['Status', 'Jumlah']],
    body: actionSummary,
    theme: 'grid',
    styles: { fontSize: 10 },
    headStyles: { fillColor: [92, 184, 92], textColor: 255, fontStyle: 'bold' }
  })

  yPos = (doc as any).lastAutoTable.finalY + 8

  // Detail Action Items
  if (walkthrough.action_items && Array.isArray(walkthrough.action_items)) {
    const actionData = walkthrough.action_items.map((a: any, idx: number) => [
      idx + 1,
      a.tindakan || '-',
      a.pic || '-',
      a.target || '-',
      formatActionStatus(a.status)
    ])

    if (actionData.length > 0) {
      checkPageBreak(40)
      doc.setFont('helvetica', 'bold')
      doc.text('Detail Action Items:', 14, yPos)
      yPos += 5

      autoTable(doc, {
        startY: yPos,
        head: [['No', 'Tindakan', 'PIC', 'Target', 'Status']],
        body: actionData,
        theme: 'grid',
        styles: { fontSize: 9 },
        headStyles: { fillColor: [240, 173, 78], textColor: 0, fontStyle: 'bold' },
        columnStyles: {
          0: { cellWidth: 10 },
          1: { cellWidth: 70 },
          2: { cellWidth: 35 },
          3: { cellWidth: 25 },
          4: { cellWidth: 25 }
        }
      })

      yPos = (doc as any).lastAutoTable.finalY + 10
    }
  }

  // Section 8: Dokumentasi Foto Walkthrough
  if (walkthrough.foto_walkthrough && walkthrough.foto_walkthrough.length > 0) {
    checkPageBreak(40)
    doc.setFontSize(12)
    doc.setFont('helvetica', 'bold')
    doc.text('VIII. DOKUMENTASI FOTO WALKTHROUGH', 14, yPos)
    yPos += 8

    doc.setFontSize(10)
    doc.setFont('helvetica', 'normal')
    doc.text(`Total ${walkthrough.foto_walkthrough.length} foto dokumentasi`, 14, yPos)
    yPos += 10

    // Load and add photos to PDF
    for (let i = 0; i < walkthrough.foto_walkthrough.length; i++) {
      const photoUrl = walkthrough.foto_walkthrough[i]
      
      if (!photoUrl) continue
      
      try {
        // Check if we need new page
        checkPageBreak(100)

        doc.setFontSize(9)
        doc.setFont('helvetica', 'italic')
        doc.text(`Foto ${i + 1}:`, 14, yPos)
        yPos += 5

        // Add image to PDF
        const img = await loadImageForPDF(photoUrl)
        const imgWidth = 180 // Max width in PDF
        const imgHeight = (img.height * imgWidth) / img.width
        const maxHeight = 120 // Max height to avoid too large images

        const finalHeight = imgHeight > maxHeight ? maxHeight : imgHeight
        const finalWidth = imgHeight > maxHeight ? (img.width * maxHeight) / img.height : imgWidth

        // Center the image
        const xOffset = (pageWidth - finalWidth) / 2

        // Detect image format
        const imageFormat = photoUrl.toLowerCase().includes('.png') ? 'PNG' : 'JPEG'
        doc.addImage(photoUrl, imageFormat, xOffset, yPos, finalWidth, finalHeight)
        yPos += finalHeight + 10
      } catch (error) {
        console.error(`Error loading photo ${i + 1}:`, error)
        doc.setFontSize(9)
        doc.setFont('helvetica', 'italic')
        doc.text(`[Foto ${i + 1} tidak dapat dimuat]`, 14, yPos)
        yPos += 10
      }
    }
    yPos += 5
  }

  // Section 9: Scoring
  checkPageBreak(50)
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('IX. PENILAIAN DAN SCORING', 14, yPos)
  yPos += 8

  const scoringData = [
    ['Skor Keseluruhan', walkthrough.skor_keseluruhan || 0],
    ['Skor Housekeeping', walkthrough.skor_housekeeping || 0],
    ['Skor APD', walkthrough.skor_apd || 0],
    ['Skor Perilaku', walkthrough.skor_perilaku || 0]
  ]

  autoTable(doc, {
    startY: yPos,
    head: [['Aspek', 'Nilai']],
    body: scoringData,
    theme: 'grid',
    styles: { fontSize: 10 },
    headStyles: { fillColor: [66, 139, 202], textColor: 255, fontStyle: 'bold' }
  })

  yPos = (doc as any).lastAutoTable.finalY + 10

  // Section 10: Ringkasan
  if (walkthrough.ringkasan_observasi) {
    checkPageBreak(30)
    doc.setFontSize(12)
    doc.setFont('helvetica', 'bold')
    doc.text('X. RINGKASAN OBSERVASI', 14, yPos)
    yPos += 8

    doc.setFontSize(10)
    doc.setFont('helvetica', 'normal')
    const ringkasanLines = doc.splitTextToSize(walkthrough.ringkasan_observasi, pageWidth - 28)
    ringkasanLines.forEach((line: string) => {
      checkPageBreak(6)
      doc.text(line, 14, yPos)
      yPos += 5
    })
    yPos += 5
  }

  // Section 11: Rekomendasi
  if (walkthrough.rekomendasi && walkthrough.rekomendasi.length > 0) {
    checkPageBreak(30)
    doc.setFontSize(12)
    doc.setFont('helvetica', 'bold')
    doc.text('XI. REKOMENDASI', 14, yPos)
    yPos += 8

    doc.setFontSize(10)
    doc.setFont('helvetica', 'normal')
    walkthrough.rekomendasi.forEach((item, idx) => {
      checkPageBreak(6)
      doc.text(`${idx + 1}. ${item}`, 14, yPos)
      yPos += 5
    })
    yPos += 10
  }

  // Footer with signatures
  checkPageBreak(40)
  doc.setLineWidth(0.5)
  doc.line(14, yPos, pageWidth - 14, yPos)
  yPos += 10

  const signatureY = yPos
  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  
  // Left signature
  doc.text('Dibuat oleh,', 30, signatureY)
  doc.text('___________________', 20, signatureY + 20)
  doc.text(`${walkthrough.pimpinan_walkthrough || ''}`, 20, signatureY + 25)
  doc.text('Pimpinan Walkthrough', 20, signatureY + 30)

  // Right signature
  doc.text('Disetujui oleh,', pageWidth - 60, signatureY)
  doc.text('___________________', pageWidth - 70, signatureY + 20)
  doc.text('Kepala Departemen K3', pageWidth - 70, signatureY + 30)

  // Page numbers
  const pageCount = (doc as any).internal.getNumberOfPages()
  for (let i = 1; i <= pageCount; i++) {
    doc.setPage(i)
    doc.setFontSize(8)
    doc.text(
      `Halaman ${i} dari ${pageCount}`,
      pageWidth / 2,
      pageHeight - 10,
      { align: 'center' }
    )
  }

  return doc
}

// Helper functions
function formatDate(dateString: string): string {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

function formatJenis(jenis: string | undefined): string {
  const jenisMap: Record<string, string> = {
    'rutin': 'Rutin',
    'insidental': 'Insidental',
    'khusus': 'Khusus'
  }
  return jenisMap[jenis || ''] || '-'
}

function formatStatus(status: string | undefined): string {
  const statusMap: Record<string, string> = {
    'draft': 'Draft',
    'in_progress': 'In Progress',
    'completed': 'Selesai',
    'cancelled': 'Dibatalkan'
  }
  return statusMap[status || ''] || '-'
}

function formatKondisi(kondisi: string | undefined): string {
  const kondisiMap: Record<string, string> = {
    'baik': 'Baik',
    'cukup': 'Cukup',
    'kurang': 'Kurang',
    'buruk': 'Buruk'
  }
  return kondisiMap[kondisi || ''] || '-'
}

function formatTingkatRisiko(risiko: string | undefined): string {
  const risikoMap: Record<string, string> = {
    'kritis': 'Kritis',
    'tinggi': 'Tinggi',
    'sedang': 'Sedang',
    'rendah': 'Rendah'
  }
  return risikoMap[risiko || ''] || '-'
}

function formatActionStatus(status: string | undefined): string {
  const statusMap: Record<string, string> = {
    'belum_mulai': 'Belum Mulai',
    'progress': 'In Progress',
    'selesai': 'Selesai'
  }
  return statusMap[status || ''] || '-'
}

/**
 * Load image for PDF (with CORS support)
 */
function loadImageForPDF(url: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.crossOrigin = 'Anonymous' // Enable CORS
    
    img.onload = () => resolve(img)
    img.onerror = () => reject(new Error('Failed to load image'))
    
    img.src = url
  })
}
