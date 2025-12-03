import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/safety_briefing_model.dart';

class SafetyBriefingDatasource {
  final SupabaseClient _supabase;
  static const String _tableName = 'safety_briefing';
  static const String _storageBucket = 'safety-briefing-photos';

  SafetyBriefingDatasource(this._supabase);

  // Get all safety briefings with pagination
  Future<List<SafetyBriefingModel>> getAll({
    int page = 1,
    int limit = 20,
    String? unitId,
    String? status,
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

      query = query
          .order('tanggal', ascending: false)
          .order('waktu_mulai', ascending: false);

      final from = (page - 1) * limit;
      final to = from + limit - 1;
      query = query.range(from, to);

      final response = await query;
      
      return (response as List)
          .map((json) => SafetyBriefingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch safety briefings: $e');
    }
  }

  // Get single safety briefing by ID
  Future<SafetyBriefingModel> getById(String id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return SafetyBriefingModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch safety briefing: $e');
    }
  }

  // Create new safety briefing
  Future<SafetyBriefingModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return SafetyBriefingModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create safety briefing: $e');
    }
  }

  // Update safety briefing
  Future<SafetyBriefingModel> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return SafetyBriefingModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update safety briefing: $e');
    }
  }

  // Delete safety briefing
  Future<void> delete(String id) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete safety briefing: $e');
    }
  }

  // Upload photo
  Future<String> uploadPhoto(File file, String fileName) async {
    try {
      await _supabase.storage
          .from(_storageBucket)
          .upload(fileName, file);

      final publicUrl = _supabase.storage
          .from(_storageBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Delete photo
  Future<void> deletePhoto(String fileName) async {
    try {
      await _supabase.storage
          .from(_storageBucket)
          .remove([fileName]);
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }
}
