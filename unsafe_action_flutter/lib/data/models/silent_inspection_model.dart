import 'package:freezed_annotation/freezed_annotation.dart';

part 'silent_inspection_model.freezed.dart';
part 'silent_inspection_model.g.dart';

@freezed
class SilentInspectionModel with _$SilentInspectionModel {
  const factory SilentInspectionModel({
    String? id,
    @JsonKey(name: 'tanggal') required String tanggal,
    @JsonKey(name: 'waktu_mulai') String? waktuMulai,
    @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
    @JsonKey(name: 'unit_id') required String unitId,
    @JsonKey(name: 'area_inspeksi') required String areaInspeksi,
    @JsonKey(name: 'kategori_bahaya') String? kategoriBahaya,
    @JsonKey(name: 'temuan_critical') @Default(0) int temuanCritical,
    @JsonKey(name: 'temuan_major') @Default(0) int temuanMajor,
    @JsonKey(name: 'temuan_minor') @Default(0) int temuanMinor,
    @JsonKey(name: 'jumlah_temuan') @Default(0) int jumlahTemuan,
    @JsonKey(name: 'deskripsi_temuan') String? deskripsiTemuan,
    @JsonKey(name: 'skor_kepatuhan') double? skorKepatuhan,
    @JsonKey(name: 'tingkat_risiko') String? tingkatRisiko,
    @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
    @JsonKey(name: 'penggunaan_apd') String? penggunaanApd,
    @JsonKey(name: 'rekomendasi') String? rekomendasi,
    @JsonKey(name: 'tindakan_korektif') String? tindakanKorektif,
    @JsonKey(name: 'pic_tindak_lanjut') String? picTindakLanjut,
    @JsonKey(name: 'target_penyelesaian') String? targetPenyelesaian,
    @JsonKey(name: 'status_tindak_lanjut') String? statusTindakLanjut,
    @JsonKey(name: 'status') @Default('draft') String status,
    @JsonKey(name: 'foto_kondisi_unsafe') @Default([]) List<String> fotoKondisiUnsafe,
    @JsonKey(name: 'foto_perilaku_unsafe') @Default([]) List<String> fotoPerilakuUnsafe,
    @JsonKey(name: 'catatan') String? catatan,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _SilentInspectionModel;

  factory SilentInspectionModel.fromJson(Map<String, dynamic> json) =>
      _$SilentInspectionModelFromJson(json);
}
