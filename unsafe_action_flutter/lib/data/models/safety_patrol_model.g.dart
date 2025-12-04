// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_patrol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SafetyPatrolImpl _$$SafetyPatrolImplFromJson(Map<String, dynamic> json) =>
    _$SafetyPatrolImpl(
      id: json['id'] as String?,
      nomorPatrol: json['nomor_patrol'] as String? ?? '',
      tanggalPatrol: json['tanggal_patrol'] == null
          ? null
          : DateTime.parse(json['tanggal_patrol'] as String),
      waktuMulai: json['waktu_mulai'] as String?,
      waktuSelesai: json['waktu_selesai'] as String?,
      shift: json['shift'] as String?,
      unitId: json['unit_id'] as String?,
      areaPatrol: json['area_patrol'] as String? ?? '',
      lokasiSpesifik: json['lokasi_spesifik'] as String?,
      ketuaPatrol: json['ketua_patrol'] as String? ?? '',
      anggotaPatrol: (json['anggota_patrol'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jumlahAnggota: (json['jumlah_anggota'] as num?)?.toInt() ?? 0,
      jenisPatrol: json['jenis_patrol'] as String?,
      tujuanPatrol: json['tujuan_patrol'] as String?,
      fokusPatrol: (json['fokus_patrol'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      cuaca: json['cuaca'] as String?,
      suhuArea: (json['suhu_area'] as num?)?.toDouble(),
      kondisiPencahayaan: json['kondisi_pencahayaan'] as String?,
      kondisiVentilasi: json['kondisi_ventilasi'] as String?,
      tingkatKebisingan: json['tingkat_kebisingan'] as String?,
      jumlahUnsafeCondition:
          (json['jumlah_unsafe_condition'] as num?)?.toInt() ?? 0,
      unsafeCondition: json['unsafe_condition'],
      fotoUnsafeCondition: (json['foto_unsafe_condition'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jumlahUnsafeAct: (json['jumlah_unsafe_act'] as num?)?.toInt() ?? 0,
      unsafeAct: json['unsafe_act'],
      fotoUnsafeAct: (json['foto_unsafe_act'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pekerjaDiamati: (json['pekerja_diamati'] as num?)?.toInt() ?? 0,
      pekerjaPatuhApd: (json['pekerja_patuh_apd'] as num?)?.toInt() ?? 0,
      pekerjaTidakPatuhApd:
          (json['pekerja_tidak_patuh_apd'] as num?)?.toInt() ?? 0,
      persentaseKepatuhanApd:
          (json['persentase_kepatuhan_apd'] as num?)?.toDouble(),
      detailApd: json['detail_apd'],
      skorHousekeeping: (json['skor_housekeeping'] as num?)?.toInt(),
      kondisiHousekeeping: json['kondisi_housekeeping'] as String?,
      areaKotor: (json['area_kotor'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      areaRapi: (json['area_rapi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jumlahMesinDiperiksa:
          (json['jumlah_mesin_diperiksa'] as num?)?.toInt() ?? 0,
      mesinKondisiBaik: (json['mesin_kondisi_baik'] as num?)?.toInt() ?? 0,
      mesinPerluPerbaikan:
          (json['mesin_perlu_perbaikan'] as num?)?.toInt() ?? 0,
      detailMesin: json['detail_mesin'],
      rambuK3Lengkap: json['rambu_k3_lengkap'] as bool? ?? false,
      rambuK3Hilang: (json['rambu_k3_hilang'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rambuK3Rusak: (json['rambu_k3_rusak'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      labelB3Lengkap: json['label_b3_lengkap'] as bool? ?? false,
      jalurEvakuasiBebas: json['jalur_evakuasi_bebas'] as bool? ?? false,
      pintuDaruratBerfungsi: json['pintu_darurat_berfungsi'] as bool? ?? false,
      aparTersedia: json['apar_tersedia'] as bool? ?? false,
      aparExpire: (json['apar_expire'] as num?)?.toInt() ?? 0,
      emergencyLightBerfungsi:
          json['emergency_light_berfungsi'] as bool? ?? false,
      goodPractice: (json['good_practice'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      areaExcellent: (json['area_excellent'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pekerjaTeladan: (json['pekerja_teladan'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalTemuan: (json['total_temuan'] as num?)?.toInt() ?? 0,
      temuanKritikal: (json['temuan_kritikal'] as num?)?.toInt() ?? 0,
      temuanMayor: (json['temuan_mayor'] as num?)?.toInt() ?? 0,
      temuanMinor: (json['temuan_minor'] as num?)?.toInt() ?? 0,
      rekomendasi: (json['rekomendasi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      catatanPatrol: json['catatan_patrol'] as String?,
      actionItems: json['action_items'],
      jumlahActionItem: (json['jumlah_action_item'] as num?)?.toInt() ?? 0,
      actionSelesai: (json['action_selesai'] as num?)?.toInt() ?? 0,
      actionProgress: (json['action_progress'] as num?)?.toInt() ?? 0,
      actionBelumMulai: (json['action_belum_mulai'] as num?)?.toInt() ?? 0,
      stopWorkIssued: json['stop_work_issued'] as bool? ?? false,
      stopWorkArea: (json['stop_work_area'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      stopWorkAlasan: json['stop_work_alasan'] as String?,
      fotoPatrol: (json['foto_patrol'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dokumenPendukung: (json['dokumen_pendukung'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skorKeseluruhan: (json['skor_keseluruhan'] as num?)?.toDouble(),
      skorApd: (json['skor_apd'] as num?)?.toDouble(),
      skorKondisiArea: (json['skor_kondisi_area'] as num?)?.toDouble(),
      skorPeralatan: (json['skor_peralatan'] as num?)?.toDouble(),
      grade: json['grade'] as String?,
      status: json['status'] as String? ?? 'draft',
      tingkatUrgensi: json['tingkat_urgensi'] as String? ?? 'normal',
      perluFollowUp: json['perlu_follow_up'] as bool? ?? false,
      tanggalFollowUp: json['tanggal_follow_up'] == null
          ? null
          : DateTime.parse(json['tanggal_follow_up'] as String),
      statusFollowUp: json['status_follow_up'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewNotes: json['review_notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SafetyPatrolImplToJson(_$SafetyPatrolImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomor_patrol': instance.nomorPatrol,
      'tanggal_patrol': instance.tanggalPatrol?.toIso8601String(),
      'waktu_mulai': instance.waktuMulai,
      'waktu_selesai': instance.waktuSelesai,
      'shift': instance.shift,
      'unit_id': instance.unitId,
      'area_patrol': instance.areaPatrol,
      'lokasi_spesifik': instance.lokasiSpesifik,
      'ketua_patrol': instance.ketuaPatrol,
      'anggota_patrol': instance.anggotaPatrol,
      'jumlah_anggota': instance.jumlahAnggota,
      'jenis_patrol': instance.jenisPatrol,
      'tujuan_patrol': instance.tujuanPatrol,
      'fokus_patrol': instance.fokusPatrol,
      'cuaca': instance.cuaca,
      'suhu_area': instance.suhuArea,
      'kondisi_pencahayaan': instance.kondisiPencahayaan,
      'kondisi_ventilasi': instance.kondisiVentilasi,
      'tingkat_kebisingan': instance.tingkatKebisingan,
      'jumlah_unsafe_condition': instance.jumlahUnsafeCondition,
      'unsafe_condition': instance.unsafeCondition,
      'foto_unsafe_condition': instance.fotoUnsafeCondition,
      'jumlah_unsafe_act': instance.jumlahUnsafeAct,
      'unsafe_act': instance.unsafeAct,
      'foto_unsafe_act': instance.fotoUnsafeAct,
      'pekerja_diamati': instance.pekerjaDiamati,
      'pekerja_patuh_apd': instance.pekerjaPatuhApd,
      'pekerja_tidak_patuh_apd': instance.pekerjaTidakPatuhApd,
      'persentase_kepatuhan_apd': instance.persentaseKepatuhanApd,
      'detail_apd': instance.detailApd,
      'skor_housekeeping': instance.skorHousekeeping,
      'kondisi_housekeeping': instance.kondisiHousekeeping,
      'area_kotor': instance.areaKotor,
      'area_rapi': instance.areaRapi,
      'jumlah_mesin_diperiksa': instance.jumlahMesinDiperiksa,
      'mesin_kondisi_baik': instance.mesinKondisiBaik,
      'mesin_perlu_perbaikan': instance.mesinPerluPerbaikan,
      'detail_mesin': instance.detailMesin,
      'rambu_k3_lengkap': instance.rambuK3Lengkap,
      'rambu_k3_hilang': instance.rambuK3Hilang,
      'rambu_k3_rusak': instance.rambuK3Rusak,
      'label_b3_lengkap': instance.labelB3Lengkap,
      'jalur_evakuasi_bebas': instance.jalurEvakuasiBebas,
      'pintu_darurat_berfungsi': instance.pintuDaruratBerfungsi,
      'apar_tersedia': instance.aparTersedia,
      'apar_expire': instance.aparExpire,
      'emergency_light_berfungsi': instance.emergencyLightBerfungsi,
      'good_practice': instance.goodPractice,
      'area_excellent': instance.areaExcellent,
      'pekerja_teladan': instance.pekerjaTeladan,
      'total_temuan': instance.totalTemuan,
      'temuan_kritikal': instance.temuanKritikal,
      'temuan_mayor': instance.temuanMayor,
      'temuan_minor': instance.temuanMinor,
      'rekomendasi': instance.rekomendasi,
      'catatan_patrol': instance.catatanPatrol,
      'action_items': instance.actionItems,
      'jumlah_action_item': instance.jumlahActionItem,
      'action_selesai': instance.actionSelesai,
      'action_progress': instance.actionProgress,
      'action_belum_mulai': instance.actionBelumMulai,
      'stop_work_issued': instance.stopWorkIssued,
      'stop_work_area': instance.stopWorkArea,
      'stop_work_alasan': instance.stopWorkAlasan,
      'foto_patrol': instance.fotoPatrol,
      'dokumen_pendukung': instance.dokumenPendukung,
      'skor_keseluruhan': instance.skorKeseluruhan,
      'skor_apd': instance.skorApd,
      'skor_kondisi_area': instance.skorKondisiArea,
      'skor_peralatan': instance.skorPeralatan,
      'grade': instance.grade,
      'status': instance.status,
      'tingkat_urgensi': instance.tingkatUrgensi,
      'perlu_follow_up': instance.perluFollowUp,
      'tanggal_follow_up': instance.tanggalFollowUp?.toIso8601String(),
      'status_follow_up': instance.statusFollowUp,
      'reviewed_by': instance.reviewedBy,
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
      'review_notes': instance.reviewNotes,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
