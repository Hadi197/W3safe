// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_briefing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SafetyBriefingModelImpl _$$SafetyBriefingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SafetyBriefingModelImpl(
      id: json['id'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      waktuMulai: json['waktu_mulai'] as String,
      waktuSelesai: json['waktu_selesai'] as String?,
      unitId: json['unit_id'] as String?,
      petugasId: json['petugas_id'] as String?,
      topik: json['topik'] as String,
      materi: json['materi'] as String?,
      jumlahPeserta: (json['jumlah_peserta'] as num?)?.toInt() ?? 0,
      daftarPeserta: (json['daftar_peserta'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fotoDokumentasi: (json['foto_dokumentasi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'draft',
      catatan: json['catatan'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SafetyBriefingModelImplToJson(
        _$SafetyBriefingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tanggal': instance.tanggal.toIso8601String(),
      'waktu_mulai': instance.waktuMulai,
      'waktu_selesai': instance.waktuSelesai,
      'unit_id': instance.unitId,
      'petugas_id': instance.petugasId,
      'topik': instance.topik,
      'materi': instance.materi,
      'jumlah_peserta': instance.jumlahPeserta,
      'daftar_peserta': instance.daftarPeserta,
      'foto_dokumentasi': instance.fotoDokumentasi,
      'status': instance.status,
      'catatan': instance.catatan,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
