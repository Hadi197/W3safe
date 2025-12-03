import 'dart:io';
import '../datasources/incident_remote_datasource.dart';
import '../models/unsafe_incident_model.dart';

class IncidentRepository {
  final IncidentRemoteDatasource _remoteDatasource;

  IncidentRepository(this._remoteDatasource);

  Future<Map<String, dynamic>> getIncidents({
    int page = 1,
    int limit = 20,
    String? search,
    String? jenisKejadian,
    String? status,
    String? prioritas,
    String? unitKerja,
  }) async {
    return await _remoteDatasource.getIncidents(
      page: page,
      limit: limit,
      search: search,
      jenisKejadian: jenisKejadian,
      status: status,
      prioritas: prioritas,
      unitKerja: unitKerja,
    );
  }

  Future<UnsafeIncidentModel> getIncidentById(String id) async {
    return await _remoteDatasource.getIncidentById(id);
  }

  Future<UnsafeIncidentModel> createIncident(Map<String, dynamic> data) async {
    return await _remoteDatasource.createIncident(data);
  }

  Future<UnsafeIncidentModel> updateIncident(
      String id, Map<String, dynamic> data) async {
    return await _remoteDatasource.updateIncident(id, data);
  }

  Future<void> deleteIncident(String id) async {
    return await _remoteDatasource.deleteIncident(id);
  }

  Future<IncidentStatsModel> getStats() async {
    return await _remoteDatasource.getStats();
  }

  Future<String> uploadPhoto(String filePath, String fileName) async {
    return await _remoteDatasource.uploadPhoto(filePath, fileName);
  }
}
