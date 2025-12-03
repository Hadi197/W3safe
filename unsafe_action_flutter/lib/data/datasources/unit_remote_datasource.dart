import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';

class UnitRemoteDatasource {
  final SupabaseClient _supabase;

  UnitRemoteDatasource(this._supabase);

  Future<List<UnitModel>> getUnits({String? status}) async {
    try {
      debugPrint('🔵 Loading all data from units table...');
      
      // Query all from units table (includes wilayah, areas, and units)
      final response = await _supabase.from('units').select('*');
      
      debugPrint('🔵 Raw response length: ${(response as List).length}');
      
      // Map all records to UnitModel
      final allUnits = (response as List)
          .where((unitData) {
            // Filter out records with null nama
            final nama = unitData['nama'] as String?;
            return nama != null && nama.isNotEmpty;
          })
          .map((unitData) {
            final tipe = unitData['tipe'] as String?;
            debugPrint('🔵 ${unitData['nama']} (tipe: $tipe)');
            
            // Map to UnitModel
            return UnitModel(
              id: unitData['id'] as String,
              kodeUnit: unitData['kode'] as String? ?? unitData['id'] as String,
              namaUnit: unitData['nama'] as String,
              lokasi: null,
              status: (unitData['aktif'] as bool? ?? true) ? 'aktif' : 'nonaktif',
              wilayahId: unitData['wilayah_id'] as String?,
              wilayahNama: tipe == 'area' || tipe == 'unit' ? 'Wilayah 3' : null,
              areaId: unitData['area_id'] as String?,
              areaNama: tipe == 'unit' ? _getAreaName(unitData['area_id'] as String?, response as List) : null,
              createdAt: unitData['created_at'] != null 
                  ? DateTime.parse(unitData['created_at'] as String)
                  : null,
              updatedAt: unitData['updated_at'] != null
                  ? DateTime.parse(unitData['updated_at'] as String)
                  : null,
            );
          })
          .toList();
      
      // Sort: Wilayah first, then Areas, then Units alphabetically
      allUnits.sort((a, b) {
        // Detect types based on name patterns
        final aIsWilayah = a.namaUnit.toLowerCase().contains('wilayah');
        final bIsWilayah = b.namaUnit.toLowerCase().contains('wilayah');
        final aIsArea = a.namaUnit.toLowerCase().startsWith('area');
        final bIsArea = b.namaUnit.toLowerCase().startsWith('area');
        
        // Wilayah first
        if (aIsWilayah && !bIsWilayah) return -1;
        if (!aIsWilayah && bIsWilayah) return 1;
        
        // Then Areas
        if (aIsArea && !bIsArea) return -1;
        if (!aIsArea && bIsArea) return 1;
        
        // Same type, sort alphabetically
        return a.namaUnit.compareTo(b.namaUnit);
      });
      
      debugPrint('✅ Total units loaded: ${allUnits.length}');
      
      return allUnits;
    } catch (e) {
      debugPrint('❌ Error loading units: $e');
      throw Exception('Failed to fetch units: $e');
    }
  }

  // Helper to get area name from area_id
  String? _getAreaName(String? areaId, List allRecords) {
    if (areaId == null) return null;
    
    try {
      final areaRecord = allRecords.firstWhere(
        (record) => record['id'] == areaId && record['tipe'] == 'area',
      );
      return areaRecord['nama'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<UnitModel?> getUnitById(String id) async {
    try {
      final response = await _supabase
          .from('units')
          .select('*')
          .eq('id', id)
          .single();

      return UnitModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch unit: $e');
    }
  }
}
