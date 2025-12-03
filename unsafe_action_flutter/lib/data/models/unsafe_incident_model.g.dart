// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsafe_incident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnsafeIncidentModelImpl _$$UnsafeIncidentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UnsafeIncidentModelImpl(
      id: json['id'] as String,
      tanggalKejadian: DateTime.parse(json['tanggal_kejadian'] as String),
      waktuKejadian: json['waktu_kejadian'] as String,
      lokasiKejadian: json['lokasi_kejadian'] as String,
      unitKerja: json['unit_kerja'] as String,
      unitId: json['unit_id'] as String?,
      jenisKejadian: json['jenis_kejadian'] as String,
      kategori: json['kategori'] as String,
      subKategori: json['sub_kategori'] as String?,
      deskripsiKejadian: json['deskripsi_kejadian'] as String,
      penyebabDiduga: json['penyebab_diduga'] as String?,
      potensiRisiko: json['potensi_risiko'] as String?,
      pelaporNama: json['pelapor_nama'] as String,
      pelaporJabatan: json['pelapor_jabatan'] as String?,
      pelaporKontak: json['pelapor_kontak'] as String?,
      tindakanSegera: json['tindakan_segera'] as String?,
      areaDiamankan: json['area_diamankan'] as bool? ?? false,
      korbanAda: json['korban_ada'] as bool? ?? false,
      korbanJumlah: (json['korban_jumlah'] as num?)?.toInt() ?? 0,
      fotoKejadian: (json['foto_kejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoKejadian: (json['video_kejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      audioCatatan: json['audio_catatan'] as String?,
      prioritas: json['prioritas'] as String? ?? 'medium',
      severityLevel: (json['severity_level'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gpsAccuracy: (json['gps_accuracy'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'draft',
      assignedTo: json['assigned_to'] as String?,
      assignedBy: json['assigned_by'] as String?,
      assignedAt: json['assigned_at'] == null
          ? null
          : DateTime.parse(json['assigned_at'] as String),
      investigasiDilakukan: json['investigasi_dilakukan'] as bool? ?? false,
      temuanInvestigasi: json['temuan_investigasi'] as String?,
      rekomendasiKoreksi: (json['rekomendasi_koreksi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetPenyelesaian: json['target_penyelesaian'] == null
          ? null
          : DateTime.parse(json['target_penyelesaian'] as String),
      aktualPenyelesaian: json['aktual_penyelesaian'] == null
          ? null
          : DateTime.parse(json['aktual_penyelesaian'] as String),
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UnsafeIncidentModelImplToJson(
        _$UnsafeIncidentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tanggal_kejadian': instance.tanggalKejadian.toIso8601String(),
      'waktu_kejadian': instance.waktuKejadian,
      'lokasi_kejadian': instance.lokasiKejadian,
      'unit_kerja': instance.unitKerja,
      'unit_id': instance.unitId,
      'jenis_kejadian': instance.jenisKejadian,
      'kategori': instance.kategori,
      'sub_kategori': instance.subKategori,
      'deskripsi_kejadian': instance.deskripsiKejadian,
      'penyebab_diduga': instance.penyebabDiduga,
      'potensi_risiko': instance.potensiRisiko,
      'pelapor_nama': instance.pelaporNama,
      'pelapor_jabatan': instance.pelaporJabatan,
      'pelapor_kontak': instance.pelaporKontak,
      'tindakan_segera': instance.tindakanSegera,
      'area_diamankan': instance.areaDiamankan,
      'korban_ada': instance.korbanAda,
      'korban_jumlah': instance.korbanJumlah,
      'foto_kejadian': instance.fotoKejadian,
      'video_kejadian': instance.videoKejadian,
      'audio_catatan': instance.audioCatatan,
      'prioritas': instance.prioritas,
      'severity_level': instance.severityLevel,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'gps_accuracy': instance.gpsAccuracy,
      'status': instance.status,
      'assigned_to': instance.assignedTo,
      'assigned_by': instance.assignedBy,
      'assigned_at': instance.assignedAt?.toIso8601String(),
      'investigasi_dilakukan': instance.investigasiDilakukan,
      'temuan_investigasi': instance.temuanInvestigasi,
      'rekomendasi_koreksi': instance.rekomendasiKoreksi,
      'target_penyelesaian': instance.targetPenyelesaian?.toIso8601String(),
      'aktual_penyelesaian': instance.aktualPenyelesaian?.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$IncidentStatsModelImpl _$$IncidentStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$IncidentStatsModelImpl(
      totalIncidents: (json['totalIncidents'] as num?)?.toInt() ?? 0,
      unsafeActionCount: (json['unsafeActionCount'] as num?)?.toInt() ?? 0,
      unsafeConditionCount:
          (json['unsafeConditionCount'] as num?)?.toInt() ?? 0,
      recentIncidents: (json['recentIncidents'] as num?)?.toInt() ?? 0,
      byPriority: (json['byPriority'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      byStatus: (json['byStatus'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$IncidentStatsModelImplToJson(
        _$IncidentStatsModelImpl instance) =>
    <String, dynamic>{
      'totalIncidents': instance.totalIncidents,
      'unsafeActionCount': instance.unsafeActionCount,
      'unsafeConditionCount': instance.unsafeConditionCount,
      'recentIncidents': instance.recentIncidents,
      'byPriority': instance.byPriority,
      'byStatus': instance.byStatus,
    };
