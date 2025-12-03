import 'dart:io';
import '../datasources/management_walkthrough_datasource.dart';
import '../models/management_walkthrough_model.dart';

class ManagementWalkthroughRepository {
  final ManagementWalkthroughDatasource _datasource;

  ManagementWalkthroughRepository(this._datasource);

  Future<List<ManagementWalkthroughModel>> getAll({
    int page = 1,
    int limit = 20,
    String? unitId,
    String? status,
    String? jenisWalkthrough,
    String? tingkatUrgensi,
  }) async {
    return await _datasource.getAll(
      page: page,
      limit: limit,
      unitId: unitId,
      status: status,
      jenisWalkthrough: jenisWalkthrough,
      tingkatUrgensi: tingkatUrgensi,
    );
  }

  Future<ManagementWalkthroughModel> getById(String id) async {
    return await _datasource.getById(id);
  }

  Future<ManagementWalkthroughModel> create(Map<String, dynamic> data) async {
    return await _datasource.create(data);
  }

  Future<ManagementWalkthroughModel> update(String id, Map<String, dynamic> data) async {
    return await _datasource.update(id, data);
  }

  Future<void> delete(String id) async {
    return await _datasource.delete(id);
  }

  Future<String> uploadPhoto(File file, String walkthroughId) async {
    return await _datasource.uploadPhoto(file, walkthroughId);
  }

  Future<String> uploadDocument(File file, String walkthroughId) async {
    return await _datasource.uploadDocument(file, walkthroughId);
  }

  Future<Map<String, dynamic>> getStatistics() async {
    return await _datasource.getStatistics();
  }

  Future<String> generateNomorWalkthrough() async {
    return await _datasource.generateNomorWalkthrough();
  }
}
