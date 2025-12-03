import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/safety_patrol_model.dart';

class SafetyPatrolDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all safety patrols with filters and pagination
  Future<List<SafetyPatrol>> getAll({
    String? unit,
    String? status,
    String? jenis,
    String? urgensi,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      dynamic query = _supabase
          .from('safety_patrol')
          .select()
          .order('tanggal_patrol', ascending: false)
          .range((page - 1) * limit, page * limit - 1);

      if (unit != null && unit.isNotEmpty) {
        query = query.eq('unit_id', unit);
      }
      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }
      if (jenis != null && jenis.isNotEmpty) {
        query = query.eq('jenis_patrol', jenis);
      }
      if (urgensi != null && urgensi.isNotEmpty) {
        query = query.eq('tingkat_urgensi', urgensi);
      }

      final response = await query;
      return (response as List)
          .map((item) => SafetyPatrol.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch safety patrols: $e');
    }
  }

  // Get safety patrol by ID
  Future<SafetyPatrol?> getById(String id) async {
    try {
      final response = await _supabase
          .from('safety_patrol')
          .select()
          .eq('id', id)
          .single();

      return SafetyPatrol.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch safety patrol: $e');
    }
  }

  // Create new safety patrol
  Future<SafetyPatrol> create(SafetyPatrol patrol) async {
    try {
      final data = patrol.toJson();
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');
      
      // Generate nomor patrol
      data['nomor_patrol'] = await generateNomorPatrol();

      final response = await _supabase
          .from('safety_patrol')
          .insert(data)
          .select()
          .single();

      return SafetyPatrol.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create safety patrol: $e');
    }
  }

  // Update safety patrol
  Future<SafetyPatrol> update(String id, SafetyPatrol patrol) async {
    try {
      final data = patrol.toJson();
      data.remove('id');
      data.remove('created_at');
      data.remove('created_by');
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('safety_patrol')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return SafetyPatrol.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update safety patrol: $e');
    }
  }

  // Delete safety patrol
  Future<void> delete(String id) async {
    try {
      await _supabase.from('safety_patrol').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete safety patrol: $e');
    }
  }

  // Upload photo
  Future<String> uploadPhoto(String filePath, String fileName) async {
    try {
      // For now, return empty string as placeholder
      // Implement actual file upload when needed
      return '';
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Upload document
  Future<String> uploadDocument(String filePath, String fileName) async {
    try {
      // For now, return empty string as placeholder
      // Implement actual file upload when needed
      return '';
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _supabase.from('safety_patrol').select();

      int total = response.length;
      int kritikal = 0;
      int mayor = 0;
      int perluFollowUp = 0;

      for (var item in response) {
        final patrol = SafetyPatrol.fromJson(item);
        if (patrol.temuanKritikal > 0) kritikal++;
        if (patrol.temuanMayor > 0) mayor++;
        if (patrol.perluFollowUp) perluFollowUp++;
      }

      return {
        'total': total,
        'temuanKritikal': kritikal,
        'temuanMayor': mayor,
        'perluFollowUp': perluFollowUp,
      };
    } catch (e) {
      throw Exception('Failed to fetch statistics: $e');
    }
  }

  // Generate nomor patrol (format: SP-YYYY-MM-XXXX)
  Future<String> generateNomorPatrol() async {
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');
      final prefix = 'SP-$year-$month';

      final response = await _supabase
          .from('safety_patrol')
          .select('nomor_patrol')
          .like('nomor_patrol', '$prefix%')
          .order('nomor_patrol', ascending: false)
          .limit(1);

      int nextNumber = 1;
      if (response.isNotEmpty) {
        final lastNumber = response.first['nomor_patrol'] as String;
        final parts = lastNumber.split('-');
        if (parts.length == 4) {
          nextNumber = (int.tryParse(parts[3]) ?? 0) + 1;
        }
      }

      return '$prefix-${nextNumber.toString().padLeft(4, '0')}';
    } catch (e) {
      throw Exception('Failed to generate nomor patrol: $e');
    }
  }
}
