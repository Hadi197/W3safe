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

interface MonitoringData {
  periode: string
  unitName: string
  programs: ProgramData[]
  insidenData: InsidenData[]
  safetyAlertData: SafetyAlertData[]
  rekapK3lData: RekapK3lData[]
  temuanMonitoringData: TemuanMonitoringData[]
  isuStrategisData: IsuStrategisData[]
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

    // Slide 1: Cover
    this.addCoverSlide(data)

    // Slide 2: Program K3 Cards Overview
    this.addProgramCardsSlide(data)

    // Slide 3: Data Insiden Table
    if (data.insidenData.length > 0) {
      this.addInsidenTableSlide(data)
    }

    // Slide 4: Safety Alert Table
    if (data.safetyAlertData.length > 0) {
      this.addSafetyAlertTableSlide(data)
    }

    // Slide 5: Rekap K3L Table
    if (data.rekapK3lData.length > 0) {
      this.addRekapK3lTableSlide(data)
    }

    // Slide 6: Temuan Monitoring Table
    if (data.temuanMonitoringData.length > 0) {
      this.addTemuanMonitoringTableSlide(data)
    }

    // Slide 7: Isu Strategis Table
    if (data.isuStrategisData.length > 0) {
      this.addIsuStrategisTableSlide(data)
    }

    // Slide Terakhir: Summary
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
   * Slide 3: Data Insiden
   */
  private addInsidenTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    slide.addText(`DATA INSIDEN - ${data.periode}`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: '1E3A8A'
    })

    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'TANGGAL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'URAIAN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'LOKASI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'KLASIFIKASI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } }
      ]
    ]

    data.insidenData.slice(0, 10).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 9 } },
        { text: item.tanggal, options: { fontSize: 9 } },
        { text: item.uraian.substring(0, 60) + '...', options: { fontSize: 9 } },
        { text: item.lokasi, options: { fontSize: 9 } },
        { text: item.klasifikasi, options: { fontSize: 9 } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1,
      w: 9.4,
      colW: [0.5, 1.2, 4, 2, 1.7],
      rowH: 0.4,
      fontSize: 10,
      border: { pt: 1, color: 'CCCCCC' },
      valign: 'top'
    })

    if (data.insidenData.length > 10) {
      slide.addText(`Menampilkan 10 dari ${data.insidenData.length} data insiden`, {
        x: 0.5,
        y: 6.5,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 4: Safety Alert
   */
  private addSafetyAlertTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    slide.addText(`SAFETY ALERT - ${data.periode}`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: '1E3A8A'
    })

    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'WHAT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'WHEN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'WHERE', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'FOLLOW UP', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } }
      ]
    ]

    data.safetyAlertData.slice(0, 8).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 9 } },
        { text: (item.what || '').substring(0, 40) + '...', options: { fontSize: 9 } },
        { text: item.when || '', options: { fontSize: 9 } },
        { text: item.where || '', options: { fontSize: 9 } },
        { text: (item.followUp || '').substring(0, 40) + '...', options: { fontSize: 9 } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1,
      w: 9.4,
      colW: [0.5, 3, 1.5, 1.5, 2.9],
      rowH: 0.5,
      fontSize: 10,
      border: { pt: 1, color: 'CCCCCC' },
      valign: 'top'
    })

    if (data.safetyAlertData.length > 8) {
      slide.addText(`Menampilkan 8 dari ${data.safetyAlertData.length} safety alert`, {
        x: 0.5,
        y: 6.5,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 5: Rekap K3L
   */
  private addRekapK3lTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    slide.addText(`REKAP K3L - ${data.periode}`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: '1E3A8A'
    })

    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: 'BRIEFING', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: 'INSPECTION', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: 'TEMUAN', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: 'CLOSED', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } },
        { text: '%', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 9 } }
      ]
    ]

    data.rekapK3lData.slice(0, 12).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 8 } },
        { text: item.unit, options: { fontSize: 8 } },
        { text: item.safety_briefing.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.silent_inspection.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.jumlah_temuan.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.temuan_closed.toString(), options: { fontSize: 8, align: 'center' } },
        { text: item.persentase_penyelesaian, options: { fontSize: 8, align: 'center' } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1,
      w: 9.4,
      colW: [0.5, 3.5, 1, 1.2, 1, 0.8, 0.9],
      rowH: 0.35,
      fontSize: 9,
      border: { pt: 1, color: 'CCCCCC' },
      valign: 'middle'
    })

    if (data.rekapK3lData.length > 12) {
      slide.addText(`Menampilkan 12 dari ${data.rekapK3lData.length} data`, {
        x: 0.5,
        y: 6.5,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 6: Temuan Monitoring
   */
  private addTemuanMonitoringTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    slide.addText(`TEMUAN MONITORING - ${data.periode}`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: '1E3A8A'
    })

    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'MODUL', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'DESKRIPSI', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'STATUS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } }
      ]
    ]

    data.temuanMonitoringData.slice(0, 10).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 9 } },
        { text: item.modul, options: { fontSize: 9 } },
        { text: item.unit, options: { fontSize: 9 } },
        { text: item.deskripsi.substring(0, 50) + '...', options: { fontSize: 9 } },
        { text: item.status, options: { fontSize: 9 } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1,
      w: 9.4,
      colW: [0.5, 1.8, 2, 4, 1.1],
      rowH: 0.4,
      fontSize: 10,
      border: { pt: 1, color: 'CCCCCC' },
      valign: 'top'
    })

    if (data.temuanMonitoringData.length > 10) {
      slide.addText(`Menampilkan 10 dari ${data.temuanMonitoringData.length} temuan`, {
        x: 0.5,
        y: 6.5,
        w: 9,
        h: 0.3,
        fontSize: 10,
        color: '6B7280',
        italic: true
      })
    }
  }

  /**
   * Slide 7: Isu Strategis
   */
  private addIsuStrategisTableSlide(data: MonitoringData): void {
    const slide = this.pptx.addSlide()

    slide.addText(`ISU STRATEGIS K3L - ${data.periode}`, {
      x: 0.5,
      y: 0.3,
      w: 9,
      h: 0.5,
      fontSize: 24,
      bold: true,
      color: '1E3A8A'
    })

    const rows: any[] = [
      [
        { text: 'NO', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'UNIT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'ISU STRATEGIS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'RENCANA TINDAK LANJUT', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } },
        { text: 'STATUS', options: { bold: true, fill: '1E40AF', color: 'FFFFFF', fontSize: 10 } }
      ]
    ]

    data.isuStrategisData.slice(0, 10).forEach(item => {
      rows.push([
        { text: item.no.toString(), options: { fontSize: 9 } },
        { text: item.unit, options: { fontSize: 9 } },
        { text: item.isu_strategis.substring(0, 40) + '...', options: { fontSize: 9 } },
        { text: item.rencana_tindak_lanjut.substring(0, 40) + '...', options: { fontSize: 9 } },
        { text: item.status, options: { fontSize: 9 } }
      ])
    })

    slide.addTable(rows, {
      x: 0.3,
      y: 1,
      w: 9.4,
      colW: [0.5, 1.5, 3, 3.2, 1.2],
      rowH: 0.45,
      fontSize: 10,
      border: { pt: 1, color: 'CCCCCC' },
      valign: 'top'
    })

    if (data.isuStrategisData.length > 10) {
      slide.addText(`Menampilkan 10 dari ${data.isuStrategisData.length} isu strategis`, {
        x: 0.5,
        y: 6.5,
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
