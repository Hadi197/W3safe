// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'management_walkthrough_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagementWalkthroughModelImpl _$$ManagementWalkthroughModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagementWalkthroughModelImpl(
      id: json['id'] as String?,
      nomorWalkthrough: json['nomor_walkthrough'] as String,
      tanggalWalkthrough: DateTime.parse(json['tanggal_walkthrough'] as String),
      waktuMulai: json['waktu_mulai'] as String,
      waktuSelesai: json['waktu_selesai'] as String?,
      unitId: json['unit_id'] as String?,
      areaInspeksi: json['area_inspeksi'] as String,
      departemen: json['departemen'] as String?,
      pimpinanWalkthrough: json['pimpinan_walkthrough'] as String,
      anggotaTim: (json['anggota_tim'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jumlahTim: (json['jumlah_tim'] as num?)?.toInt() ?? 0,
      tujuanWalkthrough: json['tujuan_walkthrough'] as String?,
      fokusArea: (json['fokus_area'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jenisWalkthrough: json['jenis_walkthrough'] as String? ?? 'rutin',
      kondisiHousekeeping: json['kondisi_housekeeping'] as String?,
      kondisiPencahayaan: json['kondisi_pencahayaan'] as String?,
      kondisiVentilasi: json['kondisi_ventilasi'] as String?,
      kondisiAksesJalan: json['kondisi_akses_jalan'] as String?,
      kepatuhanApd: (json['kepatuhan_apd'] as num?)?.toInt() ?? 0,
      apdTersedia: json['apd_tersedia'] as bool? ?? false,
      apdKondisiBaik: json['apd_kondisi_baik'] as bool? ?? false,
      apdDigunakanBenar: json['apd_digunakan_benar'] as bool? ?? false,
      apdTidakSesuai: (json['apd_tidak_sesuai'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pekerjaDiamati: (json['pekerja_diamati'] as num?)?.toInt() ?? 0,
      perilakuAman: (json['perilaku_aman'] as num?)?.toInt() ?? 0,
      perilakuTidakAman: (json['perilaku_tidak_aman'] as num?)?.toInt() ?? 0,
      perilakuTidakAmanDetail: json['perilaku_tidak_aman_detail'],
      jumlahPekerjaDiwawancara:
          (json['jumlah_pekerja_diwawancara'] as num?)?.toInt() ?? 0,
      feedbackPekerja: (json['feedback_pekerja'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      saranPekerja: (json['saran_pekerja'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pekerjaAwareProsedur: json['pekerja_aware_prosedur'] as bool? ?? false,
      jumlahTemuan: (json['jumlah_temuan'] as num?)?.toInt() ?? 0,
      temuanBahaya: json['temuan_bahaya'],
      temuanKritis: (json['temuan_kritis'] as num?)?.toInt() ?? 0,
      temuanMayor: (json['temuan_mayor'] as num?)?.toInt() ?? 0,
      temuanMinor: (json['temuan_minor'] as num?)?.toInt() ?? 0,
      temuanObservasi: (json['temuan_observasi'] as num?)?.toInt() ?? 0,
      pelanggaranProsedur: (json['pelanggaran_prosedur'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pelanggaranPeraturan: (json['pelanggaran_peraturan'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      areaNonCompliance: (json['area_non_compliance'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      praktekBaik: (json['praktek_baik'] as List<dynamic>?)
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
      actionItems: json['action_items'],
      jumlahActionItem: (json['jumlah_action_item'] as num?)?.toInt() ?? 0,
      actionSelesai: (json['action_selesai'] as num?)?.toInt() ?? 0,
      actionProgress: (json['action_progress'] as num?)?.toInt() ?? 0,
      actionBelumMulai: (json['action_belum_mulai'] as num?)?.toInt() ?? 0,
      tindakanSegera: (json['tindakan_segera'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      areaDitutup: (json['area_ditutup'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pekerjaanDihentikan: (json['pekerjaan_dihentikan'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fotoWalkthrough: (json['foto_walkthrough'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dokumenPendukung: (json['dokumen_pendukung'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sketsaLokasiUrl: json['sketsa_lokasi_url'] as String?,
      videoUrl: json['video_url'] as String?,
      ringkasanObservasi: json['ringkasan_observasi'] as String?,
      rekomendasi: (json['rekomendasi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      catatanKhusus: json['catatan_khusus'] as String?,
      status: json['status'] as String? ?? 'draft',
      tingkatUrgensi: json['tingkat_urgensi'] as String? ?? 'normal',
      perluFollowUp: json['perlu_follow_up'] as bool? ?? false,
      tanggalFollowUp: json['tanggal_follow_up'] == null
          ? null
          : DateTime.parse(json['tanggal_follow_up'] as String),
      statusFollowUp: json['status_follow_up'] as String? ?? 'belum',
      skorKeseluruhan: (json['skor_keseluruhan'] as num?)?.toInt() ?? 0,
      skorHousekeeping: (json['skor_housekeeping'] as num?)?.toInt() ?? 0,
      skorApd: (json['skor_apd'] as num?)?.toInt() ?? 0,
      skorPerilaku: (json['skor_perilaku'] as num?)?.toInt() ?? 0,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
    );

Map<String, dynamic> _$$ManagementWalkthroughModelImplToJson(
        _$ManagementWalkthroughModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomor_walkthrough': instance.nomorWalkthrough,
      'tanggal_walkthrough': instance.tanggalWalkthrough.toIso8601String(),
      'waktu_mulai': instance.waktuMulai,
      'waktu_selesai': instance.waktuSelesai,
      'unit_id': instance.unitId,
      'area_inspeksi': instance.areaInspeksi,
      'departemen': instance.departemen,
      'pimpinan_walkthrough': instance.pimpinanWalkthrough,
      'anggota_tim': instance.anggotaTim,
      'jumlah_tim': instance.jumlahTim,
      'tujuan_walkthrough': instance.tujuanWalkthrough,
      'fokus_area': instance.fokusArea,
      'jenis_walkthrough': instance.jenisWalkthrough,
      'kondisi_housekeeping': instance.kondisiHousekeeping,
      'kondisi_pencahayaan': instance.kondisiPencahayaan,
      'kondisi_ventilasi': instance.kondisiVentilasi,
      'kondisi_akses_jalan': instance.kondisiAksesJalan,
      'kepatuhan_apd': instance.kepatuhanApd,
      'apd_tersedia': instance.apdTersedia,
      'apd_kondisi_baik': instance.apdKondisiBaik,
      'apd_digunakan_benar': instance.apdDigunakanBenar,
      'apd_tidak_sesuai': instance.apdTidakSesuai,
      'pekerja_diamati': instance.pekerjaDiamati,
      'perilaku_aman': instance.perilakuAman,
      'perilaku_tidak_aman': instance.perilakuTidakAman,
      'perilaku_tidak_aman_detail': instance.perilakuTidakAmanDetail,
      'jumlah_pekerja_diwawancara': instance.jumlahPekerjaDiwawancara,
      'feedback_pekerja': instance.feedbackPekerja,
      'saran_pekerja': instance.saranPekerja,
      'pekerja_aware_prosedur': instance.pekerjaAwareProsedur,
      'jumlah_temuan': instance.jumlahTemuan,
      'temuan_bahaya': instance.temuanBahaya,
      'temuan_kritis': instance.temuanKritis,
      'temuan_mayor': instance.temuanMayor,
      'temuan_minor': instance.temuanMinor,
      'temuan_observasi': instance.temuanObservasi,
      'pelanggaran_prosedur': instance.pelanggaranProsedur,
      'pelanggaran_peraturan': instance.pelanggaranPeraturan,
      'area_non_compliance': instance.areaNonCompliance,
      'praktek_baik': instance.praktekBaik,
      'area_excellent': instance.areaExcellent,
      'pekerja_teladan': instance.pekerjaTeladan,
      'action_items': instance.actionItems,
      'jumlah_action_item': instance.jumlahActionItem,
      'action_selesai': instance.actionSelesai,
      'action_progress': instance.actionProgress,
      'action_belum_mulai': instance.actionBelumMulai,
      'tindakan_segera': instance.tindakanSegera,
      'area_ditutup': instance.areaDitutup,
      'pekerjaan_dihentikan': instance.pekerjaanDihentikan,
      'foto_walkthrough': instance.fotoWalkthrough,
      'dokumen_pendukung': instance.dokumenPendukung,
      'sketsa_lokasi_url': instance.sketsaLokasiUrl,
      'video_url': instance.videoUrl,
      'ringkasan_observasi': instance.ringkasanObservasi,
      'rekomendasi': instance.rekomendasi,
      'catatan_khusus': instance.catatanKhusus,
      'status': instance.status,
      'tingkat_urgensi': instance.tingkatUrgensi,
      'perlu_follow_up': instance.perluFollowUp,
      'tanggal_follow_up': instance.tanggalFollowUp?.toIso8601String(),
      'status_follow_up': instance.statusFollowUp,
      'skor_keseluruhan': instance.skorKeseluruhan,
      'skor_housekeeping': instance.skorHousekeeping,
      'skor_apd': instance.skorApd,
      'skor_perilaku': instance.skorPerilaku,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
    };
