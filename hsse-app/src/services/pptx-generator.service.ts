import PptxGenJS from 'pptxgenjs'

interface ProgramData {
  name: string
  icon: string
  realization: number | string
  target: string
}

interface InsidenData {
  no: number
  tanggal: string
  uraian: string
  faktor_penyebab: string
  lokasi: string
  klasifikasi: string
  tingkat_keparahan: string
}

interface SafetyAlertData {
  no: number
  what: string
  when: string
  where: string
  who: string
  why: string
  how: string
  howMuch: any
  followUp: string
  lessonLearned: any
  sumber: string
}

interface RekapK3lData {
  no: number
  unit: string
  safety_briefing: number
  silent_inspection: number
  jumlah_temuan: number
  temuan_closed: number
  persentase_penyelesaian: string
  unsafe_act_condition: number
  jumlah_unsafe: number
  unsafe_closed: number
  persentase_unsafe: string
}

interface TemuanMonitoringData {
  no: number
  modul: string
  unit: string
  lokasi: string
  deskripsi: string
  klasifikasi: string
  status: string
  target_selesai: string
  pic: string
}

interface IsuStrategisData {
  no: number
  unit: string
  isu_strategis: string
  uraian: string
  rencana_tindak_lanjut: string
  pic: string
  target_penyelesaian: string
  status: string
}

interface ManagementWalkthroughData {
  no: number
  tanggal: string
  unit: string
  area: string
  pemimpin: string
  jumlah_temuan: number
  temuan_critical: number
  temuan_major: number
  temuan_minor: number
  status_tindak_lanjut: string
}

interface MonitoringData {
  periode: string
  unitName: string
  programs: ProgramData[]
  insidenData: InsidenData[]
  safetyAlertData: SafetyAlertData[]
  rekapK3lData: RekapK3lData[]
  temuanMonitoringData: TemuanMonitoringData[]
  isuStrategisData: IsuStrategisData[]
  managementWalkthroughData: ManagementWalkthroughData[]
  lastUpdate: string
}

export class PptxGeneratorService {
  private pptx: PptxGenJS

  constructor() {
    this.pptx = new PptxGenJS()
  }

  /**
   * Generate PowerPoint untuk Monitoring Realisasi K3
   */
  generateMonitoringK3Presentation(data: MonitoringData): void {
    // Set properties
    this.pptx.author = 'HSSE App'
    this.pptx.company = 'PT Pelindo'
    this.pptx.subject = 'Monitoring Realisasi Program K3'
    this.pptx.title = `Monitoring K3 - ${data.periode}`

    // Slide Cover: Halaman Judul
    this.addCoverSlide(data)

    // Slide 1: Monitoring Realisasi K3 (Program Cards Grid 5x2)
    this.addProgramCardsSlide(data)

    // Slide 2: Tabel Data Insiden
    this.addInsidenTableSlide(data)

    // Slide 3: Safety Alert
    this.addSafetyAlertTableSlide(data)

    // Slide 4: Rekap Implementasi K3L
    this.addRekapK3lTableSlide(data)

    // Slide 5: Monitoring Temuan Audit, Inspeksi & Patrol
    this.addTemuanMonitoringTableSlide(data)

    // Slide 6: Isu Strategis K3L
    this.addIsuStrategisTableSlide(data)

    // Slide 7: Laporan Management Walkthrough
    this.addManagementWalkthroughTableSlide(data)

    // Slide Terakhir: Summary/Penutup
    this.addSummarySlide(data)

    // Download
    const filename = `Monitoring_K3_${data.unitName.replace(/\s+/g, '_')}_${data.periode.replace(/\s+/g, '_')}.pptx`
    this.pptx.writeFile({ fileName: filename })
  }

  /**
   * Slide 1: Cover
   */
  private addCoverSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background
    slide.background = { color: '1E3A8A' }

    // Title
    slide.addText('MONITORING REALISASI\nPROGRAM K3', {
      x: 0.5,
      y: 1.5,
      w: 9,
      h: 1.5,
      fontSize: 44,
      bold: true,
      color: 'FFFFFF',
      align: 'center',
      valign: 'middle'
    })

    // Subtitle
    slide.addText(data.unitName, {
      x: 0.5,
      y: 3.2,
      w: 9,
      h: 0.6,
      fontSize: 28,
      color: 'FFFFFF',
      align: 'center'
    })

    slide.addText(`Periode: ${data.periode}`, {
      x: 0.5,
      y: 3.9,
      w: 9,
      h: 0.5,
      fontSize: 20,
      color: 'BFDBFE',
      align: 'center'
    })

    // Footer
    slide.addText(`Generated: ${data.lastUpdate}`, {
      x: 0.5,
      y: 6.8,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: 'BFDBFE',
      align: 'center'
    })
  }

  /**
   * Slide 2: Program Cards Overview - Grid Layout
   */
  private addProgramCardsSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background
    slide.background = { color: '2563EB' }

    // Title
    slide.addText(`Monitoring Realisasi K3 (s.d ${data.periode})`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'center'
    })

    slide.addText(`Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.85,
      w: 9,
      h: 0.3,
      fontSize: 14,
      color: 'DBEAFE',
      align: 'center'
    })

    // Grid layout: 5 columns x 2 rows
    const cardWidth = 1.7
    const cardHeight = 1.4
    const startX = 0.5
    const startY = 1.3
    const gapX = 0.1
    const gapY = 0.15

    data.programs.forEach((program, index) => {
      const col = index % 5
      const row = Math.floor(index / 5)
      const x = startX + col * (cardWidth + gapX)
      const y = startY + row * (cardHeight + gapY)

      // Card background (white rounded box)
      slide.addShape(this.pptx.ShapeType.roundRect, {
        x,
        y,
        w: cardWidth,
        h: cardHeight,
        fill: { color: 'FFFFFF' },
        line: { color: 'E5E7EB', width: 1 }
      })

      // Icon
      slide.addText(program.icon, {
        x,
        y: y + 0.15,
        w: cardWidth,
        h: 0.35,
        fontSize: 32,
        align: 'center',
        valign: 'middle'
      })

      // Program name
      slide.addText(program.name, {
        x,
        y: y + 0.52,
        w: cardWidth,
        h: 0.3,
        fontSize: 10,
        bold: true,
        color: '1E40AF',
        align: 'center',
        valign: 'top'
      })

      // Realization box (blue background)
      slide.addShape(this.pptx.ShapeType.rect, {
        x: x + 0.2,
        y: y + 0.8,
        w: cardWidth - 0.4,
        h: 0.35,
        fill: { color: '1E40AF' },
        line: { type: 'none' }
      })

      // Realization value
      slide.addText(program.realization.toString(), {
        x: x + 0.2,
        y: y + 0.8,
        w: cardWidth - 0.4,
        h: 0.35,
        fontSize: 20,
        bold: true,
        color: 'FFFFFF',
        align: 'center',
        valign: 'middle'
      })

      // Target text
      slide.addText(program.target, {
        x,
        y: y + 1.18,
        w: cardWidth,
        h: 0.18,
        fontSize: 7,
        color: '6B7280',
        align: 'center',
        valign: 'top'
      })
    })
  }

  /**
   * Slide 2: Tabel Data Insiden
   */
  private addInsidenTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('TABEL DATA INSIDEN', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (data.insidenData.length === 0) {
      slide.addText('Tidak ada data insiden pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } },
        { text: 'TANGGAL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } },
        { text: 'URAIAN KEJADIAN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } },
        { text: 'LOKASI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } },
        { text: 'KLASIFIKASI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } }
      ]
    ]

    // Ambil maksimal 12 data untuk muat dalam slide
    data.insidenData.slice(0, 12).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 9, align: 'center' } },
        { text: item.tanggal, options: { fontSize: 9 } },
        { text: item.uraian.substring(0, 80) + (item.uraian.length > 80 ? '...' : ''), options: { fontSize: 9 } },
        { text: item.lokasi, options: { fontSize: 9 } },
        { text: item.klasifikasi, options: { fontSize: 9, align: 'center' } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1.3,
      w: 9.4,
      colW: [0.4, 1.0, 4.5, 2.0, 1.5],
      rowH: 0.35,
      fontSize: 9,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'top',
      margin: 0.05
    })

    // Footer note jika data lebih dari 12
    if (data.insidenData.length > 12) {
      slide.addText(`Menampilkan 12 dari ${data.insidenData.length} data insiden`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 3: Safety Alert
   */
  private addSafetyAlertTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('SAFETY ALERT', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (data.safetyAlertData.length === 0) {
      slide.addText('Tidak ada safety alert pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data (5W1H format)
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10, align: 'center' } },
        { text: 'WHAT\n(Apa)', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'WHEN\n(Kapan)', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'WHERE\n(Dimana)', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'WHY\n(Mengapa)', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'FOLLOW UP', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } }
      ]
    ]

    // Ambil maksimal 10 data
    data.safetyAlertData.slice(0, 10).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 8, align: 'center' } },
        { text: (item.what || '').substring(0, 60) + ((item.what || '').length > 60 ? '...' : ''), options: { fontSize: 8 } },
        { text: item.when || '-', options: { fontSize: 8 } },
        { text: item.where || '-', options: { fontSize: 8 } },
        { text: (item.why || '').substring(0, 50) + ((item.why || '').length > 50 ? '...' : ''), options: { fontSize: 8 } },
        { text: (item.followUp || '').substring(0, 50) + ((item.followUp || '').length > 50 ? '...' : ''), options: { fontSize: 8 } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1.3,
      w: 9.4,
      colW: [0.4, 2.2, 1.2, 1.2, 2.0, 2.4],
      rowH: 0.4,
      fontSize: 8,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'top',
      margin: 0.05
    })

    // Footer note
    if (data.safetyAlertData.length > 10) {
      slide.addText(`Menampilkan 10 dari ${data.safetyAlertData.length} safety alert`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 4: Rekap Implementasi K3L
   */
  private addRekapK3lTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('REKAP IMPLEMENTASI K3L', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (data.rekapK3lData.length === 0) {
      slide.addText('Tidak ada data rekap K3L pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data - sesuai dengan tampilan web
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', rowspan: 2 } },
        { text: 'UNIT/AREA', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', rowspan: 2 } },
        { text: 'SAFETY\nBRIEFING', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', rowspan: 2 } },
        { text: 'SILENT\nINSPECTION', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', rowspan: 2 } },
        { text: 'TEMUAN INSPEKSI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', colspan: 3 } },
        { text: 'UNSAFE ACT/CONDITION', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center', colspan: 3 } }
      ],
      [
        { text: 'TOTAL', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } },
        { text: 'CLOSED', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } },
        { text: '%', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } },
        { text: 'TOTAL', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } },
        { text: 'CLOSED', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } },
        { text: '%', options: { bold: true, fill: '3B82F6', color: 'FFFFFF', fontSize: 7, align: 'center' } }
      ]
    ]

    // Ambil maksimal 14 data agar muat
    data.rekapK3lData.slice(0, 14).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.unit, options: { fontSize: 7 } },
        { text: item.safety_briefing.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.silent_inspection.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.jumlah_temuan.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.temuan_closed.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.persentase_penyelesaian, options: { fontSize: 7, align: 'center', bold: true } },
        { text: item.jumlah_unsafe.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.unsafe_closed.toString(), options: { fontSize: 7, align: 'center' } },
        { text: item.persentase_unsafe, options: { fontSize: 7, align: 'center', bold: true } }
      ])
    })

    slide.addTable(rows, {
      x: 0.2,
      y: 1.3,
      w: 9.6,
      colW: [0.3, 2.5, 0.8, 0.8, 0.7, 0.7, 0.6, 0.7, 0.7, 0.6],
      rowH: 0.3,
      fontSize: 7,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'middle',
      margin: 0.03
    })

    // Footer note
    if (data.rekapK3lData.length > 14) {
      slide.addText(`Menampilkan 14 dari ${data.rekapK3lData.length} unit`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 5: Monitoring Temuan Audit, Inspeksi & Patrol
   */
  private addTemuanMonitoringTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('MONITORING TEMUAN AUDIT, INSPEKSI & PATROL', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 22,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (data.temuanMonitoringData.length === 0) {
      slide.addText('Tidak ada temuan monitoring pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'MODUL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'DESKRIPSI TEMUAN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'KLASIFIKASI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'STATUS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } }
      ]
    ]

    // Ambil maksimal 12 data
    data.temuanMonitoringData.slice(0, 12).forEach(item => {
      // Warna status badge
      let statusColor = 'F3F4F6'
      if (item.status.toLowerCase().includes('selesai') || item.status.toLowerCase().includes('closed')) {
        statusColor = 'D1FAE5' // Green
      } else if (item.status.toLowerCase().includes('proses')) {
        statusColor = 'FEF3C7' // Yellow
      } else if (item.status.toLowerCase().includes('pending')) {
        statusColor = 'FEE2E2' // Red
      }

      rows.push([
        { text: item.no.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.modul, options: { fontSize: 8 } },
        { text: item.unit, options: { fontSize: 8 } },
        { text: item.deskripsi.substring(0, 70) + (item.deskripsi.length > 70 ? '...' : ''), options: { fontSize: 8 } },
        { text: item.klasifikasi, options: { fontSize: 8, align: 'center' } },
        { text: item.status, options: { fontSize: 8, align: 'center', fill: statusColor, bold: true } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1.3,
      w: 9.4,
      colW: [0.4, 1.3, 1.5, 3.5, 1.2, 1.5],
      rowH: 0.35,
      fontSize: 8,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'top',
      margin: 0.05
    })

    // Footer note
    if (data.temuanMonitoringData.length > 12) {
      slide.addText(`Menampilkan 12 dari ${data.temuanMonitoringData.length} temuan`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 6: Isu Strategis K3L
   */
  private addIsuStrategisTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('ISU STRATEGIS K3L', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (data.isuStrategisData.length === 0) {
      slide.addText('Tidak ada isu strategis K3L pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'ISU STRATEGIS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'RENCANA TINDAK LANJUT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'PIC', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'STATUS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } }
      ]
    ]

    // Ambil maksimal 11 data
    data.isuStrategisData.slice(0, 11).forEach(item => {
      // Warna status badge
      let statusColor = 'F3F4F6'
      if (item.status.toLowerCase().includes('selesai') || item.status.toLowerCase().includes('closed')) {
        statusColor = 'D1FAE5' // Green
      } else if (item.status.toLowerCase().includes('proses')) {
        statusColor = 'FEF3C7' // Yellow
      } else if (item.status.toLowerCase().includes('pending')) {
        statusColor = 'FEE2E2' // Red
      }

      rows.push([
        { text: item.no.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.unit, options: { fontSize: 8 } },
        { text: item.isu_strategis.substring(0, 50) + (item.isu_strategis.length > 50 ? '...' : ''), options: { fontSize: 8 } },
        { text: item.rencana_tindak_lanjut.substring(0, 50) + (item.rencana_tindak_lanjut.length > 50 ? '...' : ''), options: { fontSize: 8 } },
        { text: item.pic, options: { fontSize: 8 } },
        { text: item.status, options: { fontSize: 8, align: 'center', fill: statusColor, bold: true } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1.3,
      w: 9.4,
      colW: [0.4, 1.3, 2.5, 2.5, 1.3, 1.4],
      rowH: 0.4,
      fontSize: 8,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'top',
      margin: 0.05
    })

    // Footer note
    if (data.isuStrategisData.length > 11) {
      slide.addText(`Menampilkan 11 dari ${data.isuStrategisData.length} isu strategis`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 7: Laporan Management Walkthrough
   */
  private addManagementWalkthroughTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background putih
    slide.background = { color: 'FFFFFF' }

    // Title dengan background biru
    slide.addShape(this.pptx.ShapeType.rect, {
      x: 0,
      y: 0,
      w: '100%',
      h: 0.7,
      fill: { color: '2563EB' }
    })

    slide.addText('LAPORAN MANAGEMENT WALKTHROUGH', {
      x: 0.5,
      y: 0.15,
      w: 9,
      h: 0.4,
      fontSize: 24,
      bold: true,
      color: 'FFFFFF',
      align: 'left'
    })

    // Subtitle periode
    slide.addText(`Periode: ${data.periode} | Unit: ${data.unitName}`, {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 0.3,
      fontSize: 12,
      color: '6B7280',
      align: 'left'
    })

    // Jika tidak ada data
    if (!data.managementWalkthroughData || data.managementWalkthroughData.length === 0) {
      slide.addText('Tidak ada laporan management walkthrough pada periode ini', {
        x: 1,
        y: 3,
        w: 8,
        h: 1,
        fontSize: 16,
        color: '9CA3AF',
        align: 'center',
        valign: 'middle',
        italic: true
      })
      return
    }

    // Table header dan data
    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'TANGGAL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'AREA', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'PEMIMPIN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'TEMUAN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } },
        { text: 'CRITICAL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center' } },
        { text: 'MAJOR', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center' } },
        { text: 'MINOR', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 8, align: 'center' } },
        { text: 'STATUS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9, align: 'center' } }
      ]
    ]

    // Ambil maksimal 12 data
    data.managementWalkthroughData.slice(0, 12).forEach(item => {
      // Warna status badge
      let statusColor = 'F3F4F6'
      if (item.status_tindak_lanjut.toLowerCase().includes('selesai') || item.status_tindak_lanjut.toLowerCase().includes('closed')) {
        statusColor = 'D1FAE5' // Green
      } else if (item.status_tindak_lanjut.toLowerCase().includes('proses')) {
        statusColor = 'FEF3C7' // Yellow
      } else if (item.status_tindak_lanjut.toLowerCase().includes('pending')) {
        statusColor = 'FEE2E2' // Red
      }

      rows.push([
        { text: item.no.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.tanggal, options: { fontSize: 8, align: 'center' } },
        { text: item.unit, options: { fontSize: 8 } },
        { text: item.area, options: { fontSize: 8 } },
        { text: item.pemimpin, options: { fontSize: 8 } },
        { text: item.jumlah_temuan.toString(), options: { fontSize: 8, align: 'center', bold: true } },
        { text: item.temuan_critical.toString(), options: { fontSize: 8, align: 'center', fill: item.temuan_critical > 0 ? 'FEE2E2' : 'F3F4F6' } },
        { text: item.temuan_major.toString(), options: { fontSize: 8, align: 'center', fill: item.temuan_major > 0 ? 'FEF3C7' : 'F3F4F6' } },
        { text: item.temuan_minor.toString(), options: { fontSize: 8, align: 'center', fill: item.temuan_minor > 0 ? 'DBEAFE' : 'F3F4F6' } },
        { text: item.status_tindak_lanjut, options: { fontSize: 8, align: 'center', fill: statusColor, bold: true } }
      ])
    })

    slide.addTable(rows, {
      x: 0.2,
      y: 1.3,
      w: 9.6,
      colW: [0.4, 1.0, 1.5, 1.5, 1.5, 0.8, 0.7, 0.7, 0.7, 1.2],
      rowH: 0.35,
      fontSize: 8,
      border: { pt: 1, color: 'D1D5DB' },
      valign: 'middle',
      margin: 0.05
    })

    // Footer note
    if (data.managementWalkthroughData.length > 12) {
      slide.addText(`Menampilkan 12 dari ${data.managementWalkthroughData.length} laporan`, {
        x: 0.5,
        y: 6.7,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide Summary
   */
  private addSummarySlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    // Background
    slide.background = { color: 'F3F4F6' }

    // Title
    slide.addText('KESIMPULAN', {
      x: 0.5,
      y: 1,
      w: 9,
      h: 0.8,
      fontSize: 36,
      bold: true,
      color: '1E3A8A',
      align: 'center'
    })

    // Total data
    const summaryText = [
      `Total Program K3: ${data.programs.length}`,
      `Data Insiden: ${data.insidenData.length}`,
      `Safety Alert: ${data.safetyAlertData.length}`,
      `Rekap K3L: ${data.rekapK3lData.length} kegiatan`,
      `Temuan Monitoring: ${data.temuanMonitoringData.length}`,
      `Isu Strategis: ${data.isuStrategisData.length}`,
      ``,
      `Periode: ${data.periode}`,
      `Unit: ${data.unitName}`
    ]

    slide.addText(summaryText.join('\n'), {
      x: 1.5,
      y: 2.5,
      w: 7,
      h: 3,
      fontSize: 18,
      color: '374151',
      align: 'left',
      valign: 'top',
      lineSpacing: 28
    })

    // Footer
    slide.addText('Terima kasih', {
      x: 0.5,
      y: 6,
      w: 9,
      h: 0.6,
      fontSize: 24,
      bold: true,
      color: '1E3A8A',
      align: 'center'
    })

    slide.addText('HSSE Management System', {
      x: 0.5,
      y: 6.5,
      w: 9,
      h: 0.4,
      fontSize: 14,
      color: '6B7280',
      align: 'center'
    })
  }
}
