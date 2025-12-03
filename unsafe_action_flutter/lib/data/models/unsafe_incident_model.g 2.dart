// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsafe_incident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnsafeIncidentModelImpl _$$UnsafeIncidentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UnsafeIncidentModelImpl(
      id: json['id'] as String,
      tanggalKejadian: DateTime.parse(json['tanggalKejadian'] as String),
      waktuKejadian: json['waktuKejadian'] as String,
      lokasiKejadian: json['lokasiKejadian'] as String,
      unitKerja: json['unitKerja'] as String,
      unitId: json['unitId'] as String?,
      jenisKejadian: json['jenisKejadian'] as String,
      kategori: json['kategori'] as String,
      subKategori: json['subKategori'] as String?,
      deskripsiKejadian: json['deskripsiKejadian'] as String,
      penyebabDiduga: json['penyebabDiduga'] as String?,
      potensiRisiko: json['potensiRisiko'] as String?,
      pelaporNama: json['pelaporNama'] as String,
      pelaporJabatan: json['pelaporJabatan'] as String?,
      pelaporKontak: json['pelaporKontak'] as String?,
      tindakanSegera: json['tindakanSegera'] as String?,
      areaDiamankan: json['areaDiamankan'] as bool? ?? false,
      korbanAda: json['korbanAda'] as bool? ?? false,
      korbanJumlah: (json['korbanJumlah'] as num?)?.toInt() ?? 0,
      fotoKejadian: (json['fotoKejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoKejadian: (json['videoKejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      audioCatatan: json['audioCatatan'] as String?,
      prioritas: json['prioritas'] as String? ?? 'medium',
      severityLevel: (json['severityLevel'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gpsAccuracy: (json['gpsAccuracy'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'draft',
      assignedTo: json['assignedTo'] as String?,
      assignedBy: json['assignedBy'] as String?,
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      investigasiDilakukan: json['investigasiDilakukan'] as bool? ?? false,
      temuanInvestigasi: json['temuanInvestigasi'] as String?,
      rekomendasiKoreksi: (json['rekomendasiKoreksi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetPenyelesaian: json['targetPenyelesaian'] == null
          ? null
          : DateTime.parse(json['targetPenyelesaian'] as String),
      aktualPenyelesaian: json['aktualPenyelesaian'] == null
          ? null
          : DateTime.parse(json['aktualPenyelesaian'] as String),
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UnsafeIncidentModelImplToJson(
        _$UnsafeIncidentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tanggalKejadian': instance.tanggalKejadian.toIso8601String(),
      'waktuKejadian': instance.waktuKejadian,
      'lokasiKejadian': instance.lokasiKejadian,
      'unitKerja': instance.unitKerja,
      'unitId': instance.unitId,
      'jenisKejadian': instance.jenisKejadian,
      'kategori': instance.kategori,
      'subKategori': instance.subKategori,
      'deskripsiKejadian': instance.deskripsiKejadian,
      'penyebabDiduga': instance.penyebabDiduga,
      'potensiRisiko': instance.potensiRisiko,
      'pelaporNama': instance.pelaporNama,
      'pelaporJabatan': instance.pelaporJabatan,
      'pelaporKontak': instance.pelaporKontak,
      'tindakanSegera': instance.tindakanSegera,
      'areaDiamankan': instance.areaDiamankan,
      'korbanAda': instance.korbanAda,
      'korbanJumlah': instance.korbanJumlah,
      'fotoKejadian': instance.fotoKejadian,
      'videoKejadian': instance.videoKejadian,
      'audioCatatan': instance.audioCatatan,
      'prioritas': instance.prioritas,
      'severityLevel': instance.severityLevel,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'gpsAccuracy': instance.gpsAccuracy,
      'status': instance.status,
      'assignedTo': instance.assignedTo,
      'assignedBy': instance.assignedBy,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'investigasiDilakukan': instance.investigasiDilakukan,
      'temuanInvestigasi': instance.temuanInvestigasi,
      'rekomendasiKoreksi': instance.rekomendasiKoreksi,
      'targetPenyelesaian': instance.targetPenyelesaian?.toIso8601String(),
      'aktualPenyelesaian': instance.aktualPenyelesaian?.toIso8601String(),
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
