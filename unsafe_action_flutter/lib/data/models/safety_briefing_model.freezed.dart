// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'safety_briefing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SafetyBriefingModel _$SafetyBriefingModelFromJson(Map<String, dynamic> json) {
  return _SafetyBriefingModel.fromJson(json);
}

/// @nodoc
mixin _$SafetyBriefingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tanggal')
  DateTime get tanggal => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_mulai')
  String get waktuMulai => throw _privateConstructorUsedError;
  @JsonKey(name: 'waktu_selesai')
  String? get waktuSelesai => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String? get unitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'petugas_id')
  String? get petugasId => throw _privateConstructorUsedError;
  @JsonKey(name: 'topik')
  String get topik => throw _privateConstructorUsedError;
  @JsonKey(name: 'materi')
  String? get materi => throw _privateConstructorUsedError;
  @JsonKey(name: 'jumlah_peserta')
  int get jumlahPeserta => throw _privateConstructorUsedError;
  @JsonKey(name: 'daftar_peserta')
  List<String> get daftarPeserta => throw _privateConstructorUsedError;
  @JsonKey(name: 'foto_dokumentasi')
  List<String> get fotoDokumentasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'catatan')
  String? get catatan => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SafetyBriefingModelCopyWith<SafetyBriefingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SafetyBriefingModelCopyWith<$Res> {
  factory $SafetyBriefingModelCopyWith(
          SafetyBriefingModel value, $Res Function(SafetyBriefingModel) then) =
      _$SafetyBriefingModelCopyWithImpl<$Res, SafetyBriefingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'tanggal') DateTime tanggal,
      @JsonKey(name: 'waktu_mulai') String waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'petugas_id') String? petugasId,
      @JsonKey(name: 'topik') String topik,
      @JsonKey(name: 'materi') String? materi,
      @JsonKey(name: 'jumlah_peserta') int jumlahPeserta,
      @JsonKey(name: 'daftar_peserta') List<String> daftarPeserta,
      @JsonKey(name: 'foto_dokumentasi') List<String> fotoDokumentasi,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'catatan') String? catatan,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$SafetyBriefingModelCopyWithImpl<$Res, $Val extends SafetyBriefingModel>
    implements $SafetyBriefingModelCopyWith<$Res> {
  _$SafetyBriefingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tanggal = null,
    Object? waktuMulai = null,
    Object? waktuSelesai = freezed,
    Object? unitId = freezed,
    Object? petugasId = freezed,
    Object? topik = null,
    Object? materi = freezed,
    Object? jumlahPeserta = null,
    Object? daftarPeserta = null,
    Object? fotoDokumentasi = null,
    Object? status = null,
    Object? catatan = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tanggal: null == tanggal
          ? _value.tanggal
          : tanggal // ignore: cast_nullable_to_non_nullable
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
      petugasId: freezed == petugasId
          ? _value.petugasId
          : petugasId // ignore: cast_nullable_to_non_nullable
              as String?,
      topik: null == topik
          ? _value.topik
          : topik // ignore: cast_nullable_to_non_nullable
              as String,
      materi: freezed == materi
          ? _value.materi
          : materi // ignore: cast_nullable_to_non_nullable
              as String?,
      jumlahPeserta: null == jumlahPeserta
          ? _value.jumlahPeserta
          : jumlahPeserta // ignore: cast_nullable_to_non_nullable
              as int,
      daftarPeserta: null == daftarPeserta
          ? _value.daftarPeserta
          : daftarPeserta // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoDokumentasi: null == fotoDokumentasi
          ? _value.fotoDokumentasi
          : fotoDokumentasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      catatan: freezed == catatan
          ? _value.catatan
          : catatan // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SafetyBriefingModelImplCopyWith<$Res>
    implements $SafetyBriefingModelCopyWith<$Res> {
  factory _$$SafetyBriefingModelImplCopyWith(_$SafetyBriefingModelImpl value,
          $Res Function(_$SafetyBriefingModelImpl) then) =
      __$$SafetyBriefingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'tanggal') DateTime tanggal,
      @JsonKey(name: 'waktu_mulai') String waktuMulai,
      @JsonKey(name: 'waktu_selesai') String? waktuSelesai,
      @JsonKey(name: 'unit_id') String? unitId,
      @JsonKey(name: 'petugas_id') String? petugasId,
      @JsonKey(name: 'topik') String topik,
      @JsonKey(name: 'materi') String? materi,
      @JsonKey(name: 'jumlah_peserta') int jumlahPeserta,
      @JsonKey(name: 'daftar_peserta') List<String> daftarPeserta,
      @JsonKey(name: 'foto_dokumentasi') List<String> fotoDokumentasi,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'catatan') String? catatan,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$SafetyBriefingModelImplCopyWithImpl<$Res>
    extends _$SafetyBriefingModelCopyWithImpl<$Res, _$SafetyBriefingModelImpl>
    implements _$$SafetyBriefingModelImplCopyWith<$Res> {
  __$$SafetyBriefingModelImplCopyWithImpl(_$SafetyBriefingModelImpl _value,
      $Res Function(_$SafetyBriefingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tanggal = null,
    Object? waktuMulai = null,
    Object? waktuSelesai = freezed,
    Object? unitId = freezed,
    Object? petugasId = freezed,
    Object? topik = null,
    Object? materi = freezed,
    Object? jumlahPeserta = null,
    Object? daftarPeserta = null,
    Object? fotoDokumentasi = null,
    Object? status = null,
    Object? catatan = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SafetyBriefingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tanggal: null == tanggal
          ? _value.tanggal
          : tanggal // ignore: cast_nullable_to_non_nullable
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
      petugasId: freezed == petugasId
          ? _value.petugasId
          : petugasId // ignore: cast_nullable_to_non_nullable
              as String?,
      topik: null == topik
          ? _value.topik
          : topik // ignore: cast_nullable_to_non_nullable
              as String,
      materi: freezed == materi
          ? _value.materi
          : materi // ignore: cast_nullable_to_non_nullable
              as String?,
      jumlahPeserta: null == jumlahPeserta
          ? _value.jumlahPeserta
          : jumlahPeserta // ignore: cast_nullable_to_non_nullable
              as int,
      daftarPeserta: null == daftarPeserta
          ? _value._daftarPeserta
          : daftarPeserta // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fotoDokumentasi: null == fotoDokumentasi
          ? _value._fotoDokumentasi
          : fotoDokumentasi // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      catatan: freezed == catatan
          ? _value.catatan
          : catatan // ignore: cast_nullable_to_non_nullable
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
class _$SafetyBriefingModelImpl implements _SafetyBriefingModel {
  const _$SafetyBriefingModelImpl(
      {required this.id,
      @JsonKey(name: 'tanggal') required this.tanggal,
      @JsonKey(name: 'waktu_mulai') required this.waktuMulai,
      @JsonKey(name: 'waktu_selesai') this.waktuSelesai,
      @JsonKey(name: 'unit_id') this.unitId,
      @JsonKey(name: 'petugas_id') this.petugasId,
      @JsonKey(name: 'topik') required this.topik,
      @JsonKey(name: 'materi') this.materi,
      @JsonKey(name: 'jumlah_peserta') this.jumlahPeserta = 0,
      @JsonKey(name: 'daftar_peserta')
      final List<String> daftarPeserta = const [],
      @JsonKey(name: 'foto_dokumentasi')
      final List<String> fotoDokumentasi = const [],
      @JsonKey(name: 'status') this.status = 'draft',
      @JsonKey(name: 'catatan') this.catatan,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _daftarPeserta = daftarPeserta,
        _fotoDokumentasi = fotoDokumentasi;

  factory _$SafetyBriefingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SafetyBriefingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tanggal')
  final DateTime tanggal;
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
  @JsonKey(name: 'petugas_id')
  final String? petugasId;
  @override
  @JsonKey(name: 'topik')
  final String topik;
  @override
  @JsonKey(name: 'materi')
  final String? materi;
  @override
  @JsonKey(name: 'jumlah_peserta')
  final int jumlahPeserta;
  final List<String> _daftarPeserta;
  @override
  @JsonKey(name: 'daftar_peserta')
  List<String> get daftarPeserta {
    if (_daftarPeserta is EqualUnmodifiableListView) return _daftarPeserta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daftarPeserta);
  }

  final List<String> _fotoDokumentasi;
  @override
  @JsonKey(name: 'foto_dokumentasi')
  List<String> get fotoDokumentasi {
    if (_fotoDokumentasi is EqualUnmodifiableListView) return _fotoDokumentasi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotoDokumentasi);
  }

  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'catatan')
  final String? catatan;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SafetyBriefingModel(id: $id, tanggal: $tanggal, waktuMulai: $waktuMulai, waktuSelesai: $waktuSelesai, unitId: $unitId, petugasId: $petugasId, topik: $topik, materi: $materi, jumlahPeserta: $jumlahPeserta, daftarPeserta: $daftarPeserta, fotoDokumentasi: $fotoDokumentasi, status: $status, catatan: $catatan, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafetyBriefingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tanggal, tanggal) || other.tanggal == tanggal) &&
            (identical(other.waktuMulai, waktuMulai) ||
                other.waktuMulai == waktuMulai) &&
            (identical(other.waktuSelesai, waktuSelesai) ||
                other.waktuSelesai == waktuSelesai) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.petugasId, petugasId) ||
                other.petugasId == petugasId) &&
            (identical(other.topik, topik) || other.topik == topik) &&
            (identical(other.materi, materi) || other.materi == materi) &&
            (identical(other.jumlahPeserta, jumlahPeserta) ||
                other.jumlahPeserta == jumlahPeserta) &&
            const DeepCollectionEquality()
                .equals(other._daftarPeserta, _daftarPeserta) &&
            const DeepCollectionEquality()
                .equals(other._fotoDokumentasi, _fotoDokumentasi) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.catatan, catatan) || other.catatan == catatan) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tanggal,
      waktuMulai,
      waktuSelesai,
      unitId,
      petugasId,
      topik,
      materi,
      jumlahPeserta,
      const DeepCollectionEquality().hash(_daftarPeserta),
      const DeepCollectionEquality().hash(_fotoDokumentasi),
      status,
      catatan,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SafetyBriefingModelImplCopyWith<_$SafetyBriefingModelImpl> get copyWith =>
      __$$SafetyBriefingModelImplCopyWithImpl<_$SafetyBriefingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SafetyBriefingModelImplToJson(
      this,
    );
  }
}

abstract class _SafetyBriefingModel implements SafetyBriefingModel {
  const factory _SafetyBriefingModel(
          {required final String id,
          @JsonKey(name: 'tanggal') required final DateTime tanggal,
          @JsonKey(name: 'waktu_mulai') required final String waktuMulai,
          @JsonKey(name: 'waktu_selesai') final String? waktuSelesai,
          @JsonKey(name: 'unit_id') final String? unitId,
          @JsonKey(name: 'petugas_id') final String? petugasId,
          @JsonKey(name: 'topik') required final String topik,
          @JsonKey(name: 'materi') final String? materi,
          @JsonKey(name: 'jumlah_peserta') final int jumlahPeserta,
          @JsonKey(name: 'daftar_peserta') final List<String> daftarPeserta,
          @JsonKey(name: 'foto_dokumentasi') final List<String> fotoDokumentasi,
          @JsonKey(name: 'status') final String status,
          @JsonKey(name: 'catatan') final String? catatan,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$SafetyBriefingModelImpl;

  factory _SafetyBriefingModel.fromJson(Map<String, dynamic> json) =
      _$SafetyBriefingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tanggal')
  DateTime get tanggal;
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
  @JsonKey(name: 'petugas_id')
  String? get petugasId;
  @override
  @JsonKey(name: 'topik')
  String get topik;
  @override
  @JsonKey(name: 'materi')
  String? get materi;
  @override
  @JsonKey(name: 'jumlah_peserta')
  int get jumlahPeserta;
  @override
  @JsonKey(name: 'daftar_peserta')
  List<String> get daftarPeserta;
  @override
  @JsonKey(name: 'foto_dokumentasi')
  List<String> get fotoDokumentasi;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'catatan')
  String? get catatan;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SafetyBriefingModelImplCopyWith<_$SafetyBriefingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
