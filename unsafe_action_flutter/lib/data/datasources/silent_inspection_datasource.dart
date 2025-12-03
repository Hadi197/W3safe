import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/silent_inspection_model.dart';

class SilentInspectionDatasource {
  final SupabaseClient supabase;

  SilentInspectionDatasource(this.supabase);

  Future<List<SilentInspectionModel>> getAll({
    String? unitId,
    String? tingkatRisiko,
    String? status,
  }) async {
    dynamic query = supabase
        .from('silent_inspection')
        .select('*')
        .order('created_at', ascending: false);

    if (unitId != null && unitId.isNotEmpty) {
      query = query.eq('unit_id', unitId);
    }
    if (tingkatRisiko != null && tingkatRisiko.isNotEmpty) {
      query = query.eq('tingkat_risiko', tingkatRisiko);
    }
    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    final response = await query;
    return (response as List)
        .map((json) => SilentInspectionModel.fromJson(json))
        .toList();
  }

  Future<SilentInspectionModel?> getById(String id) async {
    final response = await supabase
        .from('silent_inspection')
        .select('*')
        .eq('id', id)
        .single();

    return SilentInspectionModel.fromJson(response);
  }

  Future<SilentInspectionModel> create(Map<String, dynamic> data) async {
    final response = await supabase
        .from('silent_inspection')
        .insert(data)
        .select()
        .single();

    return SilentInspectionModel.fromJson(response);
  }

  Future<SilentInspectionModel> update(String id, Map<String, dynamic> data) async {
    final response = await supabase
        .from('silent_inspection')
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return SilentInspectionModel.fromJson(response);
  }

  Future<void> delete(String id) async {
    await supabase.from('silent_inspection').delete().eq('id', id);
  }

  Future<String> uploadPhoto(String filePath, String bucket) async {
    final file = await supabase.storage.from(bucket).upload(
          filePath,
          filePath as dynamic,
        );

    return supabase.storage.from(bucket).getPublicUrl(file);
  }
}
