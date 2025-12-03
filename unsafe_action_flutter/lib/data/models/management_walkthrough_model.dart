import 'package:freezed_annotation/freezed_annotation.dart';

part 'management_walkthrough_model.freezed.dart';
part 'management_walkthrough_model.g.dart';

@freezed
class ManagementWalkthroughModel with _$ManagementWalkthroughModel {
  const factory ManagementWalkthroughModel({
    String? id,
    @JsonKey(name: 'nomor_walkthrough') required String nomorWalkthrough,
    @JsonKey(name: 'tanggal_walkthrough') required DateTime tanggalWalkthrough,
    @JsonKey(name: 'waktu_mulai') required String waktuMulai,
    @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'area_inspeksi') required String areaInspeksi,
    @JsonKey(name: 'departemen') String? departemen,
    @JsonKey(name: 'pimpinan_walkthrough') required String pimpinanWalkthrough,
    @JsonKey(name: 'anggota_tim') @Default([]) List<String> anggotaTim,
    @JsonKey(name: 'jumlah_tim') @Default(0) int jumlahTim,
    @JsonKey(name: 'tujuan_walkthrough') String? tujuanWalkthrough,
    @JsonKey(name: 'fokus_area') @Default([]) List<String> fokusArea,
    @JsonKey(name: 'jenis_walkthrough') @Default('rutin') String jenisWalkthrough,
    
    // Observasi Kondisi
    @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
    @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan,
    @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi,
    @JsonKey(name: 'kondisi_akses_jalan') String? kondisiAksesJalan,
    
    // APD
    @JsonKey(name: 'kepatuhan_apd') @Default(0) int kepatuhanApd,
    @JsonKey(name: 'apd_tersedia') @Default(false) bool apdTersedia,
    @JsonKey(name: 'apd_kondisi_baik') @Default(false) bool apdKondisiBaik,
    @JsonKey(name: 'apd_digunakan_benar') @Default(false) bool apdDigunakanBenar,
    @JsonKey(name: 'apd_tidak_sesuai') @Default([]) List<String> apdTidakSesuai,
    
    // Perilaku Kerja
    @JsonKey(name: 'pekerja_diamati') @Default(0) int pekerjaDiamati,
    @JsonKey(name: 'perilaku_aman') @Default(0) int perilakuAman,
    @JsonKey(name: 'perilaku_tidak_aman') @Default(0) int perilakuTidakAman,
    @JsonKey(name: 'perilaku_tidak_aman_detail') dynamic perilakuTidakAmanDetail,
    
    // Interaksi Pekerja
    @JsonKey(name: 'jumlah_pekerja_diwawancara') @Default(0) int jumlahPekerjaDiwawancara,
    @JsonKey(name: 'feedback_pekerja') @Default([]) List<String> feedbackPekerja,
    @JsonKey(name: 'saran_pekerja') @Default([]) List<String> saranPekerja,
    @JsonKey(name: 'pekerja_aware_prosedur') @Default(false) bool pekerjaAwareProsedur,
    
    // Temuan
    @JsonKey(name: 'jumlah_temuan') @Default(0) int jumlahTemuan,
    @JsonKey(name: 'temuan_bahaya') dynamic temuanBahaya,
    @JsonKey(name: 'temuan_kritis') @Default(0) int temuanKritis,
    @JsonKey(name: 'temuan_mayor') @Default(0) int temuanMayor,
    @JsonKey(name: 'temuan_minor') @Default(0) int temuanMinor,
    @JsonKey(name: 'temuan_observasi') @Default(0) int temuanObservasi,
    
    // Pelanggaran
    @JsonKey(name: 'pelanggaran_prosedur') @Default([]) List<String> pelanggaranProsedur,
    @JsonKey(name: 'pelanggaran_peraturan') @Default([]) List<String> pelanggaranPeraturan,
    @JsonKey(name: 'area_non_compliance') @Default([]) List<String> areaNonCompliance,
    
    // Positive Findings
    @JsonKey(name: 'praktek_baik') @Default([]) List<String> praktekBaik,
    @JsonKey(name: 'area_excellent') @Default([]) List<String> areaExcellent,
    @JsonKey(name: 'pekerja_teladan') @Default([]) List<String> pekerjaTeladan,
    
    // Action Items
    @JsonKey(name: 'action_items') dynamic actionItems,
    @JsonKey(name: 'jumlah_action_item') @Default(0) int jumlahActionItem,
    @JsonKey(name: 'action_selesai') @Default(0) int actionSelesai,
    @JsonKey(name: 'action_progress') @Default(0) int actionProgress,
    @JsonKey(name: 'action_belum_mulai') @Default(0) int actionBelumMulai,
    
    // Immediate Actions
    @JsonKey(name: 'tindakan_segera') @Default([]) List<String> tindakanSegera,
    @JsonKey(name: 'area_ditutup') @Default([]) List<String> areaDitutup,
    @JsonKey(name: 'pekerjaan_dihentikan') @Default([]) List<String> pekerjaanDihentikan,
    
    // Dokumentasi
    @JsonKey(name: 'foto_walkthrough') @Default([]) List<String> fotoWalkthrough,
    @JsonKey(name: 'dokumen_pendukung') @Default([]) List<String> dokumenPendukung,
    @JsonKey(name: 'sketsa_lokasi_url') String? sketsaLokasiUrl,
    @JsonKey(name: 'video_url') String? videoUrl,
    
    // Ringkasan
    @JsonKey(name: 'ringkasan_observasi') String? ringkasanObservasi,
    @JsonKey(name: 'rekomendasi') @Default([]) List<String> rekomendasi,
    @JsonKey(name: 'catatan_khusus') String? catatanKhusus,
    
    // Status
    @JsonKey(name: 'status') @Default('draft') String status,
    @JsonKey(name: 'tingkat_urgensi') @Default('normal') String tingkatUrgensi,
    @JsonKey(name: 'perlu_follow_up') @Default(false) bool perluFollowUp,
    @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
    @JsonKey(name: 'status_follow_up') @Default('belum') String statusFollowUp,
    
    // Scoring
    @JsonKey(name: 'skor_keseluruhan') @Default(0) int skorKeseluruhan,
    @JsonKey(name: 'skor_housekeeping') @Default(0) int skorHousekeeping,
    @JsonKey(name: 'skor_apd') @Default(0) int skorApd,
    @JsonKey(name: 'skor_perilaku') @Default(0) int skorPerilaku,
    
    // Metadata
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
  }) = _ManagementWalkthroughModel;

  factory ManagementWalkthroughModel.fromJson(Map<String, dynamic> json) =>
      _$ManagementWalkthroughModelFromJson(json);
}
