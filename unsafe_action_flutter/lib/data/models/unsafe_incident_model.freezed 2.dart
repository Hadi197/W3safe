// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unsafe_incident_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnsafeIncidentModel _$UnsafeIncidentModelFromJson(Map<String, dynamic> json) {
  return _UnsafeIncidentModel.fromJson(json);
}

/// @nodoc
mixin _$UnsafeIncidentModel {
  String get id => throw _privateConstructorUsedError;
  DateTime get tanggalKejadian => throw _privateConstructorUsedError;
  String get waktuKejadian => throw _privateConstructorUsedError;
  String get lokasiKejadian => throw _privateConstructorUsedError;
  String get unitKerja =>
      throw _privateConstructorUsedError; // Keep for backward compatibility
  String? get unitId =>
      throw _privateConstructorUsedError; // New field for FK to units table
  String get jenisKejadian => throw _privateConstructorUsedError;
  String get kategori => throw _privateConstructorUsedError;
  String? get subKategori => throw _privateConstructorUsedError;
  String get deskripsiKejadian => throw _privateConstructorUsedError;
  String? get penyebabDiduga => throw _privateConstructorUsedError;
  String? get potensiRisiko => throw _privateConstructorUsedError;
  String get pelaporNama => throw _privateConstructorUsedError;
  String? get pelaporJabatan => throw _privateConstructorUsedError;
  String? get pelaporKontak => throw _privateConstructorUsedError;
  String? get tindakanSegera => throw _privateConstructorUsedError;
  bool get areaDiamankan => throw _privateConstructorUsedError;
  bool get korbanAda => throw _privateConstructorUsedError;
  int get korbanJumlah => throw _privateConstructorUsedError;
  List<String> get fotoKejadian => throw _privateConstructorUsedError;
  List<String> get videoKejadian => throw _privateConstructorUsedError;
  String? get audioCatatan => throw _privateConstructorUsedError;
  String get prioritas => throw _privateConstructorUsedError;
  int? get severityLevel => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get gpsAccuracy => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get assignedBy => throw _privateConstructorUsedError;
  DateTime? get assignedAt => throw _privateConstructorUsedError;
  bool get investigasiDilakukan => throw _privateConstructorUsedError;
  String? get temuanInvestigasi => throw _privateConstructorUsedError;
  List<String> get rekomendasiKoreksi => throw _privateConstructorUsedError;
  DateTime? get targetPenyelesaian => throw _privateConstructorUsedError;
  DateTime? get aktualPenyelesaian => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnsafeIncidentModelCopyWith<UnsafeIncidentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnsafeIncidentModelCopyWith<$Res> {
  factory $UnsafeIncidentModelCopyWith(
          UnsafeIncidentModel value, $Res Function(UnsafeIncidentModel) then) =
      _$UnsafeIncidentModelCopyWithImpl<$Res, UnsafeIncidentModel>;
  @useResult
  $Res call(
      {String id,
      DateTime tanggalKejadian,
      String waktuKejadian,
      String lokasiKejadian,
      String unitKerja,
      String? unitId,
      String jenisKejadian,
      String kategori,
      String? subKategori,
      String deskripsiKejadian,
      String? penyebabDiduga,
      String? potensiRisiko,
      String pelaporNama,
      String? pelaporJabatan,
      String? pelaporKontak,
      String? tindakanSegera,
      bool areaDiamankan,
      bool korbanAda,
      int korbanJumlah,
      List<String> fotoKejadian,
      List<String> videoKejadian,
      String? audioCatatan,
      String prioritas,
      int? severityLevel,
      double? latitude,
      double? longitude,
      double? gpsAccuracy,
      String status,
      String? assignedTo,
      String? assignedBy,
      DateTime? assignedAt,
      bool investigasiDilakukan,
      String? temuanInvestigasi,
      List<String> rekomendasiKoreksi,
      DateTime? targetPenyelesaian,
      DateTime? aktualPenyelesaian,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UnsafeIncidentModelCopyWithImpl<$Res, $Val extends UnsafeIncidentModel>
    implements $UnsafeIncidentModelCopyWith<$Res> {
  _$UnsafeIncidentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tanggalKejadian = null,
    Object? waktuKejadian = null,
    Object? lokasiKejadian = null,
    Object? unitKerja = null,
    Object? unitId = freezed,
    Object? jenisKejadian = null,
    Object? kategori = null,
    Object? subKategori = freezed,
    Object? deskripsiKejadian = null,
    Object? penyebabDiduga = freezed,
    Object? potensiRisiko = freezed,
    Object? pelaporNama = null,
    Object? pelaporJabatan = freezed,
    Object? pelaporKontak = freezed,
    Object? tindakanSegera = freezed,
    Object? areaDiamankan = null,
    Object? korbanAda = null,
    Object? korbanJumlah = null,
    Object? fotoKejadian = null,
    Object? videoKejadian = null,
    Object? audioCatatan = freezed,
    Object? prioritas = null,
    Object? severityLevel = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? gpsAccuracy = freezed,
    Object? status = null,
    Object? assignedTo = freezed,
    Object? assignedBy = freezed,
    Object? assignedAt = freezed,
    Object? investigasiDilakukan = null,
    Object? temuanInvestigasi = freezed,
    Object? rekomendasiKoreksi = null,
    Object? targetPenyelesaian = freezed,
    Object? aktualPenyelesaian = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalKejadian: null == tanggalKejadian
          ? _value.tanggalKejadian
          : tanggalKejadian // ignore: cast_nullable_to_non_nullable
              as DateTime,
      waktuKejadian: null == waktuKejadian
          ? _value.waktuKejadian
          : waktuKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      lokasiKejadian: null == lokasiKejadian
          ? _value.lokasiKejadian
          : lokasiKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      unitKerja: null == unitKerja
          ? _value.unitKerja
          : unitKerja // ignore: cast_nullable_to_non_nullable
              as String,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisKejadian: null == jenisKejadian
          ? _value.jenisKejadian
          : jenisKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      kategori: null == kategori
          ? _value.kategori
          : kategori // ignore: cast_nullable_to_non_nullable
              as String,
      subKategori: freezed == subKategori
          ? _value.subKategori
          : subKategori // ignore: cast_nullable_to_non_nullable
              as String?,
      deskripsiKejadian: null == deskripsiKejadian
          ? _value.deskripsiKejadian
          : deskripsiKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      penyebabDiduga: freezed == penyebabDiduga
          ? _value.penyebabDiduga
          : penyebabDiduga // ignore: cast_nullable_to_non_nullable
              as String?,
      potensiRisiko: freezed == potensiRisiko
          ? _value.potensiRisiko
          : potensiRisiko // ignore: cast_nullable_to_non_nullable
              as String?,
      pelaporNama: null == pelaporNama
          ? _value.pelaporNama
          : pelaporNama // ignore: cast_nullable_to_non_nullable
              as String,
      pelaporJabatan: freezed == pelaporJabatan
          ? _value.pelaporJabatan
          : pelaporJabatan // ignore: cast_nullable_to_non_nullable
              as String?,
      pelaporKontak: freezed == pelaporKontak
          ? _value.pelaporKontak
          : pelaporKontak // ignore: cast_nullable_to_non_nullable
              as String?,
      tindakanSegera: freezed == tindakanSegera
          ? _value.tindakanSegera
          : tindakanSegera // ignore: cast_nullable_to_non_nullable
              as String?,
      areaDiamankan: null == areaDiamankan
          ? _value.areaDiamankan
          : areaDiamankan // ignore: cast_nullable_to_non_nullable
              as bool,
      korbanAda: null == korbanAda
          ? _value.korbanAda
          : korbanAda // ignore: cast_nullable_to_non_nullable
              as bool,
      korbanJumlah: null == korbanJumlah
          ? _value.korbanJumlah
          : korbanJumlah // ignore: cast_nullable_to_non_nullable
              as int,
      fotoKejadian: null == fotoKejadian
          ? _value.fotoKejadian
          : fotoKejadian // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoKejadian: null == videoKejadian
          ? _value.videoKejadian
          : videoKejadian // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioCatatan: freezed == audioCatatan
          ? _value.audioCatatan
          : audioCatatan // ignore: cast_nullable_to_non_nullable
              as String?,
      prioritas: null == prioritas
          ? _value.prioritas
          : prioritas // ignore: cast_nullable_to_non_nullable
              as String,
      severityLevel: freezed == severityLevel
          ? _value.severityLevel
          : severityLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsAccuracy: freezed == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedBy: freezed == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      investigasiDilakukan: null == investigasiDilakukan
          ? _value.investigasiDilakukan
          : investigasiDilakukan // ignore: cast_nullable_to_non_nullable
              as bool,
      temuanInvestigasi: freezed == temuanInvestigasi
          ? _value.temuanInvestigasi
          : temuanInvestigasi // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasiKoreksi: null == rekomendasiKoreksi
          ? _value.rekomendasiKoreksi
          : rekomendasiKoreksi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetPenyelesaian: freezed == targetPenyelesaian
          ? _value.targetPenyelesaian
          : targetPenyelesaian // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      aktualPenyelesaian: freezed == aktualPenyelesaian
          ? _value.aktualPenyelesaian
          : aktualPenyelesaian // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$UnsafeIncidentModelImplCopyWith<$Res>
    implements $UnsafeIncidentModelCopyWith<$Res> {
  factory _$$UnsafeIncidentModelImplCopyWith(_$UnsafeIncidentModelImpl value,
          $Res Function(_$UnsafeIncidentModelImpl) then) =
      __$$UnsafeIncidentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime tanggalKejadian,
      String waktuKejadian,
      String lokasiKejadian,
      String unitKerja,
      String? unitId,
      String jenisKejadian,
      String kategori,
      String? subKategori,
      String deskripsiKejadian,
      String? penyebabDiduga,
      String? potensiRisiko,
      String pelaporNama,
      String? pelaporJabatan,
      String? pelaporKontak,
      String? tindakanSegera,
      bool areaDiamankan,
      bool korbanAda,
      int korbanJumlah,
      List<String> fotoKejadian,
      List<String> videoKejadian,
      String? audioCatatan,
      String prioritas,
      int? severityLevel,
      double? latitude,
      double? longitude,
      double? gpsAccuracy,
      String status,
      String? assignedTo,
      String? assignedBy,
      DateTime? assignedAt,
      bool investigasiDilakukan,
      String? temuanInvestigasi,
      List<String> rekomendasiKoreksi,
      DateTime? targetPenyelesaian,
      DateTime? aktualPenyelesaian,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UnsafeIncidentModelImplCopyWithImpl<$Res>
    extends _$UnsafeIncidentModelCopyWithImpl<$Res, _$UnsafeIncidentModelImpl>
    implements _$$UnsafeIncidentModelImplCopyWith<$Res> {
  __$$UnsafeIncidentModelImplCopyWithImpl(_$UnsafeIncidentModelImpl _value,
      $Res Function(_$UnsafeIncidentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tanggalKejadian = null,
    Object? waktuKejadian = null,
    Object? lokasiKejadian = null,
    Object? unitKerja = null,
    Object? unitId = freezed,
    Object? jenisKejadian = null,
    Object? kategori = null,
    Object? subKategori = freezed,
    Object? deskripsiKejadian = null,
    Object? penyebabDiduga = freezed,
    Object? potensiRisiko = freezed,
    Object? pelaporNama = null,
    Object? pelaporJabatan = freezed,
    Object? pelaporKontak = freezed,
    Object? tindakanSegera = freezed,
    Object? areaDiamankan = null,
    Object? korbanAda = null,
    Object? korbanJumlah = null,
    Object? fotoKejadian = null,
    Object? videoKejadian = null,
    Object? audioCatatan = freezed,
    Object? prioritas = null,
    Object? severityLevel = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? gpsAccuracy = freezed,
    Object? status = null,
    Object? assignedTo = freezed,
    Object? assignedBy = freezed,
    Object? assignedAt = freezed,
    Object? investigasiDilakukan = null,
    Object? temuanInvestigasi = freezed,
    Object? rekomendasiKoreksi = null,
    Object? targetPenyelesaian = freezed,
    Object? aktualPenyelesaian = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UnsafeIncidentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tanggalKejadian: null == tanggalKejadian
          ? _value.tanggalKejadian
          : tanggalKejadian // ignore: cast_nullable_to_non_nullable
              as DateTime,
      waktuKejadian: null == waktuKejadian
          ? _value.waktuKejadian
          : waktuKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      lokasiKejadian: null == lokasiKejadian
          ? _value.lokasiKejadian
          : lokasiKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      unitKerja: null == unitKerja
          ? _value.unitKerja
          : unitKerja // ignore: cast_nullable_to_non_nullable
              as String,
      unitId: freezed == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisKejadian: null == jenisKejadian
          ? _value.jenisKejadian
          : jenisKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      kategori: null == kategori
          ? _value.kategori
          : kategori // ignore: cast_nullable_to_non_nullable
              as String,
      subKategori: freezed == subKategori
          ? _value.subKategori
          : subKategori // ignore: cast_nullable_to_non_nullable
              as String?,
      deskripsiKejadian: null == deskripsiKejadian
          ? _value.deskripsiKejadian
          : deskripsiKejadian // ignore: cast_nullable_to_non_nullable
              as String,
      penyebabDiduga: freezed == penyebabDiduga
          ? _value.penyebabDiduga
          : penyebabDiduga // ignore: cast_nullable_to_non_nullable
              as String?,
      potensiRisiko: freezed == potensiRisiko
          ? _value.potensiRisiko
          : potensiRisiko // ignore: cast_nullable_to_non_nullable
              as String?,
      pelaporNama: null == pelaporNama
          ? _value.pelaporNama
          : pelaporNama // ignore: cast_nullable_to_non_nullable
              as String,
      pelaporJabatan: freezed == pelaporJabatan
          ? _value.pelaporJabatan
          : pelaporJabatan // ignore: cast_nullable_to_non_nullable
              as String?,
      pelaporKontak: freezed == pelaporKontak
          ? _value.pelaporKontak
          : pelaporKontak // ignore: cast_nullable_to_non_nullable
              as String?,
      tindakanSegera: freezed == tindakanSegera
          ? _value.tindakanSegera
          : tindakanSegera // ignore: cast_nullable_to_non_nullable
              as String?,
      areaDiamankan: null == areaDiamankan
          ? _value.areaDiamankan
          : areaDiamankan // ignore: cast_nullable_to_non_nullable
              as bool,
      korbanAda: null == korbanAda
          ? _value.korbanAda
          : korbanAda // ignore: cast_nullable_to_non_nullable
              as bool,
      korbanJumlah: null == korbanJumlah
          ? _value.korbanJumlah
          : korbanJumlah // ignore: cast_nullable_to_non_nullable
              as int,
      fotoKejadian: null == fotoKejadian
          ? _value._fotoKejadian
          : fotoKejadian // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoKejadian: null == videoKejadian
          ? _value._videoKejadian
          : videoKejadian // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioCatatan: freezed == audioCatatan
          ? _value.audioCatatan
          : audioCatatan // ignore: cast_nullable_to_non_nullable
              as String?,
      prioritas: null == prioritas
          ? _value.prioritas
          : prioritas // ignore: cast_nullable_to_non_nullable
              as String,
      severityLevel: freezed == severityLevel
          ? _value.severityLevel
          : severityLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsAccuracy: freezed == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedBy: freezed == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      investigasiDilakukan: null == investigasiDilakukan
          ? _value.investigasiDilakukan
          : investigasiDilakukan // ignore: cast_nullable_to_non_nullable
              as bool,
      temuanInvestigasi: freezed == temuanInvestigasi
          ? _value.temuanInvestigasi
          : temuanInvestigasi // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasiKoreksi: null == rekomendasiKoreksi
          ? _value._rekomendasiKoreksi
          : rekomendasiKoreksi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetPenyelesaian: freezed == targetPenyelesaian
          ? _value.targetPenyelesaian
          : targetPenyelesaian // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      aktualPenyelesaian: freezed == aktualPenyelesaian
          ? _value.aktualPenyelesaian
          : aktualPenyelesaian // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$UnsafeIncidentModelImpl implements _UnsafeIncidentModel {
  const _$UnsafeIncidentModelImpl(
      {required this.id,
      required this.tanggalKejadian,
      required this.waktuKejadian,
      required this.lokasiKejadian,
      required this.unitKerja,
      this.unitId,
      required this.jenisKejadian,
      required this.kategori,
      this.subKategori,
      required this.deskripsiKejadian,
      this.penyebabDiduga,
      this.potensiRisiko,
      required this.pelaporNama,
      this.pelaporJabatan,
      this.pelaporKontak,
      this.tindakanSegera,
      this.areaDiamankan = false,
      this.korbanAda = false,
      this.korbanJumlah = 0,
      final List<String> fotoKejadian = const [],
      final List<String> videoKejadian = const [],
      this.audioCatatan,
      this.prioritas = 'medium',
      this.severityLevel,
      this.latitude,
      this.longitude,
      this.gpsAccuracy,
      this.status = 'draft',
      this.assignedTo,
      this.assignedBy,
      this.assignedAt,
      this.investigasiDilakukan = false,
      this.temuanInvestigasi,
      final List<String> rekomendasiKoreksi = const [],
      this.targetPenyelesaian,
      this.aktualPenyelesaian,
      this.createdBy,
      this.createdAt,
      this.updatedAt})
      : _fotoKejadian = fotoKejadian,
        _videoKejadian = videoKejadian,
        _rekomendasiKoreksi = rekomendasiKoreksi;

  factory _$UnsafeIncidentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnsafeIncidentModelImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime tanggalKejadian;
  @override
  final String waktuKejadian;
  @override
  final String lokasiKejadian;
  @override
  final String unitKerja;
// Keep for backward compatibility
  @override
  final String? unitId;
// New field for FK to units table
  @override
  final String jenisKejadian;
  @override
  final String kategori;
  @override
  final String? subKategori;
  @override
  final String deskripsiKejadian;
  @override
  final String? penyebabDiduga;
  @override
  final String? potensiRisiko;
  @override
  final String pelaporNama;
  @override
  final String? pelaporJabatan;
  @override
  final String? pelaporKontak;
  @override
  final String? tindakanSegera;
  @override
  @JsonKey()
  final bool areaDiamankan;
  @override
  @JsonKey()
  final bool korbanAda;
  @override
  @JsonKey()
  final int korbanJumlah;
  final List<String> _fotoKejadian;
  @override
  @JsonKey()
  List<String> get fotoKejadian {
    if (_fotoKejadian is EqualUnmodifiableListView) return _fotoKejadian;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoKejadian);
  }

  final List<String> _videoKejadian;
  @override
  @JsonKey()
  List<String> get videoKejadian {
    if (_videoKejadian is EqualUnmodifiableListView) return _videoKejadian;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoKejadian);
  }

  @override
  final String? audioCatatan;
  @override
  @JsonKey()
  final String prioritas;
  @override
  final int? severityLevel;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? gpsAccuracy;
  @override
  @JsonKey()
  final String status;
  @override
  final String? assignedTo;
  @override
  final String? assignedBy;
  @override
  final DateTime? assignedAt;
  @override
  @JsonKey()
  final bool investigasiDilakukan;
  @override
  final String? temuanInvestigasi;
  final List<String> _rekomendasiKoreksi;
  @override
  @JsonKey()
  List<String> get rekomendasiKoreksi {
    if (_rekomendasiKoreksi is EqualUnmodifiableListView)
      return _rekomendasiKoreksi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rekomendasiKoreksi);
  }

  @override
  final DateTime? targetPenyelesaian;
  @override
  final DateTime? aktualPenyelesaian;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UnsafeIncidentModel(id: $id, tanggalKejadian: $tanggalKejadian, waktuKejadian: $waktuKejadian, lokasiKejadian: $lokasiKejadian, unitKerja: $unitKerja, unitId: $unitId, jenisKejadian: $jenisKejadian, kategori: $kategori, subKategori: $subKategori, deskripsiKejadian: $deskripsiKejadian, penyebabDiduga: $penyebabDiduga, potensiRisiko: $potensiRisiko, pelaporNama: $pelaporNama, pelaporJabatan: $pelaporJabatan, pelaporKontak: $pelaporKontak, tindakanSegera: $tindakanSegera, areaDiamankan: $areaDiamankan, korbanAda: $korbanAda, korbanJumlah: $korbanJumlah, fotoKejadian: $fotoKejadian, videoKejadian: $videoKejadian, audioCatatan: $audioCatatan, prioritas: $prioritas, severityLevel: $severityLevel, latitude: $latitude, longitude: $longitude, gpsAccuracy: $gpsAccuracy, status: $status, assignedTo: $assignedTo, assignedBy: $assignedBy, assignedAt: $assignedAt, investigasiDilakukan: $investigasiDilakukan, temuanInvestigasi: $temuanInvestigasi, rekomendasiKoreksi: $rekomendasiKoreksi, targetPenyelesaian: $targetPenyelesaian, aktualPenyelesaian: $aktualPenyelesaian, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnsafeIncidentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tanggalKejadian, tanggalKejadian) ||
                other.tanggalKejadian == tanggalKejadian) &&
            (identical(other.waktuKejadian, waktuKejadian) ||
                other.waktuKejadian == waktuKejadian) &&
            (identical(other.lokasiKejadian, lokasiKejadian) ||
                other.lokasiKejadian == lokasiKejadian) &&
            (identical(other.unitKerja, unitKerja) ||
                other.unitKerja == unitKerja) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.jenisKejadian, jenisKejadian) ||
                other.jenisKejadian == jenisKejadian) &&
            (identical(other.kategori, kategori) ||
                other.kategori == kategori) &&
            (identical(other.subKategori, subKategori) ||
                other.subKategori == subKategori) &&
            (identical(other.deskripsiKejadian, deskripsiKejadian) ||
                other.deskripsiKejadian == deskripsiKejadian) &&
            (identical(other.penyebabDiduga, penyebabDiduga) ||
                other.penyebabDiduga == penyebabDiduga) &&
            (identical(other.potensiRisiko, potensiRisiko) ||
                other.potensiRisiko == potensiRisiko) &&
            (identical(other.pelaporNama, pelaporNama) ||
                other.pelaporNama == pelaporNama) &&
            (identical(other.pelaporJabatan, pelaporJabatan) ||
                other.pelaporJabatan == pelaporJabatan) &&
            (identical(other.pelaporKontak, pelaporKontak) ||
                other.pelaporKontak == pelaporKontak) &&
            (identical(other.tindakanSegera, tindakanSegera) ||
                other.tindakanSegera == tindakanSegera) &&
            (identical(other.areaDiamankan, areaDiamankan) ||
                other.areaDiamankan == areaDiamankan) &&
            (identical(other.korbanAda, korbanAda) ||
                other.korbanAda == korbanAda) &&
            (identical(other.korbanJumlah, korbanJumlah) ||
                other.korbanJumlah == korbanJumlah) &&
            const DeepCollectionEquality()
                .equals(other._fotoKejadian, _fotoKejadian) &&
            const DeepCollectionEquality()
                .equals(other._videoKejadian, _videoKejadian) &&
            (identical(other.audioCatatan, audioCatatan) ||
                other.audioCatatan == audioCatatan) &&
            (identical(other.prioritas, prioritas) ||
                other.prioritas == prioritas) &&
            (identical(other.severityLevel, severityLevel) ||
                other.severityLevel == severityLevel) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.gpsAccuracy, gpsAccuracy) ||
                other.gpsAccuracy == gpsAccuracy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.investigasiDilakukan, investigasiDilakukan) ||
                other.investigasiDilakukan == investigasiDilakukan) &&
            (identical(other.temuanInvestigasi, temuanInvestigasi) ||
                other.temuanInvestigasi == temuanInvestigasi) &&
            const DeepCollectionEquality()
                .equals(other._rekomendasiKoreksi, _rekomendasiKoreksi) &&
            (identical(other.targetPenyelesaian, targetPenyelesaian) ||
                other.targetPenyelesaian == targetPenyelesaian) &&
            (identical(other.aktualPenyelesaian, aktualPenyelesaian) ||
                other.aktualPenyelesaian == aktualPenyelesaian) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        tanggalKejadian,
        waktuKejadian,
        lokasiKejadian,
        unitKerja,
        unitId,
        jenisKejadian,
        kategori,
        subKategori,
        deskripsiKejadian,
        penyebabDiduga,
        potensiRisiko,
        pelaporNama,
        pelaporJabatan,
        pelaporKontak,
        tindakanSegera,
        areaDiamankan,
        korbanAda,
        korbanJumlah,
        const DeepCollectionEquality().hash(_fotoKejadian),
        const DeepCollectionEquality().hash(_videoKejadian),
        audioCatatan,
        prioritas,
        severityLevel,
        latitude,
        longitude,
        gpsAccuracy,
        status,
        assignedTo,
        assignedBy,
        assignedAt,
        investigasiDilakukan,
        temuanInvestigasi,
        const DeepCollectionEquality().hash(_rekomendasiKoreksi),
        targetPenyelesaian,
        aktualPenyelesaian,
        createdBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnsafeIncidentModelImplCopyWith<_$UnsafeIncidentModelImpl> get copyWith =>
      __$$UnsafeIncidentModelImplCopyWithImpl<_$UnsafeIncidentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnsafeIncidentModelImplToJson(
      this,
    );
  }
}

abstract class _UnsafeIncidentModel implements UnsafeIncidentModel {
  const factory _UnsafeIncidentModel(
      {required final String id,
      required final DateTime tanggalKejadian,
      required final String waktuKejadian,
      required final String lokasiKejadian,
      required final String unitKerja,
      final String? unitId,
      required final String jenisKejadian,
      required final String kategori,
      final String? subKategori,
      required final String deskripsiKejadian,
      final String? penyebabDiduga,
      final String? potensiRisiko,
      required final String pelaporNama,
      final String? pelaporJabatan,
      final String? pelaporKontak,
      final String? tindakanSegera,
      final bool areaDiamankan,
      final bool korbanAda,
      final int korbanJumlah,
      final List<String> fotoKejadian,
      final List<String> videoKejadian,
      final String? audioCatatan,
      final String prioritas,
      final int? severityLevel,
      final double? latitude,
      final double? longitude,
      final double? gpsAccuracy,
      final String status,
      final String? assignedTo,
      final String? assignedBy,
      final DateTime? assignedAt,
      final bool investigasiDilakukan,
      final String? temuanInvestigasi,
      final List<String> rekomendasiKoreksi,
      final DateTime? targetPenyelesaian,
      final DateTime? aktualPenyelesaian,
      final String? createdBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UnsafeIncidentModelImpl;

  factory _UnsafeIncidentModel.fromJson(Map<String, dynamic> json) =
      _$UnsafeIncidentModelImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get tanggalKejadian;
  @override
  String get waktuKejadian;
  @override
  String get lokasiKejadian;
  @override
  String get unitKerja;
  @override // Keep for backward compatibility
  String? get unitId;
  @override // New field for FK to units table
  String get jenisKejadian;
  @override
  String get kategori;
  @override
  String? get subKategori;
  @override
  String get deskripsiKejadian;
  @override
  String? get penyebabDiduga;
  @override
  String? get potensiRisiko;
  @override
  String get pelaporNama;
  @override
  String? get pelaporJabatan;
  @override
  String? get pelaporKontak;
  @override
  String? get tindakanSegera;
  @override
  bool get areaDiamankan;
  @override
  bool get korbanAda;
  @override
  int get korbanJumlah;
  @override
  List<String> get fotoKejadian;
  @override
  List<String> get videoKejadian;
  @override
  String? get audioCatatan;
  @override
  String get prioritas;
  @override
  int? get severityLevel;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get gpsAccuracy;
  @override
  String get status;
  @override
  String? get assignedTo;
  @override
  String? get assignedBy;
  @override
  DateTime? get assignedAt;
  @override
  bool get investigasiDilakukan;
  @override
  String? get temuanInvestigasi;
  @override
  List<String> get rekomendasiKoreksi;
  @override
  DateTime? get targetPenyelesaian;
  @override
  DateTime? get aktualPenyelesaian;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UnsafeIncidentModelImplCopyWith<_$UnsafeIncidentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncidentStatsModel _$IncidentStatsModelFromJson(Map<String, dynamic> json) {
  return _IncidentStatsModel.fromJson(json);
}

/// @nodoc
mixin _$IncidentStatsModel {
  int get totalIncidents => throw _privateConstructorUsedError;
  int get unsafeActionCount => throw _privateConstructorUsedError;
  int get unsafeConditionCount => throw _privateConstructorUsedError;
  int get recentIncidents => throw _privateConstructorUsedError;
  Map<String, int> get byPriority => throw _privateConstructorUsedError;
  Map<String, int> get byStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncidentStatsModelCopyWith<IncidentStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncidentStatsModelCopyWith<$Res> {
  factory $IncidentStatsModelCopyWith(
          IncidentStatsModel value, $Res Function(IncidentStatsModel) then) =
      _$IncidentStatsModelCopyWithImpl<$Res, IncidentStatsModel>;
  @useResult
  $Res call(
      {int totalIncidents,
      int unsafeActionCount,
      int unsafeConditionCount,
      int recentIncidents,
      Map<String, int> byPriority,
      Map<String, int> byStatus});
}

/// @nodoc
class _$IncidentStatsModelCopyWithImpl<$Res, $Val extends IncidentStatsModel>
    implements $IncidentStatsModelCopyWith<$Res> {
  _$IncidentStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncidents = null,
    Object? unsafeActionCount = null,
    Object? unsafeConditionCount = null,
    Object? recentIncidents = null,
    Object? byPriority = null,
    Object? byStatus = null,
  }) {
    return _then(_value.copyWith(
      totalIncidents: null == totalIncidents
          ? _value.totalIncidents
          : totalIncidents // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeActionCount: null == unsafeActionCount
          ? _value.unsafeActionCount
          : unsafeActionCount // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeConditionCount: null == unsafeConditionCount
          ? _value.unsafeConditionCount
          : unsafeConditionCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentIncidents: null == recentIncidents
          ? _value.recentIncidents
          : recentIncidents // ignore: cast_nullable_to_non_nullable
              as int,
      byPriority: null == byPriority
          ? _value.byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byStatus: null == byStatus
          ? _value.byStatus
          : byStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncidentStatsModelImplCopyWith<$Res>
    implements $IncidentStatsModelCopyWith<$Res> {
  factory _$$IncidentStatsModelImplCopyWith(_$IncidentStatsModelImpl value,
          $Res Function(_$IncidentStatsModelImpl) then) =
      __$$IncidentStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalIncidents,
      int unsafeActionCount,
      int unsafeConditionCount,
      int recentIncidents,
      Map<String, int> byPriority,
      Map<String, int> byStatus});
}

/// @nodoc
class __$$IncidentStatsModelImplCopyWithImpl<$Res>
    extends _$IncidentStatsModelCopyWithImpl<$Res, _$IncidentStatsModelImpl>
    implements _$$IncidentStatsModelImplCopyWith<$Res> {
  __$$IncidentStatsModelImplCopyWithImpl(_$IncidentStatsModelImpl _value,
      $Res Function(_$IncidentStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncidents = null,
    Object? unsafeActionCount = null,
    Object? unsafeConditionCount = null,
    Object? recentIncidents = null,
    Object? byPriority = null,
    Object? byStatus = null,
  }) {
    return _then(_$IncidentStatsModelImpl(
      totalIncidents: null == totalIncidents
          ? _value.totalIncidents
          : totalIncidents // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeActionCount: null == unsafeActionCount
          ? _value.unsafeActionCount
          : unsafeActionCount // ignore: cast_nullable_to_non_nullable
              as int,
      unsafeConditionCount: null == unsafeConditionCount
          ? _value.unsafeConditionCount
          : unsafeConditionCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentIncidents: null == recentIncidents
          ? _value.recentIncidents
          : recentIncidents // ignore: cast_nullable_to_non_nullable
              as int,
      byPriority: null == byPriority
          ? _value._byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      byStatus: null == byStatus
          ? _value._byStatus
          : byStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncidentStatsModelImpl implements _IncidentStatsModel {
  const _$IncidentStatsModelImpl(
      {this.totalIncidents = 0,
      this.unsafeActionCount = 0,
      this.unsafeConditionCount = 0,
      this.recentIncidents = 0,
      final Map<String, int> byPriority = const {},
      final Map<String, int> byStatus = const {}})
      : _byPriority = byPriority,
        _byStatus = byStatus;

  factory _$IncidentStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncidentStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalIncidents;
  @override
  @JsonKey()
  final int unsafeActionCount;
  @override
  @JsonKey()
  final int unsafeConditionCount;
  @override
  @JsonKey()
  final int recentIncidents;
  final Map<String, int> _byPriority;
  @override
  @JsonKey()
  Map<String, int> get byPriority {
    if (_byPriority is EqualUnmodifiableMapView) return _byPriority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byPriority);
  }

  final Map<String, int> _byStatus;
  @override
  @JsonKey()
  Map<String, int> get byStatus {
    if (_byStatus is EqualUnmodifiableMapView) return _byStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byStatus);
  }

  @override
  String toString() {
    return 'IncidentStatsModel(totalIncidents: $totalIncidents, unsafeActionCount: $unsafeActionCount, unsafeConditionCount: $unsafeConditionCount, recentIncidents: $recentIncidents, byPriority: $byPriority, byStatus: $byStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncidentStatsModelImpl &&
            (identical(other.totalIncidents, totalIncidents) ||
                other.totalIncidents == totalIncidents) &&
            (identical(other.unsafeActionCount, unsafeActionCount) ||
                other.unsafeActionCount == unsafeActionCount) &&
            (identical(other.unsafeConditionCount, unsafeConditionCount) ||
                other.unsafeConditionCount == unsafeConditionCount) &&
            (identical(other.recentIncidents, recentIncidents) ||
                other.recentIncidents == recentIncidents) &&
            const DeepCollectionEquality()
                .equals(other._byPriority, _byPriority) &&
            const DeepCollectionEquality().equals(other._byStatus, _byStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalIncidents,
      unsafeActionCount,
      unsafeConditionCount,
      recentIncidents,
      const DeepCollectionEquality().hash(_byPriority),
      const DeepCollectionEquality().hash(_byStatus));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncidentStatsModelImplCopyWith<_$IncidentStatsModelImpl> get copyWith =>
      __$$IncidentStatsModelImplCopyWithImpl<_$IncidentStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncidentStatsModelImplToJson(
      this,
    );
  }
}

abstract class _IncidentStatsModel implements IncidentStatsModel {
  const factory _IncidentStatsModel(
      {final int totalIncidents,
      final int unsafeActionCount,
      final int unsafeConditionCount,
      final int recentIncidents,
      final Map<String, int> byPriority,
      final Map<String, int> byStatus}) = _$IncidentStatsModelImpl;

  factory _IncidentStatsModel.fromJson(Map<String, dynamic> json) =
      _$IncidentStatsModelImpl.fromJson;

  @override
  int get totalIncidents;
  @override
  int get unsafeActionCount;
  @override
  int get unsafeConditionCount;
  @override
  int get recentIncidents;
  @override
  Map<String, int> get byPriority;
  @override
  Map<String, int> get byStatus;
  @override
  @JsonKey(ignore: true)
  _$$IncidentStatsModelImplCopyWith<_$IncidentStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
