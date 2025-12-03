import '../datasources/silent_inspection_datasource.dart';
import '../models/silent_inspection_model.dart';

class SilentInspectionRepository {
  final SilentInspectionDatasource datasource;

  SilentInspectionRepository(this.datasource);

  Future<List<SilentInspectionModel>> getAll({
    String? unitId,
    String? tingkatRisiko,
    String? status,
  }) {
    return datasource.getAll(
      unitId: unitId,
      tingkatRisiko: tingkatRisiko,
      status: status,
    );
  }

  Future<SilentInspectionModel?> getById(String id) {
    return datasource.getById(id);
  }

  Future<SilentInspectionModel> create(Map<String, dynamic> data) {
    return datasource.create(data);
  }

  Future<SilentInspectionModel> update(String id, Map<String, dynamic> data) {
    return datasource.update(id, data);
  }

  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  Future<String> uploadPhoto(String filePath, String bucket) {
    return datasource.uploadPhoto(filePath, bucket);
  }
}
