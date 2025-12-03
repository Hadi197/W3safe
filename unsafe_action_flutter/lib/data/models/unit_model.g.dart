// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitModelImpl _$$UnitModelImplFromJson(Map<String, dynamic> json) =>
    _$UnitModelImpl(
      id: json['id'] as String,
      kodeUnit: json['kodeUnit'] as String,
      namaUnit: json['namaUnit'] as String,
      lokasi: json['lokasi'] as String?,
      status: json['status'] as String? ?? 'aktif',
      wilayahId: json['wilayahId'] as String?,
      wilayahNama: json['wilayahNama'] as String?,
      areaId: json['areaId'] as String?,
      areaNama: json['areaNama'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UnitModelImplToJson(_$UnitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kodeUnit': instance.kodeUnit,
      'namaUnit': instance.namaUnit,
      'lokasi': instance.lokasi,
      'status': instance.status,
      'wilayahId': instance.wilayahId,
      'wilayahNama': instance.wilayahNama,
      'areaId': instance.areaId,
      'areaNama': instance.areaNama,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
