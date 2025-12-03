import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
class UnitModel with _$UnitModel {
  const factory UnitModel({
    required String id,
    required String kodeUnit,
    required String namaUnit,
    String? lokasi,
    @Default('aktif') String status,
    String? wilayahId,
    String? wilayahNama,
    String? areaId,
    String? areaNama,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);
}
