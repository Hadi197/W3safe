// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'safety_patrol_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SafetyPatrol _$SafetyPatrolFromJson(Map<String, dynamic> json) {
  return _SafetyPatrol.fromJson(json);
}

/// @nodoc
mixin _$SafetyPatrol {
  String? get id => throw _privateConstructorUsedError; // Basic information
  @JsonKey(name: 'nomor_patrol')
  String get nomorPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal_patrol')
  DateTime? get tanggalPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_mulai')
  String? get waktuMulai => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai =>
      throw _privateConstructorUsedError; // Shift and unit
  String? get shift => throw _privateConstructorUsedError; // pagi, siang, malam
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_patrol')
  String get areaPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'lokasi_spesifik')
  String? get lokasiSpesifik =>
      throw _privateConstructorUsedError; // Team information
  @JsonKey(name: 'ketua_patrol')
  String get ketuaPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'anggota_patrol')
  List<String> get anggotaPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'jumlah_anggota')
  int get jumlahAnggota => throw _privateConstructorUsedError; // Patrol details
  @JsonKey(name: 'jenis_patrol')
  String? get jenisPatrol =>
      throw _privateConstructorUsedError; // rutin, terjadwal, insidental, khusus, malam, emergency
  @JsonKey(name: 'tujuan_patrol')
  String? get tujuanPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'fokus_patrol')
  List<String> get fokusPatrol =>
      throw _privateConstructorUsedError; // Environmental conditions
  String? get cuaca =>
      throw _privateConstructorUsedError; // cerah, mendung, hujan, panas
  @JsonKey(name: 'suhu_area')
  double? get suhuArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_pencahayaan')
  String? get kondisiPencahayaan =>
      throw _privateConstructorUsedError; // baik, cukup, kurang, buruk
  @JsonKey(name: 'kondisi_ventilasi')
  String? get kondisiVentilasi =>
      throw _privateConstructorUsedError; // baik, cukup, kurang, buruk
  @JsonKey(name: 'tingkat_kebisingan')
  String? get tingkatKebisingan =>
      throw _privateConstructorUsedError; // normal, cukup_bising, bising, sangat_bising
// Unsafe conditions and acts
  @JsonKey(name: 'jumlah_unsafe_condition')
  int get jumlahUnsafeCondition => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsafe_condition')
  dynamic get unsafeCondition =>
      throw _privateConstructorUsedError; // JSONB array of objects
  @JsonKey(name: 'jumlah_unsafe_act')
  int get jumlahUnsafeAct => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsafe_act')
  dynamic get unsafeAct =>
      throw _privateConstructorUsedError; // JSONB array of objects
// Worker observations
  @JsonKey(name: 'pekerja_diamati')
  int get pekerjaDiamati => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerja_patuh_apd')
  int get pekerjaPatuhApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerja_tidak_patuh_apd')
  int get pekerjaTidakPatuhApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'persentase_kepatuhan_apd')
  double? get persentaseKepatuhanApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_apd')
  dynamic get detailApd =>
      throw _privateConstructorUsedError; // JSONB array of objects
// Housekeeping
  @JsonKey(name: 'skor_housekeeping')
  int? get skorHousekeeping => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping =>
      throw _privateConstructorUsedError; // sangat_baik, baik, cukup, kurang, buruk
  @JsonKey(name: 'area_kotor')
  List<String> get areaKotor => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_rapi')
  List<String> get areaRapi =>
      throw _privateConstructorUsedError; // Equipment checks
  @JsonKey(name: 'jumlah_mesin_diperiksa')
  int get jumlahMesinDiperiksa => throw _privateConstructorUsedError;
  @JsonKey(name: 'mesin_kondisi_baik')
  int get mesinKondisiBaik => throw _privateConstructorUsedError;
  @JsonKey(name: 'mesin_perlu_perbaikan')
  int get mesinPerluPerbaikan => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_mesin')
  dynamic get detailMesin =>
      throw _privateConstructorUsedError; // JSONB array of objects
// Safety equipment checks
  @JsonKey(name: 'rambu_k3_lengkap')
  bool get rambuK3Lengkap => throw _privateConstructorUsedError;
  @JsonKey(name: 'rambu_k3_hilang')
  List<String> get rambuK3Hilang => throw _privateConstructorUsedError;
  @JsonKey(name: 'rambu_k3_rusak')
  List<String> get rambuK3Rusak => throw _privateConstructorUsedError;
  @JsonKey(name: 'label_b3_lengkap')
  bool get labelB3Lengkap => throw _privateConstructorUsedError;
  @JsonKey(name: 'jalur_evakuasi_bebas')
  bool get jalurEvakuasiBebas => throw _privateConstructorUsedError;
  @JsonKey(name: 'pintu_darurat_berfungsi')
  bool get pintuDaruratBerfungsi => throw _privateConstructorUsedError;
  @JsonKey(name: 'apar_tersedia')
  bool get aparTersedia => throw _privateConstructorUsedError;
  @JsonKey(name: 'apar_expire')
  int get aparExpire => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_light_berfungsi')
  bool get emergencyLightBerfungsi =>
      throw _privateConstructorUsedError; // Positive observations
  @JsonKey(name: 'good_practice')
  List<String> get goodPractice => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_excellent')
  List<String> get areaExcellent => throw _privateConstructorUsedError;
  @JsonKey(name: 'pekerja_teladan')
  List<String> get pekerjaTeladan =>
      throw _privateConstructorUsedError; // Findings and recommendations
  @JsonKey(name: 'total_temuan')
  int get totalTemuan => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_kritikal')
  int get temuanKritikal => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_mayor')
  int get temuanMayor => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor => throw _privateConstructorUsedError;
  List<String> get rekomendasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'catatan_patrol')
  String? get catatanPatrol =>
      throw _privateConstructorUsedError; // Action items
  @JsonKey(name: 'action_items')
  dynamic get actionItems =>
      throw _privateConstructorUsedError; // JSONB array of objects
  @JsonKey(name: 'jumlah_action_item')
  int get jumlahActionItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_selesai')
  int get actionSelesai => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_progress')
  int get actionProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_belum_mulai')
  int get actionBelumMulai =>
      throw _privateConstructorUsedError; // Stop work orders
  @JsonKey(name: 'stop_work_issued')
  bool get stopWorkIssued => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_work_area')
  List<String> get stopWorkArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_work_alasan')
  String? get stopWorkAlasan =>
      throw _privateConstructorUsedError; // Documentation
  @JsonKey(name: 'foto_patrol')
  List<String> get fotoPatrol => throw _privateConstructorUsedError;
  @JsonKey(name: 'dokumen_pendukung')
  List<String> get dokumenPendukung =>
      throw _privateConstructorUsedError; // Scoring
  @JsonKey(name: 'skor_keseluruhan')
  double? get skorKeseluruhan => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_apd')
  double? get skorApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_kondisi_area')
  double? get skorKondisiArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_peralatan')
  double? get skorPeralatan => throw _privateConstructorUsedError;
  String? get grade => throw _privateConstructorUsedError; // A, B, C, D, E
// Status and approval
  String get status =>
      throw _privateConstructorUsedError; // draft, submitted, reviewed, closed, cancelled
  @JsonKey(name: 'tingkat_urgensi')
  String get tingkatUrgensi =>
      throw _privateConstructorUsedError; // rendah, normal, tinggi, kritis
// Follow up
  @JsonKey(name: 'perlu_follow_up')
  bool get perluFollowUp => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal_follow_up')
  DateTime? get tanggalFollowUp => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_follow_up')
  String? get statusFollowUp =>
      throw _privateConstructorUsedError; // belum, dijadwalkan, selesai
// Review information
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_notes')
  String? get reviewNotes => throw _privateConstructorUsedError; // Audit fields
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SafetyPatrolCopyWith<SafetyPatrol> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SafetyPatrolCopyWith<$Res> {
  factory $SafetyPatrolCopyWith(
          SafetyPatrol value, $Res Function(SafetyPatrol) then) =
      _$SafetyPatrolCopyWithImpl<$Res, SafetyPatrol>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'nomor_patrol') String nomorPatrol,
      @JsonKey(name: 'tanggal_patrol') DateTime? tanggalPatrol,
      @JsonKey(name: 'waktu_mulai') String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      String? shift,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'area_patrol') String areaPatrol,
      @JsonKey(name: 'lokasi_spesifik') String? lokasiSpesifik,
      @JsonKey(name: 'ketua_patrol') String ketuaPatrol,
      @JsonKey(name: 'anggota_patrol') List<String> anggotaPatrol,
      @JsonKey(name: 'jumlah_anggota') int jumlahAnggota,
      @JsonKey(name: 'jenis_patrol') String? jenisPatrol,
      @JsonKey(name: 'tujuan_patrol') String? tujuanPatrol,
      @JsonKey(name: 'fokus_patrol') List<String> fokusPatrol,
      String? cuaca,
      @JsonKey(name: 'suhu_area') double? suhuArea,
      @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi,
      @JsonKey(name: 'tingkat_kebisingan') String? tingkatKebisingan,
      @JsonKey(name: 'jumlah_unsafe_condition') int jumlahUnsafeCondition,
      @JsonKey(name: 'unsafe_condition') dynamic unsafeCondition,
      @JsonKey(name: 'jumlah_unsafe_act') int jumlahUnsafeAct,
      @JsonKey(name: 'unsafe_act') dynamic unsafeAct,
      @JsonKey(name: 'pekerja_diamati') int pekerjaDiamati,
      @JsonKey(name: 'pekerja_patuh_apd') int pekerjaPatuhApd,
      @JsonKey(name: 'pekerja_tidak_patuh_apd') int pekerjaTidakPatuhApd,
      @JsonKey(name: 'persentase_kepatuhan_apd') double? persentaseKepatuhanApd,
      @JsonKey(name: 'detail_apd') dynamic detailApd,
      @JsonKey(name: 'skor_housekeeping') int? skorHousekeeping,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'area_kotor') List<String> areaKotor,
      @JsonKey(name: 'area_rapi') List<String> areaRapi,
      @JsonKey(name: 'jumlah_mesin_diperiksa') int jumlahMesinDiperiksa,
      @JsonKey(name: 'mesin_kondisi_baik') int mesinKondisiBaik,
      @JsonKey(name: 'mesin_perlu_perbaikan') int mesinPerluPerbaikan,
      @JsonKey(name: 'detail_mesin') dynamic detailMesin,
      @JsonKey(name: 'rambu_k3_lengkap') bool rambuK3Lengkap,
      @JsonKey(name: 'rambu_k3_hilang') List<String> rambuK3Hilang,
      @JsonKey(name: 'rambu_k3_rusak') List<String> rambuK3Rusak,
      @JsonKey(name: 'label_b3_lengkap') bool labelB3Lengkap,
      @JsonKey(name: 'jalur_evakuasi_bebas') bool jalurEvakuasiBebas,
      @JsonKey(name: 'pintu_darurat_berfungsi') bool pintuDaruratBerfungsi,
      @JsonKey(name: 'apar_tersedia') bool aparTersedia,
      @JsonKey(name: 'apar_expire') int aparExpire,
      @JsonKey(name: 'emergency_light_berfungsi') bool emergencyLightBerfungsi,
      @JsonKey(name: 'good_practice') List<String> goodPractice,
      @JsonKey(name: 'area_excellent') List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') List<String> pekerjaTeladan,
      @JsonKey(name: 'total_temuan') int totalTemuan,
      @JsonKey(name: 'temuan_kritikal') int temuanKritikal,
      @JsonKey(name: 'temuan_mayor') int temuanMayor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      List<String> rekomendasi,
      @JsonKey(name: 'catatan_patrol') String? catatanPatrol,
      @JsonKey(name: 'action_items') dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') int jumlahActionItem,
      @JsonKey(name: 'action_selesai') int actionSelesai,
      @JsonKey(name: 'action_progress') int actionProgress,
      @JsonKey(name: 'action_belum_mulai') int actionBelumMulai,
      @JsonKey(name: 'stop_work_issued') bool stopWorkIssued,
      @JsonKey(name: 'stop_work_area') List<String> stopWorkArea,
      @JsonKey(name: 'stop_work_alasan') String? stopWorkAlasan,
      @JsonKey(name: 'foto_patrol') List<String> fotoPatrol,
      @JsonKey(name: 'dokumen_pendukung') List<String> dokumenPendukung,
      @JsonKey(name: 'skor_keseluruhan') double? skorKeseluruhan,
      @JsonKey(name: 'skor_apd') double? skorApd,
      @JsonKey(name: 'skor_kondisi_area') double? skorKondisiArea,
      @JsonKey(name: 'skor_peralatan') double? skorPeralatan,
      String? grade,
      String status,
      @JsonKey(name: 'tingkat_urgensi') String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') String? statusFollowUp,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
      @JsonKey(name: 'review_notes') String? reviewNotes,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$SafetyPatrolCopyWithImpl<$Res, $Val extends SafetyPatrol>
    implements $SafetyPatrolCopyWith<$Res> {
  _$SafetyPatrolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nomorPatrol = null,
    Object? tanggalPatrol = freezed,
    Object? waktuMulai = freezed,
    Object? waktuSelesai = freezed,
    Object? shift = freezed,
    Object? unitId = freezed,
    Object? areaPatrol = null,
    Object? lokasiSpesifik = freezed,
    Object? ketuaPatrol = null,
    Object? anggotaPatrol = null,
    Object? jumlahAnggota = null,
    Object? jenisPatrol = freezed,
    Object? tujuanPatrol = freezed,
    Object? fokusPatrol = null,
    Object? cuaca = freezed,
    Object? suhuArea = freezed,
    Object? kondisiPencahayaan = freezed,
    Object? kondisiVentilasi = freezed,
    Object? tingkatKebisingan = freezed,
    Object? jumlahUnsafeCondition = null,
    Object? unsafeCondition = freezed,
    Object? jumlahUnsafeAct = null,
    Object? unsafeAct = freezed,
    Object? pekerjaDiamati = null,
    Object? pekerjaPatuhApd = null,
    Object? pekerjaTidakPatuhApd = null,
    Object? persentaseKepatuhanApd = freezed,
    Object? detailApd = freezed,
    Object? skorHousekeeping = freezed,
    Object? kondisiHousekeeping = freezed,
    Object? areaKotor = null,
    Object? areaRapi = null,
    Object? jumlahMesinDiperiksa = null,
    Object? mesinKondisiBaik = null,
    Object? mesinPerluPerbaikan = null,
    Object? detailMesin = freezed,
    Object? rambuK3Lengkap = null,
    Object? rambuK3Hilang = null,
    Object? rambuK3Rusak = null,
    Object? labelB3Lengkap = null,
    Object? jalurEvakuasiBebas = null,
    Object? pintuDaruratBerfungsi = null,
    Object? aparTersedia = null,
    Object? aparExpire = null,
    Object? emergencyLightBerfungsi = null,
    Object? goodPractice = null,
    Object? areaExcellent = null,
    Object? pekerjaTeladan = null,
    Object? totalTemuan = null,
    Object? temuanKritikal = null,
    Object? temuanMayor = null,
    Object? temuanMinor = null,
    Object? rekomendasi = null,
    Object? catatanPatrol = freezed,
    Object? actionItems = freezed,
    Object? jumlahActionItem = null,
    Object? actionSelesai = null,
    Object? actionProgress = null,
    Object? actionBelumMulai = null,
    Object? stopWorkIssued = null,
    Object? stopWorkArea = null,
    Object? stopWorkAlasan = freezed,
    Object? fotoPatrol = null,
    Object? dokumenPendukung = null,
    Object? skorKeseluruhan = freezed,
    Object? skorApd = freezed,
    Object? skorKondisiArea = freezed,
    Object? skorPeralatan = freezed,
    Object? grade = freezed,
    Object? status = null,
    Object? tingkatUrgensi = null,
    Object? perluFollowUp = null,
    Object? tanggalFollowUp = freezed,
    Object? statusFollowUp = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorPatrol: null == nomorPatrol
          ? _value.nomorPatrol
          : nomorPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalPatrol: freezed == tanggalPatrol
          ? _value.tanggalPatrol
          : tanggalPatrol // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      waktuMulai: freezed == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String?,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      shift: freezed == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaPatrol: null == areaPatrol
          ? _value.areaPatrol
          : areaPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      lokasiSpesifik: freezed == lokasiSpesifik
          ? _value.lokasiSpesifik
          : lokasiSpesifik // ignore: cast_nullable_to_non_nullable
              as String?,
      ketuaPatrol: null == ketuaPatrol
          ? _value.ketuaPatrol
          : ketuaPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      anggotaPatrol: null == anggotaPatrol
          ? _value.anggotaPatrol
          : anggotaPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahAnggota: null == jumlahAnggota
          ? _value.jumlahAnggota
          : jumlahAnggota // ignore: cast_nullable_to_non_nullable
              as int,
      jenisPatrol: freezed == jenisPatrol
          ? _value.jenisPatrol
          : jenisPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
      tujuanPatrol: freezed == tujuanPatrol
          ? _value.tujuanPatrol
          : tujuanPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
      fokusPatrol: null == fokusPatrol
          ? _value.fokusPatrol
          : fokusPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuaca: freezed == cuaca
          ? _value.cuaca
          : cuaca // ignore: cast_nullable_to_non_nullable
              as String?,
      suhuArea: freezed == suhuArea
          ? _value.suhuArea
          : suhuArea // ignore: cast_nullable_to_non_nullable
              as double?,
      kondisiPencahayaan: freezed == kondisiPencahayaan
          ? _value.kondisiPencahayaan
          : kondisiPencahayaan // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiVentilasi: freezed == kondisiVentilasi
          ? _value.kondisiVentilasi
          : kondisiVentilasi // ignore: cast_nullable_to_non_nullable
              as String?,
      tingkatKebisingan: freezed == tingkatKebisingan
          ? _value.tingkatKebisingan
          : tingkatKebisingan // ignore: cast_nullable_to_non_nullable
              as String?,
      jumlahUnsafeCondition: null == jumlahUnsafeCondition
          ? _value.jumlahUnsafeCondition
          : jumlahUnsafeCondition // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeCondition: freezed == unsafeCondition
          ? _value.unsafeCondition
          : unsafeCondition // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahUnsafeAct: null == jumlahUnsafeAct
          ? _value.jumlahUnsafeAct
          : jumlahUnsafeAct // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeAct: freezed == unsafeAct
          ? _value.unsafeAct
          : unsafeAct // ignore: cast_nullable_to_non_nullable
              as dynamic,
      pekerjaDiamati: null == pekerjaDiamati
          ? _value.pekerjaDiamati
          : pekerjaDiamati // ignore: cast_nullable_to_non_nullable
              as int,
      pekerjaPatuhApd: null == pekerjaPatuhApd
          ? _value.pekerjaPatuhApd
          : pekerjaPatuhApd // ignore: cast_nullable_to_non_nullable
              as int,
      pekerjaTidakPatuhApd: null == pekerjaTidakPatuhApd
          ? _value.pekerjaTidakPatuhApd
          : pekerjaTidakPatuhApd // ignore: cast_nullable_to_non_nullable
              as int,
      persentaseKepatuhanApd: freezed == persentaseKepatuhanApd
          ? _value.persentaseKepatuhanApd
          : persentaseKepatuhanApd // ignore: cast_nullable_to_non_nullable
              as double?,
      detailApd: freezed == detailApd
          ? _value.detailApd
          : detailApd // ignore: cast_nullable_to_non_nullable
              as dynamic,
      skorHousekeeping: freezed == skorHousekeeping
          ? _value.skorHousekeeping
          : skorHousekeeping // ignore: cast_nullable_to_non_nullable
              as int?,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      areaKotor: null == areaKotor
          ? _value.areaKotor
          : areaKotor // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaRapi: null == areaRapi
          ? _value.areaRapi
          : areaRapi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahMesinDiperiksa: null == jumlahMesinDiperiksa
          ? _value.jumlahMesinDiperiksa
          : jumlahMesinDiperiksa // ignore: cast_nullable_to_non_nullable
              as int,
      mesinKondisiBaik: null == mesinKondisiBaik
          ? _value.mesinKondisiBaik
          : mesinKondisiBaik // ignore: cast_nullable_to_non_nullable
              as int,
      mesinPerluPerbaikan: null == mesinPerluPerbaikan
          ? _value.mesinPerluPerbaikan
          : mesinPerluPerbaikan // ignore: cast_nullable_to_non_nullable
              as int,
      detailMesin: freezed == detailMesin
          ? _value.detailMesin
          : detailMesin // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rambuK3Lengkap: null == rambuK3Lengkap
          ? _value.rambuK3Lengkap
          : rambuK3Lengkap // ignore: cast_nullable_to_non_nullable
              as bool,
      rambuK3Hilang: null == rambuK3Hilang
          ? _value.rambuK3Hilang
          : rambuK3Hilang // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rambuK3Rusak: null == rambuK3Rusak
          ? _value.rambuK3Rusak
          : rambuK3Rusak // ignore: cast_nullable_to_non_nullable
              as List<String>,
      labelB3Lengkap: null == labelB3Lengkap
          ? _value.labelB3Lengkap
          : labelB3Lengkap // ignore: cast_nullable_to_non_nullable
              as bool,
      jalurEvakuasiBebas: null == jalurEvakuasiBebas
          ? _value.jalurEvakuasiBebas
          : jalurEvakuasiBebas // ignore: cast_nullable_to_non_nullable
              as bool,
      pintuDaruratBerfungsi: null == pintuDaruratBerfungsi
          ? _value.pintuDaruratBerfungsi
          : pintuDaruratBerfungsi // ignore: cast_nullable_to_non_nullable
              as bool,
      aparTersedia: null == aparTersedia
          ? _value.aparTersedia
          : aparTersedia // ignore: cast_nullable_to_non_nullable
              as bool,
      aparExpire: null == aparExpire
          ? _value.aparExpire
          : aparExpire // ignore: cast_nullable_to_non_nullable
              as int,
      emergencyLightBerfungsi: null == emergencyLightBerfungsi
          ? _value.emergencyLightBerfungsi
          : emergencyLightBerfungsi // ignore: cast_nullable_to_non_nullable
              as bool,
      goodPractice: null == goodPractice
          ? _value.goodPractice
          : goodPractice // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaExcellent: null == areaExcellent
          ? _value.areaExcellent
          : areaExcellent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaTeladan: null == pekerjaTeladan
          ? _value.pekerjaTeladan
          : pekerjaTeladan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalTemuan: null == totalTemuan
          ? _value.totalTemuan
          : totalTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      temuanKritikal: null == temuanKritikal
          ? _value.temuanKritikal
          : temuanKritikal // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMayor: null == temuanMayor
          ? _value.temuanMayor
          : temuanMayor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      rekomendasi: null == rekomendasi
          ? _value.rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatanPatrol: freezed == catatanPatrol
          ? _value.catatanPatrol
          : catatanPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
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
      stopWorkIssued: null == stopWorkIssued
          ? _value.stopWorkIssued
          : stopWorkIssued // ignore: cast_nullable_to_non_nullable
              as bool,
      stopWorkArea: null == stopWorkArea
          ? _value.stopWorkArea
          : stopWorkArea // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stopWorkAlasan: freezed == stopWorkAlasan
          ? _value.stopWorkAlasan
          : stopWorkAlasan // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoPatrol: null == fotoPatrol
          ? _value.fotoPatrol
          : fotoPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dokumenPendukung: null == dokumenPendukung
          ? _value.dokumenPendukung
          : dokumenPendukung // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skorKeseluruhan: freezed == skorKeseluruhan
          ? _value.skorKeseluruhan
          : skorKeseluruhan // ignore: cast_nullable_to_non_nullable
              as double?,
      skorApd: freezed == skorApd
          ? _value.skorApd
          : skorApd // ignore: cast_nullable_to_non_nullable
              as double?,
      skorKondisiArea: freezed == skorKondisiArea
          ? _value.skorKondisiArea
          : skorKondisiArea // ignore: cast_nullable_to_non_nullable
              as double?,
      skorPeralatan: freezed == skorPeralatan
          ? _value.skorPeralatan
          : skorPeralatan // ignore: cast_nullable_to_non_nullable
              as double?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
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
      statusFollowUp: freezed == statusFollowUp
          ? _value.statusFollowUp
          : statusFollowUp // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SafetyPatrolImplCopyWith<$Res>
    implements $SafetyPatrolCopyWith<$Res> {
  factory _$$SafetyPatrolImplCopyWith(
          _$SafetyPatrolImpl value, $Res Function(_$SafetyPatrolImpl) then) =
      __$$SafetyPatrolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'nomor_patrol') String nomorPatrol,
      @JsonKey(name: 'tanggal_patrol') DateTime? tanggalPatrol,
      @JsonKey(name: 'waktu_mulai') String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      String? shift,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'area_patrol') String areaPatrol,
      @JsonKey(name: 'lokasi_spesifik') String? lokasiSpesifik,
      @JsonKey(name: 'ketua_patrol') String ketuaPatrol,
      @JsonKey(name: 'anggota_patrol') List<String> anggotaPatrol,
      @JsonKey(name: 'jumlah_anggota') int jumlahAnggota,
      @JsonKey(name: 'jenis_patrol') String? jenisPatrol,
      @JsonKey(name: 'tujuan_patrol') String? tujuanPatrol,
      @JsonKey(name: 'fokus_patrol') List<String> fokusPatrol,
      String? cuaca,
      @JsonKey(name: 'suhu_area') double? suhuArea,
      @JsonKey(name: 'kondisi_pencahayaan') String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') String? kondisiVentilasi,
      @JsonKey(name: 'tingkat_kebisingan') String? tingkatKebisingan,
      @JsonKey(name: 'jumlah_unsafe_condition') int jumlahUnsafeCondition,
      @JsonKey(name: 'unsafe_condition') dynamic unsafeCondition,
      @JsonKey(name: 'jumlah_unsafe_act') int jumlahUnsafeAct,
      @JsonKey(name: 'unsafe_act') dynamic unsafeAct,
      @JsonKey(name: 'pekerja_diamati') int pekerjaDiamati,
      @JsonKey(name: 'pekerja_patuh_apd') int pekerjaPatuhApd,
      @JsonKey(name: 'pekerja_tidak_patuh_apd') int pekerjaTidakPatuhApd,
      @JsonKey(name: 'persentase_kepatuhan_apd') double? persentaseKepatuhanApd,
      @JsonKey(name: 'detail_apd') dynamic detailApd,
      @JsonKey(name: 'skor_housekeeping') int? skorHousekeeping,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'area_kotor') List<String> areaKotor,
      @JsonKey(name: 'area_rapi') List<String> areaRapi,
      @JsonKey(name: 'jumlah_mesin_diperiksa') int jumlahMesinDiperiksa,
      @JsonKey(name: 'mesin_kondisi_baik') int mesinKondisiBaik,
      @JsonKey(name: 'mesin_perlu_perbaikan') int mesinPerluPerbaikan,
      @JsonKey(name: 'detail_mesin') dynamic detailMesin,
      @JsonKey(name: 'rambu_k3_lengkap') bool rambuK3Lengkap,
      @JsonKey(name: 'rambu_k3_hilang') List<String> rambuK3Hilang,
      @JsonKey(name: 'rambu_k3_rusak') List<String> rambuK3Rusak,
      @JsonKey(name: 'label_b3_lengkap') bool labelB3Lengkap,
      @JsonKey(name: 'jalur_evakuasi_bebas') bool jalurEvakuasiBebas,
      @JsonKey(name: 'pintu_darurat_berfungsi') bool pintuDaruratBerfungsi,
      @JsonKey(name: 'apar_tersedia') bool aparTersedia,
      @JsonKey(name: 'apar_expire') int aparExpire,
      @JsonKey(name: 'emergency_light_berfungsi') bool emergencyLightBerfungsi,
      @JsonKey(name: 'good_practice') List<String> goodPractice,
      @JsonKey(name: 'area_excellent') List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') List<String> pekerjaTeladan,
      @JsonKey(name: 'total_temuan') int totalTemuan,
      @JsonKey(name: 'temuan_kritikal') int temuanKritikal,
      @JsonKey(name: 'temuan_mayor') int temuanMayor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      List<String> rekomendasi,
      @JsonKey(name: 'catatan_patrol') String? catatanPatrol,
      @JsonKey(name: 'action_items') dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') int jumlahActionItem,
      @JsonKey(name: 'action_selesai') int actionSelesai,
      @JsonKey(name: 'action_progress') int actionProgress,
      @JsonKey(name: 'action_belum_mulai') int actionBelumMulai,
      @JsonKey(name: 'stop_work_issued') bool stopWorkIssued,
      @JsonKey(name: 'stop_work_area') List<String> stopWorkArea,
      @JsonKey(name: 'stop_work_alasan') String? stopWorkAlasan,
      @JsonKey(name: 'foto_patrol') List<String> fotoPatrol,
      @JsonKey(name: 'dokumen_pendukung') List<String> dokumenPendukung,
      @JsonKey(name: 'skor_keseluruhan') double? skorKeseluruhan,
      @JsonKey(name: 'skor_apd') double? skorApd,
      @JsonKey(name: 'skor_kondisi_area') double? skorKondisiArea,
      @JsonKey(name: 'skor_peralatan') double? skorPeralatan,
      String? grade,
      String status,
      @JsonKey(name: 'tingkat_urgensi') String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') String? statusFollowUp,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
      @JsonKey(name: 'review_notes') String? reviewNotes,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$SafetyPatrolImplCopyWithImpl<$Res>
    extends _$SafetyPatrolCopyWithImpl<$Res, _$SafetyPatrolImpl>
    implements _$$SafetyPatrolImplCopyWith<$Res> {
  __$$SafetyPatrolImplCopyWithImpl(
      _$SafetyPatrolImpl _value, $Res Function(_$SafetyPatrolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nomorPatrol = null,
    Object? tanggalPatrol = freezed,
    Object? waktuMulai = freezed,
    Object? waktuSelesai = freezed,
    Object? shift = freezed,
    Object? unitId = freezed,
    Object? areaPatrol = null,
    Object? lokasiSpesifik = freezed,
    Object? ketuaPatrol = null,
    Object? anggotaPatrol = null,
    Object? jumlahAnggota = null,
    Object? jenisPatrol = freezed,
    Object? tujuanPatrol = freezed,
    Object? fokusPatrol = null,
    Object? cuaca = freezed,
    Object? suhuArea = freezed,
    Object? kondisiPencahayaan = freezed,
    Object? kondisiVentilasi = freezed,
    Object? tingkatKebisingan = freezed,
    Object? jumlahUnsafeCondition = null,
    Object? unsafeCondition = freezed,
    Object? jumlahUnsafeAct = null,
    Object? unsafeAct = freezed,
    Object? pekerjaDiamati = null,
    Object? pekerjaPatuhApd = null,
    Object? pekerjaTidakPatuhApd = null,
    Object? persentaseKepatuhanApd = freezed,
    Object? detailApd = freezed,
    Object? skorHousekeeping = freezed,
    Object? kondisiHousekeeping = freezed,
    Object? areaKotor = null,
    Object? areaRapi = null,
    Object? jumlahMesinDiperiksa = null,
    Object? mesinKondisiBaik = null,
    Object? mesinPerluPerbaikan = null,
    Object? detailMesin = freezed,
    Object? rambuK3Lengkap = null,
    Object? rambuK3Hilang = null,
    Object? rambuK3Rusak = null,
    Object? labelB3Lengkap = null,
    Object? jalurEvakuasiBebas = null,
    Object? pintuDaruratBerfungsi = null,
    Object? aparTersedia = null,
    Object? aparExpire = null,
    Object? emergencyLightBerfungsi = null,
    Object? goodPractice = null,
    Object? areaExcellent = null,
    Object? pekerjaTeladan = null,
    Object? totalTemuan = null,
    Object? temuanKritikal = null,
    Object? temuanMayor = null,
    Object? temuanMinor = null,
    Object? rekomendasi = null,
    Object? catatanPatrol = freezed,
    Object? actionItems = freezed,
    Object? jumlahActionItem = null,
    Object? actionSelesai = null,
    Object? actionProgress = null,
    Object? actionBelumMulai = null,
    Object? stopWorkIssued = null,
    Object? stopWorkArea = null,
    Object? stopWorkAlasan = freezed,
    Object? fotoPatrol = null,
    Object? dokumenPendukung = null,
    Object? skorKeseluruhan = freezed,
    Object? skorApd = freezed,
    Object? skorKondisiArea = freezed,
    Object? skorPeralatan = freezed,
    Object? grade = freezed,
    Object? status = null,
    Object? tingkatUrgensi = null,
    Object? perluFollowUp = null,
    Object? tanggalFollowUp = freezed,
    Object? statusFollowUp = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SafetyPatrolImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorPatrol: null == nomorPatrol
          ? _value.nomorPatrol
          : nomorPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalPatrol: freezed == tanggalPatrol
          ? _value.tanggalPatrol
          : tanggalPatrol // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      waktuMulai: freezed == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String?,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      shift: freezed == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaPatrol: null == areaPatrol
          ? _value.areaPatrol
          : areaPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      lokasiSpesifik: freezed == lokasiSpesifik
          ? _value.lokasiSpesifik
          : lokasiSpesifik // ignore: cast_nullable_to_non_nullable
              as String?,
      ketuaPatrol: null == ketuaPatrol
          ? _value.ketuaPatrol
          : ketuaPatrol // ignore: cast_nullable_to_non_nullable
              as String,
      anggotaPatrol: null == anggotaPatrol
          ? _value._anggotaPatrol
          : anggotaPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahAnggota: null == jumlahAnggota
          ? _value.jumlahAnggota
          : jumlahAnggota // ignore: cast_nullable_to_non_nullable
              as int,
      jenisPatrol: freezed == jenisPatrol
          ? _value.jenisPatrol
          : jenisPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
      tujuanPatrol: freezed == tujuanPatrol
          ? _value.tujuanPatrol
          : tujuanPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
      fokusPatrol: null == fokusPatrol
          ? _value._fokusPatrol
          : fokusPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuaca: freezed == cuaca
          ? _value.cuaca
          : cuaca // ignore: cast_nullable_to_non_nullable
              as String?,
      suhuArea: freezed == suhuArea
          ? _value.suhuArea
          : suhuArea // ignore: cast_nullable_to_non_nullable
              as double?,
      kondisiPencahayaan: freezed == kondisiPencahayaan
          ? _value.kondisiPencahayaan
          : kondisiPencahayaan // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiVentilasi: freezed == kondisiVentilasi
          ? _value.kondisiVentilasi
          : kondisiVentilasi // ignore: cast_nullable_to_non_nullable
              as String?,
      tingkatKebisingan: freezed == tingkatKebisingan
          ? _value.tingkatKebisingan
          : tingkatKebisingan // ignore: cast_nullable_to_non_nullable
              as String?,
      jumlahUnsafeCondition: null == jumlahUnsafeCondition
          ? _value.jumlahUnsafeCondition
          : jumlahUnsafeCondition // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeCondition: freezed == unsafeCondition
          ? _value.unsafeCondition
          : unsafeCondition // ignore: cast_nullable_to_non_nullable
              as dynamic,
      jumlahUnsafeAct: null == jumlahUnsafeAct
          ? _value.jumlahUnsafeAct
          : jumlahUnsafeAct // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeAct: freezed == unsafeAct
          ? _value.unsafeAct
          : unsafeAct // ignore: cast_nullable_to_non_nullable
              as dynamic,
      pekerjaDiamati: null == pekerjaDiamati
          ? _value.pekerjaDiamati
          : pekerjaDiamati // ignore: cast_nullable_to_non_nullable
              as int,
      pekerjaPatuhApd: null == pekerjaPatuhApd
          ? _value.pekerjaPatuhApd
          : pekerjaPatuhApd // ignore: cast_nullable_to_non_nullable
              as int,
      pekerjaTidakPatuhApd: null == pekerjaTidakPatuhApd
          ? _value.pekerjaTidakPatuhApd
          : pekerjaTidakPatuhApd // ignore: cast_nullable_to_non_nullable
              as int,
      persentaseKepatuhanApd: freezed == persentaseKepatuhanApd
          ? _value.persentaseKepatuhanApd
          : persentaseKepatuhanApd // ignore: cast_nullable_to_non_nullable
              as double?,
      detailApd: freezed == detailApd
          ? _value.detailApd
          : detailApd // ignore: cast_nullable_to_non_nullable
              as dynamic,
      skorHousekeeping: freezed == skorHousekeeping
          ? _value.skorHousekeeping
          : skorHousekeeping // ignore: cast_nullable_to_non_nullable
              as int?,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      areaKotor: null == areaKotor
          ? _value._areaKotor
          : areaKotor // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaRapi: null == areaRapi
          ? _value._areaRapi
          : areaRapi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      jumlahMesinDiperiksa: null == jumlahMesinDiperiksa
          ? _value.jumlahMesinDiperiksa
          : jumlahMesinDiperiksa // ignore: cast_nullable_to_non_nullable
              as int,
      mesinKondisiBaik: null == mesinKondisiBaik
          ? _value.mesinKondisiBaik
          : mesinKondisiBaik // ignore: cast_nullable_to_non_nullable
              as int,
      mesinPerluPerbaikan: null == mesinPerluPerbaikan
          ? _value.mesinPerluPerbaikan
          : mesinPerluPerbaikan // ignore: cast_nullable_to_non_nullable
              as int,
      detailMesin: freezed == detailMesin
          ? _value.detailMesin
          : detailMesin // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rambuK3Lengkap: null == rambuK3Lengkap
          ? _value.rambuK3Lengkap
          : rambuK3Lengkap // ignore: cast_nullable_to_non_nullable
              as bool,
      rambuK3Hilang: null == rambuK3Hilang
          ? _value._rambuK3Hilang
          : rambuK3Hilang // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rambuK3Rusak: null == rambuK3Rusak
          ? _value._rambuK3Rusak
          : rambuK3Rusak // ignore: cast_nullable_to_non_nullable
              as List<String>,
      labelB3Lengkap: null == labelB3Lengkap
          ? _value.labelB3Lengkap
          : labelB3Lengkap // ignore: cast_nullable_to_non_nullable
              as bool,
      jalurEvakuasiBebas: null == jalurEvakuasiBebas
          ? _value.jalurEvakuasiBebas
          : jalurEvakuasiBebas // ignore: cast_nullable_to_non_nullable
              as bool,
      pintuDaruratBerfungsi: null == pintuDaruratBerfungsi
          ? _value.pintuDaruratBerfungsi
          : pintuDaruratBerfungsi // ignore: cast_nullable_to_non_nullable
              as bool,
      aparTersedia: null == aparTersedia
          ? _value.aparTersedia
          : aparTersedia // ignore: cast_nullable_to_non_nullable
              as bool,
      aparExpire: null == aparExpire
          ? _value.aparExpire
          : aparExpire // ignore: cast_nullable_to_non_nullable
              as int,
      emergencyLightBerfungsi: null == emergencyLightBerfungsi
          ? _value.emergencyLightBerfungsi
          : emergencyLightBerfungsi // ignore: cast_nullable_to_non_nullable
              as bool,
      goodPractice: null == goodPractice
          ? _value._goodPractice
          : goodPractice // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areaExcellent: null == areaExcellent
          ? _value._areaExcellent
          : areaExcellent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pekerjaTeladan: null == pekerjaTeladan
          ? _value._pekerjaTeladan
          : pekerjaTeladan // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalTemuan: null == totalTemuan
          ? _value.totalTemuan
          : totalTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      temuanKritikal: null == temuanKritikal
          ? _value.temuanKritikal
          : temuanKritikal // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMayor: null == temuanMayor
          ? _value.temuanMayor
          : temuanMayor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      rekomendasi: null == rekomendasi
          ? _value._rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatanPatrol: freezed == catatanPatrol
          ? _value.catatanPatrol
          : catatanPatrol // ignore: cast_nullable_to_non_nullable
              as String?,
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
      stopWorkIssued: null == stopWorkIssued
          ? _value.stopWorkIssued
          : stopWorkIssued // ignore: cast_nullable_to_non_nullable
              as bool,
      stopWorkArea: null == stopWorkArea
          ? _value._stopWorkArea
          : stopWorkArea // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stopWorkAlasan: freezed == stopWorkAlasan
          ? _value.stopWorkAlasan
          : stopWorkAlasan // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoPatrol: null == fotoPatrol
          ? _value._fotoPatrol
          : fotoPatrol // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dokumenPendukung: null == dokumenPendukung
          ? _value._dokumenPendukung
          : dokumenPendukung // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skorKeseluruhan: freezed == skorKeseluruhan
          ? _value.skorKeseluruhan
          : skorKeseluruhan // ignore: cast_nullable_to_non_nullable
              as double?,
      skorApd: freezed == skorApd
          ? _value.skorApd
          : skorApd // ignore: cast_nullable_to_non_nullable
              as double?,
      skorKondisiArea: freezed == skorKondisiArea
          ? _value.skorKondisiArea
          : skorKondisiArea // ignore: cast_nullable_to_non_nullable
              as double?,
      skorPeralatan: freezed == skorPeralatan
          ? _value.skorPeralatan
          : skorPeralatan // ignore: cast_nullable_to_non_nullable
              as double?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
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
      statusFollowUp: freezed == statusFollowUp
          ? _value.statusFollowUp
          : statusFollowUp // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SafetyPatrolImpl implements _SafetyPatrol {
  const _$SafetyPatrolImpl(
      {this.id,
      @JsonKey(name: 'nomor_patrol') this.nomorPatrol = '',
      @JsonKey(name: 'tanggal_patrol') this.tanggalPatrol,
      @JsonKey(name: 'waktu_mulai') this.waktuMulai,
      @JsonKey(name: 'waktu_selesai') this.waktuSelesai,
      this.shift,
      @JsonKey(name: 'unit_id') this.unitId,
      @JsonKey(name: 'area_patrol') this.areaPatrol = '',
      @JsonKey(name: 'lokasi_spesifik') this.lokasiSpesifik,
      @JsonKey(name: 'ketua_patrol') this.ketuaPatrol = '',
      @JsonKey(name: 'anggota_patrol')
      final List<String> anggotaPatrol = const [],
      @JsonKey(name: 'jumlah_anggota') this.jumlahAnggota = 0,
      @JsonKey(name: 'jenis_patrol') this.jenisPatrol,
      @JsonKey(name: 'tujuan_patrol') this.tujuanPatrol,
      @JsonKey(name: 'fokus_patrol') final List<String> fokusPatrol = const [],
      this.cuaca,
      @JsonKey(name: 'suhu_area') this.suhuArea,
      @JsonKey(name: 'kondisi_pencahayaan') this.kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') this.kondisiVentilasi,
      @JsonKey(name: 'tingkat_kebisingan') this.tingkatKebisingan,
      @JsonKey(name: 'jumlah_unsafe_condition') this.jumlahUnsafeCondition = 0,
      @JsonKey(name: 'unsafe_condition') this.unsafeCondition,
      @JsonKey(name: 'jumlah_unsafe_act') this.jumlahUnsafeAct = 0,
      @JsonKey(name: 'unsafe_act') this.unsafeAct,
      @JsonKey(name: 'pekerja_diamati') this.pekerjaDiamati = 0,
      @JsonKey(name: 'pekerja_patuh_apd') this.pekerjaPatuhApd = 0,
      @JsonKey(name: 'pekerja_tidak_patuh_apd') this.pekerjaTidakPatuhApd = 0,
      @JsonKey(name: 'persentase_kepatuhan_apd') this.persentaseKepatuhanApd,
      @JsonKey(name: 'detail_apd') this.detailApd,
      @JsonKey(name: 'skor_housekeeping') this.skorHousekeeping,
      @JsonKey(name: 'kondisi_housekeeping') this.kondisiHousekeeping,
      @JsonKey(name: 'area_kotor') final List<String> areaKotor = const [],
      @JsonKey(name: 'area_rapi') final List<String> areaRapi = const [],
      @JsonKey(name: 'jumlah_mesin_diperiksa') this.jumlahMesinDiperiksa = 0,
      @JsonKey(name: 'mesin_kondisi_baik') this.mesinKondisiBaik = 0,
      @JsonKey(name: 'mesin_perlu_perbaikan') this.mesinPerluPerbaikan = 0,
      @JsonKey(name: 'detail_mesin') this.detailMesin,
      @JsonKey(name: 'rambu_k3_lengkap') this.rambuK3Lengkap = false,
      @JsonKey(name: 'rambu_k3_hilang')
      final List<String> rambuK3Hilang = const [],
      @JsonKey(name: 'rambu_k3_rusak')
      final List<String> rambuK3Rusak = const [],
      @JsonKey(name: 'label_b3_lengkap') this.labelB3Lengkap = false,
      @JsonKey(name: 'jalur_evakuasi_bebas') this.jalurEvakuasiBebas = false,
      @JsonKey(name: 'pintu_darurat_berfungsi')
      this.pintuDaruratBerfungsi = false,
      @JsonKey(name: 'apar_tersedia') this.aparTersedia = false,
      @JsonKey(name: 'apar_expire') this.aparExpire = 0,
      @JsonKey(name: 'emergency_light_berfungsi')
      this.emergencyLightBerfungsi = false,
      @JsonKey(name: 'good_practice')
      final List<String> goodPractice = const [],
      @JsonKey(name: 'area_excellent')
      final List<String> areaExcellent = const [],
      @JsonKey(name: 'pekerja_teladan')
      final List<String> pekerjaTeladan = const [],
      @JsonKey(name: 'total_temuan') this.totalTemuan = 0,
      @JsonKey(name: 'temuan_kritikal') this.temuanKritikal = 0,
      @JsonKey(name: 'temuan_mayor') this.temuanMayor = 0,
      @JsonKey(name: 'temuan_minor') this.temuanMinor = 0,
      final List<String> rekomendasi = const [],
      @JsonKey(name: 'catatan_patrol') this.catatanPatrol,
      @JsonKey(name: 'action_items') this.actionItems,
      @JsonKey(name: 'jumlah_action_item') this.jumlahActionItem = 0,
      @JsonKey(name: 'action_selesai') this.actionSelesai = 0,
      @JsonKey(name: 'action_progress') this.actionProgress = 0,
      @JsonKey(name: 'action_belum_mulai') this.actionBelumMulai = 0,
      @JsonKey(name: 'stop_work_issued') this.stopWorkIssued = false,
      @JsonKey(name: 'stop_work_area')
      final List<String> stopWorkArea = const [],
      @JsonKey(name: 'stop_work_alasan') this.stopWorkAlasan,
      @JsonKey(name: 'foto_patrol') final List<String> fotoPatrol = const [],
      @JsonKey(name: 'dokumen_pendukung')
      final List<String> dokumenPendukung = const [],
      @JsonKey(name: 'skor_keseluruhan') this.skorKeseluruhan,
      @JsonKey(name: 'skor_apd') this.skorApd,
      @JsonKey(name: 'skor_kondisi_area') this.skorKondisiArea,
      @JsonKey(name: 'skor_peralatan') this.skorPeralatan,
      this.grade,
      this.status = 'draft',
      @JsonKey(name: 'tingkat_urgensi') this.tingkatUrgensi = 'normal',
      @JsonKey(name: 'perlu_follow_up') this.perluFollowUp = false,
      @JsonKey(name: 'tanggal_follow_up') this.tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') this.statusFollowUp,
      @JsonKey(name: 'reviewed_by') this.reviewedBy,
      @JsonKey(name: 'reviewed_at') this.reviewedAt,
      @JsonKey(name: 'review_notes') this.reviewNotes,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _anggotaPatrol = anggotaPatrol,
        _fokusPatrol = fokusPatrol,
        _areaKotor = areaKotor,
        _areaRapi = areaRapi,
        _rambuK3Hilang = rambuK3Hilang,
        _rambuK3Rusak = rambuK3Rusak,
        _goodPractice = goodPractice,
        _areaExcellent = areaExcellent,
        _pekerjaTeladan = pekerjaTeladan,
        _rekomendasi = rekomendasi,
        _stopWorkArea = stopWorkArea,
        _fotoPatrol = fotoPatrol,
        _dokumenPendukung = dokumenPendukung;

  factory _$SafetyPatrolImpl.fromJson(Map<String, dynamic> json) =>
      _$$SafetyPatrolImplFromJson(json);

  @override
  final String? id;
// Basic information
  @override
  @JsonKey(name: 'nomor_patrol')
  final String nomorPatrol;
  @override
  @JsonKey(name: 'tanggal_patrol')
  final DateTime? tanggalPatrol;
  @override
  @JsonKey(name: 'waktu_mulai')
  final String? waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  final String? waktuSelesai;
// Shift and unit
  @override
  final String? shift;
// pagi, siang, malam
  @override
  @JsonKey(name: 'unit_id')
  final String? unitId;
  @override
  @JsonKey(name: 'area_patrol')
  final String areaPatrol;
  @override
  @JsonKey(name: 'lokasi_spesifik')
  final String? lokasiSpesifik;
// Team information
  @override
  @JsonKey(name: 'ketua_patrol')
  final String ketuaPatrol;
  final List<String> _anggotaPatrol;
  @override
  @JsonKey(name: 'anggota_patrol')
  List<String> get anggotaPatrol {
    if (_anggotaPatrol is EqualUnmodifiableListView) return _anggotaPatrol;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_anggotaPatrol);
  }

  @override
  @JsonKey(name: 'jumlah_anggota')
  final int jumlahAnggota;
// Patrol details
  @override
  @JsonKey(name: 'jenis_patrol')
  final String? jenisPatrol;
// rutin, terjadwal, insidental, khusus, malam, emergency
  @override
  @JsonKey(name: 'tujuan_patrol')
  final String? tujuanPatrol;
  final List<String> _fokusPatrol;
  @override
  @JsonKey(name: 'fokus_patrol')
  List<String> get fokusPatrol {
    if (_fokusPatrol is EqualUnmodifiableListView) return _fokusPatrol;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fokusPatrol);
  }

// Environmental conditions
  @override
  final String? cuaca;
// cerah, mendung, hujan, panas
  @override
  @JsonKey(name: 'suhu_area')
  final double? suhuArea;
  @override
  @JsonKey(name: 'kondisi_pencahayaan')
  final String? kondisiPencahayaan;
// baik, cukup, kurang, buruk
  @override
  @JsonKey(name: 'kondisi_ventilasi')
  final String? kondisiVentilasi;
// baik, cukup, kurang, buruk
  @override
  @JsonKey(name: 'tingkat_kebisingan')
  final String? tingkatKebisingan;
// normal, cukup_bising, bising, sangat_bising
// Unsafe conditions and acts
  @override
  @JsonKey(name: 'jumlah_unsafe_condition')
  final int jumlahUnsafeCondition;
  @override
  @JsonKey(name: 'unsafe_condition')
  final dynamic unsafeCondition;
// JSONB array of objects
  @override
  @JsonKey(name: 'jumlah_unsafe_act')
  final int jumlahUnsafeAct;
  @override
  @JsonKey(name: 'unsafe_act')
  final dynamic unsafeAct;
// JSONB array of objects
// Worker observations
  @override
  @JsonKey(name: 'pekerja_diamati')
  final int pekerjaDiamati;
  @override
  @JsonKey(name: 'pekerja_patuh_apd')
  final int pekerjaPatuhApd;
  @override
  @JsonKey(name: 'pekerja_tidak_patuh_apd')
  final int pekerjaTidakPatuhApd;
  @override
  @JsonKey(name: 'persentase_kepatuhan_apd')
  final double? persentaseKepatuhanApd;
  @override
  @JsonKey(name: 'detail_apd')
  final dynamic detailApd;
// JSONB array of objects
// Housekeeping
  @override
  @JsonKey(name: 'skor_housekeeping')
  final int? skorHousekeeping;
  @override
  @JsonKey(name: 'kondisi_housekeeping')
  final String? kondisiHousekeeping;
// sangat_baik, baik, cukup, kurang, buruk
  final List<String> _areaKotor;
// sangat_baik, baik, cukup, kurang, buruk
  @override
  @JsonKey(name: 'area_kotor')
  List<String> get areaKotor {
    if (_areaKotor is EqualUnmodifiableListView) return _areaKotor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaKotor);
  }

  final List<String> _areaRapi;
  @override
  @JsonKey(name: 'area_rapi')
  List<String> get areaRapi {
    if (_areaRapi is EqualUnmodifiableListView) return _areaRapi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaRapi);
  }

// Equipment checks
  @override
  @JsonKey(name: 'jumlah_mesin_diperiksa')
  final int jumlahMesinDiperiksa;
  @override
  @JsonKey(name: 'mesin_kondisi_baik')
  final int mesinKondisiBaik;
  @override
  @JsonKey(name: 'mesin_perlu_perbaikan')
  final int mesinPerluPerbaikan;
  @override
  @JsonKey(name: 'detail_mesin')
  final dynamic detailMesin;
// JSONB array of objects
// Safety equipment checks
  @override
  @JsonKey(name: 'rambu_k3_lengkap')
  final bool rambuK3Lengkap;
  final List<String> _rambuK3Hilang;
  @override
  @JsonKey(name: 'rambu_k3_hilang')
  List<String> get rambuK3Hilang {
    if (_rambuK3Hilang is EqualUnmodifiableListView) return _rambuK3Hilang;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rambuK3Hilang);
  }

  final List<String> _rambuK3Rusak;
  @override
  @JsonKey(name: 'rambu_k3_rusak')
  List<String> get rambuK3Rusak {
    if (_rambuK3Rusak is EqualUnmodifiableListView) return _rambuK3Rusak;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rambuK3Rusak);
  }

  @override
  @JsonKey(name: 'label_b3_lengkap')
  final bool labelB3Lengkap;
  @override
  @JsonKey(name: 'jalur_evakuasi_bebas')
  final bool jalurEvakuasiBebas;
  @override
  @JsonKey(name: 'pintu_darurat_berfungsi')
  final bool pintuDaruratBerfungsi;
  @override
  @JsonKey(name: 'apar_tersedia')
  final bool aparTersedia;
  @override
  @JsonKey(name: 'apar_expire')
  final int aparExpire;
  @override
  @JsonKey(name: 'emergency_light_berfungsi')
  final bool emergencyLightBerfungsi;
// Positive observations
  final List<String> _goodPractice;
// Positive observations
  @override
  @JsonKey(name: 'good_practice')
  List<String> get goodPractice {
    if (_goodPractice is EqualUnmodifiableListView) return _goodPractice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goodPractice);
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

// Findings and recommendations
  @override
  @JsonKey(name: 'total_temuan')
  final int totalTemuan;
  @override
  @JsonKey(name: 'temuan_kritikal')
  final int temuanKritikal;
  @override
  @JsonKey(name: 'temuan_mayor')
  final int temuanMayor;
  @override
  @JsonKey(name: 'temuan_minor')
  final int temuanMinor;
  final List<String> _rekomendasi;
  @override
  @JsonKey()
  List<String> get rekomendasi {
    if (_rekomendasi is EqualUnmodifiableListView) return _rekomendasi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rekomendasi);
  }

  @override
  @JsonKey(name: 'catatan_patrol')
  final String? catatanPatrol;
// Action items
  @override
  @JsonKey(name: 'action_items')
  final dynamic actionItems;
// JSONB array of objects
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
// Stop work orders
  @override
  @JsonKey(name: 'stop_work_issued')
  final bool stopWorkIssued;
  final List<String> _stopWorkArea;
  @override
  @JsonKey(name: 'stop_work_area')
  List<String> get stopWorkArea {
    if (_stopWorkArea is EqualUnmodifiableListView) return _stopWorkArea;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stopWorkArea);
  }

  @override
  @JsonKey(name: 'stop_work_alasan')
  final String? stopWorkAlasan;
// Documentation
  final List<String> _fotoPatrol;
// Documentation
  @override
  @JsonKey(name: 'foto_patrol')
  List<String> get fotoPatrol {
    if (_fotoPatrol is EqualUnmodifiableListView) return _fotoPatrol;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoPatrol);
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

// Scoring
  @override
  @JsonKey(name: 'skor_keseluruhan')
  final double? skorKeseluruhan;
  @override
  @JsonKey(name: 'skor_apd')
  final double? skorApd;
  @override
  @JsonKey(name: 'skor_kondisi_area')
  final double? skorKondisiArea;
  @override
  @JsonKey(name: 'skor_peralatan')
  final double? skorPeralatan;
  @override
  final String? grade;
// A, B, C, D, E
// Status and approval
  @override
  @JsonKey()
  final String status;
// draft, submitted, reviewed, closed, cancelled
  @override
  @JsonKey(name: 'tingkat_urgensi')
  final String tingkatUrgensi;
// rendah, normal, tinggi, kritis
// Follow up
  @override
  @JsonKey(name: 'perlu_follow_up')
  final bool perluFollowUp;
  @override
  @JsonKey(name: 'tanggal_follow_up')
  final DateTime? tanggalFollowUp;
  @override
  @JsonKey(name: 'status_follow_up')
  final String? statusFollowUp;
// belum, dijadwalkan, selesai
// Review information
  @override
  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;
  @override
  @JsonKey(name: 'reviewed_at')
  final DateTime? reviewedAt;
  @override
  @JsonKey(name: 'review_notes')
  final String? reviewNotes;
// Audit fields
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
  String toString() {
    return 'SafetyPatrol(id: $id, nomorPatrol: $nomorPatrol, tanggalPatrol: $tanggalPatrol, waktuMulai: $waktuMulai, waktuSelesai: $waktuSelesai, shift: $shift, unitId: $unitId, areaPatrol: $areaPatrol, lokasiSpesifik: $lokasiSpesifik, ketuaPatrol: $ketuaPatrol, anggotaPatrol: $anggotaPatrol, jumlahAnggota: $jumlahAnggota, jenisPatrol: $jenisPatrol, tujuanPatrol: $tujuanPatrol, fokusPatrol: $fokusPatrol, cuaca: $cuaca, suhuArea: $suhuArea, kondisiPencahayaan: $kondisiPencahayaan, kondisiVentilasi: $kondisiVentilasi, tingkatKebisingan: $tingkatKebisingan, jumlahUnsafeCondition: $jumlahUnsafeCondition, unsafeCondition: $unsafeCondition, jumlahUnsafeAct: $jumlahUnsafeAct, unsafeAct: $unsafeAct, pekerjaDiamati: $pekerjaDiamati, pekerjaPatuhApd: $pekerjaPatuhApd, pekerjaTidakPatuhApd: $pekerjaTidakPatuhApd, persentaseKepatuhanApd: $persentaseKepatuhanApd, detailApd: $detailApd, skorHousekeeping: $skorHousekeeping, kondisiHousekeeping: $kondisiHousekeeping, areaKotor: $areaKotor, areaRapi: $areaRapi, jumlahMesinDiperiksa: $jumlahMesinDiperiksa, mesinKondisiBaik: $mesinKondisiBaik, mesinPerluPerbaikan: $mesinPerluPerbaikan, detailMesin: $detailMesin, rambuK3Lengkap: $rambuK3Lengkap, rambuK3Hilang: $rambuK3Hilang, rambuK3Rusak: $rambuK3Rusak, labelB3Lengkap: $labelB3Lengkap, jalurEvakuasiBebas: $jalurEvakuasiBebas, pintuDaruratBerfungsi: $pintuDaruratBerfungsi, aparTersedia: $aparTersedia, aparExpire: $aparExpire, emergencyLightBerfungsi: $emergencyLightBerfungsi, goodPractice: $goodPractice, areaExcellent: $areaExcellent, pekerjaTeladan: $pekerjaTeladan, totalTemuan: $totalTemuan, temuanKritikal: $temuanKritikal, temuanMayor: $temuanMayor, temuanMinor: $temuanMinor, rekomendasi: $rekomendasi, catatanPatrol: $catatanPatrol, actionItems: $actionItems, jumlahActionItem: $jumlahActionItem, actionSelesai: $actionSelesai, actionProgress: $actionProgress, actionBelumMulai: $actionBelumMulai, stopWorkIssued: $stopWorkIssued, stopWorkArea: $stopWorkArea, stopWorkAlasan: $stopWorkAlasan, fotoPatrol: $fotoPatrol, dokumenPendukung: $dokumenPendukung, skorKeseluruhan: $skorKeseluruhan, skorApd: $skorApd, skorKondisiArea: $skorKondisiArea, skorPeralatan: $skorPeralatan, grade: $grade, status: $status, tingkatUrgensi: $tingkatUrgensi, perluFollowUp: $perluFollowUp, tanggalFollowUp: $tanggalFollowUp, statusFollowUp: $statusFollowUp, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafetyPatrolImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nomorPatrol, nomorPatrol) ||
                other.nomorPatrol == nomorPatrol) &&
            (identical(other.tanggalPatrol, tanggalPatrol) ||
                other.tanggalPatrol == tanggalPatrol) &&
            (identical(other.waktuMulai, waktuMulai) ||
                other.waktuMulai == waktuMulai) &&
            (identical(other.waktuSelesai, waktuSelesai) ||
                other.waktuSelesai == waktuSelesai) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.areaPatrol, areaPatrol) ||
                other.areaPatrol == areaPatrol) &&
            (identical(other.lokasiSpesifik, lokasiSpesifik) ||
                other.lokasiSpesifik == lokasiSpesifik) &&
            (identical(other.ketuaPatrol, ketuaPatrol) ||
                other.ketuaPatrol == ketuaPatrol) &&
            const DeepCollectionEquality()
                .equals(other._anggotaPatrol, _anggotaPatrol) &&
            (identical(other.jumlahAnggota, jumlahAnggota) ||
                other.jumlahAnggota == jumlahAnggota) &&
            (identical(other.jenisPatrol, jenisPatrol) ||
                other.jenisPatrol == jenisPatrol) &&
            (identical(other.tujuanPatrol, tujuanPatrol) ||
                other.tujuanPatrol == tujuanPatrol) &&
            const DeepCollectionEquality()
                .equals(other._fokusPatrol, _fokusPatrol) &&
            (identical(other.cuaca, cuaca) || other.cuaca == cuaca) &&
            (identical(other.suhuArea, suhuArea) ||
                other.suhuArea == suhuArea) &&
            (identical(other.kondisiPencahayaan, kondisiPencahayaan) ||
                other.kondisiPencahayaan == kondisiPencahayaan) &&
            (identical(other.kondisiVentilasi, kondisiVentilasi) ||
                other.kondisiVentilasi == kondisiVentilasi) &&
            (identical(other.tingkatKebisingan, tingkatKebisingan) ||
                other.tingkatKebisingan == tingkatKebisingan) &&
            (identical(other.jumlahUnsafeCondition, jumlahUnsafeCondition) ||
                other.jumlahUnsafeCondition == jumlahUnsafeCondition) &&
            const DeepCollectionEquality()
                .equals(other.unsafeCondition, unsafeCondition) &&
            (identical(other.jumlahUnsafeAct, jumlahUnsafeAct) ||
                other.jumlahUnsafeAct == jumlahUnsafeAct) &&
            const DeepCollectionEquality().equals(other.unsafeAct, unsafeAct) &&
            (identical(other.pekerjaDiamati, pekerjaDiamati) ||
                other.pekerjaDiamati == pekerjaDiamati) &&
            (identical(other.pekerjaPatuhApd, pekerjaPatuhApd) ||
                other.pekerjaPatuhApd == pekerjaPatuhApd) &&
            (identical(other.pekerjaTidakPatuhApd, pekerjaTidakPatuhApd) ||
                other.pekerjaTidakPatuhApd == pekerjaTidakPatuhApd) &&
            (identical(other.persentaseKepatuhanApd, persentaseKepatuhanApd) ||
                other.persentaseKepatuhanApd == persentaseKepatuhanApd) &&
            const DeepCollectionEquality().equals(other.detailApd, detailApd) &&
            (identical(other.skorHousekeeping, skorHousekeeping) ||
                other.skorHousekeeping == skorHousekeeping) &&
            (identical(other.kondisiHousekeeping, kondisiHousekeeping) ||
                other.kondisiHousekeeping == kondisiHousekeeping) &&
            const DeepCollectionEquality()
                .equals(other._areaKotor, _areaKotor) &&
            const DeepCollectionEquality().equals(other._areaRapi, _areaRapi) &&
            (identical(other.jumlahMesinDiperiksa, jumlahMesinDiperiksa) ||
                other.jumlahMesinDiperiksa == jumlahMesinDiperiksa) &&
            (identical(other.mesinKondisiBaik, mesinKondisiBaik) ||
                other.mesinKondisiBaik == mesinKondisiBaik) &&
            (identical(other.mesinPerluPerbaikan, mesinPerluPerbaikan) ||
                other.mesinPerluPerbaikan == mesinPerluPerbaikan) &&
            const DeepCollectionEquality()
                .equals(other.detailMesin, detailMesin) &&
            (identical(other.rambuK3Lengkap, rambuK3Lengkap) ||
                other.rambuK3Lengkap == rambuK3Lengkap) &&
            const DeepCollectionEquality()
                .equals(other._rambuK3Hilang, _rambuK3Hilang) &&
            const DeepCollectionEquality()
                .equals(other._rambuK3Rusak, _rambuK3Rusak) &&
            (identical(other.labelB3Lengkap, labelB3Lengkap) ||
                other.labelB3Lengkap == labelB3Lengkap) &&
            (identical(other.jalurEvakuasiBebas, jalurEvakuasiBebas) ||
                other.jalurEvakuasiBebas == jalurEvakuasiBebas) &&
            (identical(other.pintuDaruratBerfungsi, pintuDaruratBerfungsi) ||
                other.pintuDaruratBerfungsi == pintuDaruratBerfungsi) &&
            (identical(other.aparTersedia, aparTersedia) ||
                other.aparTersedia == aparTersedia) &&
            (identical(other.aparExpire, aparExpire) ||
                other.aparExpire == aparExpire) &&
            (identical(other.emergencyLightBerfungsi, emergencyLightBerfungsi) ||
                other.emergencyLightBerfungsi == emergencyLightBerfungsi) &&
            const DeepCollectionEquality()
                .equals(other._goodPractice, _goodPractice) &&
            const DeepCollectionEquality()
                .equals(other._areaExcellent, _areaExcellent) &&
            const DeepCollectionEquality()
                .equals(other._pekerjaTeladan, _pekerjaTeladan) &&
            (identical(other.totalTemuan, totalTemuan) || other.totalTemuan == totalTemuan) &&
            (identical(other.temuanKritikal, temuanKritikal) || other.temuanKritikal == temuanKritikal) &&
            (identical(other.temuanMayor, temuanMayor) || other.temuanMayor == temuanMayor) &&
            (identical(other.temuanMinor, temuanMinor) || other.temuanMinor == temuanMinor) &&
            const DeepCollectionEquality().equals(other._rekomendasi, _rekomendasi) &&
            (identical(other.catatanPatrol, catatanPatrol) || other.catatanPatrol == catatanPatrol) &&
            const DeepCollectionEquality().equals(other.actionItems, actionItems) &&
            (identical(other.jumlahActionItem, jumlahActionItem) || other.jumlahActionItem == jumlahActionItem) &&
            (identical(other.actionSelesai, actionSelesai) || other.actionSelesai == actionSelesai) &&
            (identical(other.actionProgress, actionProgress) || other.actionProgress == actionProgress) &&
            (identical(other.actionBelumMulai, actionBelumMulai) || other.actionBelumMulai == actionBelumMulai) &&
            (identical(other.stopWorkIssued, stopWorkIssued) || other.stopWorkIssued == stopWorkIssued) &&
            const DeepCollectionEquality().equals(other._stopWorkArea, _stopWorkArea) &&
            (identical(other.stopWorkAlasan, stopWorkAlasan) || other.stopWorkAlasan == stopWorkAlasan) &&
            const DeepCollectionEquality().equals(other._fotoPatrol, _fotoPatrol) &&
            const DeepCollectionEquality().equals(other._dokumenPendukung, _dokumenPendukung) &&
            (identical(other.skorKeseluruhan, skorKeseluruhan) || other.skorKeseluruhan == skorKeseluruhan) &&
            (identical(other.skorApd, skorApd) || other.skorApd == skorApd) &&
            (identical(other.skorKondisiArea, skorKondisiArea) || other.skorKondisiArea == skorKondisiArea) &&
            (identical(other.skorPeralatan, skorPeralatan) || other.skorPeralatan == skorPeralatan) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tingkatUrgensi, tingkatUrgensi) || other.tingkatUrgensi == tingkatUrgensi) &&
            (identical(other.perluFollowUp, perluFollowUp) || other.perluFollowUp == perluFollowUp) &&
            (identical(other.tanggalFollowUp, tanggalFollowUp) || other.tanggalFollowUp == tanggalFollowUp) &&
            (identical(other.statusFollowUp, statusFollowUp) || other.statusFollowUp == statusFollowUp) &&
            (identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt) &&
            (identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nomorPatrol,
        tanggalPatrol,
        waktuMulai,
        waktuSelesai,
        shift,
        unitId,
        areaPatrol,
        lokasiSpesifik,
        ketuaPatrol,
        const DeepCollectionEquality().hash(_anggotaPatrol),
        jumlahAnggota,
        jenisPatrol,
        tujuanPatrol,
        const DeepCollectionEquality().hash(_fokusPatrol),
        cuaca,
        suhuArea,
        kondisiPencahayaan,
        kondisiVentilasi,
        tingkatKebisingan,
        jumlahUnsafeCondition,
        const DeepCollectionEquality().hash(unsafeCondition),
        jumlahUnsafeAct,
        const DeepCollectionEquality().hash(unsafeAct),
        pekerjaDiamati,
        pekerjaPatuhApd,
        pekerjaTidakPatuhApd,
        persentaseKepatuhanApd,
        const DeepCollectionEquality().hash(detailApd),
        skorHousekeeping,
        kondisiHousekeeping,
        const DeepCollectionEquality().hash(_areaKotor),
        const DeepCollectionEquality().hash(_areaRapi),
        jumlahMesinDiperiksa,
        mesinKondisiBaik,
        mesinPerluPerbaikan,
        const DeepCollectionEquality().hash(detailMesin),
        rambuK3Lengkap,
        const DeepCollectionEquality().hash(_rambuK3Hilang),
        const DeepCollectionEquality().hash(_rambuK3Rusak),
        labelB3Lengkap,
        jalurEvakuasiBebas,
        pintuDaruratBerfungsi,
        aparTersedia,
        aparExpire,
        emergencyLightBerfungsi,
        const DeepCollectionEquality().hash(_goodPractice),
        const DeepCollectionEquality().hash(_areaExcellent),
        const DeepCollectionEquality().hash(_pekerjaTeladan),
        totalTemuan,
        temuanKritikal,
        temuanMayor,
        temuanMinor,
        const DeepCollectionEquality().hash(_rekomendasi),
        catatanPatrol,
        const DeepCollectionEquality().hash(actionItems),
        jumlahActionItem,
        actionSelesai,
        actionProgress,
        actionBelumMulai,
        stopWorkIssued,
        const DeepCollectionEquality().hash(_stopWorkArea),
        stopWorkAlasan,
        const DeepCollectionEquality().hash(_fotoPatrol),
        const DeepCollectionEquality().hash(_dokumenPendukung),
        skorKeseluruhan,
        skorApd,
        skorKondisiArea,
        skorPeralatan,
        grade,
        status,
        tingkatUrgensi,
        perluFollowUp,
        tanggalFollowUp,
        statusFollowUp,
        reviewedBy,
        reviewedAt,
        reviewNotes,
        createdBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SafetyPatrolImplCopyWith<_$SafetyPatrolImpl> get copyWith =>
      __$$SafetyPatrolImplCopyWithImpl<_$SafetyPatrolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SafetyPatrolImplToJson(
      this,
    );
  }
}

abstract class _SafetyPatrol implements SafetyPatrol {
  const factory _SafetyPatrol(
      {final String? id,
      @JsonKey(name: 'nomor_patrol') final String nomorPatrol,
      @JsonKey(name: 'tanggal_patrol') final DateTime? tanggalPatrol,
      @JsonKey(name: 'waktu_mulai') final String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') final String? waktuSelesai,
      final String? shift,
      @JsonKey(name: 'unit_id') final String? unitId,
      @JsonKey(name: 'area_patrol') final String areaPatrol,
      @JsonKey(name: 'lokasi_spesifik') final String? lokasiSpesifik,
      @JsonKey(name: 'ketua_patrol') final String ketuaPatrol,
      @JsonKey(name: 'anggota_patrol') final List<String> anggotaPatrol,
      @JsonKey(name: 'jumlah_anggota') final int jumlahAnggota,
      @JsonKey(name: 'jenis_patrol') final String? jenisPatrol,
      @JsonKey(name: 'tujuan_patrol') final String? tujuanPatrol,
      @JsonKey(name: 'fokus_patrol') final List<String> fokusPatrol,
      final String? cuaca,
      @JsonKey(name: 'suhu_area') final double? suhuArea,
      @JsonKey(name: 'kondisi_pencahayaan') final String? kondisiPencahayaan,
      @JsonKey(name: 'kondisi_ventilasi') final String? kondisiVentilasi,
      @JsonKey(name: 'tingkat_kebisingan') final String? tingkatKebisingan,
      @JsonKey(name: 'jumlah_unsafe_condition') final int jumlahUnsafeCondition,
      @JsonKey(name: 'unsafe_condition') final dynamic unsafeCondition,
      @JsonKey(name: 'jumlah_unsafe_act') final int jumlahUnsafeAct,
      @JsonKey(name: 'unsafe_act') final dynamic unsafeAct,
      @JsonKey(name: 'pekerja_diamati') final int pekerjaDiamati,
      @JsonKey(name: 'pekerja_patuh_apd') final int pekerjaPatuhApd,
      @JsonKey(name: 'pekerja_tidak_patuh_apd') final int pekerjaTidakPatuhApd,
      @JsonKey(name: 'persentase_kepatuhan_apd')
      final double? persentaseKepatuhanApd,
      @JsonKey(name: 'detail_apd') final dynamic detailApd,
      @JsonKey(name: 'skor_housekeeping') final int? skorHousekeeping,
      @JsonKey(name: 'kondisi_housekeeping') final String? kondisiHousekeeping,
      @JsonKey(name: 'area_kotor') final List<String> areaKotor,
      @JsonKey(name: 'area_rapi') final List<String> areaRapi,
      @JsonKey(name: 'jumlah_mesin_diperiksa') final int jumlahMesinDiperiksa,
      @JsonKey(name: 'mesin_kondisi_baik') final int mesinKondisiBaik,
      @JsonKey(name: 'mesin_perlu_perbaikan') final int mesinPerluPerbaikan,
      @JsonKey(name: 'detail_mesin') final dynamic detailMesin,
      @JsonKey(name: 'rambu_k3_lengkap') final bool rambuK3Lengkap,
      @JsonKey(name: 'rambu_k3_hilang') final List<String> rambuK3Hilang,
      @JsonKey(name: 'rambu_k3_rusak') final List<String> rambuK3Rusak,
      @JsonKey(name: 'label_b3_lengkap') final bool labelB3Lengkap,
      @JsonKey(name: 'jalur_evakuasi_bebas') final bool jalurEvakuasiBebas,
      @JsonKey(name: 'pintu_darurat_berfungsi')
      final bool pintuDaruratBerfungsi,
      @JsonKey(name: 'apar_tersedia') final bool aparTersedia,
      @JsonKey(name: 'apar_expire') final int aparExpire,
      @JsonKey(name: 'emergency_light_berfungsi')
      final bool emergencyLightBerfungsi,
      @JsonKey(name: 'good_practice') final List<String> goodPractice,
      @JsonKey(name: 'area_excellent') final List<String> areaExcellent,
      @JsonKey(name: 'pekerja_teladan') final List<String> pekerjaTeladan,
      @JsonKey(name: 'total_temuan') final int totalTemuan,
      @JsonKey(name: 'temuan_kritikal') final int temuanKritikal,
      @JsonKey(name: 'temuan_mayor') final int temuanMayor,
      @JsonKey(name: 'temuan_minor') final int temuanMinor,
      final List<String> rekomendasi,
      @JsonKey(name: 'catatan_patrol') final String? catatanPatrol,
      @JsonKey(name: 'action_items') final dynamic actionItems,
      @JsonKey(name: 'jumlah_action_item') final int jumlahActionItem,
      @JsonKey(name: 'action_selesai') final int actionSelesai,
      @JsonKey(name: 'action_progress') final int actionProgress,
      @JsonKey(name: 'action_belum_mulai') final int actionBelumMulai,
      @JsonKey(name: 'stop_work_issued') final bool stopWorkIssued,
      @JsonKey(name: 'stop_work_area') final List<String> stopWorkArea,
      @JsonKey(name: 'stop_work_alasan') final String? stopWorkAlasan,
      @JsonKey(name: 'foto_patrol') final List<String> fotoPatrol,
      @JsonKey(name: 'dokumen_pendukung') final List<String> dokumenPendukung,
      @JsonKey(name: 'skor_keseluruhan') final double? skorKeseluruhan,
      @JsonKey(name: 'skor_apd') final double? skorApd,
      @JsonKey(name: 'skor_kondisi_area') final double? skorKondisiArea,
      @JsonKey(name: 'skor_peralatan') final double? skorPeralatan,
      final String? grade,
      final String status,
      @JsonKey(name: 'tingkat_urgensi') final String tingkatUrgensi,
      @JsonKey(name: 'perlu_follow_up') final bool perluFollowUp,
      @JsonKey(name: 'tanggal_follow_up') final DateTime? tanggalFollowUp,
      @JsonKey(name: 'status_follow_up') final String? statusFollowUp,
      @JsonKey(name: 'reviewed_by') final String? reviewedBy,
      @JsonKey(name: 'reviewed_at') final DateTime? reviewedAt,
      @JsonKey(name: 'review_notes') final String? reviewNotes,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$SafetyPatrolImpl;

  factory _SafetyPatrol.fromJson(Map<String, dynamic> json) =
      _$SafetyPatrolImpl.fromJson;

  @override
  String? get id;
  @override // Basic information
  @JsonKey(name: 'nomor_patrol')
  String get nomorPatrol;
  @override
  @JsonKey(name: 'tanggal_patrol')
  DateTime? get tanggalPatrol;
  @override
  @JsonKey(name: 'waktu_mulai')
  String? get waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai;
  @override // Shift and unit
  String? get shift;
  @override // pagi, siang, malam
  @JsonKey(name: 'unit_id')
  String? get unitId;
  @override
  @JsonKey(name: 'area_patrol')
  String get areaPatrol;
  @override
  @JsonKey(name: 'lokasi_spesifik')
  String? get lokasiSpesifik;
  @override // Team information
  @JsonKey(name: 'ketua_patrol')
  String get ketuaPatrol;
  @override
  @JsonKey(name: 'anggota_patrol')
  List<String> get anggotaPatrol;
  @override
  @JsonKey(name: 'jumlah_anggota')
  int get jumlahAnggota;
  @override // Patrol details
  @JsonKey(name: 'jenis_patrol')
  String? get jenisPatrol;
  @override // rutin, terjadwal, insidental, khusus, malam, emergency
  @JsonKey(name: 'tujuan_patrol')
  String? get tujuanPatrol;
  @override
  @JsonKey(name: 'fokus_patrol')
  List<String> get fokusPatrol;
  @override // Environmental conditions
  String? get cuaca;
  @override // cerah, mendung, hujan, panas
  @JsonKey(name: 'suhu_area')
  double? get suhuArea;
  @override
  @JsonKey(name: 'kondisi_pencahayaan')
  String? get kondisiPencahayaan;
  @override // baik, cukup, kurang, buruk
  @JsonKey(name: 'kondisi_ventilasi')
  String? get kondisiVentilasi;
  @override // baik, cukup, kurang, buruk
  @JsonKey(name: 'tingkat_kebisingan')
  String? get tingkatKebisingan;
  @override // normal, cukup_bising, bising, sangat_bising
// Unsafe conditions and acts
  @JsonKey(name: 'jumlah_unsafe_condition')
  int get jumlahUnsafeCondition;
  @override
  @JsonKey(name: 'unsafe_condition')
  dynamic get unsafeCondition;
  @override // JSONB array of objects
  @JsonKey(name: 'jumlah_unsafe_act')
  int get jumlahUnsafeAct;
  @override
  @JsonKey(name: 'unsafe_act')
  dynamic get unsafeAct;
  @override // JSONB array of objects
// Worker observations
  @JsonKey(name: 'pekerja_diamati')
  int get pekerjaDiamati;
  @override
  @JsonKey(name: 'pekerja_patuh_apd')
  int get pekerjaPatuhApd;
  @override
  @JsonKey(name: 'pekerja_tidak_patuh_apd')
  int get pekerjaTidakPatuhApd;
  @override
  @JsonKey(name: 'persentase_kepatuhan_apd')
  double? get persentaseKepatuhanApd;
  @override
  @JsonKey(name: 'detail_apd')
  dynamic get detailApd;
  @override // JSONB array of objects
// Housekeeping
  @JsonKey(name: 'skor_housekeeping')
  int? get skorHousekeeping;
  @override
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping;
  @override // sangat_baik, baik, cukup, kurang, buruk
  @JsonKey(name: 'area_kotor')
  List<String> get areaKotor;
  @override
  @JsonKey(name: 'area_rapi')
  List<String> get areaRapi;
  @override // Equipment checks
  @JsonKey(name: 'jumlah_mesin_diperiksa')
  int get jumlahMesinDiperiksa;
  @override
  @JsonKey(name: 'mesin_kondisi_baik')
  int get mesinKondisiBaik;
  @override
  @JsonKey(name: 'mesin_perlu_perbaikan')
  int get mesinPerluPerbaikan;
  @override
  @JsonKey(name: 'detail_mesin')
  dynamic get detailMesin;
  @override // JSONB array of objects
// Safety equipment checks
  @JsonKey(name: 'rambu_k3_lengkap')
  bool get rambuK3Lengkap;
  @override
  @JsonKey(name: 'rambu_k3_hilang')
  List<String> get rambuK3Hilang;
  @override
  @JsonKey(name: 'rambu_k3_rusak')
  List<String> get rambuK3Rusak;
  @override
  @JsonKey(name: 'label_b3_lengkap')
  bool get labelB3Lengkap;
  @override
  @JsonKey(name: 'jalur_evakuasi_bebas')
  bool get jalurEvakuasiBebas;
  @override
  @JsonKey(name: 'pintu_darurat_berfungsi')
  bool get pintuDaruratBerfungsi;
  @override
  @JsonKey(name: 'apar_tersedia')
  bool get aparTersedia;
  @override
  @JsonKey(name: 'apar_expire')
  int get aparExpire;
  @override
  @JsonKey(name: 'emergency_light_berfungsi')
  bool get emergencyLightBerfungsi;
  @override // Positive observations
  @JsonKey(name: 'good_practice')
  List<String> get goodPractice;
  @override
  @JsonKey(name: 'area_excellent')
  List<String> get areaExcellent;
  @override
  @JsonKey(name: 'pekerja_teladan')
  List<String> get pekerjaTeladan;
  @override // Findings and recommendations
  @JsonKey(name: 'total_temuan')
  int get totalTemuan;
  @override
  @JsonKey(name: 'temuan_kritikal')
  int get temuanKritikal;
  @override
  @JsonKey(name: 'temuan_mayor')
  int get temuanMayor;
  @override
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor;
  @override
  List<String> get rekomendasi;
  @override
  @JsonKey(name: 'catatan_patrol')
  String? get catatanPatrol;
  @override // Action items
  @JsonKey(name: 'action_items')
  dynamic get actionItems;
  @override // JSONB array of objects
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
  @override // Stop work orders
  @JsonKey(name: 'stop_work_issued')
  bool get stopWorkIssued;
  @override
  @JsonKey(name: 'stop_work_area')
  List<String> get stopWorkArea;
  @override
  @JsonKey(name: 'stop_work_alasan')
  String? get stopWorkAlasan;
  @override // Documentation
  @JsonKey(name: 'foto_patrol')
  List<String> get fotoPatrol;
  @override
  @JsonKey(name: 'dokumen_pendukung')
  List<String> get dokumenPendukung;
  @override // Scoring
  @JsonKey(name: 'skor_keseluruhan')
  double? get skorKeseluruhan;
  @override
  @JsonKey(name: 'skor_apd')
  double? get skorApd;
  @override
  @JsonKey(name: 'skor_kondisi_area')
  double? get skorKondisiArea;
  @override
  @JsonKey(name: 'skor_peralatan')
  double? get skorPeralatan;
  @override
  String? get grade;
  @override // A, B, C, D, E
// Status and approval
  String get status;
  @override // draft, submitted, reviewed, closed, cancelled
  @JsonKey(name: 'tingkat_urgensi')
  String get tingkatUrgensi;
  @override // rendah, normal, tinggi, kritis
// Follow up
  @JsonKey(name: 'perlu_follow_up')
  bool get perluFollowUp;
  @override
  @JsonKey(name: 'tanggal_follow_up')
  DateTime? get tanggalFollowUp;
  @override
  @JsonKey(name: 'status_follow_up')
  String? get statusFollowUp;
  @override // belum, dijadwalkan, selesai
// Review information
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy;
  @override
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt;
  @override
  @JsonKey(name: 'review_notes')
  String? get reviewNotes;
  @override // Audit fields
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SafetyPatrolImplCopyWith<_$SafetyPatrolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
