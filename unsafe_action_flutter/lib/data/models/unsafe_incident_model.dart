import 'package:freezed_annotation/freezed_annotation.dart';

part 'unsafe_incident_model.freezed.dart';
part 'unsafe_incident_model.g.dart';

@freezed
class UnsafeIncidentModel with _$UnsafeIncidentModel {
  const factory UnsafeIncidentModel({
    required String id,
    @JsonKey(name: 'tanggal_kejadian') required DateTime tanggalKejadian,
    @JsonKey(name: 'waktu_kejadian') required String waktuKejadian,
    @JsonKey(name: 'lokasi_kejadian') required String lokasiKejadian,
    @JsonKey(name: 'unit_kerja') required String unitKerja, // Keep for backward compatibility
    @JsonKey(name: 'unit_id') String? unitId, // New field for FK to units table
    @JsonKey(name: 'jenis_kejadian') required String jenisKejadian,
    required String kategori,
    @JsonKey(name: 'sub_kategori') String? subKategori,
    @JsonKey(name: 'deskripsi_kejadian') required String deskripsiKejadian,
    @JsonKey(name: 'penyebab_diduga') String? penyebabDiduga,
    @JsonKey(name: 'potensi_risiko') String? potensiRisiko,
    @JsonKey(name: 'pelapor_nama') required String pelaporNama,
    @JsonKey(name: 'pelapor_jabatan') String? pelaporJabatan,
    @JsonKey(name: 'pelapor_kontak') String? pelaporKontak,
    @JsonKey(name: 'tindakan_segera') String? tindakanSegera,
    @JsonKey(name: 'area_diamankan') @Default(false) bool areaDiamankan,
    @JsonKey(name: 'korban_ada') @Default(false) bool korbanAda,
    @JsonKey(name: 'korban_jumlah') @Default(0) int korbanJumlah,
    @JsonKey(name: 'foto_kejadian') @Default([]) List<String> fotoKejadian,
    @JsonKey(name: 'video_kejadian') @Default([]) List<String> videoKejadian,
    @JsonKey(name: 'audio_catatan') String? audioCatatan,
    @Default('medium') String prioritas,
    @JsonKey(name: 'severity_level') int? severityLevel,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'gps_accuracy') double? gpsAccuracy,
    @Default('draft') String status,
    @JsonKey(name: 'assigned_to') String? assignedTo,
    @JsonKey(name: 'assigned_by') String? assignedBy,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    @JsonKey(name: 'investigasi_dilakukan') @Default(false) bool investigasiDilakukan,
    @JsonKey(name: 'temuan_investigasi') String? temuanInvestigasi,
    @JsonKey(name: 'rekomendasi_koreksi') @Default([]) List<String> rekomendasiKoreksi,
    @JsonKey(name: 'target_penyelesaian') DateTime? targetPenyelesaian,
    @JsonKey(name: 'aktual_penyelesaian') DateTime? aktualPenyelesaian,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UnsafeIncidentModel;

  factory UnsafeIncidentModel.fromJson(Map<String, dynamic> json) =>
      _$UnsafeIncidentModelFromJson(json);
}

// Stats Model
@freezed
class IncidentStatsModel with _$IncidentStatsModel {
  const factory IncidentStatsModel({
    @Default(0) int totalIncidents,
    @Default(0) int unsafeActionCount,
    @Default(0) int unsafeConditionCount,
    @Default(0) int recentIncidents,
    @Default({}) Map<String, int> byPriority,
    @Default({}) Map<String, int> byStatus,
  }) = _IncidentStatsModel;

  factory IncidentStatsModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentStatsModelFromJson(json);
}
