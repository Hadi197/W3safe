// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'management_walkthrough_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagementWalkthroughModel _$ManagementWalkthroughModelFromJson(
    Map<String, dynamic> json) {
  return _ManagementWalkthroughModel.fromJson(json);
}

/// @nodoc
mixin _$ManagementWalkthroughModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nomor_walkthrough')
  String get nomorWalkthrough => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal_walkthrough')
  DateTime get tanggalWalkthrough => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_mulai')
  String get waktuMulai => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_inspeksi')
  String get areaInspeksi => throw _privateConstructorUsedError;
  @JsonKey(name: 'departemen')
  String? get departemen => throw _privateConstructorUsedError;
  @JsonKey(name: 'pimpinan_walkthrough')
  String get pimpinanWalkthrough => throw _privateConstructorUsedError;
  @JsonKey(name: 'anggota_tim')
  List<String> get anggotaTim => throw _privateConstructorUsedError;
  @JsonKey(name: 'jumlah_tim')
  int get jumlahTim => throw _privateConstructorUsedError;
  @JsonKey(name: 'tujuan_walkthrough')
  String? get tujuanWalkthrough => throw _privateConstructorUsedError;
  @JsonKey(name: 'fokus_area')
  List<String> get fokusArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'jenis_walkthrough')
  String get jenisWalkthrough =>
      throw _privateConstructorUsedError; // Observasi Kondisi
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_pencahayaan')
  String? get kondisiPencahayaan => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_ventilasi')
  String? get kondisiVentilasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_akses_jalan')
  String? get kondisiAksesJalan => throw _privateConstructorUsedError; // APD
  @JsonKey(name: 'kepatuhan_apd')
  int get kepatuhanApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'apd_tersedia')
  bool get apdTersedia => throw _privateConstructorUsedError;
  @JsonKey(name: 'apd_kondisi_baik')
  bool get apdKondisiBaik => throw _privateConstructorUsedError;
  @JsonKey(name: 'apd_digunakan_benar')
  bool get apdDigunakanBenar => throw _privateConstructorUsedError;
  @JsonKey(name: 'apd_tidak_sesuai')
  List<String> get apdTidakSesuai =>
      throw _privateConstructorUsedError; // Perilaku Kerja
  @JsonKey(name: 'pekerja_diamati')
  int get pekerjaDiamati => throw _privateConstructorUsedError;
  @JsonKey(name: 'perilaku_aman')
  int get perilakuAman => throw _privateConstructorUsedError;
  @JsonKey(name: 'perilaku_tidak_aman')
  int get perilakuTidakAman => throw _privateConstructorUsedError;
  @JsonKey(name: 'perilaku_tidak_aman_detail')
  dynamic get perilakuTidakAmanDetail =>
      throw _privateConstructorUsedError; // Interaksi Pekerja
  @JsonKey(name: 'jumlah_pekerja_diwawancara')
  int get jumlahPekerjaDiwawancara => throw _privateConstructorUsedError;
  @JsonKey(name: 'feedback_pekerja')
  List<String> get feedbackPekerja => throw _privateConstructorUsedError;
  @JsonKey(name: 'saran_pekerja')
  List<String> get saranPekerja => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerja_aware_prosedur')
  bool get pekerjaAwareProsedur => throw _privateConstructorUsedError; // Temuan
  @JsonKey(name: 'jumlah_temuan')
  int get jumlahTemuan => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_bahaya')
  dynamic get temuanBahaya => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_kritis')
  int get temuanKritis => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_mayor')
  int get temuanMayor => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_observasi')
  int get temuanObservasi => throw _privateConstructorUsedError; // Pelanggaran
  @JsonKey(name: 'pelanggaran_prosedur')
  List<String> get pelanggaranProsedur => throw _privateConstructorUsedError;
  @JsonKey(name: 'pelanggaran_peraturan')
  List<String> get pelanggaranPeraturan => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_non_compliance')
  List<String> get areaNonCompliance =>
      throw _privateConstructorUsedError; // Positive Findings
  @JsonKey(name: 'praktek_baik')
  List<String> get praktekBaik => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_excellent')
  List<String> get areaExcellent => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerja_teladan')
  List<String> get pekerjaTeladan =>
      throw _privateConstructorUsedError; // Action Items
  @JsonKey(name: 'action_items')
  dynamic get actionItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'jumlah_action_item')
  int get jumlahActionItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_selesai')
  int get actionSelesai => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_progress')
  int get actionProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_belum_mulai')
  int get actionBelumMulai =>
      throw _privateConstructorUsedError; // Immediate Actions
  @JsonKey(name: 'tindakan_segera')
  List<String> get tindakanSegera => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_ditutup')
  List<String> get areaDitutup => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerjaan_dihentikan')
  List<String> get pekerjaanDihentikan =>
      throw _privateConstructorUsedError; // Dokumentasi
  @JsonKey(name: 'foto_walkthrough')
  List<String> get fotoWalkthrough => throw _privateConstructorUsedError;
  @JsonKey(name: 'dokumen_pendukung')
  List<String> get dokumenPendukung => throw _privateConstructorUsedError;
  @JsonKey(name: 'sketsa_lokasi_url')
  String? get sketsaLokasiUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError; // Ringkasan
  @JsonKey(name: 'ringkasan_observasi')
  String? get ringkasanObservasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'rekomendasi')
  List<String> get rekomendasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'catatan_khusus')
  String? get catatanKhusus => throw _privateConstructorUsedError; // Status
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'tingkat_urgensi')
  String get tingkatUrgensi => throw _privateConstructorUsedError;
  @JsonKey(name: 'perlu_follow_up')
  bool get perluFollowUp => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal_follow_up')
  DateTime? get tanggalFollowUp => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_follow_up')
  String get statusFollowUp => throw _privateConstructorUsedError; // Scoring
  @JsonKey(name: 'skor_keseluruhan')
  int get skorKeseluruhan => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_housekeeping')
  int get skorHousekeeping => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_apd')
  int get skorApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_perilaku')
  int get skorPerilaku => throw _privateConstructorUsedError; // Metadata
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ManagementWalkthroughModelCopyWith<ManagementWalkthroughModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagementWalkthroughModelCopyWith<$Res> {
  factory $ManagementWalkthroughModelCopyWith(ManagementWalkthroughModel value,
          $Res Function(ManagementWalkthroughModel) then) =
      _$ManagementWalkthroughModelCopyWithImpl<$Res,
          ManagementWalkthroughModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'nomor_walkthrough') String nomorWalkthrough,
      @JsonKey(name: 'tanggal_walkthrough') DateTime tanggalWalkthrough,
      @JsonKey(name: 'waktu_mulai') String waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'area_inspeksi') String areaInspeksi,
      @JsonKey(name: 'departemen') String? departemen,
      @JsonKey(name: 'pimpinan_walkthrough') String pimpinanWalkthrough,
      @JsonKey(name: 'anggota_tim') List<String> anggotaTim,
      @JsonKey(name: 'jumlah_tim') int jumlahTim,
      @JsonKey(name: 'tujuan_walkthrough') String? tujuanWalkthrough,
      @JsonKey(name: 'fokus_area') List<String> fokusArea,
      @JsonKey(name: 'jenis_walkthrough') String jenisWalkthrough,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi,
      @JsonKey(name: 'kondisi_akses_jalan') String? kondisiAksesJalan,
      @JsonKey(name: 'kepatuhan_apd') int kepatuhanApd,
      @JsonKey(name: 'apd_tersedia') bool apdTersedia,
      @JsonKey(name: 'apd_kondisi_baik') bool apdKondisiBaik,
      @JsonKey(name: 'apd_digunakan_benar') bool apdDigunakanBenar,
      @JsonKey(name: 'apd_tidak_sesuai') List<String> apdTidakSesuai,
      @JsonKey(name: 'pekerja_diamati') int pekerjaDiamati,
      @JsonKey(name: 'perilaku_aman') int perilakuAman,
      @JsonKey(name: 'perilaku_tidak_aman') int perilakuTidakAman,
      @JsonKey(name: 'perilaku_tidak_aman_detail')
      dynamic perilakuTidakAmanDetail,
      @JsonKey(name: 'jumlah_pekerja_diwawancara') int jumlahPekerjaDiwawancara,
      @JsonKey(name: 'feedback_pekerja') List<String> feedbackPekerja,
      @JsonKey(name: 'saran_pekerja') List<String> saranPekerja,
      @JsonKey(name: 'pekerja_aware_prosedur') bool pekerjaAwareProsedur,
      @JsonKey(name: 'jumlah_temuan') int jumlahTemuan,
      @JsonKey(name: 'temuan_bahaya') dynamic temuanBahaya,
      @JsonKey(name: 'temuan_kritis') int temuanKritis,
      @JsonKey(name: 'temuan_mayor') int temuanMayor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      @JsonKey(name: 'temuan_observasi') int temuanObservasi,
      @JsonKey(name: 'pelanggaran_prosedur') List<String> pelanggaranProsedur,
      @JsonKey(name: 'pelanggaran_peraturan') List<String> pelanggaranPeraturan,
      @JsonKey(name: 'area_non_compliance') List<String> areaNonCompliance,
      @JsonKey(name: 'praktek_baik') List<String> praktekBaik,
      @JsonKey(name: 'area_excellent') List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') List<String> pekerjaTeladan,
      @JsonKey(name: 'action_items') dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') int jumlahActionItem,
      @JsonKey(name: 'action_selesai') int actionSelesai,
      @JsonKey(name: 'action_progress') int actionProgress,
      @JsonKey(name: 'action_belum_mulai') int actionBelumMulai,
      @JsonKey(name: 'tindakan_segera') List<String> tindakanSegera,
      @JsonKey(name: 'area_ditutup') List<String> areaDitutup,
      @JsonKey(name: 'pekerjaan_dihentikan') List<String> pekerjaanDihentikan,
      @JsonKey(name: 'foto_walkthrough') List<String> fotoWalkthrough,
      @JsonKey(name: 'dokumen_pendukung') List<String> dokumenPendukung,
      @JsonKey(name: 'sketsa_lokasi_url') String? sketsaLokasiUrl,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'ringkasan_observasi') String? ringkasanObservasi,
      @JsonKey(name: 'rekomendasi') List<String> rekomendasi,
      @JsonKey(name: 'catatan_khusus') String? catatanKhusus,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'tingkat_urgensi') String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') String statusFollowUp,
      @JsonKey(name: 'skor_keseluruhan') int skorKeseluruhan,
      @JsonKey(name: 'skor_housekeeping') int skorHousekeeping,
      @JsonKey(name: 'skor_apd') int skorApd,
      @JsonKey(name: 'skor_perilaku') int skorPerilaku,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});
}

/// @nodoc
class _$ManagementWalkthroughModelCopyWithImpl<$Res,
        $Val extends ManagementWalkthroughModel>
    implements $ManagementWalkthroughModelCopyWith<$Res> {
  _$ManagementWalkthroughModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nomorWalkthrough = null,
    Object? tanggalWalkthrough = null,
    Object? waktuMulai = null,
    Object? waktuSelesai = freezed,
    Object? unitId = freezed,
    Object? areaInspeksi = null,
    Object? departemen = freezed,
    Object? pimpinanWalkthrough = null,
    Object? anggotaTim = null,
    Object? jumlahTim = null,
    Object? tujuanWalkthrough = freezed,
    Object? fokusArea = null,
    Object? jenisWalkthrough = null,
    Object? kondisiHousekeeping = freezed,
    Object? kondisiPencahayaan = freezed,
    Object? kondisiVentilasi = freezed,
    Object? kondisiAksesJalan = freezed,
    Object? kepatuhanApd = null,
    Object? apdTersedia = null,
    Object? apdKondisiBaik = null,
    Object? apdDigunakanBenar = null,
    Object? apdTidakSesuai = null,
    Object? pekerjaDiamati = null,
    Object? perilakuAman = null,
    Object? perilakuTidakAman = null,
    Object? perilakuTidakAmanDetail = freezed,
    Object? jumlahPekerjaDiwawancara = null,
    Object? feedbackPekerja = null,
    Object? saranPekerja = null,
    Object? pekerjaAwareProsedur = null,
    Object? jumlahTemuan = null,
    Object? temuanBahaya = freezed,
    Object? temuanKritis = null,
    Object? temuanMayor = null,
    Object? temuanMinor = null,
    Object? temuanObservasi = null,
    Object? pelanggaranProsedur = null,
    Object? pelanggaranPeraturan = null,
    Object? areaNonCompliance = null,
    Object? praktekBaik = null,
    Object? areaExcellent = null,
    Object? pekerjaTeladan = null,
    Object? actionItems = freezed,
    Object? jumlahActionItem = null,
    Object? actionSelesai = null,
    Object? actionProgress = null,
    Object? actionBelumMulai = null,
    Object? tindakanSegera = null,
    Object? areaDitutup = null,
    Object? pekerjaanDihentikan = null,
    Object? fotoWalkthrough = null,
    Object? dokumenPendukung = null,
    Object? sketsaLokasiUrl = freezed,
    Object? videoUrl = freezed,
    Object? ringkasanObservasi = freezed,
    Object? rekomendasi = null,
    Object? catatanKhusus = freezed,
    Object? status = null,
    Object? tingkatUrgensi = null,
    Object? perluFollowUp = null,
    Object? tanggalFollowUp = freezed,
    Object? statusFollowUp = null,
    Object? skorKeseluruhan = null,
    Object? skorHousekeeping = null,
    Object? skorApd = null,
    Object? skorPerilaku = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorWalkthrough: null == nomorWalkthrough
          ? _value.nomorWalkthrough
          : nomorWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalWalkthrough: null == tanggalWalkthrough
          ? _value.tanggalWalkthrough
          : tanggalWalkthrough // ignore: cast_nullable_to_non_nullable
              as DateTime,
      waktuMulai: null == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaInspeksi: null == areaInspeksi
          ? _value.areaInspeksi
          : areaInspeksi // ignore: cast_nullable_to_non_nullable
              as String,
      departemen: freezed == departemen
          ? _value.departemen
          : departemen // ignore: cast_nullable_to_non_nullable
              as String?,
      pimpinanWalkthrough: null == pimpinanWalkthrough
          ? _value.pimpinanWalkthrough
          : pimpinanWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      anggotaTim: null == anggotaTim
          ? _value.anggotaTim
          : anggotaTim // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahTim: null == jumlahTim
          ? _value.jumlahTim
          : jumlahTim // ignore: cast_nullable_to_non_nullable
              as int,
      tujuanWalkthrough: freezed == tujuanWalkthrough
          ? _value.tujuanWalkthrough
          : tujuanWalkthrough // ignore: cast_nullable_to_non_nullable
              as String?,
      fokusArea: null == fokusArea
          ? _value.fokusArea
          : fokusArea // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jenisWalkthrough: null == jenisWalkthrough
          ? _value.jenisWalkthrough
          : jenisWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiPencahayaan: freezed == kondisiPencahayaan
          ? _value.kondisiPencahayaan
          : kondisiPencahayaan // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiVentilasi: freezed == kondisiVentilasi
          ? _value.kondisiVentilasi
          : kondisiVentilasi // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiAksesJalan: freezed == kondisiAksesJalan
          ? _value.kondisiAksesJalan
          : kondisiAksesJalan // ignore: cast_nullable_to_non_nullable
              as String?,
      kepatuhanApd: null == kepatuhanApd
          ? _value.kepatuhanApd
          : kepatuhanApd // ignore: cast_nullable_to_non_nullable
              as int,
      apdTersedia: null == apdTersedia
          ? _value.apdTersedia
          : apdTersedia // ignore: cast_nullable_to_non_nullable
              as bool,
      apdKondisiBaik: null == apdKondisiBaik
          ? _value.apdKondisiBaik
          : apdKondisiBaik // ignore: cast_nullable_to_non_nullable
              as bool,
      apdDigunakanBenar: null == apdDigunakanBenar
          ? _value.apdDigunakanBenar
          : apdDigunakanBenar // ignore: cast_nullable_to_non_nullable
              as bool,
      apdTidakSesuai: null == apdTidakSesuai
          ? _value.apdTidakSesuai
          : apdTidakSesuai // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaDiamati: null == pekerjaDiamati
          ? _value.pekerjaDiamati
          : pekerjaDiamati // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuAman: null == perilakuAman
          ? _value.perilakuAman
          : perilakuAman // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuTidakAman: null == perilakuTidakAman
          ? _value.perilakuTidakAman
          : perilakuTidakAman // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuTidakAmanDetail: freezed == perilakuTidakAmanDetail
          ? _value.perilakuTidakAmanDetail
          : perilakuTidakAmanDetail // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahPekerjaDiwawancara: null == jumlahPekerjaDiwawancara
          ? _value.jumlahPekerjaDiwawancara
          : jumlahPekerjaDiwawancara // ignore: cast_nullable_to_non_nullable
              as int,
      feedbackPekerja: null == feedbackPekerja
          ? _value.feedbackPekerja
          : feedbackPekerja // ignore: cast_nullable_to_non_nullable
              as List<String>,
      saranPekerja: null == saranPekerja
          ? _value.saranPekerja
          : saranPekerja // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaAwareProsedur: null == pekerjaAwareProsedur
          ? _value.pekerjaAwareProsedur
          : pekerjaAwareProsedur // ignore: cast_nullable_to_non_nullable
              as bool,
      jumlahTemuan: null == jumlahTemuan
          ? _value.jumlahTemuan
          : jumlahTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      temuanBahaya: freezed == temuanBahaya
          ? _value.temuanBahaya
          : temuanBahaya // ignore: cast_nullable_to_non_nullable
              as dynamic,
      temuanKritis: null == temuanKritis
          ? _value.temuanKritis
          : temuanKritis // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMayor: null == temuanMayor
          ? _value.temuanMayor
          : temuanMayor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanObservasi: null == temuanObservasi
          ? _value.temuanObservasi
          : temuanObservasi // ignore: cast_nullable_to_non_nullable
              as int,
      pelanggaranProsedur: null == pelanggaranProsedur
          ? _value.pelanggaranProsedur
          : pelanggaranProsedur // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pelanggaranPeraturan: null == pelanggaranPeraturan
          ? _value.pelanggaranPeraturan
          : pelanggaranPeraturan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaNonCompliance: null == areaNonCompliance
          ? _value.areaNonCompliance
          : areaNonCompliance // ignore: cast_nullable_to_non_nullable
              as List<String>,
      praktekBaik: null == praktekBaik
          ? _value.praktekBaik
          : praktekBaik // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaExcellent: null == areaExcellent
          ? _value.areaExcellent
          : areaExcellent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaTeladan: null == pekerjaTeladan
          ? _value.pekerjaTeladan
          : pekerjaTeladan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionItems: freezed == actionItems
          ? _value.actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahActionItem: null == jumlahActionItem
          ? _value.jumlahActionItem
          : jumlahActionItem // ignore: cast_nullable_to_non_nullable
              as int,
      actionSelesai: null == actionSelesai
          ? _value.actionSelesai
          : actionSelesai // ignore: cast_nullable_to_non_nullable
              as int,
      actionProgress: null == actionProgress
          ? _value.actionProgress
          : actionProgress // ignore: cast_nullable_to_non_nullable
              as int,
      actionBelumMulai: null == actionBelumMulai
          ? _value.actionBelumMulai
          : actionBelumMulai // ignore: cast_nullable_to_non_nullable
              as int,
      tindakanSegera: null == tindakanSegera
          ? _value.tindakanSegera
          : tindakanSegera // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaDitutup: null == areaDitutup
          ? _value.areaDitutup
          : areaDitutup // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaanDihentikan: null == pekerjaanDihentikan
          ? _value.pekerjaanDihentikan
          : pekerjaanDihentikan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoWalkthrough: null == fotoWalkthrough
          ? _value.fotoWalkthrough
          : fotoWalkthrough // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dokumenPendukung: null == dokumenPendukung
          ? _value.dokumenPendukung
          : dokumenPendukung // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sketsaLokasiUrl: freezed == sketsaLokasiUrl
          ? _value.sketsaLokasiUrl
          : sketsaLokasiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ringkasanObservasi: freezed == ringkasanObservasi
          ? _value.ringkasanObservasi
          : ringkasanObservasi // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasi: null == rekomendasi
          ? _value.rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatanKhusus: freezed == catatanKhusus
          ? _value.catatanKhusus
          : catatanKhusus // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      tingkatUrgensi: null == tingkatUrgensi
          ? _value.tingkatUrgensi
          : tingkatUrgensi // ignore: cast_nullable_to_non_nullable
              as String,
      perluFollowUp: null == perluFollowUp
          ? _value.perluFollowUp
          : perluFollowUp // ignore: cast_nullable_to_non_nullable
              as bool,
      tanggalFollowUp: freezed == tanggalFollowUp
          ? _value.tanggalFollowUp
          : tanggalFollowUp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusFollowUp: null == statusFollowUp
          ? _value.statusFollowUp
          : statusFollowUp // ignore: cast_nullable_to_non_nullable
              as String,
      skorKeseluruhan: null == skorKeseluruhan
          ? _value.skorKeseluruhan
          : skorKeseluruhan // ignore: cast_nullable_to_non_nullable
              as int,
      skorHousekeeping: null == skorHousekeeping
          ? _value.skorHousekeeping
          : skorHousekeeping // ignore: cast_nullable_to_non_nullable
              as int,
      skorApd: null == skorApd
          ? _value.skorApd
          : skorApd // ignore: cast_nullable_to_non_nullable
              as int,
      skorPerilaku: null == skorPerilaku
          ? _value.skorPerilaku
          : skorPerilaku // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagementWalkthroughModelImplCopyWith<$Res>
    implements $ManagementWalkthroughModelCopyWith<$Res> {
  factory _$$ManagementWalkthroughModelImplCopyWith(
          _$ManagementWalkthroughModelImpl value,
          $Res Function(_$ManagementWalkthroughModelImpl) then) =
      __$$ManagementWalkthroughModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'nomor_walkthrough') String nomorWalkthrough,
      @JsonKey(name: 'tanggal_walkthrough') DateTime tanggalWalkthrough,
      @JsonKey(name: 'waktu_mulai') String waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'area_inspeksi') String areaInspeksi,
      @JsonKey(name: 'departemen') String? departemen,
      @JsonKey(name: 'pimpinan_walkthrough') String pimpinanWalkthrough,
      @JsonKey(name: 'anggota_tim') List<String> anggotaTim,
      @JsonKey(name: 'jumlah_tim') int jumlahTim,
      @JsonKey(name: 'tujuan_walkthrough') String? tujuanWalkthrough,
      @JsonKey(name: 'fokus_area') List<String> fokusArea,
      @JsonKey(name: 'jenis_walkthrough') String jenisWalkthrough,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi,
      @JsonKey(name: 'kondisi_akses_jalan') String? kondisiAksesJalan,
      @JsonKey(name: 'kepatuhan_apd') int kepatuhanApd,
      @JsonKey(name: 'apd_tersedia') bool apdTersedia,
      @JsonKey(name: 'apd_kondisi_baik') bool apdKondisiBaik,
      @JsonKey(name: 'apd_digunakan_benar') bool apdDigunakanBenar,
      @JsonKey(name: 'apd_tidak_sesuai') List<String> apdTidakSesuai,
      @JsonKey(name: 'pekerja_diamati') int pekerjaDiamati,
      @JsonKey(name: 'perilaku_aman') int perilakuAman,
      @JsonKey(name: 'perilaku_tidak_aman') int perilakuTidakAman,
      @JsonKey(name: 'perilaku_tidak_aman_detail')
      dynamic perilakuTidakAmanDetail,
      @JsonKey(name: 'jumlah_pekerja_diwawancara') int jumlahPekerjaDiwawancara,
      @JsonKey(name: 'feedback_pekerja') List<String> feedbackPekerja,
      @JsonKey(name: 'saran_pekerja') List<String> saranPekerja,
      @JsonKey(name: 'pekerja_aware_prosedur') bool pekerjaAwareProsedur,
      @JsonKey(name: 'jumlah_temuan') int jumlahTemuan,
      @JsonKey(name: 'temuan_bahaya') dynamic temuanBahaya,
      @JsonKey(name: 'temuan_kritis') int temuanKritis,
      @JsonKey(name: 'temuan_mayor') int temuanMayor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      @JsonKey(name: 'temuan_observasi') int temuanObservasi,
      @JsonKey(name: 'pelanggaran_prosedur') List<String> pelanggaranProsedur,
      @JsonKey(name: 'pelanggaran_peraturan') List<String> pelanggaranPeraturan,
      @JsonKey(name: 'area_non_compliance') List<String> areaNonCompliance,
      @JsonKey(name: 'praktek_baik') List<String> praktekBaik,
      @JsonKey(name: 'area_excellent') List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') List<String> pekerjaTeladan,
      @JsonKey(name: 'action_items') dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') int jumlahActionItem,
      @JsonKey(name: 'action_selesai') int actionSelesai,
      @JsonKey(name: 'action_progress') int actionProgress,
      @JsonKey(name: 'action_belum_mulai') int actionBelumMulai,
      @JsonKey(name: 'tindakan_segera') List<String> tindakanSegera,
      @JsonKey(name: 'area_ditutup') List<String> areaDitutup,
      @JsonKey(name: 'pekerjaan_dihentikan') List<String> pekerjaanDihentikan,
      @JsonKey(name: 'foto_walkthrough') List<String> fotoWalkthrough,
      @JsonKey(name: 'dokumen_pendukung') List<String> dokumenPendukung,
      @JsonKey(name: 'sketsa_lokasi_url') String? sketsaLokasiUrl,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'ringkasan_observasi') String? ringkasanObservasi,
      @JsonKey(name: 'rekomendasi') List<String> rekomendasi,
      @JsonKey(name: 'catatan_khusus') String? catatanKhusus,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'tingkat_urgensi') String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') String statusFollowUp,
      @JsonKey(name: 'skor_keseluruhan') int skorKeseluruhan,
      @JsonKey(name: 'skor_housekeeping') int skorHousekeeping,
      @JsonKey(name: 'skor_apd') int skorApd,
      @JsonKey(name: 'skor_perilaku') int skorPerilaku,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});
}

/// @nodoc
class __$$ManagementWalkthroughModelImplCopyWithImpl<$Res>
    extends _$ManagementWalkthroughModelCopyWithImpl<$Res,
        _$ManagementWalkthroughModelImpl>
    implements _$$ManagementWalkthroughModelImplCopyWith<$Res> {
  __$$ManagementWalkthroughModelImplCopyWithImpl(
      _$ManagementWalkthroughModelImpl _value,
      $Res Function(_$ManagementWalkthroughModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nomorWalkthrough = null,
    Object? tanggalWalkthrough = null,
    Object? waktuMulai = null,
    Object? waktuSelesai = freezed,
    Object? unitId = freezed,
    Object? areaInspeksi = null,
    Object? departemen = freezed,
    Object? pimpinanWalkthrough = null,
    Object? anggotaTim = null,
    Object? jumlahTim = null,
    Object? tujuanWalkthrough = freezed,
    Object? fokusArea = null,
    Object? jenisWalkthrough = null,
    Object? kondisiHousekeeping = freezed,
    Object? kondisiPencahayaan = freezed,
    Object? kondisiVentilasi = freezed,
    Object? kondisiAksesJalan = freezed,
    Object? kepatuhanApd = null,
    Object? apdTersedia = null,
    Object? apdKondisiBaik = null,
    Object? apdDigunakanBenar = null,
    Object? apdTidakSesuai = null,
    Object? pekerjaDiamati = null,
    Object? perilakuAman = null,
    Object? perilakuTidakAman = null,
    Object? perilakuTidakAmanDetail = freezed,
    Object? jumlahPekerjaDiwawancara = null,
    Object? feedbackPekerja = null,
    Object? saranPekerja = null,
    Object? pekerjaAwareProsedur = null,
    Object? jumlahTemuan = null,
    Object? temuanBahaya = freezed,
    Object? temuanKritis = null,
    Object? temuanMayor = null,
    Object? temuanMinor = null,
    Object? temuanObservasi = null,
    Object? pelanggaranProsedur = null,
    Object? pelanggaranPeraturan = null,
    Object? areaNonCompliance = null,
    Object? praktekBaik = null,
    Object? areaExcellent = null,
    Object? pekerjaTeladan = null,
    Object? actionItems = freezed,
    Object? jumlahActionItem = null,
    Object? actionSelesai = null,
    Object? actionProgress = null,
    Object? actionBelumMulai = null,
    Object? tindakanSegera = null,
    Object? areaDitutup = null,
    Object? pekerjaanDihentikan = null,
    Object? fotoWalkthrough = null,
    Object? dokumenPendukung = null,
    Object? sketsaLokasiUrl = freezed,
    Object? videoUrl = freezed,
    Object? ringkasanObservasi = freezed,
    Object? rekomendasi = null,
    Object? catatanKhusus = freezed,
    Object? status = null,
    Object? tingkatUrgensi = null,
    Object? perluFollowUp = null,
    Object? tanggalFollowUp = freezed,
    Object? statusFollowUp = null,
    Object? skorKeseluruhan = null,
    Object? skorHousekeeping = null,
    Object? skorApd = null,
    Object? skorPerilaku = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_$ManagementWalkthroughModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorWalkthrough: null == nomorWalkthrough
          ? _value.nomorWalkthrough
          : nomorWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalWalkthrough: null == tanggalWalkthrough
          ? _value.tanggalWalkthrough
          : tanggalWalkthrough // ignore: cast_nullable_to_non_nullable
              as DateTime,
      waktuMulai: null == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaInspeksi: null == areaInspeksi
          ? _value.areaInspeksi
          : areaInspeksi // ignore: cast_nullable_to_non_nullable
              as String,
      departemen: freezed == departemen
          ? _value.departemen
          : departemen // ignore: cast_nullable_to_non_nullable
              as String?,
      pimpinanWalkthrough: null == pimpinanWalkthrough
          ? _value.pimpinanWalkthrough
          : pimpinanWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      anggotaTim: null == anggotaTim
          ? _value._anggotaTim
          : anggotaTim // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahTim: null == jumlahTim
          ? _value.jumlahTim
          : jumlahTim // ignore: cast_nullable_to_non_nullable
              as int,
      tujuanWalkthrough: freezed == tujuanWalkthrough
          ? _value.tujuanWalkthrough
          : tujuanWalkthrough // ignore: cast_nullable_to_non_nullable
              as String?,
      fokusArea: null == fokusArea
          ? _value._fokusArea
          : fokusArea // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jenisWalkthrough: null == jenisWalkthrough
          ? _value.jenisWalkthrough
          : jenisWalkthrough // ignore: cast_nullable_to_non_nullable
              as String,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiPencahayaan: freezed == kondisiPencahayaan
          ? _value.kondisiPencahayaan
          : kondisiPencahayaan // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiVentilasi: freezed == kondisiVentilasi
          ? _value.kondisiVentilasi
          : kondisiVentilasi // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiAksesJalan: freezed == kondisiAksesJalan
          ? _value.kondisiAksesJalan
          : kondisiAksesJalan // ignore: cast_nullable_to_non_nullable
              as String?,
      kepatuhanApd: null == kepatuhanApd
          ? _value.kepatuhanApd
          : kepatuhanApd // ignore: cast_nullable_to_non_nullable
              as int,
      apdTersedia: null == apdTersedia
          ? _value.apdTersedia
          : apdTersedia // ignore: cast_nullable_to_non_nullable
              as bool,
      apdKondisiBaik: null == apdKondisiBaik
          ? _value.apdKondisiBaik
          : apdKondisiBaik // ignore: cast_nullable_to_non_nullable
              as bool,
      apdDigunakanBenar: null == apdDigunakanBenar
          ? _value.apdDigunakanBenar
          : apdDigunakanBenar // ignore: cast_nullable_to_non_nullable
              as bool,
      apdTidakSesuai: null == apdTidakSesuai
          ? _value._apdTidakSesuai
          : apdTidakSesuai // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaDiamati: null == pekerjaDiamati
          ? _value.pekerjaDiamati
          : pekerjaDiamati // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuAman: null == perilakuAman
          ? _value.perilakuAman
          : perilakuAman // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuTidakAman: null == perilakuTidakAman
          ? _value.perilakuTidakAman
          : perilakuTidakAman // ignore: cast_nullable_to_non_nullable
              as int,
      perilakuTidakAmanDetail: freezed == perilakuTidakAmanDetail
          ? _value.perilakuTidakAmanDetail
          : perilakuTidakAmanDetail // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahPekerjaDiwawancara: null == jumlahPekerjaDiwawancara
          ? _value.jumlahPekerjaDiwawancara
          : jumlahPekerjaDiwawancara // ignore: cast_nullable_to_non_nullable
              as int,
      feedbackPekerja: null == feedbackPekerja
          ? _value._feedbackPekerja
          : feedbackPekerja // ignore: cast_nullable_to_non_nullable
              as List<String>,
      saranPekerja: null == saranPekerja
          ? _value._saranPekerja
          : saranPekerja // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaAwareProsedur: null == pekerjaAwareProsedur
          ? _value.pekerjaAwareProsedur
          : pekerjaAwareProsedur // ignore: cast_nullable_to_non_nullable
              as bool,
      jumlahTemuan: null == jumlahTemuan
          ? _value.jumlahTemuan
          : jumlahTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      temuanBahaya: freezed == temuanBahaya
          ? _value.temuanBahaya
          : temuanBahaya // ignore: cast_nullable_to_non_nullable
              as dynamic,
      temuanKritis: null == temuanKritis
          ? _value.temuanKritis
          : temuanKritis // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMayor: null == temuanMayor
          ? _value.temuanMayor
          : temuanMayor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanObservasi: null == temuanObservasi
          ? _value.temuanObservasi
          : temuanObservasi // ignore: cast_nullable_to_non_nullable
              as int,
      pelanggaranProsedur: null == pelanggaranProsedur
          ? _value._pelanggaranProsedur
          : pelanggaranProsedur // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pelanggaranPeraturan: null == pelanggaranPeraturan
          ? _value._pelanggaranPeraturan
          : pelanggaranPeraturan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaNonCompliance: null == areaNonCompliance
          ? _value._areaNonCompliance
          : areaNonCompliance // ignore: cast_nullable_to_non_nullable
              as List<String>,
      praktekBaik: null == praktekBaik
          ? _value._praktekBaik
          : praktekBaik // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaExcellent: null == areaExcellent
          ? _value._areaExcellent
          : areaExcellent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaTeladan: null == pekerjaTeladan
          ? _value._pekerjaTeladan
          : pekerjaTeladan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actionItems: freezed == actionItems
          ? _value.actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahActionItem: null == jumlahActionItem
          ? _value.jumlahActionItem
          : jumlahActionItem // ignore: cast_nullable_to_non_nullable
              as int,
      actionSelesai: null == actionSelesai
          ? _value.actionSelesai
          : actionSelesai // ignore: cast_nullable_to_non_nullable
              as int,
      actionProgress: null == actionProgress
          ? _value.actionProgress
          : actionProgress // ignore: cast_nullable_to_non_nullable
              as int,
      actionBelumMulai: null == actionBelumMulai
          ? _value.actionBelumMulai
          : actionBelumMulai // ignore: cast_nullable_to_non_nullable
              as int,
      tindakanSegera: null == tindakanSegera
          ? _value._tindakanSegera
          : tindakanSegera // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaDitutup: null == areaDitutup
          ? _value._areaDitutup
          : areaDitutup // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaanDihentikan: null == pekerjaanDihentikan
          ? _value._pekerjaanDihentikan
          : pekerjaanDihentikan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoWalkthrough: null == fotoWalkthrough
          ? _value._fotoWalkthrough
          : fotoWalkthrough // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dokumenPendukung: null == dokumenPendukung
          ? _value._dokumenPendukung
          : dokumenPendukung // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sketsaLokasiUrl: freezed == sketsaLokasiUrl
          ? _value.sketsaLokasiUrl
          : sketsaLokasiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ringkasanObservasi: freezed == ringkasanObservasi
          ? _value.ringkasanObservasi
          : ringkasanObservasi // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasi: null == rekomendasi
          ? _value._rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatanKhusus: freezed == catatanKhusus
          ? _value.catatanKhusus
          : catatanKhusus // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      tingkatUrgensi: null == tingkatUrgensi
          ? _value.tingkatUrgensi
          : tingkatUrgensi // ignore: cast_nullable_to_non_nullable
              as String,
      perluFollowUp: null == perluFollowUp
          ? _value.perluFollowUp
          : perluFollowUp // ignore: cast_nullable_to_non_nullable
              as bool,
      tanggalFollowUp: freezed == tanggalFollowUp
          ? _value.tanggalFollowUp
          : tanggalFollowUp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusFollowUp: null == statusFollowUp
          ? _value.statusFollowUp
          : statusFollowUp // ignore: cast_nullable_to_non_nullable
              as String,
      skorKeseluruhan: null == skorKeseluruhan
          ? _value.skorKeseluruhan
          : skorKeseluruhan // ignore: cast_nullable_to_non_nullable
              as int,
      skorHousekeeping: null == skorHousekeeping
          ? _value.skorHousekeeping
          : skorHousekeeping // ignore: cast_nullable_to_non_nullable
              as int,
      skorApd: null == skorApd
          ? _value.skorApd
          : skorApd // ignore: cast_nullable_to_non_nullable
              as int,
      skorPerilaku: null == skorPerilaku
          ? _value.skorPerilaku
          : skorPerilaku // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagementWalkthroughModelImpl implements _ManagementWalkthroughModel {
  const _$ManagementWalkthroughModelImpl(
      {this.id,
      @JsonKey(name: 'nomor_walkthrough') required this.nomorWalkthrough,
      @JsonKey(name: 'tanggal_walkthrough') required this.tanggalWalkthrough,
      @JsonKey(name: 'waktu_mulai') required this.waktuMulai,
      @JsonKey(name: 'waktu_selesai') this.waktuSelesai,
      @JsonKey(name: 'unit_id') this.unitId,
      @JsonKey(name: 'area_inspeksi') required this.areaInspeksi,
      @JsonKey(name: 'departemen') this.departemen,
      @JsonKey(name: 'pimpinan_walkthrough') required this.pimpinanWalkthrough,
      @JsonKey(name: 'anggota_tim') final List<String> anggotaTim = const [],
      @JsonKey(name: 'jumlah_tim') this.jumlahTim = 0,
      @JsonKey(name: 'tujuan_walkthrough') this.tujuanWalkthrough,
      @JsonKey(name: 'fokus_area') final List<String> fokusArea = const [],
      @JsonKey(name: 'jenis_walkthrough') this.jenisWalkthrough = 'rutin',
      @JsonKey(name: 'kondisi_housekeeping') this.kondisiHousekeeping,
      @JsonKey(name: 'kondisi_pencahayaan') this.kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') this.kondisiVentilasi,
      @JsonKey(name: 'kondisi_akses_jalan') this.kondisiAksesJalan,
      @JsonKey(name: 'kepatuhan_apd') this.kepatuhanApd = 0,
      @JsonKey(name: 'apd_tersedia') this.apdTersedia = false,
      @JsonKey(name: 'apd_kondisi_baik') this.apdKondisiBaik = false,
      @JsonKey(name: 'apd_digunakan_benar') this.apdDigunakanBenar = false,
      @JsonKey(name: 'apd_tidak_sesuai')
      final List<String> apdTidakSesuai = const [],
      @JsonKey(name: 'pekerja_diamati') this.pekerjaDiamati = 0,
      @JsonKey(name: 'perilaku_aman') this.perilakuAman = 0,
      @JsonKey(name: 'perilaku_tidak_aman') this.perilakuTidakAman = 0,
      @JsonKey(name: 'perilaku_tidak_aman_detail') this.perilakuTidakAmanDetail,
      @JsonKey(name: 'jumlah_pekerja_diwawancara')
      this.jumlahPekerjaDiwawancara = 0,
      @JsonKey(name: 'feedback_pekerja')
      final List<String> feedbackPekerja = const [],
      @JsonKey(name: 'saran_pekerja')
      final List<String> saranPekerja = const [],
      @JsonKey(name: 'pekerja_aware_prosedur')
      this.pekerjaAwareProsedur = false,
      @JsonKey(name: 'jumlah_temuan') this.jumlahTemuan = 0,
      @JsonKey(name: 'temuan_bahaya') this.temuanBahaya,
      @JsonKey(name: 'temuan_kritis') this.temuanKritis = 0,
      @JsonKey(name: 'temuan_mayor') this.temuanMayor = 0,
      @JsonKey(name: 'temuan_minor') this.temuanMinor = 0,
      @JsonKey(name: 'temuan_observasi') this.temuanObservasi = 0,
      @JsonKey(name: 'pelanggaran_prosedur')
      final List<String> pelanggaranProsedur = const [],
      @JsonKey(name: 'pelanggaran_peraturan')
      final List<String> pelanggaranPeraturan = const [],
      @JsonKey(name: 'area_non_compliance')
      final List<String> areaNonCompliance = const [],
      @JsonKey(name: 'praktek_baik') final List<String> praktekBaik = const [],
      @JsonKey(name: 'area_excellent')
      final List<String> areaExcellent = const [],
      @JsonKey(name: 'pekerja_teladan')
      final List<String> pekerjaTeladan = const [],
      @JsonKey(name: 'action_items') this.actionItems,
      @JsonKey(name: 'jumlah_action_item') this.jumlahActionItem = 0,
      @JsonKey(name: 'action_selesai') this.actionSelesai = 0,
      @JsonKey(name: 'action_progress') this.actionProgress = 0,
      @JsonKey(name: 'action_belum_mulai') this.actionBelumMulai = 0,
      @JsonKey(name: 'tindakan_segera')
      final List<String> tindakanSegera = const [],
      @JsonKey(name: 'area_ditutup') final List<String> areaDitutup = const [],
      @JsonKey(name: 'pekerjaan_dihentikan')
      final List<String> pekerjaanDihentikan = const [],
      @JsonKey(name: 'foto_walkthrough')
      final List<String> fotoWalkthrough = const [],
      @JsonKey(name: 'dokumen_pendukung')
      final List<String> dokumenPendukung = const [],
      @JsonKey(name: 'sketsa_lokasi_url') this.sketsaLokasiUrl,
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'ringkasan_observasi') this.ringkasanObservasi,
      @JsonKey(name: 'rekomendasi') final List<String> rekomendasi = const [],
      @JsonKey(name: 'catatan_khusus') this.catatanKhusus,
      @JsonKey(name: 'status') this.status = 'draft',
      @JsonKey(name: 'tingkat_urgensi') this.tingkatUrgensi = 'normal',
      @JsonKey(name: 'perlu_follow_up') this.perluFollowUp = false,
      @JsonKey(name: 'tanggal_follow_up') this.tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') this.statusFollowUp = 'belum',
      @JsonKey(name: 'skor_keseluruhan') this.skorKeseluruhan = 0,
      @JsonKey(name: 'skor_housekeeping') this.skorHousekeeping = 0,
      @JsonKey(name: 'skor_apd') this.skorApd = 0,
      @JsonKey(name: 'skor_perilaku') this.skorPerilaku = 0,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'approved_at') this.approvedAt})
      : _anggotaTim = anggotaTim,
        _fokusArea = fokusArea,
        _apdTidakSesuai = apdTidakSesuai,
        _feedbackPekerja = feedbackPekerja,
        _saranPekerja = saranPekerja,
        _pelanggaranProsedur = pelanggaranProsedur,
        _pelanggaranPeraturan = pelanggaranPeraturan,
        _areaNonCompliance = areaNonCompliance,
        _praktekBaik = praktekBaik,
        _areaExcellent = areaExcellent,
        _pekerjaTeladan = pekerjaTeladan,
        _tindakanSegera = tindakanSegera,
        _areaDitutup = areaDitutup,
        _pekerjaanDihentikan = pekerjaanDihentikan,
        _fotoWalkthrough = fotoWalkthrough,
        _dokumenPendukung = dokumenPendukung,
        _rekomendasi = rekomendasi;

  factory _$ManagementWalkthroughModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ManagementWalkthroughModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'nomor_walkthrough')
  final String nomorWalkthrough;
  @override
  @JsonKey(name: 'tanggal_walkthrough')
  final DateTime tanggalWalkthrough;
  @override
  @JsonKey(name: 'waktu_mulai')
  final String waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  final String? waktuSelesai;
  @override
  @JsonKey(name: 'unit_id')
  final String? unitId;
  @override
  @JsonKey(name: 'area_inspeksi')
  final String areaInspeksi;
  @override
  @JsonKey(name: 'departemen')
  final String? departemen;
  @override
  @JsonKey(name: 'pimpinan_walkthrough')
  final String pimpinanWalkthrough;
  final List<String> _anggotaTim;
  @override
  @JsonKey(name: 'anggota_tim')
  List<String> get anggotaTim {
    if (_anggotaTim is EqualUnmodifiableListView) return _anggotaTim;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_anggotaTim);
  }

  @override
  @JsonKey(name: 'jumlah_tim')
  final int jumlahTim;
  @override
  @JsonKey(name: 'tujuan_walkthrough')
  final String? tujuanWalkthrough;
  final List<String> _fokusArea;
  @override
  @JsonKey(name: 'fokus_area')
  List<String> get fokusArea {
    if (_fokusArea is EqualUnmodifiableListView) return _fokusArea;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fokusArea);
  }

  @override
  @JsonKey(name: 'jenis_walkthrough')
  final String jenisWalkthrough;
// Observasi Kondisi
  @override
  @JsonKey(name: 'kondisi_housekeeping')
  final String? kondisiHousekeeping;
  @override
  @JsonKey(name: 'kondisi_pencahayaan')
  final String? kondisiPencahayaan;
  @override
  @JsonKey(name: 'kondisi_ventilasi')
  final String? kondisiVentilasi;
  @override
  @JsonKey(name: 'kondisi_akses_jalan')
  final String? kondisiAksesJalan;
// APD
  @override
  @JsonKey(name: 'kepatuhan_apd')
  final int kepatuhanApd;
  @override
  @JsonKey(name: 'apd_tersedia')
  final bool apdTersedia;
  @override
  @JsonKey(name: 'apd_kondisi_baik')
  final bool apdKondisiBaik;
  @override
  @JsonKey(name: 'apd_digunakan_benar')
  final bool apdDigunakanBenar;
  final List<String> _apdTidakSesuai;
  @override
  @JsonKey(name: 'apd_tidak_sesuai')
  List<String> get apdTidakSesuai {
    if (_apdTidakSesuai is EqualUnmodifiableListView) return _apdTidakSesuai;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apdTidakSesuai);
  }

// Perilaku Kerja
  @override
  @JsonKey(name: 'pekerja_diamati')
  final int pekerjaDiamati;
  @override
  @JsonKey(name: 'perilaku_aman')
  final int perilakuAman;
  @override
  @JsonKey(name: 'perilaku_tidak_aman')
  final int perilakuTidakAman;
  @override
  @JsonKey(name: 'perilaku_tidak_aman_detail')
  final dynamic perilakuTidakAmanDetail;
// Interaksi Pekerja
  @override
  @JsonKey(name: 'jumlah_pekerja_diwawancara')
  final int jumlahPekerjaDiwawancara;
  final List<String> _feedbackPekerja;
  @override
  @JsonKey(name: 'feedback_pekerja')
  List<String> get feedbackPekerja {
    if (_feedbackPekerja is EqualUnmodifiableListView) return _feedbackPekerja;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedbackPekerja);
  }

  final List<String> _saranPekerja;
  @override
  @JsonKey(name: 'saran_pekerja')
  List<String> get saranPekerja {
    if (_saranPekerja is EqualUnmodifiableListView) return _saranPekerja;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_saranPekerja);
  }

  @override
  @JsonKey(name: 'pekerja_aware_prosedur')
  final bool pekerjaAwareProsedur;
// Temuan
  @override
  @JsonKey(name: 'jumlah_temuan')
  final int jumlahTemuan;
  @override
  @JsonKey(name: 'temuan_bahaya')
  final dynamic temuanBahaya;
  @override
  @JsonKey(name: 'temuan_kritis')
  final int temuanKritis;
  @override
  @JsonKey(name: 'temuan_mayor')
  final int temuanMayor;
  @override
  @JsonKey(name: 'temuan_minor')
  final int temuanMinor;
  @override
  @JsonKey(name: 'temuan_observasi')
  final int temuanObservasi;
// Pelanggaran
  final List<String> _pelanggaranProsedur;
// Pelanggaran
  @override
  @JsonKey(name: 'pelanggaran_prosedur')
  List<String> get pelanggaranProsedur {
    if (_pelanggaranProsedur is EqualUnmodifiableListView)
      return _pelanggaranProsedur;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pelanggaranProsedur);
  }

  final List<String> _pelanggaranPeraturan;
  @override
  @JsonKey(name: 'pelanggaran_peraturan')
  List<String> get pelanggaranPeraturan {
    if (_pelanggaranPeraturan is EqualUnmodifiableListView)
      return _pelanggaranPeraturan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pelanggaranPeraturan);
  }

  final List<String> _areaNonCompliance;
  @override
  @JsonKey(name: 'area_non_compliance')
  List<String> get areaNonCompliance {
    if (_areaNonCompliance is EqualUnmodifiableListView)
      return _areaNonCompliance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaNonCompliance);
  }

// Positive Findings
  final List<String> _praktekBaik;
// Positive Findings
  @override
  @JsonKey(name: 'praktek_baik')
  List<String> get praktekBaik {
    if (_praktekBaik is EqualUnmodifiableListView) return _praktekBaik;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_praktekBaik);
  }

  final List<String> _areaExcellent;
  @override
  @JsonKey(name: 'area_excellent')
  List<String> get areaExcellent {
    if (_areaExcellent is EqualUnmodifiableListView) return _areaExcellent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaExcellent);
  }

  final List<String> _pekerjaTeladan;
  @override
  @JsonKey(name: 'pekerja_teladan')
  List<String> get pekerjaTeladan {
    if (_pekerjaTeladan is EqualUnmodifiableListView) return _pekerjaTeladan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pekerjaTeladan);
  }

// Action Items
  @override
  @JsonKey(name: 'action_items')
  final dynamic actionItems;
  @override
  @JsonKey(name: 'jumlah_action_item')
  final int jumlahActionItem;
  @override
  @JsonKey(name: 'action_selesai')
  final int actionSelesai;
  @override
  @JsonKey(name: 'action_progress')
  final int actionProgress;
  @override
  @JsonKey(name: 'action_belum_mulai')
  final int actionBelumMulai;
// Immediate Actions
  final List<String> _tindakanSegera;
// Immediate Actions
  @override
  @JsonKey(name: 'tindakan_segera')
  List<String> get tindakanSegera {
    if (_tindakanSegera is EqualUnmodifiableListView) return _tindakanSegera;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tindakanSegera);
  }

  final List<String> _areaDitutup;
  @override
  @JsonKey(name: 'area_ditutup')
  List<String> get areaDitutup {
    if (_areaDitutup is EqualUnmodifiableListView) return _areaDitutup;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaDitutup);
  }

  final List<String> _pekerjaanDihentikan;
  @override
  @JsonKey(name: 'pekerjaan_dihentikan')
  List<String> get pekerjaanDihentikan {
    if (_pekerjaanDihentikan is EqualUnmodifiableListView)
      return _pekerjaanDihentikan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pekerjaanDihentikan);
  }

// Dokumentasi
  final List<String> _fotoWalkthrough;
// Dokumentasi
  @override
  @JsonKey(name: 'foto_walkthrough')
  List<String> get fotoWalkthrough {
    if (_fotoWalkthrough is EqualUnmodifiableListView) return _fotoWalkthrough;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoWalkthrough);
  }

  final List<String> _dokumenPendukung;
  @override
  @JsonKey(name: 'dokumen_pendukung')
  List<String> get dokumenPendukung {
    if (_dokumenPendukung is EqualUnmodifiableListView)
      return _dokumenPendukung;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dokumenPendukung);
  }

  @override
  @JsonKey(name: 'sketsa_lokasi_url')
  final String? sketsaLokasiUrl;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
// Ringkasan
  @override
  @JsonKey(name: 'ringkasan_observasi')
  final String? ringkasanObservasi;
  final List<String> _rekomendasi;
  @override
  @JsonKey(name: 'rekomendasi')
  List<String> get rekomendasi {
    if (_rekomendasi is EqualUnmodifiableListView) return _rekomendasi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rekomendasi);
  }

  @override
  @JsonKey(name: 'catatan_khusus')
  final String? catatanKhusus;
// Status
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'tingkat_urgensi')
  final String tingkatUrgensi;
  @override
  @JsonKey(name: 'perlu_follow_up')
  final bool perluFollowUp;
  @override
  @JsonKey(name: 'tanggal_follow_up')
  final DateTime? tanggalFollowUp;
  @override
  @JsonKey(name: 'status_follow_up')
  final String statusFollowUp;
// Scoring
  @override
  @JsonKey(name: 'skor_keseluruhan')
  final int skorKeseluruhan;
  @override
  @JsonKey(name: 'skor_housekeeping')
  final int skorHousekeeping;
  @override
  @JsonKey(name: 'skor_apd')
  final int skorApd;
  @override
  @JsonKey(name: 'skor_perilaku')
  final int skorPerilaku;
// Metadata
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;

  @override
  String toString() {
    return 'ManagementWalkthroughModel(id: $id, nomorWalkthrough: $nomorWalkthrough, tanggalWalkthrough: $tanggalWalkthrough, waktuMulai: $waktuMulai, waktuSelesai: $waktuSelesai, unitId: $unitId, areaInspeksi: $areaInspeksi, departemen: $departemen, pimpinanWalkthrough: $pimpinanWalkthrough, anggotaTim: $anggotaTim, jumlahTim: $jumlahTim, tujuanWalkthrough: $tujuanWalkthrough, fokusArea: $fokusArea, jenisWalkthrough: $jenisWalkthrough, kondisiHousekeeping: $kondisiHousekeeping, kondisiPencahayaan: $kondisiPencahayaan, kondisiVentilasi: $kondisiVentilasi, kondisiAksesJalan: $kondisiAksesJalan, kepatuhanApd: $kepatuhanApd, apdTersedia: $apdTersedia, apdKondisiBaik: $apdKondisiBaik, apdDigunakanBenar: $apdDigunakanBenar, apdTidakSesuai: $apdTidakSesuai, pekerjaDiamati: $pekerjaDiamati, perilakuAman: $perilakuAman, perilakuTidakAman: $perilakuTidakAman, perilakuTidakAmanDetail: $perilakuTidakAmanDetail, jumlahPekerjaDiwawancara: $jumlahPekerjaDiwawancara, feedbackPekerja: $feedbackPekerja, saranPekerja: $saranPekerja, pekerjaAwareProsedur: $pekerjaAwareProsedur, jumlahTemuan: $jumlahTemuan, temuanBahaya: $temuanBahaya, temuanKritis: $temuanKritis, temuanMayor: $temuanMayor, temuanMinor: $temuanMinor, temuanObservasi: $temuanObservasi, pelanggaranProsedur: $pelanggaranProsedur, pelanggaranPeraturan: $pelanggaranPeraturan, areaNonCompliance: $areaNonCompliance, praktekBaik: $praktekBaik, areaExcellent: $areaExcellent, pekerjaTeladan: $pekerjaTeladan, actionItems: $actionItems, jumlahActionItem: $jumlahActionItem, actionSelesai: $actionSelesai, actionProgress: $actionProgress, actionBelumMulai: $actionBelumMulai, tindakanSegera: $tindakanSegera, areaDitutup: $areaDitutup, pekerjaanDihentikan: $pekerjaanDihentikan, fotoWalkthrough: $fotoWalkthrough, dokumenPendukung: $dokumenPendukung, sketsaLokasiUrl: $sketsaLokasiUrl, videoUrl: $videoUrl, ringkasanObservasi: $ringkasanObservasi, rekomendasi: $rekomendasi, catatanKhusus: $catatanKhusus, status: $status, tingkatUrgensi: $tingkatUrgensi, perluFollowUp: $perluFollowUp, tanggalFollowUp: $tanggalFollowUp, statusFollowUp: $statusFollowUp, skorKeseluruhan: $skorKeseluruhan, skorHousekeeping: $skorHousekeeping, skorApd: $skorApd, skorPerilaku: $skorPerilaku, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, approvedBy: $approvedBy, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagementWalkthroughModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nomorWalkthrough, nomorWalkthrough) ||
                other.nomorWalkthrough == nomorWalkthrough) &&
            (identical(other.tanggalWalkthrough, tanggalWalkthrough) ||
                other.tanggalWalkthrough == tanggalWalkthrough) &&
            (identical(other.waktuMulai, waktuMulai) ||
                other.waktuMulai == waktuMulai) &&
            (identical(other.waktuSelesai, waktuSelesai) ||
                other.waktuSelesai == waktuSelesai) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.areaInspeksi, areaInspeksi) ||
                other.areaInspeksi == areaInspeksi) &&
            (identical(other.departemen, departemen) ||
                other.departemen == departemen) &&
            (identical(other.pimpinanWalkthrough, pimpinanWalkthrough) ||
                other.pimpinanWalkthrough == pimpinanWalkthrough) &&
            const DeepCollectionEquality()
                .equals(other._anggotaTim, _anggotaTim) &&
            (identical(other.jumlahTim, jumlahTim) ||
                other.jumlahTim == jumlahTim) &&
            (identical(other.tujuanWalkthrough, tujuanWalkthrough) ||
                other.tujuanWalkthrough == tujuanWalkthrough) &&
            const DeepCollectionEquality()
                .equals(other._fokusArea, _fokusArea) &&
            (identical(other.jenisWalkthrough, jenisWalkthrough) ||
                other.jenisWalkthrough == jenisWalkthrough) &&
            (identical(other.kondisiHousekeeping, kondisiHousekeeping) ||
                other.kondisiHousekeeping == kondisiHousekeeping) &&
            (identical(other.kondisiPencahayaan, kondisiPencahayaan) ||
                other.kondisiPencahayaan == kondisiPencahayaan) &&
            (identical(other.kondisiVentilasi, kondisiVentilasi) ||
                other.kondisiVentilasi == kondisiVentilasi) &&
            (identical(other.kondisiAksesJalan, kondisiAksesJalan) ||
                other.kondisiAksesJalan == kondisiAksesJalan) &&
            (identical(other.kepatuhanApd, kepatuhanApd) ||
                other.kepatuhanApd == kepatuhanApd) &&
            (identical(other.apdTersedia, apdTersedia) ||
                other.apdTersedia == apdTersedia) &&
            (identical(other.apdKondisiBaik, apdKondisiBaik) ||
                other.apdKondisiBaik == apdKondisiBaik) &&
            (identical(other.apdDigunakanBenar, apdDigunakanBenar) ||
                other.apdDigunakanBenar == apdDigunakanBenar) &&
            const DeepCollectionEquality()
                .equals(other._apdTidakSesuai, _apdTidakSesuai) &&
            (identical(other.pekerjaDiamati, pekerjaDiamati) ||
                other.pekerjaDiamati == pekerjaDiamati) &&
            (identical(other.perilakuAman, perilakuAman) ||
                other.perilakuAman == perilakuAman) &&
            (identical(other.perilakuTidakAman, perilakuTidakAman) ||
                other.perilakuTidakAman == perilakuTidakAman) &&
            const DeepCollectionEquality().equals(
                other.perilakuTidakAmanDetail, perilakuTidakAmanDetail) &&
            (identical(other.jumlahPekerjaDiwawancara, jumlahPekerjaDiwawancara) ||
                other.jumlahPekerjaDiwawancara == jumlahPekerjaDiwawancara) &&
            const DeepCollectionEquality()
                .equals(other._feedbackPekerja, _feedbackPekerja) &&
            const DeepCollectionEquality()
                .equals(other._saranPekerja, _saranPekerja) &&
            (identical(other.pekerjaAwareProsedur, pekerjaAwareProsedur) ||
                other.pekerjaAwareProsedur == pekerjaAwareProsedur) &&
            (identical(other.jumlahTemuan, jumlahTemuan) ||
                other.jumlahTemuan == jumlahTemuan) &&
            const DeepCollectionEquality()
                .equals(other.temuanBahaya, temuanBahaya) &&
            (identical(other.temuanKritis, temuanKritis) ||
                other.temuanKritis == temuanKritis) &&
            (identical(other.temuanMayor, temuanMayor) ||
                other.temuanMayor == temuanMayor) &&
            (identical(other.temuanMinor, temuanMinor) ||
                other.temuanMinor == temuanMinor) &&
            (identical(other.temuanObservasi, temuanObservasi) ||
                other.temuanObservasi == temuanObservasi) &&
            const DeepCollectionEquality()
                .equals(other._pelanggaranProsedur, _pelanggaranProsedur) &&
            const DeepCollectionEquality()
                .equals(other._pelanggaranPeraturan, _pelanggaranPeraturan) &&
            const DeepCollectionEquality()
                .equals(other._areaNonCompliance, _areaNonCompliance) &&
            const DeepCollectionEquality()
                .equals(other._praktekBaik, _praktekBaik) &&
            const DeepCollectionEquality()
                .equals(other._areaExcellent, _areaExcellent) &&
            const DeepCollectionEquality().equals(other._pekerjaTeladan, _pekerjaTeladan) &&
            const DeepCollectionEquality().equals(other.actionItems, actionItems) &&
            (identical(other.jumlahActionItem, jumlahActionItem) || other.jumlahActionItem == jumlahActionItem) &&
            (identical(other.actionSelesai, actionSelesai) || other.actionSelesai == actionSelesai) &&
            (identical(other.actionProgress, actionProgress) || other.actionProgress == actionProgress) &&
            (identical(other.actionBelumMulai, actionBelumMulai) || other.actionBelumMulai == actionBelumMulai) &&
            const DeepCollectionEquality().equals(other._tindakanSegera, _tindakanSegera) &&
            const DeepCollectionEquality().equals(other._areaDitutup, _areaDitutup) &&
            const DeepCollectionEquality().equals(other._pekerjaanDihentikan, _pekerjaanDihentikan) &&
            const DeepCollectionEquality().equals(other._fotoWalkthrough, _fotoWalkthrough) &&
            const DeepCollectionEquality().equals(other._dokumenPendukung, _dokumenPendukung) &&
            (identical(other.sketsaLokasiUrl, sketsaLokasiUrl) || other.sketsaLokasiUrl == sketsaLokasiUrl) &&
            (identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl) &&
            (identical(other.ringkasanObservasi, ringkasanObservasi) || other.ringkasanObservasi == ringkasanObservasi) &&
            const DeepCollectionEquality().equals(other._rekomendasi, _rekomendasi) &&
            (identical(other.catatanKhusus, catatanKhusus) || other.catatanKhusus == catatanKhusus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tingkatUrgensi, tingkatUrgensi) || other.tingkatUrgensi == tingkatUrgensi) &&
            (identical(other.perluFollowUp, perluFollowUp) || other.perluFollowUp == perluFollowUp) &&
            (identical(other.tanggalFollowUp, tanggalFollowUp) || other.tanggalFollowUp == tanggalFollowUp) &&
            (identical(other.statusFollowUp, statusFollowUp) || other.statusFollowUp == statusFollowUp) &&
            (identical(other.skorKeseluruhan, skorKeseluruhan) || other.skorKeseluruhan == skorKeseluruhan) &&
            (identical(other.skorHousekeeping, skorHousekeeping) || other.skorHousekeeping == skorHousekeeping) &&
            (identical(other.skorApd, skorApd) || other.skorApd == skorApd) &&
            (identical(other.skorPerilaku, skorPerilaku) || other.skorPerilaku == skorPerilaku) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nomorWalkthrough,
        tanggalWalkthrough,
        waktuMulai,
        waktuSelesai,
        unitId,
        areaInspeksi,
        departemen,
        pimpinanWalkthrough,
        const DeepCollectionEquality().hash(_anggotaTim),
        jumlahTim,
        tujuanWalkthrough,
        const DeepCollectionEquality().hash(_fokusArea),
        jenisWalkthrough,
        kondisiHousekeeping,
        kondisiPencahayaan,
        kondisiVentilasi,
        kondisiAksesJalan,
        kepatuhanApd,
        apdTersedia,
        apdKondisiBaik,
        apdDigunakanBenar,
        const DeepCollectionEquality().hash(_apdTidakSesuai),
        pekerjaDiamati,
        perilakuAman,
        perilakuTidakAman,
        const DeepCollectionEquality().hash(perilakuTidakAmanDetail),
        jumlahPekerjaDiwawancara,
        const DeepCollectionEquality().hash(_feedbackPekerja),
        const DeepCollectionEquality().hash(_saranPekerja),
        pekerjaAwareProsedur,
        jumlahTemuan,
        const DeepCollectionEquality().hash(temuanBahaya),
        temuanKritis,
        temuanMayor,
        temuanMinor,
        temuanObservasi,
        const DeepCollectionEquality().hash(_pelanggaranProsedur),
        const DeepCollectionEquality().hash(_pelanggaranPeraturan),
        const DeepCollectionEquality().hash(_areaNonCompliance),
        const DeepCollectionEquality().hash(_praktekBaik),
        const DeepCollectionEquality().hash(_areaExcellent),
        const DeepCollectionEquality().hash(_pekerjaTeladan),
        const DeepCollectionEquality().hash(actionItems),
        jumlahActionItem,
        actionSelesai,
        actionProgress,
        actionBelumMulai,
        const DeepCollectionEquality().hash(_tindakanSegera),
        const DeepCollectionEquality().hash(_areaDitutup),
        const DeepCollectionEquality().hash(_pekerjaanDihentikan),
        const DeepCollectionEquality().hash(_fotoWalkthrough),
        const DeepCollectionEquality().hash(_dokumenPendukung),
        sketsaLokasiUrl,
        videoUrl,
        ringkasanObservasi,
        const DeepCollectionEquality().hash(_rekomendasi),
        catatanKhusus,
        status,
        tingkatUrgensi,
        perluFollowUp,
        tanggalFollowUp,
        statusFollowUp,
        skorKeseluruhan,
        skorHousekeeping,
        skorApd,
        skorPerilaku,
        createdBy,
        createdAt,
        updatedAt,
        approvedBy,
        approvedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagementWalkthroughModelImplCopyWith<_$ManagementWalkthroughModelImpl>
      get copyWith => __$$ManagementWalkthroughModelImplCopyWithImpl<
          _$ManagementWalkthroughModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagementWalkthroughModelImplToJson(
      this,
    );
  }
}

abstract class _ManagementWalkthroughModel
    implements ManagementWalkthroughModel {
  const factory _ManagementWalkthroughModel(
      {final String? id,
      @JsonKey(name: 'nomor_walkthrough')
      required final String nomorWalkthrough,
      @JsonKey(name: 'tanggal_walkthrough')
      required final DateTime tanggalWalkthrough,
      @JsonKey(name: 'waktu_mulai') required final String waktuMulai,
      @JsonKey(name: 'waktu_selesai') final String? waktuSelesai,
      @JsonKey(name: 'unit_id') final String? unitId,
      @JsonKey(name: 'area_inspeksi') required final String areaInspeksi,
      @JsonKey(name: 'departemen') final String? departemen,
      @JsonKey(name: 'pimpinan_walkthrough')
      required final String pimpinanWalkthrough,
      @JsonKey(name: 'anggota_tim') final List<String> anggotaTim,
      @JsonKey(name: 'jumlah_tim') final int jumlahTim,
      @JsonKey(name: 'tujuan_walkthrough') final String? tujuanWalkthrough,
      @JsonKey(name: 'fokus_area') final List<String> fokusArea,
      @JsonKey(name: 'jenis_walkthrough') final String jenisWalkthrough,
      @JsonKey(name: 'kondisi_housekeeping') final String? kondisiHousekeeping,
      @JsonKey(name: 'kondisi_pencahayaan') final String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') final String? kondisiVentilasi,
      @JsonKey(name: 'kondisi_akses_jalan') final String? kondisiAksesJalan,
      @JsonKey(name: 'kepatuhan_apd') final int kepatuhanApd,
      @JsonKey(name: 'apd_tersedia') final bool apdTersedia,
      @JsonKey(name: 'apd_kondisi_baik') final bool apdKondisiBaik,
      @JsonKey(name: 'apd_digunakan_benar') final bool apdDigunakanBenar,
      @JsonKey(name: 'apd_tidak_sesuai') final List<String> apdTidakSesuai,
      @JsonKey(name: 'pekerja_diamati') final int pekerjaDiamati,
      @JsonKey(name: 'perilaku_aman') final int perilakuAman,
      @JsonKey(name: 'perilaku_tidak_aman') final int perilakuTidakAman,
      @JsonKey(name: 'perilaku_tidak_aman_detail')
      final dynamic perilakuTidakAmanDetail,
      @JsonKey(name: 'jumlah_pekerja_diwawancara')
      final int jumlahPekerjaDiwawancara,
      @JsonKey(name: 'feedback_pekerja') final List<String> feedbackPekerja,
      @JsonKey(name: 'saran_pekerja') final List<String> saranPekerja,
      @JsonKey(name: 'pekerja_aware_prosedur') final bool pekerjaAwareProsedur,
      @JsonKey(name: 'jumlah_temuan') final int jumlahTemuan,
      @JsonKey(name: 'temuan_bahaya') final dynamic temuanBahaya,
      @JsonKey(name: 'temuan_kritis') final int temuanKritis,
      @JsonKey(name: 'temuan_mayor') final int temuanMayor,
      @JsonKey(name: 'temuan_minor') final int temuanMinor,
      @JsonKey(name: 'temuan_observasi') final int temuanObservasi,
      @JsonKey(name: 'pelanggaran_prosedur')
      final List<String> pelanggaranProsedur,
      @JsonKey(name: 'pelanggaran_peraturan')
      final List<String> pelanggaranPeraturan,
      @JsonKey(name: 'area_non_compliance')
      final List<String> areaNonCompliance,
      @JsonKey(name: 'praktek_baik') final List<String> praktekBaik,
      @JsonKey(name: 'area_excellent') final List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') final List<String> pekerjaTeladan,
      @JsonKey(name: 'action_items') final dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') final int jumlahActionItem,
      @JsonKey(name: 'action_selesai') final int actionSelesai,
      @JsonKey(name: 'action_progress') final int actionProgress,
      @JsonKey(name: 'action_belum_mulai') final int actionBelumMulai,
      @JsonKey(name: 'tindakan_segera') final List<String> tindakanSegera,
      @JsonKey(name: 'area_ditutup') final List<String> areaDitutup,
      @JsonKey(name: 'pekerjaan_dihentikan')
      final List<String> pekerjaanDihentikan,
      @JsonKey(name: 'foto_walkthrough') final List<String> fotoWalkthrough,
      @JsonKey(name: 'dokumen_pendukung') final List<String> dokumenPendukung,
      @JsonKey(name: 'sketsa_lokasi_url') final String? sketsaLokasiUrl,
      @JsonKey(name: 'video_url') final String? videoUrl,
      @JsonKey(name: 'ringkasan_observasi') final String? ringkasanObservasi,
      @JsonKey(name: 'rekomendasi') final List<String> rekomendasi,
      @JsonKey(name: 'catatan_khusus') final String? catatanKhusus,
      @JsonKey(name: 'status') final String status,
      @JsonKey(name: 'tingkat_urgensi') final String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') final bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') final DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') final String statusFollowUp,
      @JsonKey(name: 'skor_keseluruhan') final int skorKeseluruhan,
      @JsonKey(name: 'skor_housekeeping') final int skorHousekeeping,
      @JsonKey(name: 'skor_apd') final int skorApd,
      @JsonKey(name: 'skor_perilaku') final int skorPerilaku,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'approved_by') final String? approvedBy,
      @JsonKey(name: 'approved_at')
      final DateTime? approvedAt}) = _$ManagementWalkthroughModelImpl;

  factory _ManagementWalkthroughModel.fromJson(Map<String, dynamic> json) =
      _$ManagementWalkthroughModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'nomor_walkthrough')
  String get nomorWalkthrough;
  @override
  @JsonKey(name: 'tanggal_walkthrough')
  DateTime get tanggalWalkthrough;
  @override
  @JsonKey(name: 'waktu_mulai')
  String get waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai;
  @override
  @JsonKey(name: 'unit_id')
  String? get unitId;
  @override
  @JsonKey(name: 'area_inspeksi')
  String get areaInspeksi;
  @override
  @JsonKey(name: 'departemen')
  String? get departemen;
  @override
  @JsonKey(name: 'pimpinan_walkthrough')
  String get pimpinanWalkthrough;
  @override
  @JsonKey(name: 'anggota_tim')
  List<String> get anggotaTim;
  @override
  @JsonKey(name: 'jumlah_tim')
  int get jumlahTim;
  @override
  @JsonKey(name: 'tujuan_walkthrough')
  String? get tujuanWalkthrough;
  @override
  @JsonKey(name: 'fokus_area')
  List<String> get fokusArea;
  @override
  @JsonKey(name: 'jenis_walkthrough')
  String get jenisWalkthrough;
  @override // Observasi Kondisi
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping;
  @override
  @JsonKey(name: 'kondisi_pencahayaan')
  String? get kondisiPencahayaan;
  @override
  @JsonKey(name: 'kondisi_ventilasi')
  String? get kondisiVentilasi;
  @override
  @JsonKey(name: 'kondisi_akses_jalan')
  String? get kondisiAksesJalan;
  @override // APD
  @JsonKey(name: 'kepatuhan_apd')
  int get kepatuhanApd;
  @override
  @JsonKey(name: 'apd_tersedia')
  bool get apdTersedia;
  @override
  @JsonKey(name: 'apd_kondisi_baik')
  bool get apdKondisiBaik;
  @override
  @JsonKey(name: 'apd_digunakan_benar')
  bool get apdDigunakanBenar;
  @override
  @JsonKey(name: 'apd_tidak_sesuai')
  List<String> get apdTidakSesuai;
  @override // Perilaku Kerja
  @JsonKey(name: 'pekerja_diamati')
  int get pekerjaDiamati;
  @override
  @JsonKey(name: 'perilaku_aman')
  int get perilakuAman;
  @override
  @JsonKey(name: 'perilaku_tidak_aman')
  int get perilakuTidakAman;
  @override
  @JsonKey(name: 'perilaku_tidak_aman_detail')
  dynamic get perilakuTidakAmanDetail;
  @override // Interaksi Pekerja
  @JsonKey(name: 'jumlah_pekerja_diwawancara')
  int get jumlahPekerjaDiwawancara;
  @override
  @JsonKey(name: 'feedback_pekerja')
  List<String> get feedbackPekerja;
  @override
  @JsonKey(name: 'saran_pekerja')
  List<String> get saranPekerja;
  @override
  @JsonKey(name: 'pekerja_aware_prosedur')
  bool get pekerjaAwareProsedur;
  @override // Temuan
  @JsonKey(name: 'jumlah_temuan')
  int get jumlahTemuan;
  @override
  @JsonKey(name: 'temuan_bahaya')
  dynamic get temuanBahaya;
  @override
  @JsonKey(name: 'temuan_kritis')
  int get temuanKritis;
  @override
  @JsonKey(name: 'temuan_mayor')
  int get temuanMayor;
  @override
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor;
  @override
  @JsonKey(name: 'temuan_observasi')
  int get temuanObservasi;
  @override // Pelanggaran
  @JsonKey(name: 'pelanggaran_prosedur')
  List<String> get pelanggaranProsedur;
  @override
  @JsonKey(name: 'pelanggaran_peraturan')
  List<String> get pelanggaranPeraturan;
  @override
  @JsonKey(name: 'area_non_compliance')
  List<String> get areaNonCompliance;
  @override // Positive Findings
  @JsonKey(name: 'praktek_baik')
  List<String> get praktekBaik;
  @override
  @JsonKey(name: 'area_excellent')
  List<String> get areaExcellent;
  @override
  @JsonKey(name: 'pekerja_teladan')
  List<String> get pekerjaTeladan;
  @override // Action Items
  @JsonKey(name: 'action_items')
  dynamic get actionItems;
  @override
  @JsonKey(name: 'jumlah_action_item')
  int get jumlahActionItem;
  @override
  @JsonKey(name: 'action_selesai')
  int get actionSelesai;
  @override
  @JsonKey(name: 'action_progress')
  int get actionProgress;
  @override
  @JsonKey(name: 'action_belum_mulai')
  int get actionBelumMulai;
  @override // Immediate Actions
  @JsonKey(name: 'tindakan_segera')
  List<String> get tindakanSegera;
  @override
  @JsonKey(name: 'area_ditutup')
  List<String> get areaDitutup;
  @override
  @JsonKey(name: 'pekerjaan_dihentikan')
  List<String> get pekerjaanDihentikan;
  @override // Dokumentasi
  @JsonKey(name: 'foto_walkthrough')
  List<String> get fotoWalkthrough;
  @override
  @JsonKey(name: 'dokumen_pendukung')
  List<String> get dokumenPendukung;
  @override
  @JsonKey(name: 'sketsa_lokasi_url')
  String? get sketsaLokasiUrl;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override // Ringkasan
  @JsonKey(name: 'ringkasan_observasi')
  String? get ringkasanObservasi;
  @override
  @JsonKey(name: 'rekomendasi')
  List<String> get rekomendasi;
  @override
  @JsonKey(name: 'catatan_khusus')
  String? get catatanKhusus;
  @override // Status
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'tingkat_urgensi')
  String get tingkatUrgensi;
  @override
  @JsonKey(name: 'perlu_follow_up')
  bool get perluFollowUp;
  @override
  @JsonKey(name: 'tanggal_follow_up')
  DateTime? get tanggalFollowUp;
  @override
  @JsonKey(name: 'status_follow_up')
  String get statusFollowUp;
  @override // Scoring
  @JsonKey(name: 'skor_keseluruhan')
  int get skorKeseluruhan;
  @override
  @JsonKey(name: 'skor_housekeeping')
  int get skorHousekeeping;
  @override
  @JsonKey(name: 'skor_apd')
  int get skorApd;
  @override
  @JsonKey(name: 'skor_perilaku')
  int get skorPerilaku;
  @override // Metadata
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(ignore: true)
  _$$ManagementWalkthroughModelImplCopyWith<_$ManagementWalkthroughModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
