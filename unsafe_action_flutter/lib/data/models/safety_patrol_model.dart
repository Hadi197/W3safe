import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_patrol_model.freezed.dart';
part 'safety_patrol_model.g.dart';

@freezed
class SafetyPatrol with _$SafetyPatrol {
  const factory SafetyPatrol({
    String? id,
    
    // Basic information
    @JsonKey(name: 'nomor_patrol') @Default('') String nomorPatrol,
    @JsonKey(name: 'tanggal_patrol') DateTime? tanggalPatrol,
    @JsonKey(name: 'waktu_mulai') String? waktuMulai,
    @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
    
    // Shift and unit
    String? shift, // pagi, siang, malam
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'area_patrol') @Default('') String areaPatrol,
    @JsonKey(name: 'lokasi_spesifik') String? lokasiSpesifik,
    
    // Team information
    @JsonKey(name: 'ketua_patrol') @Default('') String ketuaPatrol,
    @JsonKey(name: 'anggota_patrol') @Default([]) List<String> anggotaPatrol,
    @JsonKey(name: 'jumlah_anggota') @Default(0) int jumlahAnggota,
    
    // Patrol details
    @JsonKey(name: 'jenis_patrol') String? jenisPatrol, // rutin, terjadwal, insidental, khusus, malam, emergency
    @JsonKey(name: 'tujuan_patrol') String? tujuanPatrol,
    @JsonKey(name: 'fokus_patrol') @Default([]) List<String> fokusPatrol,
    
    // Environmental conditions
    String? cuaca, // cerah, mendung, hujan, panas
    @JsonKey(name: 'suhu_area') double? suhuArea,
    @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan, // baik, cukup, kurang, buruk
    @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi, // baik, cukup, kurang, buruk
    @JsonKey(name: 'tingkat_kebisingan') String? tingkatKebisingan, // normal, cukup_bising, bising, sangat_bising
    
    // Unsafe conditions and acts
    @JsonKey(name: 'jumlah_unsafe_condition') @Default(0) int jumlahUnsafeCondition,
    @JsonKey(name: 'unsafe_condition') dynamic unsafeCondition, // JSONB array of objects
    @JsonKey(name: 'foto_unsafe_condition') @Default([]) List<String> fotoUnsafeCondition,
    @JsonKey(name: 'jumlah_unsafe_act') @Default(0) int jumlahUnsafeAct,
    @JsonKey(name: 'unsafe_act') dynamic unsafeAct, // JSONB array of objects
    @JsonKey(name: 'foto_unsafe_act') @Default([]) List<String> fotoUnsafeAct,
    
    // Worker observations
    @JsonKey(name: 'pekerja_diamati') @Default(0) int pekerjaDiamati,
    @JsonKey(name: 'pekerja_patuh_apd') @Default(0) int pekerjaPatuhApd,
    @JsonKey(name: 'pekerja_tidak_patuh_apd') @Default(0) int pekerjaTidakPatuhApd,
    @JsonKey(name: 'persentase_kepatuhan_apd') double? persentaseKepatuhanApd,
    @JsonKey(name: 'detail_apd') dynamic detailApd, // JSONB array of objects
    
    // Housekeeping
    @JsonKey(name: 'skor_housekeeping') int? skorHousekeeping,
    @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping, // sangat_baik, baik, cukup, kurang, buruk
    @JsonKey(name: 'area_kotor') @Default([]) List<String> areaKotor,
    @JsonKey(name: 'area_rapi') @Default([]) List<String> areaRapi,
    
    // Equipment checks
    @JsonKey(name: 'jumlah_mesin_diperiksa') @Default(0) int jumlahMesinDiperiksa,
    @JsonKey(name: 'mesin_kondisi_baik') @Default(0) int mesinKondisiBaik,
    @JsonKey(name: 'mesin_perlu_perbaikan') @Default(0) int mesinPerluPerbaikan,
    @JsonKey(name: 'detail_mesin') dynamic detailMesin, // JSONB array of objects
    
    // Safety equipment checks
    @JsonKey(name: 'rambu_k3_lengkap') @Default(false) bool rambuK3Lengkap,
    @JsonKey(name: 'rambu_k3_hilang') @Default([]) List<String> rambuK3Hilang,
    @JsonKey(name: 'rambu_k3_rusak') @Default([]) List<String> rambuK3Rusak,
    @JsonKey(name: 'label_b3_lengkap') @Default(false) bool labelB3Lengkap,
    @JsonKey(name: 'jalur_evakuasi_bebas') @Default(false) bool jalurEvakuasiBebas,
    @JsonKey(name: 'pintu_darurat_berfungsi') @Default(false) bool pintuDaruratBerfungsi,
    @JsonKey(name: 'apar_tersedia') @Default(false) bool aparTersedia,
    @JsonKey(name: 'apar_expire') @Default(0) int aparExpire,
    @JsonKey(name: 'emergency_light_berfungsi') @Default(false) bool emergencyLightBerfungsi,
    
    // Positive observations
    @JsonKey(name: 'good_practice') @Default([]) List<String> goodPractice,
    @JsonKey(name: 'area_excellent') @Default([]) List<String> areaExcellent,
    @JsonKey(name: 'pekerja_teladan') @Default([]) List<String> pekerjaTeladan,
    
    // Findings and recommendations
    @JsonKey(name: 'total_temuan') @Default(0) int totalTemuan,
    @JsonKey(name: 'temuan_kritikal') @Default(0) int temuanKritikal,
    @JsonKey(name: 'temuan_mayor') @Default(0) int temuanMayor,
    @JsonKey(name: 'temuan_minor') @Default(0) int temuanMinor,
    @Default([]) List<String> rekomendasi,
    @JsonKey(name: 'catatan_patrol') String? catatanPatrol,
    
    // Action items
    @JsonKey(name: 'action_items') dynamic actionItems, // JSONB array of objects
    @JsonKey(name: 'jumlah_action_item') @Default(0) int jumlahActionItem,
    @JsonKey(name: 'action_selesai') @Default(0) int actionSelesai,
    @JsonKey(name: 'action_progress') @Default(0) int actionProgress,
    @JsonKey(name: 'action_belum_mulai') @Default(0) int actionBelumMulai,
    
    // Stop work orders
    @JsonKey(name: 'stop_work_issued') @Default(false) bool stopWorkIssued,
    @JsonKey(name: 'stop_work_area') @Default([]) List<String> stopWorkArea,
    @JsonKey(name: 'stop_work_alasan') String? stopWorkAlasan,
    
    // Documentation
    @JsonKey(name: 'foto_patrol') @Default([]) List<String> fotoPatrol,
    @JsonKey(name: 'dokumen_pendukung') @Default([]) List<String> dokumenPendukung,
    
    // Scoring
    @JsonKey(name: 'skor_keseluruhan') double? skorKeseluruhan,
    @JsonKey(name: 'skor_apd') double? skorApd,
    @JsonKey(name: 'skor_kondisi_area') double? skorKondisiArea,
    @JsonKey(name: 'skor_peralatan') double? skorPeralatan,
    String? grade, // A, B, C, D, E
    
    // Status and approval
    @Default('draft') String status, // draft, submitted, reviewed, closed, cancelled
    @JsonKey(name: 'tingkat_urgensi') @Default('normal') String tingkatUrgensi, // rendah, normal, tinggi, kritis
    
    // Follow up
    @JsonKey(name: 'perlu_follow_up') @Default(false) bool perluFollowUp,
    @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
    @JsonKey(name: 'status_follow_up') String? statusFollowUp, // belum, dijadwalkan, selesai
    
    // Review information
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'review_notes') String? reviewNotes,
    
    // Audit fields
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SafetyPatrol;

  factory SafetyPatrol.fromJson(Map<String, dynamic> json) =>
      _$SafetyPatrolFromJson(json);
}
