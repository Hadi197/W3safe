import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../models/unsafe_incident_model.dart';

class IncidentRemoteDatasource {
  final SupabaseClient _supabase;

  IncidentRemoteDatasource(this._supabase);

  // Get all incidents with filters and pagination
  Future<List<UnsafeIncidentModel>> getIncidents({
    int page = 1,
    int limit = 20,
    String? search,
    String? jenisKejadian,
    String? status,
    String? prioritas,
    String? unitKerja,
  }) async {
    try {
      PostgrestFilterBuilder<PostgrestList> query = _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .select('*');

      // Apply filters
      if (jenisKejadian != null && jenisKejadian.isNotEmpty) {
        query = query.eq('jenis_kejadian', jenisKejadian);
      }
      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }
      if (prioritas != null && prioritas.isNotEmpty) {
        query = query.eq('prioritas', prioritas);
      }
      if (unitKerja != null && unitKerja.isNotEmpty) {
        query = query.eq('unit_kerja', unitKerja);
      }
      if (search != null && search.isNotEmpty) {
        query = query.or(
            'deskripsi_kejadian.ilike.%$search%,lokasi_kejadian.ilike.%$search%,pelapor_nama.ilike.%$search%');
      }

      // Apply pagination and ordering
      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => _mapToModel(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch incidents: $e');
    }
  }

  // Get incident by ID
  Future<UnsafeIncidentModel> getIncidentById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .select()
          .eq('id', id)
          .single();

      return _mapToModel(response);
    } catch (e) {
      throw Exception('Failed to fetch incident: $e');
    }
  }

  // Create new incident
  Future<UnsafeIncidentModel> createIncident(
      Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .insert(data)
          .select()
          .single();

      return _mapToModel(response);
    } catch (e) {
      throw Exception('Failed to create incident: $e');
    }
  }

  // Update incident
  Future<UnsafeIncidentModel> updateIncident(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return _mapToModel(response);
    } catch (e) {
      throw Exception('Failed to update incident: $e');
    }
  }

  // Delete incident
  Future<void> deleteIncident(String id) async {
    try {
      await _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete incident: $e');
    }
  }

  // Get statistics
  Future<IncidentStatsModel> getStats() async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.unsafeActionConditionTable)
          .select();

      final incidents = response as List<dynamic>;
      final total = incidents.length;

      final unsafeAction = incidents
          .where((item) => item['jenis_kejadian'] == 'unsafe_action')
          .length;
      final unsafeCondition = incidents
          .where((item) => item['jenis_kejadian'] == 'unsafe_condition')
          .length;

      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final recent = incidents.where((item) {
        final createdAt = DateTime.parse(item['created_at']);
        return createdAt.isAfter(sevenDaysAgo);
      }).length;

      final byPriority = <String, int>{};
      final byStatus = <String, int>{};

      for (var item in incidents) {
        final priority = item['prioritas'] as String? ?? 'medium';
        final status = item['status'] as String? ?? 'draft';

        byPriority[priority] = (byPriority[priority] ?? 0) + 1;
        byStatus[status] = (byStatus[status] ?? 0) + 1;
      }

      return IncidentStatsModel(
        totalIncidents: total,
        unsafeActionCount: unsafeAction,
        unsafeConditionCount: unsafeCondition,
        recentIncidents: recent,
        byPriority: byPriority,
        byStatus: byStatus,
      );
    } catch (e) {
      throw Exception('Failed to fetch stats: $e');
    }
  }

  // Upload photo
  Future<String> uploadPhoto(String filePath, String fileName) async {
    try {
      final file = File(filePath);
      await _supabase.storage
          .from(SupabaseConfig.storagePhotoBucket)
          .upload(fileName, file);

      final publicUrl = _supabase.storage
          .from(SupabaseConfig.storagePhotoBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Helper method to map JSON to model
  UnsafeIncidentModel _mapToModel(Map<String, dynamic> json) {
    return UnsafeIncidentModel(
      id: json['id'] as String,
      tanggalKejadian: DateTime.parse(json['tanggal_kejadian']),
      waktuKejadian: json['waktu_kejadian'] as String,
      lokasiKejadian: json['lokasi_kejadian'] as String,
      unitKerja: json['unit_kerja'] as String,
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
      korbanJumlah: json['korban_jumlah'] as int? ?? 0,
      fotoKejadian: (json['foto_kejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      videoKejadian: (json['video_kejadian'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      audioCatatan: json['audio_catatan'] as String?,
      prioritas: json['prioritas'] as String? ?? 'medium',
      severityLevel: json['severity_level'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gpsAccuracy: (json['gps_accuracy'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'draft',
      assignedTo: json['assigned_to'] as String?,
      assignedBy: json['assigned_by'] as String?,
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'])
          : null,
      investigasiDilakukan: json['investigasi_dilakukan'] as bool? ?? false,
      temuanInvestigasi: json['temuan_investigasi'] as String?,
      rekomendasiKoreksi: (json['rekomendasi_koreksi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      targetPenyelesaian: json['target_penyelesaian'] != null
          ? DateTime.parse(json['target_penyelesaian'])
          : null,
      aktualPenyelesaian: json['aktual_penyelesaian'] != null
          ? DateTime.parse(json['aktual_penyelesaian'])
          : null,
      createdBy: json['created_by'] as String?,
      createdAt:
          json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt:
          json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
