// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'silent_inspection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SilentInspectionModel _$SilentInspectionModelFromJson(
    Map<String, dynamic> json) {
  return _SilentInspectionModel.fromJson(json);
}

/// @nodoc
mixin _$SilentInspectionModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal')
  String get tanggal => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_mulai')
  String? get waktuMulai => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_inspeksi')
  String get areaInspeksi => throw _privateConstructorUsedError;
  @JsonKey(name: 'kategori_bahaya')
  String? get kategoriBahaya => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_critical')
  int get temuanCritical => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_major')
  int get temuanMajor => throw _privateConstructorUsedError;
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor => throw _privateConstructorUsedError;
  @JsonKey(name: 'jumlah_temuan')
  int get jumlahTemuan => throw _privateConstructorUsedError;
  @JsonKey(name: 'deskripsi_temuan')
  String? get deskripsiTemuan => throw _privateConstructorUsedError;
  @JsonKey(name: 'skor_kepatuhan')
  double? get skorKepatuhan => throw _privateConstructorUsedError;
  @JsonKey(name: 'tingkat_risiko')
  String? get tingkatRisiko => throw _privateConstructorUsedError;
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping => throw _privateConstructorUsedError;
  @JsonKey(name: 'penggunaan_apd')
  String? get penggunaanApd => throw _privateConstructorUsedError;
  @JsonKey(name: 'rekomendasi')
  String? get rekomendasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'tindakan_korektif')
  String? get tindakanKorektif => throw _privateConstructorUsedError;
  @JsonKey(name: 'pic_tindak_lanjut')
  String? get picTindakLanjut => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_penyelesaian')
  String? get targetPenyelesaian => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_tindak_lanjut')
  String? get statusTindakLanjut => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'foto_kondisi_unsafe')
  List<String> get fotoKondisiUnsafe => throw _privateConstructorUsedError;
  @JsonKey(name: 'foto_perilaku_unsafe')
  List<String> get fotoPerilakuUnsafe => throw _privateConstructorUsedError;
  @JsonKey(name: 'catatan')
  String? get catatan => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SilentInspectionModelCopyWith<SilentInspectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SilentInspectionModelCopyWith<$Res> {
  factory $SilentInspectionModelCopyWith(SilentInspectionModel value,
          $Res Function(SilentInspectionModel) then) =
      _$SilentInspectionModelCopyWithImpl<$Res, SilentInspectionModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'tanggal') String tanggal,
      @JsonKey(name: 'waktu_mulai') String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String unitId,
      @JsonKey(name: 'area_inspeksi') String areaInspeksi,
      @JsonKey(name: 'kategori_bahaya') String? kategoriBahaya,
      @JsonKey(name: 'temuan_critical') int temuanCritical,
      @JsonKey(name: 'temuan_major') int temuanMajor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      @JsonKey(name: 'jumlah_temuan') int jumlahTemuan,
      @JsonKey(name: 'deskripsi_temuan') String? deskripsiTemuan,
      @JsonKey(name: 'skor_kepatuhan') double? skorKepatuhan,
      @JsonKey(name: 'tingkat_risiko') String? tingkatRisiko,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'penggunaan_apd') String? penggunaanApd,
      @JsonKey(name: 'rekomendasi') String? rekomendasi,
      @JsonKey(name: 'tindakan_korektif') String? tindakanKorektif,
      @JsonKey(name: 'pic_tindak_lanjut') String? picTindakLanjut,
      @JsonKey(name: 'target_penyelesaian') String? targetPenyelesaian,
      @JsonKey(name: 'status_tindak_lanjut') String? statusTindakLanjut,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'foto_kondisi_unsafe') List<String> fotoKondisiUnsafe,
      @JsonKey(name: 'foto_perilaku_unsafe') List<String> fotoPerilakuUnsafe,
      @JsonKey(name: 'catatan') String? catatan,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$SilentInspectionModelCopyWithImpl<$Res,
        $Val extends SilentInspectionModel>
    implements $SilentInspectionModelCopyWith<$Res> {
  _$SilentInspectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tanggal = null,
    Object? waktuMulai = freezed,
    Object? waktuSelesai = freezed,
    Object? unitId = null,
    Object? areaInspeksi = null,
    Object? kategoriBahaya = freezed,
    Object? temuanCritical = null,
    Object? temuanMajor = null,
    Object? temuanMinor = null,
    Object? jumlahTemuan = null,
    Object? deskripsiTemuan = freezed,
    Object? skorKepatuhan = freezed,
    Object? tingkatRisiko = freezed,
    Object? kondisiHousekeeping = freezed,
    Object? penggunaanApd = freezed,
    Object? rekomendasi = freezed,
    Object? tindakanKorektif = freezed,
    Object? picTindakLanjut = freezed,
    Object? targetPenyelesaian = freezed,
    Object? statusTindakLanjut = freezed,
    Object? status = null,
    Object? fotoKondisiUnsafe = null,
    Object? fotoPerilakuUnsafe = null,
    Object? catatan = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      tanggal: null == tanggal
          ? _value.tanggal
          : tanggal // ignore: cast_nullable_to_non_nullable
              as String,
      waktuMulai: freezed == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String?,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: null == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String,
      areaInspeksi: null == areaInspeksi
          ? _value.areaInspeksi
          : areaInspeksi // ignore: cast_nullable_to_non_nullable
              as String,
      kategoriBahaya: freezed == kategoriBahaya
          ? _value.kategoriBahaya
          : kategoriBahaya // ignore: cast_nullable_to_non_nullable
              as String?,
      temuanCritical: null == temuanCritical
          ? _value.temuanCritical
          : temuanCritical // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMajor: null == temuanMajor
          ? _value.temuanMajor
          : temuanMajor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      jumlahTemuan: null == jumlahTemuan
          ? _value.jumlahTemuan
          : jumlahTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      deskripsiTemuan: freezed == deskripsiTemuan
          ? _value.deskripsiTemuan
          : deskripsiTemuan // ignore: cast_nullable_to_non_nullable
              as String?,
      skorKepatuhan: freezed == skorKepatuhan
          ? _value.skorKepatuhan
          : skorKepatuhan // ignore: cast_nullable_to_non_nullable
              as double?,
      tingkatRisiko: freezed == tingkatRisiko
          ? _value.tingkatRisiko
          : tingkatRisiko // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      penggunaanApd: freezed == penggunaanApd
          ? _value.penggunaanApd
          : penggunaanApd // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasi: freezed == rekomendasi
          ? _value.rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as String?,
      tindakanKorektif: freezed == tindakanKorektif
          ? _value.tindakanKorektif
          : tindakanKorektif // ignore: cast_nullable_to_non_nullable
              as String?,
      picTindakLanjut: freezed == picTindakLanjut
          ? _value.picTindakLanjut
          : picTindakLanjut // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPenyelesaian: freezed == targetPenyelesaian
          ? _value.targetPenyelesaian
          : targetPenyelesaian // ignore: cast_nullable_to_non_nullable
              as String?,
      statusTindakLanjut: freezed == statusTindakLanjut
          ? _value.statusTindakLanjut
          : statusTindakLanjut // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      fotoKondisiUnsafe: null == fotoKondisiUnsafe
          ? _value.fotoKondisiUnsafe
          : fotoKondisiUnsafe // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoPerilakuUnsafe: null == fotoPerilakuUnsafe
          ? _value.fotoPerilakuUnsafe
          : fotoPerilakuUnsafe // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatan: freezed == catatan
          ? _value.catatan
          : catatan // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SilentInspectionModelImplCopyWith<$Res>
    implements $SilentInspectionModelCopyWith<$Res> {
  factory _$$SilentInspectionModelImplCopyWith(
          _$SilentInspectionModelImpl value,
          $Res Function(_$SilentInspectionModelImpl) then) =
      __$$SilentInspectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'tanggal') String tanggal,
      @JsonKey(name: 'waktu_mulai') String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String unitId,
      @JsonKey(name: 'area_inspeksi') String areaInspeksi,
      @JsonKey(name: 'kategori_bahaya') String? kategoriBahaya,
      @JsonKey(name: 'temuan_critical') int temuanCritical,
      @JsonKey(name: 'temuan_major') int temuanMajor,
      @JsonKey(name: 'temuan_minor') int temuanMinor,
      @JsonKey(name: 'jumlah_temuan') int jumlahTemuan,
      @JsonKey(name: 'deskripsi_temuan') String? deskripsiTemuan,
      @JsonKey(name: 'skor_kepatuhan') double? skorKepatuhan,
      @JsonKey(name: 'tingkat_risiko') String? tingkatRisiko,
      @JsonKey(name: 'kondisi_housekeeping') String? kondisiHousekeeping,
      @JsonKey(name: 'penggunaan_apd') String? penggunaanApd,
      @JsonKey(name: 'rekomendasi') String? rekomendasi,
      @JsonKey(name: 'tindakan_korektif') String? tindakanKorektif,
      @JsonKey(name: 'pic_tindak_lanjut') String? picTindakLanjut,
      @JsonKey(name: 'target_penyelesaian') String? targetPenyelesaian,
      @JsonKey(name: 'status_tindak_lanjut') String? statusTindakLanjut,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'foto_kondisi_unsafe') List<String> fotoKondisiUnsafe,
      @JsonKey(name: 'foto_perilaku_unsafe') List<String> fotoPerilakuUnsafe,
      @JsonKey(name: 'catatan') String? catatan,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$SilentInspectionModelImplCopyWithImpl<$Res>
    extends _$SilentInspectionModelCopyWithImpl<$Res,
        _$SilentInspectionModelImpl>
    implements _$$SilentInspectionModelImplCopyWith<$Res> {
  __$$SilentInspectionModelImplCopyWithImpl(_$SilentInspectionModelImpl _value,
      $Res Function(_$SilentInspectionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tanggal = null,
    Object? waktuMulai = freezed,
    Object? waktuSelesai = freezed,
    Object? unitId = null,
    Object? areaInspeksi = null,
    Object? kategoriBahaya = freezed,
    Object? temuanCritical = null,
    Object? temuanMajor = null,
    Object? temuanMinor = null,
    Object? jumlahTemuan = null,
    Object? deskripsiTemuan = freezed,
    Object? skorKepatuhan = freezed,
    Object? tingkatRisiko = freezed,
    Object? kondisiHousekeeping = freezed,
    Object? penggunaanApd = freezed,
    Object? rekomendasi = freezed,
    Object? tindakanKorektif = freezed,
    Object? picTindakLanjut = freezed,
    Object? targetPenyelesaian = freezed,
    Object? statusTindakLanjut = freezed,
    Object? status = null,
    Object? fotoKondisiUnsafe = null,
    Object? fotoPerilakuUnsafe = null,
    Object? catatan = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SilentInspectionModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      tanggal: null == tanggal
          ? _value.tanggal
          : tanggal // ignore: cast_nullable_to_non_nullable
              as String,
      waktuMulai: freezed == waktuMulai
          ? _value.waktuMulai
          : waktuMulai // ignore: cast_nullable_to_non_nullable
              as String?,
      waktuSelesai: freezed == waktuSelesai
          ? _value.waktuSelesai
          : waktuSelesai // ignore: cast_nullable_to_non_nullable
              as String?,
      unitId: null == unitId
          ? _value.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String,
      areaInspeksi: null == areaInspeksi
          ? _value.areaInspeksi
          : areaInspeksi // ignore: cast_nullable_to_non_nullable
              as String,
      kategoriBahaya: freezed == kategoriBahaya
          ? _value.kategoriBahaya
          : kategoriBahaya // ignore: cast_nullable_to_non_nullable
              as String?,
      temuanCritical: null == temuanCritical
          ? _value.temuanCritical
          : temuanCritical // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMajor: null == temuanMajor
          ? _value.temuanMajor
          : temuanMajor // ignore: cast_nullable_to_non_nullable
              as int,
      temuanMinor: null == temuanMinor
          ? _value.temuanMinor
          : temuanMinor // ignore: cast_nullable_to_non_nullable
              as int,
      jumlahTemuan: null == jumlahTemuan
          ? _value.jumlahTemuan
          : jumlahTemuan // ignore: cast_nullable_to_non_nullable
              as int,
      deskripsiTemuan: freezed == deskripsiTemuan
          ? _value.deskripsiTemuan
          : deskripsiTemuan // ignore: cast_nullable_to_non_nullable
              as String?,
      skorKepatuhan: freezed == skorKepatuhan
          ? _value.skorKepatuhan
          : skorKepatuhan // ignore: cast_nullable_to_non_nullable
              as double?,
      tingkatRisiko: freezed == tingkatRisiko
          ? _value.tingkatRisiko
          : tingkatRisiko // ignore: cast_nullable_to_non_nullable
              as String?,
      kondisiHousekeeping: freezed == kondisiHousekeeping
          ? _value.kondisiHousekeeping
          : kondisiHousekeeping // ignore: cast_nullable_to_non_nullable
              as String?,
      penggunaanApd: freezed == penggunaanApd
          ? _value.penggunaanApd
          : penggunaanApd // ignore: cast_nullable_to_non_nullable
              as String?,
      rekomendasi: freezed == rekomendasi
          ? _value.rekomendasi
          : rekomendasi // ignore: cast_nullable_to_non_nullable
              as String?,
      tindakanKorektif: freezed == tindakanKorektif
          ? _value.tindakanKorektif
          : tindakanKorektif // ignore: cast_nullable_to_non_nullable
              as String?,
      picTindakLanjut: freezed == picTindakLanjut
          ? _value.picTindakLanjut
          : picTindakLanjut // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPenyelesaian: freezed == targetPenyelesaian
          ? _value.targetPenyelesaian
          : targetPenyelesaian // ignore: cast_nullable_to_non_nullable
              as String?,
      statusTindakLanjut: freezed == statusTindakLanjut
          ? _value.statusTindakLanjut
          : statusTindakLanjut // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      fotoKondisiUnsafe: null == fotoKondisiUnsafe
          ? _value._fotoKondisiUnsafe
          : fotoKondisiUnsafe // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoPerilakuUnsafe: null == fotoPerilakuUnsafe
          ? _value._fotoPerilakuUnsafe
          : fotoPerilakuUnsafe // ignore: cast_nullable_to_non_nullable
              as List<String>,
      catatan: freezed == catatan
          ? _value.catatan
          : catatan // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SilentInspectionModelImpl implements _SilentInspectionModel {
  const _$SilentInspectionModelImpl(
      {this.id,
      @JsonKey(name: 'tanggal') required this.tanggal,
      @JsonKey(name: 'waktu_mulai') this.waktuMulai,
      @JsonKey(name: 'waktu_selesai') this.waktuSelesai,
      @JsonKey(name: 'unit_id') required this.unitId,
      @JsonKey(name: 'area_inspeksi') required this.areaInspeksi,
      @JsonKey(name: 'kategori_bahaya') this.kategoriBahaya,
      @JsonKey(name: 'temuan_critical') this.temuanCritical = 0,
      @JsonKey(name: 'temuan_major') this.temuanMajor = 0,
      @JsonKey(name: 'temuan_minor') this.temuanMinor = 0,
      @JsonKey(name: 'jumlah_temuan') this.jumlahTemuan = 0,
      @JsonKey(name: 'deskripsi_temuan') this.deskripsiTemuan,
      @JsonKey(name: 'skor_kepatuhan') this.skorKepatuhan,
      @JsonKey(name: 'tingkat_risiko') this.tingkatRisiko,
      @JsonKey(name: 'kondisi_housekeeping') this.kondisiHousekeeping,
      @JsonKey(name: 'penggunaan_apd') this.penggunaanApd,
      @JsonKey(name: 'rekomendasi') this.rekomendasi,
      @JsonKey(name: 'tindakan_korektif') this.tindakanKorektif,
      @JsonKey(name: 'pic_tindak_lanjut') this.picTindakLanjut,
      @JsonKey(name: 'target_penyelesaian') this.targetPenyelesaian,
      @JsonKey(name: 'status_tindak_lanjut') this.statusTindakLanjut,
      @JsonKey(name: 'status') this.status = 'draft',
      @JsonKey(name: 'foto_kondisi_unsafe')
      final List<String> fotoKondisiUnsafe = const [],
      @JsonKey(name: 'foto_perilaku_unsafe')
      final List<String> fotoPerilakuUnsafe = const [],
      @JsonKey(name: 'catatan') this.catatan,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _fotoKondisiUnsafe = fotoKondisiUnsafe,
        _fotoPerilakuUnsafe = fotoPerilakuUnsafe;

  factory _$SilentInspectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SilentInspectionModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'tanggal')
  final String tanggal;
  @override
  @JsonKey(name: 'waktu_mulai')
  final String? waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  final String? waktuSelesai;
  @override
  @JsonKey(name: 'unit_id')
  final String unitId;
  @override
  @JsonKey(name: 'area_inspeksi')
  final String areaInspeksi;
  @override
  @JsonKey(name: 'kategori_bahaya')
  final String? kategoriBahaya;
  @override
  @JsonKey(name: 'temuan_critical')
  final int temuanCritical;
  @override
  @JsonKey(name: 'temuan_major')
  final int temuanMajor;
  @override
  @JsonKey(name: 'temuan_minor')
  final int temuanMinor;
  @override
  @JsonKey(name: 'jumlah_temuan')
  final int jumlahTemuan;
  @override
  @JsonKey(name: 'deskripsi_temuan')
  final String? deskripsiTemuan;
  @override
  @JsonKey(name: 'skor_kepatuhan')
  final double? skorKepatuhan;
  @override
  @JsonKey(name: 'tingkat_risiko')
  final String? tingkatRisiko;
  @override
  @JsonKey(name: 'kondisi_housekeeping')
  final String? kondisiHousekeeping;
  @override
  @JsonKey(name: 'penggunaan_apd')
  final String? penggunaanApd;
  @override
  @JsonKey(name: 'rekomendasi')
  final String? rekomendasi;
  @override
  @JsonKey(name: 'tindakan_korektif')
  final String? tindakanKorektif;
  @override
  @JsonKey(name: 'pic_tindak_lanjut')
  final String? picTindakLanjut;
  @override
  @JsonKey(name: 'target_penyelesaian')
  final String? targetPenyelesaian;
  @override
  @JsonKey(name: 'status_tindak_lanjut')
  final String? statusTindakLanjut;
  @override
  @JsonKey(name: 'status')
  final String status;
  final List<String> _fotoKondisiUnsafe;
  @override
  @JsonKey(name: 'foto_kondisi_unsafe')
  List<String> get fotoKondisiUnsafe {
    if (_fotoKondisiUnsafe is EqualUnmodifiableListView)
      return _fotoKondisiUnsafe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoKondisiUnsafe);
  }

  final List<String> _fotoPerilakuUnsafe;
  @override
  @JsonKey(name: 'foto_perilaku_unsafe')
  List<String> get fotoPerilakuUnsafe {
    if (_fotoPerilakuUnsafe is EqualUnmodifiableListView)
      return _fotoPerilakuUnsafe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoPerilakuUnsafe);
  }

  @override
  @JsonKey(name: 'catatan')
  final String? catatan;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'SilentInspectionModel(id: $id, tanggal: $tanggal, waktuMulai: $waktuMulai, waktuSelesai: $waktuSelesai, unitId: $unitId, areaInspeksi: $areaInspeksi, kategoriBahaya: $kategoriBahaya, temuanCritical: $temuanCritical, temuanMajor: $temuanMajor, temuanMinor: $temuanMinor, jumlahTemuan: $jumlahTemuan, deskripsiTemuan: $deskripsiTemuan, skorKepatuhan: $skorKepatuhan, tingkatRisiko: $tingkatRisiko, kondisiHousekeeping: $kondisiHousekeeping, penggunaanApd: $penggunaanApd, rekomendasi: $rekomendasi, tindakanKorektif: $tindakanKorektif, picTindakLanjut: $picTindakLanjut, targetPenyelesaian: $targetPenyelesaian, statusTindakLanjut: $statusTindakLanjut, status: $status, fotoKondisiUnsafe: $fotoKondisiUnsafe, fotoPerilakuUnsafe: $fotoPerilakuUnsafe, catatan: $catatan, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SilentInspectionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tanggal, tanggal) || other.tanggal == tanggal) &&
            (identical(other.waktuMulai, waktuMulai) ||
                other.waktuMulai == waktuMulai) &&
            (identical(other.waktuSelesai, waktuSelesai) ||
                other.waktuSelesai == waktuSelesai) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.areaInspeksi, areaInspeksi) ||
                other.areaInspeksi == areaInspeksi) &&
            (identical(other.kategoriBahaya, kategoriBahaya) ||
                other.kategoriBahaya == kategoriBahaya) &&
            (identical(other.temuanCritical, temuanCritical) ||
                other.temuanCritical == temuanCritical) &&
            (identical(other.temuanMajor, temuanMajor) ||
                other.temuanMajor == temuanMajor) &&
            (identical(other.temuanMinor, temuanMinor) ||
                other.temuanMinor == temuanMinor) &&
            (identical(other.jumlahTemuan, jumlahTemuan) ||
                other.jumlahTemuan == jumlahTemuan) &&
            (identical(other.deskripsiTemuan, deskripsiTemuan) ||
                other.deskripsiTemuan == deskripsiTemuan) &&
            (identical(other.skorKepatuhan, skorKepatuhan) ||
                other.skorKepatuhan == skorKepatuhan) &&
            (identical(other.tingkatRisiko, tingkatRisiko) ||
                other.tingkatRisiko == tingkatRisiko) &&
            (identical(other.kondisiHousekeeping, kondisiHousekeeping) ||
                other.kondisiHousekeeping == kondisiHousekeeping) &&
            (identical(other.penggunaanApd, penggunaanApd) ||
                other.penggunaanApd == penggunaanApd) &&
            (identical(other.rekomendasi, rekomendasi) ||
                other.rekomendasi == rekomendasi) &&
            (identical(other.tindakanKorektif, tindakanKorektif) ||
                other.tindakanKorektif == tindakanKorektif) &&
            (identical(other.picTindakLanjut, picTindakLanjut) ||
                other.picTindakLanjut == picTindakLanjut) &&
            (identical(other.targetPenyelesaian, targetPenyelesaian) ||
                other.targetPenyelesaian == targetPenyelesaian) &&
            (identical(other.statusTindakLanjut, statusTindakLanjut) ||
                other.statusTindakLanjut == statusTindakLanjut) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._fotoKondisiUnsafe, _fotoKondisiUnsafe) &&
            const DeepCollectionEquality()
                .equals(other._fotoPerilakuUnsafe, _fotoPerilakuUnsafe) &&
            (identical(other.catatan, catatan) || other.catatan == catatan) &&
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
        tanggal,
        waktuMulai,
        waktuSelesai,
        unitId,
        areaInspeksi,
        kategoriBahaya,
        temuanCritical,
        temuanMajor,
        temuanMinor,
        jumlahTemuan,
        deskripsiTemuan,
        skorKepatuhan,
        tingkatRisiko,
        kondisiHousekeeping,
        penggunaanApd,
        rekomendasi,
        tindakanKorektif,
        picTindakLanjut,
        targetPenyelesaian,
        statusTindakLanjut,
        status,
        const DeepCollectionEquality().hash(_fotoKondisiUnsafe),
        const DeepCollectionEquality().hash(_fotoPerilakuUnsafe),
        catatan,
        createdBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SilentInspectionModelImplCopyWith<_$SilentInspectionModelImpl>
      get copyWith => __$$SilentInspectionModelImplCopyWithImpl<
          _$SilentInspectionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SilentInspectionModelImplToJson(
      this,
    );
  }
}

abstract class _SilentInspectionModel implements SilentInspectionModel {
  const factory _SilentInspectionModel(
      {final String? id,
      @JsonKey(name: 'tanggal') required final String tanggal,
      @JsonKey(name: 'waktu_mulai') final String? waktuMulai,
      @JsonKey(name: 'waktu_selesai') final String? waktuSelesai,
      @JsonKey(name: 'unit_id') required final String unitId,
      @JsonKey(name: 'area_inspeksi') required final String areaInspeksi,
      @JsonKey(name: 'kategori_bahaya') final String? kategoriBahaya,
      @JsonKey(name: 'temuan_critical') final int temuanCritical,
      @JsonKey(name: 'temuan_major') final int temuanMajor,
      @JsonKey(name: 'temuan_minor') final int temuanMinor,
      @JsonKey(name: 'jumlah_temuan') final int jumlahTemuan,
      @JsonKey(name: 'deskripsi_temuan') final String? deskripsiTemuan,
      @JsonKey(name: 'skor_kepatuhan') final double? skorKepatuhan,
      @JsonKey(name: 'tingkat_risiko') final String? tingkatRisiko,
      @JsonKey(name: 'kondisi_housekeeping') final String? kondisiHousekeeping,
      @JsonKey(name: 'penggunaan_apd') final String? penggunaanApd,
      @JsonKey(name: 'rekomendasi') final String? rekomendasi,
      @JsonKey(name: 'tindakan_korektif') final String? tindakanKorektif,
      @JsonKey(name: 'pic_tindak_lanjut') final String? picTindakLanjut,
      @JsonKey(name: 'target_penyelesaian') final String? targetPenyelesaian,
      @JsonKey(name: 'status_tindak_lanjut') final String? statusTindakLanjut,
      @JsonKey(name: 'status') final String status,
      @JsonKey(name: 'foto_kondisi_unsafe')
      final List<String> fotoKondisiUnsafe,
      @JsonKey(name: 'foto_perilaku_unsafe')
      final List<String> fotoPerilakuUnsafe,
      @JsonKey(name: 'catatan') final String? catatan,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at')
      final String? updatedAt}) = _$SilentInspectionModelImpl;

  factory _SilentInspectionModel.fromJson(Map<String, dynamic> json) =
      _$SilentInspectionModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'tanggal')
  String get tanggal;
  @override
  @JsonKey(name: 'waktu_mulai')
  String? get waktuMulai;
  @override
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai;
  @override
  @JsonKey(name: 'unit_id')
  String get unitId;
  @override
  @JsonKey(name: 'area_inspeksi')
  String get areaInspeksi;
  @override
  @JsonKey(name: 'kategori_bahaya')
  String? get kategoriBahaya;
  @override
  @JsonKey(name: 'temuan_critical')
  int get temuanCritical;
  @override
  @JsonKey(name: 'temuan_major')
  int get temuanMajor;
  @override
  @JsonKey(name: 'temuan_minor')
  int get temuanMinor;
  @override
  @JsonKey(name: 'jumlah_temuan')
  int get jumlahTemuan;
  @override
  @JsonKey(name: 'deskripsi_temuan')
  String? get deskripsiTemuan;
  @override
  @JsonKey(name: 'skor_kepatuhan')
  double? get skorKepatuhan;
  @override
  @JsonKey(name: 'tingkat_risiko')
  String? get tingkatRisiko;
  @override
  @JsonKey(name: 'kondisi_housekeeping')
  String? get kondisiHousekeeping;
  @override
  @JsonKey(name: 'penggunaan_apd')
  String? get penggunaanApd;
  @override
  @JsonKey(name: 'rekomendasi')
  String? get rekomendasi;
  @override
  @JsonKey(name: 'tindakan_korektif')
  String? get tindakanKorektif;
  @override
  @JsonKey(name: 'pic_tindak_lanjut')
  String? get picTindakLanjut;
  @override
  @JsonKey(name: 'target_penyelesaian')
  String? get targetPenyelesaian;
  @override
  @JsonKey(name: 'status_tindak_lanjut')
  String? get statusTindakLanjut;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'foto_kondisi_unsafe')
  List<String> get fotoKondisiUnsafe;
  @override
  @JsonKey(name: 'foto_perilaku_unsafe')
  List<String> get fotoPerilakuUnsafe;
  @override
  @JsonKey(name: 'catatan')
  String? get catatan;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SilentInspectionModelImplCopyWith<_$SilentInspectionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
