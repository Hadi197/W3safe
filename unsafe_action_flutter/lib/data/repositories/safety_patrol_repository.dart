import '../datasources/safety_patrol_datasource.dart';
import '../models/safety_patrol_model.dart';

class SafetyPatrolRepository {
  final SafetyPatrolDatasource _datasource = SafetyPatrolDatasource();

  Future<List<SafetyPatrol>> getAll({
    String? unit,
    String? status,
    String? jenis,
    String? urgensi,
    int page = 1,
    int limit = 10,
  }) {
    return _datasource.getAll(
      unit: unit,
      status: status,
      jenis: jenis,
      urgensi: urgensi,
      page: page,
      limit: limit,
    );
  }

  Future<SafetyPatrol?> getById(String id) {
    return _datasource.getById(id);
  }

  Future<SafetyPatrol> create(SafetyPatrol patrol) {
    return _datasource.create(patrol);
  }

  Future<SafetyPatrol> update(String id, SafetyPatrol patrol) {
    return _datasource.update(id, patrol);
  }

  Future<void> delete(String id) {
    return _datasource.delete(id);
  }

  Future<String> uploadPhoto(String filePath, String fileName) {
    return _datasource.uploadPhoto(filePath, fileName);
  }

  Future<String> uploadDocument(String filePath, String fileName) {
    return _datasource.uploadDocument(filePath, fileName);
  }

  Future<Map<String, dynamic>> getStatistics() {
    return _datasource.getStatistics();
  }

  Future<String> generateNomorPatrol() {
    return _datasource.generateNomorPatrol();
  }
}
