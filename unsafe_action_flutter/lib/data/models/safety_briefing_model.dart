import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_briefing_model.freezed.dart';
part 'safety_briefing_model.g.dart';

@freezed
class SafetyBriefingModel with _$SafetyBriefingModel {
  const factory SafetyBriefingModel({
    required String id,
    @JsonKey(name: 'tanggal') required DateTime tanggal,
    @JsonKey(name: 'waktu_mulai') required String waktuMulai,
    @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
    @JsonKey(name: 'unit_id') String? unitId,
    @JsonKey(name: 'petugas_id') String? petugasId,
    @JsonKey(name: 'topik') required String topik,
    @JsonKey(name: 'materi') String? materi,
    @JsonKey(name: 'jumlah_peserta') @Default(0) int jumlahPeserta,
    @JsonKey(name: 'daftar_peserta') @Default([]) List<String> daftarPeserta,
    @JsonKey(name: 'foto_dokumentasi') @Default([]) List<String> fotoDokumentasi,
    @JsonKey(name: 'status') @Default('draft') String status,
    @JsonKey(name: 'catatan') String? catatan,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SafetyBriefingModel;

  factory SafetyBriefingModel.fromJson(Map<String, dynamic> json) =>
      _$SafetyBriefingModelFromJson(json);
}
