import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/management_walkthrough_model.dart';

class ManagementWalkthroughDatasource {
  final SupabaseClient _supabase;
  static const String _tableName = 'management_walkthrough';
  static const String _storageBucket = 'safety-forum-photos';

  ManagementWalkthroughDatasource(this._supabase);

  // Get all management walkthroughs with pagination
  Future<List<ManagementWalkthroughModel>> getAll({
    int page = 1,
    int limit = 20,
    String? unitId,
    String? status,
    String? jenisWalkthrough,
    String? tingkatUrgensi,
  }) async {
    try {
      dynamic query = _supabase
          .from(_tableName)
          .select();

      if (unitId != null && unitId.isNotEmpty) {
        query = query.eq('unit_id', unitId);
      }

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      if (jenisWalkthrough != null && jenisWalkthrough.isNotEmpty) {
        query = query.eq('jenis_walkthrough', jenisWalkthrough);
      }

      if (tingkatUrgensi != null && tingkatUrgensi.isNotEmpty) {
        query = query.eq('tingkat_urgensi', tingkatUrgensi);
      }

      query = query
          .order('tanggal_walkthrough', ascending: false)
          .order('waktu_mulai', ascending: false);

      final from = (page - 1) * limit;
      final to = from + limit - 1;
      query = query.range(from, to);

      final response = await query;
      
      return (response as List)
          .map((json) => ManagementWalkthroughModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch management walkthroughs: $e');
    }
  }

  // Get single management walkthrough by ID
  Future<ManagementWalkthroughModel> getById(String id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return ManagementWalkthroughModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch management walkthrough: $e');
    }
  }

  // Create new management walkthrough
  Future<ManagementWalkthroughModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return ManagementWalkthroughModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create management walkthrough: $e');
    }
  }

  // Update management walkthrough
  Future<ManagementWalkthroughModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return ManagementWalkthroughModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update management walkthrough: $e');
    }
  }

  // Delete management walkthrough
  Future<void> delete(String id) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete management walkthrough: $e');
    }
  }

  // Upload photo to storage
  Future<String> uploadPhoto(File file, String walkthroughId) async {
    try {
      final fileName = '${walkthroughId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'walkthrough/$fileName';

      await _supabase.storage
          .from(_storageBucket)
          .upload(filePath, file);

      final publicUrl = _supabase.storage
          .from(_storageBucket)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Upload document to storage
  Future<String> uploadDocument(File file, String walkthroughId) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName = '${walkthroughId}/${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'walkthrough-docs/$fileName';

      await _supabase.storage
          .from(_storageBucket)
          .upload(filePath, file);

      final publicUrl = _supabase.storage
          .from(_storageBucket)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select();

      final data = response as List;
      
      int total = data.length;
      int temuanKritis = 0;
      int temuanMayor = 0;
      int perluFollowUp = 0;

      for (var item in data) {
        temuanKritis += (item['temuan_kritis'] as int?) ?? 0;
        temuanMayor += (item['temuan_mayor'] as int?) ?? 0;
        if (item['perlu_follow_up'] == true) {
          perluFollowUp++;
        }
      }

      return {
        'total': total,
        'temuanKritis': temuanKritis,
        'temuanMayor': temuanMayor,
        'perluFollowUp': perluFollowUp,
      };
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }

  // Generate nomor walkthrough
  Future<String> generateNomorWalkthrough() async {
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');
      final prefix = 'MW-$year-$month';

      final response = await _supabase
          .from(_tableName)
          .select('nomor_walkthrough')
          .like('nomor_walkthrough', '$prefix%')
          .order('nomor_walkthrough', ascending: false)
          .limit(1);

      int nextNumber = 1;
      if (response.isNotEmpty) {
        final lastNumber = (response[0]['nomor_walkthrough'] as String).split('-').last;
        nextNumber = (int.tryParse(lastNumber) ?? 0) + 1;
      }

      return '$prefix-${nextNumber.toString().padLeft(4, '0')}';
    } catch (e) {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');
      return 'MW-$year-$month-0001';
    }
  }
}
