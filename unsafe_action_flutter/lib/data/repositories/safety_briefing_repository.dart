import 'dart:io';
import '../datasources/safety_briefing_datasource.dart';
import '../models/safety_briefing_model.dart';

class SafetyBriefingRepository {
  final SafetyBriefingDatasource _datasource;

  SafetyBriefingRepository(this._datasource);

  Future<List<SafetyBriefingModel>> getAll({
    int page = 1,
    int limit = 20,
    String? unitId,
    String? status,
  }) async {
    return await _datasource.getAll(
      page: page,
      limit: limit,
      unitId: unitId,
      status: status,
    );
  }

  Future<SafetyBriefingModel> getById(String id) async {
    return await _datasource.getById(id);
  }

  Future<SafetyBriefingModel> create(Map<String, dynamic> data) async {
    return await _datasource.create(data);
  }

  Future<SafetyBriefingModel> update(String id, Map<String, dynamic> data) async {
    return await _datasource.update(id, data);
  }

  Future<void> delete(String id) async {
    return await _datasource.delete(id);
  }

  Future<String> uploadPhoto(File file, String fileName) async {
    return await _datasource.uploadPhoto(file, fileName);
  }

  Future<void> deletePhoto(String fileName) async {
    return await _datasource.deletePhoto(fileName);
  }
}
