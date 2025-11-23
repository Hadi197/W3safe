export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      areas: {
        Row: {
          aktif: boolean
          created_at: string | null
          deskripsi: string | null
          id: string
          kode_area: string
          nama_area: string
          updated_at: string | null
          wilayah_id: string
        }
        Insert: {
          aktif?: boolean
          created_at?: string | null
          deskripsi?: string | null
          id?: string
          kode_area: string
          nama_area: string
          updated_at?: string | null
          wilayah_id: string
        }
        Update: {
          aktif?: boolean
          created_at?: string | null
          deskripsi?: string | null
          id?: string
          kode_area?: string
          nama_area?: string
          updated_at?: string | null
          wilayah_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "areas_wilayah_id_fkey"
            columns: ["wilayah_id"]
            isOneToOne: false
            referencedRelation: "wilayah"
            referencedColumns: ["id"]
          },
        ]
      }
      management_walkthrough: {
        Row: {
          action_belum_mulai: number | null
          action_items: Json | null
          action_progress: number | null
          action_selesai: number | null
          anggota_tim: Json | null
          apd_digunakan_benar: boolean | null
          apd_kondisi_baik: boolean | null
          apd_tersedia: boolean | null
          apd_tidak_sesuai: Json | null
          approved_at: string | null
          approved_by: string | null
          area_ditutup: Json | null
          area_excellent: Json | null
          area_inspeksi: string | null
          area_non_compliance: Json | null
          catatan_khusus: string | null
          created_at: string | null
          created_by: string | null
          departemen: string | null
          dokumen_pendukung: Json | null
          feedback_pekerja: Json | null
          fokus_area: Json | null
          foto_walkthrough: Json | null
          id: string
          jenis_walkthrough: string | null
          jumlah_action_item: number | null
          jumlah_pekerja_diwawancara: number | null
          jumlah_temuan: number | null
          jumlah_tim: number | null
          kepatuhan_apd: number | null
          kondisi_akses_jalan: string | null
          kondisi_housekeeping: string | null
          kondisi_pencahayaan: string | null
          kondisi_ventilasi: string | null
          nomor_walkthrough: string
          pekerja_aware_prosedur: boolean | null
          pekerja_diamati: number | null
          pekerja_teladan: Json | null
          pekerjaan_dihentikan: Json | null
          pelanggaran_peraturan: Json | null
          pelanggaran_prosedur: Json | null
          perilaku_aman: number | null
          perilaku_tidak_aman: number | null
          perilaku_tidak_aman_detail: Json | null
          perlu_follow_up: boolean | null
          pimpinan_walkthrough: string
          praktek_baik: Json | null
          rekomendasi: Json | null
          ringkasan_observasi: string | null
          saran_pekerja: Json | null
          sketsa_lokasi_url: string | null
          skor_apd: number | null
          skor_housekeeping: number | null
          skor_keseluruhan: number | null
          skor_perilaku: number | null
          status: string | null
          status_follow_up: string | null
          tanggal_follow_up: string | null
          tanggal_walkthrough: string
          temuan_bahaya: Json | null
          temuan_kritis: number | null
          temuan_mayor: number | null
          temuan_minor: number | null
          temuan_observasi: number | null
          tindakan_segera: Json | null
          tingkat_urgensi: string | null
          tujuan_walkthrough: string | null
          unit_id: string | null
          updated_at: string | null
          video_url: string | null
          waktu_mulai: string | null
          waktu_selesai: string | null
        }
        Insert: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          anggota_tim?: Json | null
          apd_digunakan_benar?: boolean | null
          apd_kondisi_baik?: boolean | null
          apd_tersedia?: boolean | null
          apd_tidak_sesuai?: Json | null
          approved_at?: string | null
          approved_by?: string | null
          area_ditutup?: Json | null
          area_excellent?: Json | null
          area_inspeksi?: string | null
          area_non_compliance?: Json | null
          catatan_khusus?: string | null
          created_at?: string | null
          created_by?: string | null
          departemen?: string | null
          dokumen_pendukung?: Json | null
          feedback_pekerja?: Json | null
          fokus_area?: Json | null
          foto_walkthrough?: Json | null
          id?: string
          jenis_walkthrough?: string | null
          jumlah_action_item?: number | null
          jumlah_pekerja_diwawancara?: number | null
          jumlah_temuan?: number | null
          jumlah_tim?: number | null
          kepatuhan_apd?: number | null
          kondisi_akses_jalan?: string | null
          kondisi_housekeeping?: string | null
          kondisi_pencahayaan?: string | null
          kondisi_ventilasi?: string | null
          nomor_walkthrough: string
          pekerja_aware_prosedur?: boolean | null
          pekerja_diamati?: number | null
          pekerja_teladan?: Json | null
          pekerjaan_dihentikan?: Json | null
          pelanggaran_peraturan?: Json | null
          pelanggaran_prosedur?: Json | null
          perilaku_aman?: number | null
          perilaku_tidak_aman?: number | null
          perilaku_tidak_aman_detail?: Json | null
          perlu_follow_up?: boolean | null
          pimpinan_walkthrough: string
          praktek_baik?: Json | null
          rekomendasi?: Json | null
          ringkasan_observasi?: string | null
          saran_pekerja?: Json | null
          sketsa_lokasi_url?: string | null
          skor_apd?: number | null
          skor_housekeeping?: number | null
          skor_keseluruhan?: number | null
          skor_perilaku?: number | null
          status?: string | null
          status_follow_up?: string | null
          tanggal_follow_up?: string | null
          tanggal_walkthrough: string
          temuan_bahaya?: Json | null
          temuan_kritis?: number | null
          temuan_mayor?: number | null
          temuan_minor?: number | null
          temuan_observasi?: number | null
          tindakan_segera?: Json | null
          tingkat_urgensi?: string | null
          tujuan_walkthrough?: string | null
          unit_id?: string | null
          updated_at?: string | null
          video_url?: string | null
          waktu_mulai?: string | null
          waktu_selesai?: string | null
        }
        Update: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          anggota_tim?: Json | null
          apd_digunakan_benar?: boolean | null
          apd_kondisi_baik?: boolean | null
          apd_tersedia?: boolean | null
          apd_tidak_sesuai?: Json | null
          approved_at?: string | null
          approved_by?: string | null
          area_ditutup?: Json | null
          area_excellent?: Json | null
          area_inspeksi?: string | null
          area_non_compliance?: Json | null
          catatan_khusus?: string | null
          created_at?: string | null
          created_by?: string | null
          departemen?: string | null
          dokumen_pendukung?: Json | null
          feedback_pekerja?: Json | null
          fokus_area?: Json | null
          foto_walkthrough?: Json | null
          id?: string
          jenis_walkthrough?: string | null
          jumlah_action_item?: number | null
          jumlah_pekerja_diwawancara?: number | null
          jumlah_temuan?: number | null
          jumlah_tim?: number | null
          kepatuhan_apd?: number | null
          kondisi_akses_jalan?: string | null
          kondisi_housekeeping?: string | null
          kondisi_pencahayaan?: string | null
          kondisi_ventilasi?: string | null
          nomor_walkthrough?: string
          pekerja_aware_prosedur?: boolean | null
          pekerja_diamati?: number | null
          pekerja_teladan?: Json | null
          pekerjaan_dihentikan?: Json | null
          pelanggaran_peraturan?: Json | null
          pelanggaran_prosedur?: Json | null
          perilaku_aman?: number | null
          perilaku_tidak_aman?: number | null
          perilaku_tidak_aman_detail?: Json | null
          perlu_follow_up?: boolean | null
          pimpinan_walkthrough?: string
          praktek_baik?: Json | null
          rekomendasi?: Json | null
          ringkasan_observasi?: string | null
          saran_pekerja?: Json | null
          sketsa_lokasi_url?: string | null
          skor_apd?: number | null
          skor_housekeeping?: number | null
          skor_keseluruhan?: number | null
          skor_perilaku?: number | null
          status?: string | null
          status_follow_up?: string | null
          tanggal_follow_up?: string | null
          tanggal_walkthrough?: string
          temuan_bahaya?: Json | null
          temuan_kritis?: number | null
          temuan_mayor?: number | null
          temuan_minor?: number | null
          temuan_observasi?: number | null
          tindakan_segera?: Json | null
          tingkat_urgensi?: string | null
          tujuan_walkthrough?: string | null
          unit_id?: string | null
          updated_at?: string | null
          video_url?: string | null
          waktu_mulai?: string | null
          waktu_selesai?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_management_walkthrough_unit"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
        ]
      }
      master_pegawai: {
        Row: {
          alamat: string | null
          created_at: string | null
          created_by: string | null
          email: string | null
          id: string
          jabatan: string
          nama: string
          nipp: string
          no_telepon: string | null
          status: string | null
          tanggal_lahir: string | null
          unit_kerja: string
          updated_at: string | null
        }
        Insert: {
          alamat?: string | null
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          id?: string
          jabatan: string
          nama: string
          nipp: string
          no_telepon?: string | null
          status?: string | null
          tanggal_lahir?: string | null
          unit_kerja: string
          updated_at?: string | null
        }
        Update: {
          alamat?: string | null
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          id?: string
          jabatan?: string
          nama?: string
          nipp?: string
          no_telepon?: string | null
          status?: string | null
          tanggal_lahir?: string | null
          unit_kerja?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      master_pelabuhan: {
        Row: {
          aktif: boolean
          area_id: string
          created_at: string | null
          id: string
          unit_id: string
          updated_at: string | null
          wilayah_id: string
        }
        Insert: {
          aktif?: boolean
          area_id: string
          created_at?: string | null
          id?: string
          unit_id: string
          updated_at?: string | null
          wilayah_id: string
        }
        Update: {
          aktif?: boolean
          area_id?: string
          created_at?: string | null
          id?: string
          unit_id?: string
          updated_at?: string | null
          wilayah_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "master_pelabuhan_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "master_pelabuhan_unit_id_fkey"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "master_pelabuhan_wilayah_id_fkey"
            columns: ["wilayah_id"]
            isOneToOne: false
            referencedRelation: "wilayah"
            referencedColumns: ["id"]
          },
        ]
      }
      pegawai: {
        Row: {
          created_at: string | null
          email: string
          id: string
          jabatan: string | null
          nama_lengkap: string
          nip: string
          phone: string | null
          photo_url: string | null
          role: string
          status: string
          tanggal_bergabung: string | null
          unit_id: string | null
          updated_at: string | null
          wilayah_id: string | null
        }
        Insert: {
          created_at?: string | null
          email: string
          id?: string
          jabatan?: string | null
          nama_lengkap: string
          nip: string
          phone?: string | null
          photo_url?: string | null
          role?: string
          status?: string
          tanggal_bergabung?: string | null
          unit_id?: string | null
          updated_at?: string | null
          wilayah_id?: string | null
        }
        Update: {
          created_at?: string | null
          email?: string
          id?: string
          jabatan?: string | null
          nama_lengkap?: string
          nip?: string
          phone?: string | null
          photo_url?: string | null
          role?: string
          status?: string
          tanggal_bergabung?: string | null
          unit_id?: string | null
          updated_at?: string | null
          wilayah_id?: string | null
        }
        Relationships: []
      }
      safety_briefing: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          area_briefing: string | null
          catatan: string | null
          created_at: string | null
          created_by: string
          foto_dokumentasi: string[] | null
          id: string
          inspector_id: string | null
          jenis_briefing: string | null
          jumlah_peserta: number | null
          kesimpulan: string | null
          lampiran_url: string | null
          lokasi: string | null
          materi: string | null
          materi_briefing: string | null
          peserta_ids: Json | null
          petugas_id: string
          poin_poin_pembahasan: Json | null
          status: string
          tanggal: string
          temuan: string | null
          tindak_lanjut: string | null
          topik: string
          topik_briefing: string | null
          unit_id: string | null
          updated_at: string | null
          waktu_mulai: string
          waktu_selesai: string | null
          wilayah_id: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          area_briefing?: string | null
          catatan?: string | null
          created_at?: string | null
          created_by: string
          foto_dokumentasi?: string[] | null
          id?: string
          inspector_id?: string | null
          jenis_briefing?: string | null
          jumlah_peserta?: number | null
          kesimpulan?: string | null
          lampiran_url?: string | null
          lokasi?: string | null
          materi?: string | null
          materi_briefing?: string | null
          peserta_ids?: Json | null
          petugas_id: string
          poin_poin_pembahasan?: Json | null
          status?: string
          tanggal: string
          temuan?: string | null
          tindak_lanjut?: string | null
          topik: string
          topik_briefing?: string | null
          unit_id?: string | null
          updated_at?: string | null
          waktu_mulai: string
          waktu_selesai?: string | null
          wilayah_id?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          area_briefing?: string | null
          catatan?: string | null
          created_at?: string | null
          created_by?: string
          foto_dokumentasi?: string[] | null
          id?: string
          inspector_id?: string | null
          jenis_briefing?: string | null
          jumlah_peserta?: number | null
          kesimpulan?: string | null
          lampiran_url?: string | null
          lokasi?: string | null
          materi?: string | null
          materi_briefing?: string | null
          peserta_ids?: Json | null
          petugas_id?: string
          poin_poin_pembahasan?: Json | null
          status?: string
          tanggal?: string
          temuan?: string | null
          tindak_lanjut?: string | null
          topik?: string
          topik_briefing?: string | null
          unit_id?: string | null
          updated_at?: string | null
          waktu_mulai?: string
          waktu_selesai?: string | null
          wilayah_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "safety_briefing_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "safety_briefing_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "safety_briefing_inspector_id_fkey"
            columns: ["inspector_id"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "safety_briefing_petugas_id_fkey"
            columns: ["petugas_id"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
        ]
      }
      safety_drill: {
        Row: {
          action_belum_mulai: number | null
          action_items: Json | null
          action_progress: number | null
          action_required: boolean | null
          action_selesai: number | null
          ada_korban: boolean | null
          alarm_activated: boolean | null
          alarm_to_evacuation: number | null
          alasan_tidak_evakuasi: string | null
          alat_komunikasi: string[] | null
          apar_digunakan: number | null
          approved_at: string | null
          approved_by: string | null
          area_lokasi: string
          area_terdampak: string[] | null
          briefing_dilakukan: boolean | null
          communication_team: string[] | null
          controller: string[] | null
          created_at: string | null
          created_by: string | null
          daftar_peserta: Json | null
          deskripsi: string | null
          detection_time: number | null
          dokumen_pendukung: string[] | null
          drill_commander: string
          drill_dimulai: boolean | null
          durasi_menit: number | null
          emergency_contact_called: string[] | null
          ert_leader: string | null
          ert_members: string[] | null
          evacuation_completion_time: number | null
          evacuation_team: string[] | null
          evakuasi_dilakukan: boolean | null
          evaluasi_overall: string | null
          evaluator: string[] | null
          fire_team: string[] | null
          first_aider: string[] | null
          foto_drill: string[] | null
          hydrant_digunakan: number | null
          id: string
          improvement_areas: string[] | null
          jabatan_commander: string | null
          jabatan_safety: string | null
          jenis_alarm: string | null
          jenis_cedera: string[] | null
          jenis_drill: string | null
          judul_drill: string
          jumlah_action_item: number | null
          jumlah_berhasil_evakuasi: number | null
          jumlah_dievaluasi: number | null
          jumlah_karyawan: number | null
          jumlah_kontraktor: number | null
          jumlah_korban_luka: number | null
          jumlah_korban_meninggal: number | null
          jumlah_observer: number | null
          jumlah_peserta: number
          jumlah_temuan: number | null
          jumlah_tidak_evakuasi: number | null
          kategori_drill: string | null
          kriteria_keberhasilan: string[] | null
          laporan_drill: string | null
          materi_briefing: string | null
          nomor_drill: string
          observer: string[] | null
          pa_system_used: boolean | null
          pelanggaran_teridentifikasi: string[] | null
          penanganan_korban: string | null
          peralatan_digunakan: Json | null
          perlu_follow_up: boolean | null
          peserta_briefing: string[] | null
          pic_perencanaan: string | null
          ppe_digunakan: string[] | null
          radio_communication: boolean | null
          rekomendasi: string[] | null
          review_notes: string | null
          ruang_khusus: string | null
          safe_area_reached: boolean | null
          safety_officer: string
          sasaran_drill: string[] | null
          shift: string | null
          skenario: string
          skor_overall: number | null
          status: string | null
          status_follow_up: string | null
          strength_areas: string[] | null
          stretcher_digunakan: number | null
          tanggal_briefing: string | null
          tanggal_drill: string
          tanggal_follow_up: string | null
          tanggal_perencanaan: string | null
          temuan_selama_drill: string[] | null
          tingkat_drill: string | null
          tingkat_keparahan: string[] | null
          titik_kumpul: string
          total_response_time: number | null
          total_waktu_evakuasi: number | null
          tujuan_drill: string
          unit_kerja: string
          unsafe_act: string[] | null
          unsafe_condition: string[] | null
          updated_at: string | null
          video_drill: string[] | null
          waktu_aktual_mulai: string | null
          waktu_alarm: string | null
          waktu_alarm_berbunyi: string | null
          waktu_all_clear: string | null
          waktu_briefing: string | null
          waktu_deteksi: string | null
          waktu_ke_safe_area: string | null
          waktu_mulai: string
          waktu_mulai_evakuasi: string | null
          waktu_selesai: string | null
          waktu_selesai_evakuasi: string | null
        }
        Insert: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_required?: boolean | null
          action_selesai?: number | null
          ada_korban?: boolean | null
          alarm_activated?: boolean | null
          alarm_to_evacuation?: number | null
          alasan_tidak_evakuasi?: string | null
          alat_komunikasi?: string[] | null
          apar_digunakan?: number | null
          approved_at?: string | null
          approved_by?: string | null
          area_lokasi: string
          area_terdampak?: string[] | null
          briefing_dilakukan?: boolean | null
          communication_team?: string[] | null
          controller?: string[] | null
          created_at?: string | null
          created_by?: string | null
          daftar_peserta?: Json | null
          deskripsi?: string | null
          detection_time?: number | null
          dokumen_pendukung?: string[] | null
          drill_commander: string
          drill_dimulai?: boolean | null
          durasi_menit?: number | null
          emergency_contact_called?: string[] | null
          ert_leader?: string | null
          ert_members?: string[] | null
          evacuation_completion_time?: number | null
          evacuation_team?: string[] | null
          evakuasi_dilakukan?: boolean | null
          evaluasi_overall?: string | null
          evaluator?: string[] | null
          fire_team?: string[] | null
          first_aider?: string[] | null
          foto_drill?: string[] | null
          hydrant_digunakan?: number | null
          id?: string
          improvement_areas?: string[] | null
          jabatan_commander?: string | null
          jabatan_safety?: string | null
          jenis_alarm?: string | null
          jenis_cedera?: string[] | null
          jenis_drill?: string | null
          judul_drill: string
          jumlah_action_item?: number | null
          jumlah_berhasil_evakuasi?: number | null
          jumlah_dievaluasi?: number | null
          jumlah_karyawan?: number | null
          jumlah_kontraktor?: number | null
          jumlah_korban_luka?: number | null
          jumlah_korban_meninggal?: number | null
          jumlah_observer?: number | null
          jumlah_peserta?: number
          jumlah_temuan?: number | null
          jumlah_tidak_evakuasi?: number | null
          kategori_drill?: string | null
          kriteria_keberhasilan?: string[] | null
          laporan_drill?: string | null
          materi_briefing?: string | null
          nomor_drill: string
          observer?: string[] | null
          pa_system_used?: boolean | null
          pelanggaran_teridentifikasi?: string[] | null
          penanganan_korban?: string | null
          peralatan_digunakan?: Json | null
          perlu_follow_up?: boolean | null
          peserta_briefing?: string[] | null
          pic_perencanaan?: string | null
          ppe_digunakan?: string[] | null
          radio_communication?: boolean | null
          rekomendasi?: string[] | null
          review_notes?: string | null
          ruang_khusus?: string | null
          safe_area_reached?: boolean | null
          safety_officer: string
          sasaran_drill?: string[] | null
          shift?: string | null
          skenario: string
          skor_overall?: number | null
          status?: string | null
          status_follow_up?: string | null
          strength_areas?: string[] | null
          stretcher_digunakan?: number | null
          tanggal_briefing?: string | null
          tanggal_drill: string
          tanggal_follow_up?: string | null
          tanggal_perencanaan?: string | null
          temuan_selama_drill?: string[] | null
          tingkat_drill?: string | null
          tingkat_keparahan?: string[] | null
          titik_kumpul: string
          total_response_time?: number | null
          total_waktu_evakuasi?: number | null
          tujuan_drill: string
          unit_kerja: string
          unsafe_act?: string[] | null
          unsafe_condition?: string[] | null
          updated_at?: string | null
          video_drill?: string[] | null
          waktu_aktual_mulai?: string | null
          waktu_alarm?: string | null
          waktu_alarm_berbunyi?: string | null
          waktu_all_clear?: string | null
          waktu_briefing?: string | null
          waktu_deteksi?: string | null
          waktu_ke_safe_area?: string | null
          waktu_mulai: string
          waktu_mulai_evakuasi?: string | null
          waktu_selesai?: string | null
          waktu_selesai_evakuasi?: string | null
        }
        Update: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_required?: boolean | null
          action_selesai?: number | null
          ada_korban?: boolean | null
          alarm_activated?: boolean | null
          alarm_to_evacuation?: number | null
          alasan_tidak_evakuasi?: string | null
          alat_komunikasi?: string[] | null
          apar_digunakan?: number | null
          approved_at?: string | null
          approved_by?: string | null
          area_lokasi?: string
          area_terdampak?: string[] | null
          briefing_dilakukan?: boolean | null
          communication_team?: string[] | null
          controller?: string[] | null
          created_at?: string | null
          created_by?: string | null
          daftar_peserta?: Json | null
          deskripsi?: string | null
          detection_time?: number | null
          dokumen_pendukung?: string[] | null
          drill_commander?: string
          drill_dimulai?: boolean | null
          durasi_menit?: number | null
          emergency_contact_called?: string[] | null
          ert_leader?: string | null
          ert_members?: string[] | null
          evacuation_completion_time?: number | null
          evacuation_team?: string[] | null
          evakuasi_dilakukan?: boolean | null
          evaluasi_overall?: string | null
          evaluator?: string[] | null
          fire_team?: string[] | null
          first_aider?: string[] | null
          foto_drill?: string[] | null
          hydrant_digunakan?: number | null
          id?: string
          improvement_areas?: string[] | null
          jabatan_commander?: string | null
          jabatan_safety?: string | null
          jenis_alarm?: string | null
          jenis_cedera?: string[] | null
          jenis_drill?: string | null
          judul_drill?: string
          jumlah_action_item?: number | null
          jumlah_berhasil_evakuasi?: number | null
          jumlah_dievaluasi?: number | null
          jumlah_karyawan?: number | null
          jumlah_kontraktor?: number | null
          jumlah_korban_luka?: number | null
          jumlah_korban_meninggal?: number | null
          jumlah_observer?: number | null
          jumlah_peserta?: number
          jumlah_temuan?: number | null
          jumlah_tidak_evakuasi?: number | null
          kategori_drill?: string | null
          kriteria_keberhasilan?: string[] | null
          laporan_drill?: string | null
          materi_briefing?: string | null
          nomor_drill?: string
          observer?: string[] | null
          pa_system_used?: boolean | null
          pelanggaran_teridentifikasi?: string[] | null
          penanganan_korban?: string | null
          peralatan_digunakan?: Json | null
          perlu_follow_up?: boolean | null
          peserta_briefing?: string[] | null
          pic_perencanaan?: string | null
          ppe_digunakan?: string[] | null
          radio_communication?: boolean | null
          rekomendasi?: string[] | null
          review_notes?: string | null
          ruang_khusus?: string | null
          safe_area_reached?: boolean | null
          safety_officer?: string
          sasaran_drill?: string[] | null
          shift?: string | null
          skenario?: string
          skor_overall?: number | null
          status?: string | null
          status_follow_up?: string | null
          strength_areas?: string[] | null
          stretcher_digunakan?: number | null
          tanggal_briefing?: string | null
          tanggal_drill?: string
          tanggal_follow_up?: string | null
          tanggal_perencanaan?: string | null
          temuan_selama_drill?: string[] | null
          tingkat_drill?: string | null
          tingkat_keparahan?: string[] | null
          titik_kumpul?: string
          total_response_time?: number | null
          total_waktu_evakuasi?: number | null
          tujuan_drill?: string
          unit_kerja?: string
          unsafe_act?: string[] | null
          unsafe_condition?: string[] | null
          updated_at?: string | null
          video_drill?: string[] | null
          waktu_aktual_mulai?: string | null
          waktu_alarm?: string | null
          waktu_alarm_berbunyi?: string | null
          waktu_all_clear?: string | null
          waktu_briefing?: string | null
          waktu_deteksi?: string | null
          waktu_ke_safe_area?: string | null
          waktu_mulai?: string
          waktu_mulai_evakuasi?: string | null
          waktu_selesai?: string | null
          waktu_selesai_evakuasi?: string | null
        }
        Relationships: []
      }
      safety_forum: {
        Row: {
          action_belum_mulai: number | null
          action_items: Json | null
          action_progress: number | null
          action_selesai: number | null
          agenda_detail: Json | null
          agenda_forum_berikutnya: string | null
          agenda_utama: string
          apd_yang_diperlukan: string[] | null
          approved_at: string | null
          approved_by: string | null
          catatan: string | null
          created_at: string | null
          created_by: string | null
          daftar_hadir_url: string | null
          dokumen_pendukung: string[] | null
          evaluasi_tindak_lanjut: string | null
          forum_sebelumnya_id: string | null
          foto_forum: string[] | null
          id: string
          jadwal_forum_berikutnya: string | null
          jenis_forum: string
          jumlah_action_item: number | null
          jumlah_peserta: number | null
          kategori_forum: string | null
          keputusan: string | null
          ketua_forum: string | null
          latar_belakang: string | null
          lokasi: string
          masalah_teridentifikasi: string[] | null
          nomor_forum: string
          notulen_by: string | null
          notulen_file_url: string | null
          periode: string | null
          peserta_hadir: string[] | null
          peserta_tidak_hadir: string[] | null
          peserta_wajib: string[] | null
          poin_poin_pembahasan: Json | null
          presentasi_url: string[] | null
          progress_action_sebelumnya: number | null
          rekomendasi: string[] | null
          ringkasan_pembahasan: string | null
          risiko_teridentifikasi: Json | null
          sop_baru: string[] | null
          status: string
          status_notulen: string | null
          tanggal_forum: string
          tingkat_urgensi: string | null
          topik_bahaya: string[] | null
          topik_incident: string[] | null
          topik_kecelakaan: string[] | null
          topik_lainnya: string[] | null
          topik_observasi: string[] | null
          topik_peraturan: string[] | null
          topik_training: string[] | null
          training_yang_diperlukan: string[] | null
          tujuan_forum: string | null
          unit_id: string | null
          updated_at: string | null
          updated_by: string | null
          waktu_mulai: string
          waktu_selesai: string | null
        }
        Insert: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          agenda_detail?: Json | null
          agenda_forum_berikutnya?: string | null
          agenda_utama: string
          apd_yang_diperlukan?: string[] | null
          approved_at?: string | null
          approved_by?: string | null
          catatan?: string | null
          created_at?: string | null
          created_by?: string | null
          daftar_hadir_url?: string | null
          dokumen_pendukung?: string[] | null
          evaluasi_tindak_lanjut?: string | null
          forum_sebelumnya_id?: string | null
          foto_forum?: string[] | null
          id?: string
          jadwal_forum_berikutnya?: string | null
          jenis_forum?: string
          jumlah_action_item?: number | null
          jumlah_peserta?: number | null
          kategori_forum?: string | null
          keputusan?: string | null
          ketua_forum?: string | null
          latar_belakang?: string | null
          lokasi: string
          masalah_teridentifikasi?: string[] | null
          nomor_forum: string
          notulen_by?: string | null
          notulen_file_url?: string | null
          periode?: string | null
          peserta_hadir?: string[] | null
          peserta_tidak_hadir?: string[] | null
          peserta_wajib?: string[] | null
          poin_poin_pembahasan?: Json | null
          presentasi_url?: string[] | null
          progress_action_sebelumnya?: number | null
          rekomendasi?: string[] | null
          ringkasan_pembahasan?: string | null
          risiko_teridentifikasi?: Json | null
          sop_baru?: string[] | null
          status?: string
          status_notulen?: string | null
          tanggal_forum: string
          tingkat_urgensi?: string | null
          topik_bahaya?: string[] | null
          topik_incident?: string[] | null
          topik_kecelakaan?: string[] | null
          topik_lainnya?: string[] | null
          topik_observasi?: string[] | null
          topik_peraturan?: string[] | null
          topik_training?: string[] | null
          training_yang_diperlukan?: string[] | null
          tujuan_forum?: string | null
          unit_id?: string | null
          updated_at?: string | null
          updated_by?: string | null
          waktu_mulai: string
          waktu_selesai?: string | null
        }
        Update: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          agenda_detail?: Json | null
          agenda_forum_berikutnya?: string | null
          agenda_utama?: string
          apd_yang_diperlukan?: string[] | null
          approved_at?: string | null
          approved_by?: string | null
          catatan?: string | null
          created_at?: string | null
          created_by?: string | null
          daftar_hadir_url?: string | null
          dokumen_pendukung?: string[] | null
          evaluasi_tindak_lanjut?: string | null
          forum_sebelumnya_id?: string | null
          foto_forum?: string[] | null
          id?: string
          jadwal_forum_berikutnya?: string | null
          jenis_forum?: string
          jumlah_action_item?: number | null
          jumlah_peserta?: number | null
          kategori_forum?: string | null
          keputusan?: string | null
          ketua_forum?: string | null
          latar_belakang?: string | null
          lokasi?: string
          masalah_teridentifikasi?: string[] | null
          nomor_forum?: string
          notulen_by?: string | null
          notulen_file_url?: string | null
          periode?: string | null
          peserta_hadir?: string[] | null
          peserta_tidak_hadir?: string[] | null
          peserta_wajib?: string[] | null
          poin_poin_pembahasan?: Json | null
          presentasi_url?: string[] | null
          progress_action_sebelumnya?: number | null
          rekomendasi?: string[] | null
          ringkasan_pembahasan?: string | null
          risiko_teridentifikasi?: Json | null
          sop_baru?: string[] | null
          status?: string
          status_notulen?: string | null
          tanggal_forum?: string
          tingkat_urgensi?: string | null
          topik_bahaya?: string[] | null
          topik_incident?: string[] | null
          topik_kecelakaan?: string[] | null
          topik_lainnya?: string[] | null
          topik_observasi?: string[] | null
          topik_peraturan?: string[] | null
          topik_training?: string[] | null
          training_yang_diperlukan?: string[] | null
          tujuan_forum?: string | null
          unit_id?: string | null
          updated_at?: string | null
          updated_by?: string | null
          waktu_mulai?: string
          waktu_selesai?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_safety_forum_unit"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
        ]
      }
      safety_induction: {
        Row: {
          akses_area: string[] | null
          alasan_reinduction: string | null
          alergi: string | null
          apd_diberikan: Json | null
          approved_at: string | null
          approved_by: string | null
          area_dikunjungi: string[] | null
          catatan_khusus: string | null
          created_at: string | null
          created_by: string | null
          departemen: string | null
          dokumen_pendukung: string[] | null
          durasi_menit: number | null
          durasi_tour_menit: number | null
          email: string | null
          emergency_kontak_hubungan: string | null
          emergency_kontak_nama: string | null
          emergency_kontak_telepon: string | null
          feedback_peserta: string | null
          feedback_tambahan: string | null
          file_sertifikat: string | null
          foto_induction: string[] | null
          foto_kegiatan: string[] | null
          foto_peserta: string | null
          golongan_darah: string | null
          id: string
          instruktur_pendamping: string[] | null
          instruktur_utama: string
          jabatan: string | null
          jenis_peserta: string | null
          jenis_ujian: string | null
          jumlah_soal: number | null
          kartu_id_diberikan: boolean | null
          kategori_pekerjaan: string | null
          lokasi_induction: string
          masa_berlaku_bulan: number | null
          masa_berlaku_sertifikat: string | null
          materi_apd_wajib: boolean | null
          materi_chemical_safety: boolean | null
          materi_confined_space: boolean | null
          materi_ergonomi: boolean | null
          materi_fire_safety: boolean | null
          materi_first_aid: boolean | null
          materi_housekeeping: boolean | null
          materi_identifikasi_bahaya: boolean | null
          materi_kebijakan_k3: boolean | null
          materi_loto: boolean | null
          materi_pelaporan_insiden: boolean | null
          materi_permit_to_work: boolean | null
          materi_presentasi: string[] | null
          materi_prosedur_emergency: boolean | null
          materi_rambu_k3: boolean | null
          materi_tambahan: Json | null
          materi_working_at_height: boolean | null
          nama_peserta: string
          nik: string | null
          no_identitas: string | null
          no_telepon: string | null
          nomor_induction: string
          nomor_kartu_id: string | null
          nomor_sertifikat: string | null
          obat_khusus: string | null
          passing_grade: number | null
          pemandu_tour: string | null
          perlu_follow_up: boolean | null
          perlu_reinduction: boolean | null
          perusahaan: string
          pic_hse: string
          rating_instruktur: number | null
          rating_materi: number | null
          rating_overall: number | null
          rekomendasi_peningkatan: string | null
          review_notes: string | null
          riwayat_penyakit: string | null
          ruangan: string | null
          sertifikat_dikeluarkan: boolean | null
          sertifikat_diterbitkan: boolean | null
          site_tour_dilakukan: boolean | null
          skor_ujian: number | null
          status: string | null
          status_follow_up: string | null
          status_ujian: string | null
          tanda_tangan_instruktur: string | null
          tanda_tangan_peserta: string | null
          tanda_tangan_pic_hse: string | null
          tanggal_expired: string | null
          tanggal_follow_up: string | null
          tanggal_induction: string
          tanggal_reinduction_scheduled: string | null
          tanggal_sertifikat: string | null
          tanggal_terbit_sertifikat: string | null
          tanggal_ujian: string | null
          ujian_dilakukan: boolean | null
          unit_id: string | null
          updated_at: string | null
          video_induction: string | null
          waktu_hadir: string | null
          waktu_mulai: string
          waktu_selesai: string | null
        }
        Insert: {
          akses_area?: string[] | null
          alasan_reinduction?: string | null
          alergi?: string | null
          apd_diberikan?: Json | null
          approved_at?: string | null
          approved_by?: string | null
          area_dikunjungi?: string[] | null
          catatan_khusus?: string | null
          created_at?: string | null
          created_by?: string | null
          departemen?: string | null
          dokumen_pendukung?: string[] | null
          durasi_menit?: number | null
          durasi_tour_menit?: number | null
          email?: string | null
          emergency_kontak_hubungan?: string | null
          emergency_kontak_nama?: string | null
          emergency_kontak_telepon?: string | null
          feedback_peserta?: string | null
          feedback_tambahan?: string | null
          file_sertifikat?: string | null
          foto_induction?: string[] | null
          foto_kegiatan?: string[] | null
          foto_peserta?: string | null
          golongan_darah?: string | null
          id?: string
          instruktur_pendamping?: string[] | null
          instruktur_utama: string
          jabatan?: string | null
          jenis_peserta?: string | null
          jenis_ujian?: string | null
          jumlah_soal?: number | null
          kartu_id_diberikan?: boolean | null
          kategori_pekerjaan?: string | null
          lokasi_induction: string
          masa_berlaku_bulan?: number | null
          masa_berlaku_sertifikat?: string | null
          materi_apd_wajib?: boolean | null
          materi_chemical_safety?: boolean | null
          materi_confined_space?: boolean | null
          materi_ergonomi?: boolean | null
          materi_fire_safety?: boolean | null
          materi_first_aid?: boolean | null
          materi_housekeeping?: boolean | null
          materi_identifikasi_bahaya?: boolean | null
          materi_kebijakan_k3?: boolean | null
          materi_loto?: boolean | null
          materi_pelaporan_insiden?: boolean | null
          materi_permit_to_work?: boolean | null
          materi_presentasi?: string[] | null
          materi_prosedur_emergency?: boolean | null
          materi_rambu_k3?: boolean | null
          materi_tambahan?: Json | null
          materi_working_at_height?: boolean | null
          nama_peserta: string
          nik?: string | null
          no_identitas?: string | null
          no_telepon?: string | null
          nomor_induction: string
          nomor_kartu_id?: string | null
          nomor_sertifikat?: string | null
          obat_khusus?: string | null
          passing_grade?: number | null
          pemandu_tour?: string | null
          perlu_follow_up?: boolean | null
          perlu_reinduction?: boolean | null
          perusahaan: string
          pic_hse: string
          rating_instruktur?: number | null
          rating_materi?: number | null
          rating_overall?: number | null
          rekomendasi_peningkatan?: string | null
          review_notes?: string | null
          riwayat_penyakit?: string | null
          ruangan?: string | null
          sertifikat_dikeluarkan?: boolean | null
          sertifikat_diterbitkan?: boolean | null
          site_tour_dilakukan?: boolean | null
          skor_ujian?: number | null
          status?: string | null
          status_follow_up?: string | null
          status_ujian?: string | null
          tanda_tangan_instruktur?: string | null
          tanda_tangan_peserta?: string | null
          tanda_tangan_pic_hse?: string | null
          tanggal_expired?: string | null
          tanggal_follow_up?: string | null
          tanggal_induction: string
          tanggal_reinduction_scheduled?: string | null
          tanggal_sertifikat?: string | null
          tanggal_terbit_sertifikat?: string | null
          tanggal_ujian?: string | null
          ujian_dilakukan?: boolean | null
          unit_id?: string | null
          updated_at?: string | null
          video_induction?: string | null
          waktu_hadir?: string | null
          waktu_mulai: string
          waktu_selesai?: string | null
        }
        Update: {
          akses_area?: string[] | null
          alasan_reinduction?: string | null
          alergi?: string | null
          apd_diberikan?: Json | null
          approved_at?: string | null
          approved_by?: string | null
          area_dikunjungi?: string[] | null
          catatan_khusus?: string | null
          created_at?: string | null
          created_by?: string | null
          departemen?: string | null
          dokumen_pendukung?: string[] | null
          durasi_menit?: number | null
          durasi_tour_menit?: number | null
          email?: string | null
          emergency_kontak_hubungan?: string | null
          emergency_kontak_nama?: string | null
          emergency_kontak_telepon?: string | null
          feedback_peserta?: string | null
          feedback_tambahan?: string | null
          file_sertifikat?: string | null
          foto_induction?: string[] | null
          foto_kegiatan?: string[] | null
          foto_peserta?: string | null
          golongan_darah?: string | null
          id?: string
          instruktur_pendamping?: string[] | null
          instruktur_utama?: string
          jabatan?: string | null
          jenis_peserta?: string | null
          jenis_ujian?: string | null
          jumlah_soal?: number | null
          kartu_id_diberikan?: boolean | null
          kategori_pekerjaan?: string | null
          lokasi_induction?: string
          masa_berlaku_bulan?: number | null
          masa_berlaku_sertifikat?: string | null
          materi_apd_wajib?: boolean | null
          materi_chemical_safety?: boolean | null
          materi_confined_space?: boolean | null
          materi_ergonomi?: boolean | null
          materi_fire_safety?: boolean | null
          materi_first_aid?: boolean | null
          materi_housekeeping?: boolean | null
          materi_identifikasi_bahaya?: boolean | null
          materi_kebijakan_k3?: boolean | null
          materi_loto?: boolean | null
          materi_pelaporan_insiden?: boolean | null
          materi_permit_to_work?: boolean | null
          materi_presentasi?: string[] | null
          materi_prosedur_emergency?: boolean | null
          materi_rambu_k3?: boolean | null
          materi_tambahan?: Json | null
          materi_working_at_height?: boolean | null
          nama_peserta?: string
          nik?: string | null
          no_identitas?: string | null
          no_telepon?: string | null
          nomor_induction?: string
          nomor_kartu_id?: string | null
          nomor_sertifikat?: string | null
          obat_khusus?: string | null
          passing_grade?: number | null
          pemandu_tour?: string | null
          perlu_follow_up?: boolean | null
          perlu_reinduction?: boolean | null
          perusahaan?: string
          pic_hse?: string
          rating_instruktur?: number | null
          rating_materi?: number | null
          rating_overall?: number | null
          rekomendasi_peningkatan?: string | null
          review_notes?: string | null
          riwayat_penyakit?: string | null
          ruangan?: string | null
          sertifikat_dikeluarkan?: boolean | null
          sertifikat_diterbitkan?: boolean | null
          site_tour_dilakukan?: boolean | null
          skor_ujian?: number | null
          status?: string | null
          status_follow_up?: string | null
          status_ujian?: string | null
          tanda_tangan_instruktur?: string | null
          tanda_tangan_peserta?: string | null
          tanda_tangan_pic_hse?: string | null
          tanggal_expired?: string | null
          tanggal_follow_up?: string | null
          tanggal_induction?: string
          tanggal_reinduction_scheduled?: string | null
          tanggal_sertifikat?: string | null
          tanggal_terbit_sertifikat?: string | null
          tanggal_ujian?: string | null
          ujian_dilakukan?: boolean | null
          unit_id?: string | null
          updated_at?: string | null
          video_induction?: string | null
          waktu_hadir?: string | null
          waktu_mulai?: string
          waktu_selesai?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_safety_induction_unit"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "safety_induction_unit_id_fkey"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
        ]
      }
      safety_patrol: {
        Row: {
          action_belum_mulai: number | null
          action_items: Json | null
          action_progress: number | null
          action_selesai: number | null
          anggota_patrol: string[] | null
          apar_expire: number | null
          apar_tersedia: boolean | null
          area_excellent: string[] | null
          area_kotor: string[] | null
          area_patrol: string
          area_rapi: string[] | null
          catatan_patrol: string | null
          created_at: string | null
          created_by: string | null
          cuaca: string | null
          detail_apd: Json | null
          detail_mesin: Json | null
          dokumen_pendukung: string[] | null
          emergency_light_berfungsi: boolean | null
          fokus_patrol: string[] | null
          foto_patrol: string[] | null
          good_practice: string[] | null
          grade: string | null
          id: string
          jalur_evakuasi_bebas: boolean | null
          jenis_patrol: string | null
          jumlah_action_item: number | null
          jumlah_anggota: number | null
          jumlah_mesin_diperiksa: number | null
          jumlah_unsafe_act: number | null
          jumlah_unsafe_condition: number | null
          ketua_patrol: string
          kondisi_housekeeping: string | null
          kondisi_pencahayaan: string | null
          kondisi_ventilasi: string | null
          label_b3_lengkap: boolean | null
          lokasi_spesifik: string | null
          mesin_kondisi_baik: number | null
          mesin_perlu_perbaikan: number | null
          nomor_patrol: string
          pekerja_diamati: number | null
          pekerja_patuh_apd: number | null
          pekerja_teladan: string[] | null
          pekerja_tidak_patuh_apd: number | null
          perlu_follow_up: boolean | null
          persentase_kepatuhan_apd: number | null
          pintu_darurat_berfungsi: boolean | null
          rambu_k3_hilang: string[] | null
          rambu_k3_lengkap: boolean | null
          rambu_k3_rusak: string[] | null
          rekomendasi: string[] | null
          review_notes: string | null
          reviewed_at: string | null
          reviewed_by: string | null
          shift: string | null
          skor_apd: number | null
          skor_housekeeping: number | null
          skor_keseluruhan: number | null
          skor_kondisi_area: number | null
          skor_peralatan: number | null
          status: string | null
          status_follow_up: string | null
          stop_work_alasan: string | null
          stop_work_area: string[] | null
          stop_work_issued: boolean | null
          suhu_area: number | null
          tanggal_follow_up: string | null
          tanggal_patrol: string
          temuan_kritikal: number | null
          temuan_mayor: number | null
          temuan_minor: number | null
          tingkat_kebisingan: string | null
          tingkat_urgensi: string | null
          total_temuan: number | null
          tujuan_patrol: string | null
          unit_id: string | null
          unsafe_act: Json | null
          unsafe_condition: Json | null
          updated_at: string | null
          waktu_mulai: string
          waktu_selesai: string | null
        }
        Insert: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          anggota_patrol?: string[] | null
          apar_expire?: number | null
          apar_tersedia?: boolean | null
          area_excellent?: string[] | null
          area_kotor?: string[] | null
          area_patrol: string
          area_rapi?: string[] | null
          catatan_patrol?: string | null
          created_at?: string | null
          created_by?: string | null
          cuaca?: string | null
          detail_apd?: Json | null
          detail_mesin?: Json | null
          dokumen_pendukung?: string[] | null
          emergency_light_berfungsi?: boolean | null
          fokus_patrol?: string[] | null
          foto_patrol?: string[] | null
          good_practice?: string[] | null
          grade?: string | null
          id?: string
          jalur_evakuasi_bebas?: boolean | null
          jenis_patrol?: string | null
          jumlah_action_item?: number | null
          jumlah_anggota?: number | null
          jumlah_mesin_diperiksa?: number | null
          jumlah_unsafe_act?: number | null
          jumlah_unsafe_condition?: number | null
          ketua_patrol: string
          kondisi_housekeeping?: string | null
          kondisi_pencahayaan?: string | null
          kondisi_ventilasi?: string | null
          label_b3_lengkap?: boolean | null
          lokasi_spesifik?: string | null
          mesin_kondisi_baik?: number | null
          mesin_perlu_perbaikan?: number | null
          nomor_patrol: string
          pekerja_diamati?: number | null
          pekerja_patuh_apd?: number | null
          pekerja_teladan?: string[] | null
          pekerja_tidak_patuh_apd?: number | null
          perlu_follow_up?: boolean | null
          persentase_kepatuhan_apd?: number | null
          pintu_darurat_berfungsi?: boolean | null
          rambu_k3_hilang?: string[] | null
          rambu_k3_lengkap?: boolean | null
          rambu_k3_rusak?: string[] | null
          rekomendasi?: string[] | null
          review_notes?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          shift?: string | null
          skor_apd?: number | null
          skor_housekeeping?: number | null
          skor_keseluruhan?: number | null
          skor_kondisi_area?: number | null
          skor_peralatan?: number | null
          status?: string | null
          status_follow_up?: string | null
          stop_work_alasan?: string | null
          stop_work_area?: string[] | null
          stop_work_issued?: boolean | null
          suhu_area?: number | null
          tanggal_follow_up?: string | null
          tanggal_patrol: string
          temuan_kritikal?: number | null
          temuan_mayor?: number | null
          temuan_minor?: number | null
          tingkat_kebisingan?: string | null
          tingkat_urgensi?: string | null
          total_temuan?: number | null
          tujuan_patrol?: string | null
          unit_id?: string | null
          unsafe_act?: Json | null
          unsafe_condition?: Json | null
          updated_at?: string | null
          waktu_mulai: string
          waktu_selesai?: string | null
        }
        Update: {
          action_belum_mulai?: number | null
          action_items?: Json | null
          action_progress?: number | null
          action_selesai?: number | null
          anggota_patrol?: string[] | null
          apar_expire?: number | null
          apar_tersedia?: boolean | null
          area_excellent?: string[] | null
          area_kotor?: string[] | null
          area_patrol?: string
          area_rapi?: string[] | null
          catatan_patrol?: string | null
          created_at?: string | null
          created_by?: string | null
          cuaca?: string | null
          detail_apd?: Json | null
          detail_mesin?: Json | null
          dokumen_pendukung?: string[] | null
          emergency_light_berfungsi?: boolean | null
          fokus_patrol?: string[] | null
          foto_patrol?: string[] | null
          good_practice?: string[] | null
          grade?: string | null
          id?: string
          jalur_evakuasi_bebas?: boolean | null
          jenis_patrol?: string | null
          jumlah_action_item?: number | null
          jumlah_anggota?: number | null
          jumlah_mesin_diperiksa?: number | null
          jumlah_unsafe_act?: number | null
          jumlah_unsafe_condition?: number | null
          ketua_patrol?: string
          kondisi_housekeeping?: string | null
          kondisi_pencahayaan?: string | null
          kondisi_ventilasi?: string | null
          label_b3_lengkap?: boolean | null
          lokasi_spesifik?: string | null
          mesin_kondisi_baik?: number | null
          mesin_perlu_perbaikan?: number | null
          nomor_patrol?: string
          pekerja_diamati?: number | null
          pekerja_patuh_apd?: number | null
          pekerja_teladan?: string[] | null
          pekerja_tidak_patuh_apd?: number | null
          perlu_follow_up?: boolean | null
          persentase_kepatuhan_apd?: number | null
          pintu_darurat_berfungsi?: boolean | null
          rambu_k3_hilang?: string[] | null
          rambu_k3_lengkap?: boolean | null
          rambu_k3_rusak?: string[] | null
          rekomendasi?: string[] | null
          review_notes?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          shift?: string | null
          skor_apd?: number | null
          skor_housekeeping?: number | null
          skor_keseluruhan?: number | null
          skor_kondisi_area?: number | null
          skor_peralatan?: number | null
          status?: string | null
          status_follow_up?: string | null
          stop_work_alasan?: string | null
          stop_work_area?: string[] | null
          stop_work_issued?: boolean | null
          suhu_area?: number | null
          tanggal_follow_up?: string | null
          tanggal_patrol?: string
          temuan_kritikal?: number | null
          temuan_mayor?: number | null
          temuan_minor?: number | null
          tingkat_kebisingan?: string | null
          tingkat_urgensi?: string | null
          total_temuan?: number | null
          tujuan_patrol?: string | null
          unit_id?: string | null
          unsafe_act?: Json | null
          unsafe_condition?: Json | null
          updated_at?: string | null
          waktu_mulai?: string
          waktu_selesai?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_safety_patrol_unit"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
        ]
      }
      silent_inspection: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          area_inspeksi: string
          checklist: Json | null
          created_at: string | null
          created_by: string
          deskripsi_temuan: string | null
          fokus_inspeksi: Json | null
          foto_kondisi_unsafe: Json | null
          foto_perilaku_unsafe: Json | null
          id: string
          inspector_id: string
          jenis_inspeksi: string | null
          jumlah_temuan: number | null
          kategori_bahaya: string | null
          kategori_temuan: string | null
          kondisi_housekeeping: string | null
          lampiran_url: string | null
          nomor_inspeksi: string | null
          penggunaan_apd: string | null
          pic_perbaikan_id: string | null
          rekomendasi: string | null
          skor_kepatuhan: number | null
          skor_total: number | null
          status: string
          status_tindak_lanjut: string | null
          tahun: number
          tanggal: string
          tanggal_selesai: string | null
          target_selesai: string | null
          temuan: string | null
          temuan_critical: number | null
          temuan_major: number | null
          temuan_minor: number | null
          tindak_lanjut: Json | null
          tindakan_korektif: string | null
          tingkat_risiko: string | null
          triwulan: number
          unit_id: string | null
          updated_at: string | null
          verified_at: string | null
          verified_by: string | null
          waktu_mulai: string | null
          waktu_selesai: string | null
          wilayah_id: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          area_inspeksi: string
          checklist?: Json | null
          created_at?: string | null
          created_by: string
          deskripsi_temuan?: string | null
          fokus_inspeksi?: Json | null
          foto_kondisi_unsafe?: Json | null
          foto_perilaku_unsafe?: Json | null
          id?: string
          inspector_id: string
          jenis_inspeksi?: string | null
          jumlah_temuan?: number | null
          kategori_bahaya?: string | null
          kategori_temuan?: string | null
          kondisi_housekeeping?: string | null
          lampiran_url?: string | null
          nomor_inspeksi?: string | null
          penggunaan_apd?: string | null
          pic_perbaikan_id?: string | null
          rekomendasi?: string | null
          skor_kepatuhan?: number | null
          skor_total?: number | null
          status?: string
          status_tindak_lanjut?: string | null
          tahun: number
          tanggal: string
          tanggal_selesai?: string | null
          target_selesai?: string | null
          temuan?: string | null
          temuan_critical?: number | null
          temuan_major?: number | null
          temuan_minor?: number | null
          tindak_lanjut?: Json | null
          tindakan_korektif?: string | null
          tingkat_risiko?: string | null
          triwulan: number
          unit_id?: string | null
          updated_at?: string | null
          verified_at?: string | null
          verified_by?: string | null
          waktu_mulai?: string | null
          waktu_selesai?: string | null
          wilayah_id?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          area_inspeksi?: string
          checklist?: Json | null
          created_at?: string | null
          created_by?: string
          deskripsi_temuan?: string | null
          fokus_inspeksi?: Json | null
          foto_kondisi_unsafe?: Json | null
          foto_perilaku_unsafe?: Json | null
          id?: string
          inspector_id?: string
          jenis_inspeksi?: string | null
          jumlah_temuan?: number | null
          kategori_bahaya?: string | null
          kategori_temuan?: string | null
          kondisi_housekeeping?: string | null
          lampiran_url?: string | null
          nomor_inspeksi?: string | null
          penggunaan_apd?: string | null
          pic_perbaikan_id?: string | null
          rekomendasi?: string | null
          skor_kepatuhan?: number | null
          skor_total?: number | null
          status?: string
          status_tindak_lanjut?: string | null
          tahun?: number
          tanggal?: string
          tanggal_selesai?: string | null
          target_selesai?: string | null
          temuan?: string | null
          temuan_critical?: number | null
          temuan_major?: number | null
          temuan_minor?: number | null
          tindak_lanjut?: Json | null
          tindakan_korektif?: string | null
          tingkat_risiko?: string | null
          triwulan?: number
          unit_id?: string | null
          updated_at?: string | null
          verified_at?: string | null
          verified_by?: string | null
          waktu_mulai?: string | null
          waktu_selesai?: string | null
          wilayah_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_silent_inspection_verified_by"
            columns: ["verified_by"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "silent_inspection_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "silent_inspection_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "silent_inspection_inspector_id_fkey"
            columns: ["inspector_id"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "silent_inspection_pic_perbaikan_id_fkey"
            columns: ["pic_perbaikan_id"]
            isOneToOne: false
            referencedRelation: "pegawai"
            referencedColumns: ["id"]
          },
        ]
      }
      tamu_eksternal: {
        Row: {
          created_at: string | null
          email: string | null
          foto_identitas_url: string | null
          id: string
          nama_lengkap: string
          nik: string | null
          perusahaan: string | null
          phone: string | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          email?: string | null
          foto_identitas_url?: string | null
          id?: string
          nama_lengkap: string
          nik?: string | null
          perusahaan?: string | null
          phone?: string | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          email?: string | null
          foto_identitas_url?: string | null
          id?: string
          nama_lengkap?: string
          nik?: string | null
          perusahaan?: string | null
          phone?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      units: {
        Row: {
          aktif: boolean | null
          area_id: string | null
          created_at: string | null
          id: string
          kode_unit: string
          lokasi: string | null
          nama_unit: string
          status: string
          tipe: string | null
          updated_at: string | null
          wilayah_id: string | null
        }
        Insert: {
          aktif?: boolean | null
          area_id?: string | null
          created_at?: string | null
          id?: string
          kode_unit: string
          lokasi?: string | null
          nama_unit: string
          status?: string
          tipe?: string | null
          updated_at?: string | null
          wilayah_id?: string | null
        }
        Update: {
          aktif?: boolean | null
          area_id?: string | null
          created_at?: string | null
          id?: string
          kode_unit?: string
          lokasi?: string | null
          nama_unit?: string
          status?: string
          tipe?: string | null
          updated_at?: string | null
          wilayah_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "units_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "units_wilayah_id_fkey"
            columns: ["wilayah_id"]
            isOneToOne: false
            referencedRelation: "wilayah"
            referencedColumns: ["id"]
          },
        ]
      }
      unsafe_action_condition: {
        Row: {
          aktual_penyelesaian: string | null
          area_diamankan: boolean | null
          assigned_at: string | null
          assigned_by: string | null
          assigned_to: string | null
          audio_catatan: string | null
          created_at: string | null
          created_by: string | null
          deskripsi_kejadian: string
          foto_kejadian: string[] | null
          gps_accuracy: number | null
          id: string
          investigasi_dilakukan: boolean | null
          jenis_kejadian: string
          kategori: string
          korban_ada: boolean | null
          korban_jumlah: number | null
          latitude: number | null
          lokasi_kejadian: string
          longitude: number | null
          pelapor_jabatan: string | null
          pelapor_kontak: string | null
          pelapor_nama: string
          penyebab_diduga: string | null
          potensi_risiko: string | null
          prioritas: string | null
          rekomendasi_koreksi: string[] | null
          severity_level: number | null
          status: string | null
          sub_kategori: string | null
          tanggal_kejadian: string
          target_penyelesaian: string | null
          temuan_investigasi: string | null
          tindakan_segera: string | null
          unit_kerja: string
          updated_at: string | null
          video_kejadian: string[] | null
          waktu_kejadian: string
        }
        Insert: {
          aktual_penyelesaian?: string | null
          area_diamankan?: boolean | null
          assigned_at?: string | null
          assigned_by?: string | null
          assigned_to?: string | null
          audio_catatan?: string | null
          created_at?: string | null
          created_by?: string | null
          deskripsi_kejadian: string
          foto_kejadian?: string[] | null
          gps_accuracy?: number | null
          id?: string
          investigasi_dilakukan?: boolean | null
          jenis_kejadian: string
          kategori: string
          korban_ada?: boolean | null
          korban_jumlah?: number | null
          latitude?: number | null
          lokasi_kejadian: string
          longitude?: number | null
          pelapor_jabatan?: string | null
          pelapor_kontak?: string | null
          pelapor_nama: string
          penyebab_diduga?: string | null
          potensi_risiko?: string | null
          prioritas?: string | null
          rekomendasi_koreksi?: string[] | null
          severity_level?: number | null
          status?: string | null
          sub_kategori?: string | null
          tanggal_kejadian: string
          target_penyelesaian?: string | null
          temuan_investigasi?: string | null
          tindakan_segera?: string | null
          unit_kerja: string
          updated_at?: string | null
          video_kejadian?: string[] | null
          waktu_kejadian: string
        }
        Update: {
          aktual_penyelesaian?: string | null
          area_diamankan?: boolean | null
          assigned_at?: string | null
          assigned_by?: string | null
          assigned_to?: string | null
          audio_catatan?: string | null
          created_at?: string | null
          created_by?: string | null
          deskripsi_kejadian?: string
          foto_kejadian?: string[] | null
          gps_accuracy?: number | null
          id?: string
          investigasi_dilakukan?: boolean | null
          jenis_kejadian?: string
          kategori?: string
          korban_ada?: boolean | null
          korban_jumlah?: number | null
          latitude?: number | null
          lokasi_kejadian?: string
          longitude?: number | null
          pelapor_jabatan?: string | null
          pelapor_kontak?: string | null
          pelapor_nama?: string
          penyebab_diduga?: string | null
          potensi_risiko?: string | null
          prioritas?: string | null
          rekomendasi_koreksi?: string[] | null
          severity_level?: number | null
          status?: string | null
          sub_kategori?: string | null
          tanggal_kejadian?: string
          target_penyelesaian?: string | null
          temuan_investigasi?: string | null
          tindakan_segera?: string | null
          unit_kerja?: string
          updated_at?: string | null
          video_kejadian?: string[] | null
          waktu_kejadian?: string
        }
        Relationships: []
      }
      wilayah: {
        Row: {
          aktif: boolean | null
          created_at: string | null
          id: string
          kode_wilayah: string
          kota: string | null
          nama: string | null
          nama_wilayah: string
          provinsi: string | null
          status: string
          updated_at: string | null
        }
        Insert: {
          aktif?: boolean | null
          created_at?: string | null
          id?: string
          kode_wilayah: string
          kota?: string | null
          nama?: string | null
          nama_wilayah: string
          provinsi?: string | null
          status?: string
          updated_at?: string | null
        }
        Update: {
          aktif?: boolean | null
          created_at?: string | null
          id?: string
          kode_wilayah?: string
          kota?: string | null
          nama?: string | null
          nama_wilayah?: string
          provinsi?: string | null
          status?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      unsafe_action_condition: {
        Row: {
          id: string
          tanggal_kejadian: string
          waktu_kejadian: string
          lokasi_kejadian: string
          unit_kerja: string
          jenis_kejadian: string
          kategori: string
          sub_kategori: string | null
          deskripsi_kejadian: string
          penyebab_diduga: string | null
          potensi_risiko: string | null
          pelapor_nama: string
          pelapor_jabatan: string | null
          pelapor_kontak: string | null
          tindakan_segera: string | null
          area_diamankan: boolean
          korban_ada: boolean
          korban_jumlah: number
          foto_kejadian: string[] | null
          video_kejadian: string[] | null
          audio_catatan: string | null
          prioritas: string
          severity_level: number | null
          status: string
          assigned_to: string | null
          assigned_by: string | null
          assigned_at: string | null
          investigasi_dilakukan: boolean
          temuan_investigasi: string | null
          rekomendasi_koreksi: string[] | null
          target_penyelesaian: string | null
          aktual_penyelesaian: string | null
          latitude: number | null
          longitude: number | null
          gps_accuracy: number | null
          created_by: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          tanggal_kejadian: string
          waktu_kejadian: string
          lokasi_kejadian: string
          unit_kerja: string
          jenis_kejadian: string
          kategori: string
          sub_kategori?: string | null
          deskripsi_kejadian: string
          penyebab_diduga?: string | null
          potensi_risiko?: string | null
          pelapor_nama: string
          pelapor_jabatan?: string | null
          pelapor_kontak?: string | null
          tindakan_segera?: string | null
          area_diamankan?: boolean
          korban_ada?: boolean
          korban_jumlah?: number
          foto_kejadian?: string[] | null
          video_kejadian?: string[] | null
          audio_catatan?: string | null
          prioritas?: string
          severity_level?: number | null
          status?: string
          assigned_to?: string | null
          assigned_by?: string | null
          assigned_at?: string | null
          investigasi_dilakukan?: boolean
          temuan_investigasi?: string | null
          rekomendasi_koreksi?: string[] | null
          target_penyelesaian?: string | null
          aktual_penyelesaian?: string | null
          latitude?: number | null
          longitude?: number | null
          gps_accuracy?: number | null
          created_by?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          tanggal_kejadian?: string
          waktu_kejadian?: string
          lokasi_kejadian?: string
          unit_kerja?: string
          jenis_kejadian?: string
          kategori?: string
          sub_kategori?: string | null
          deskripsi_kejadian?: string
          penyebab_diduga?: string | null
          potensi_risiko?: string | null
          pelapor_nama?: string
          pelapor_jabatan?: string | null
          pelapor_kontak?: string | null
          tindakan_segera?: string | null
          area_diamankan?: boolean
          korban_ada?: boolean
          korban_jumlah?: number
          foto_kejadian?: string[] | null
          video_kejadian?: string[] | null
          audio_catatan?: string | null
          prioritas?: string
          severity_level?: number | null
          status?: string
          assigned_to?: string | null
          assigned_by?: string | null
          assigned_at?: string | null
          investigasi_dilakukan?: boolean
          temuan_investigasi?: string | null
          rekomendasi_koreksi?: string[] | null
          target_penyelesaian?: string | null
          aktual_penyelesaian?: string | null
          latitude?: number | null
          longitude?: number | null
          gps_accuracy?: number | null
          created_by?: string | null
          created_at?: string
          updated_at?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
