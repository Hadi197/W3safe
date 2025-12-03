// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'silent_inspection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SilentInspectionModelImpl _$$SilentInspectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SilentInspectionModelImpl(
      id: json['id'] as String?,
      tanggal: json['tanggal'] as String,
      waktuMulai: json['waktu_mulai'] as String?,
      waktuSelesai: json['waktu_selesai'] as String?,
      unitId: json['unit_id'] as String,
      areaInspeksi: json['area_inspeksi'] as String,
      kategoriBahaya: json['kategori_bahaya'] as String?,
      temuanCritical: (json['temuan_critical'] as num?)?.toInt() ?? 0,
      temuanMajor: (json['temuan_major'] as num?)?.toInt() ?? 0,
      temuanMinor: (json['temuan_minor'] as num?)?.toInt() ?? 0,
      jumlahTemuan: (json['jumlah_temuan'] as num?)?.toInt() ?? 0,
      deskripsiTemuan: json['deskripsi_temuan'] as String?,
      skorKepatuhan: (json['skor_kepatuhan'] as num?)?.toDouble(),
      tingkatRisiko: json['tingkat_risiko'] as String?,
      kondisiHousekeeping: json['kondisi_housekeeping'] as String?,
      penggunaanApd: json['penggunaan_apd'] as String?,
      rekomendasi: json['rekomendasi'] as String?,
      tindakanKorektif: json['tindakan_korektif'] as String?,
      picTindakLanjut: json['pic_tindak_lanjut'] as String?,
      targetPenyelesaian: json['target_penyelesaian'] as String?,
      statusTindakLanjut: json['status_tindak_lanjut'] as String?,
      status: json['status'] as String? ?? 'draft',
      fotoKondisiUnsafe: (json['foto_kondisi_unsafe'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fotoPerilakuUnsafe: (json['foto_perilaku_unsafe'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      catatan: json['catatan'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$SilentInspectionModelImplToJson(
        _$SilentInspectionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tanggal': instance.tanggal,
      'waktu_mulai': instance.waktuMulai,
      'waktu_selesai': instance.waktuSelesai,
      'unit_id': instance.unitId,
      'area_inspeksi': instance.areaInspeksi,
      'kategori_bahaya': instance.kategoriBahaya,
      'temuan_critical': instance.temuanCritical,
      'temuan_major': instance.temuanMajor,
      'temuan_minor': instance.temuanMinor,
      'jumlah_temuan': instance.jumlahTemuan,
      'deskripsi_temuan': instance.deskripsiTemuan,
      'skor_kepatuhan': instance.skorKepatuhan,
      'tingkat_risiko': instance.tingkatRisiko,
      'kondisi_housekeeping': instance.kondisiHousekeeping,
      'penggunaan_apd': instance.penggunaanApd,
      'rekomendasi': instance.rekomendasi,
      'tindakan_korektif': instance.tindakanKorektif,
      'pic_tindak_lanjut': instance.picTindakLanjut,
      'target_penyelesaian': instance.targetPenyelesaian,
      'status_tindak_lanjut': instance.statusTindakLanjut,
      'status': instance.status,
      'foto_kondisi_unsafe': instance.fotoKondisiUnsafe,
      'foto_perilaku_unsafe': instance.fotoPerilakuUnsafe,
      'catatan': instance.catatan,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
