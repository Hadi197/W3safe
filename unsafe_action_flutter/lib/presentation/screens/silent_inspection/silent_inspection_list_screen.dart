import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasources/silent_inspection_datasource.dart';
import '../../../data/repositories/silent_inspection_repository.dart';
import '../../../data/models/silent_inspection_model.dart';
import 'silent_inspection_form_screen.dart';

class SilentInspectionListScreen extends StatefulWidget {
  const SilentInspectionListScreen({Key? key}) : super(key: key);

  @override
  State<SilentInspectionListScreen> createState() =>
      _SilentInspectionListScreenState();
}

class _SilentInspectionListScreenState
    extends State<SilentInspectionListScreen> {
  final _repository = SilentInspectionRepository(
    SilentInspectionDatasource(Supabase.instance.client),
  );

  List<SilentInspectionModel> _inspections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    setState(() => _isLoading = true);
    try {
      final inspections = await _repository.getAll();
      setState(() {
        _inspections = inspections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _getRiskColor(String? risk) {
    switch (risk?.toLowerCase()) {
      case 'rendah':
        return '🟢';
      case 'sedang':
        return '🟡';
      case 'tinggi':
        return '🟠';
      case 'sangat_tinggi':
        return '🔴';
      default:
        return '⚪';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silent Inspection'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _inspections.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Belum ada data inspeksi'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _navigateToForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Inspeksi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadInspections,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _inspections.length,
                    itemBuilder: (context, index) {
                      final inspection = _inspections[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            inspection.areaInspeksi,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('📅 ${inspection.tanggal}'),
                              if (inspection.waktuMulai != null)
                                Text('🕐 ${inspection.waktuMulai} - ${inspection.waktuSelesai ?? "-"}'),
                              Text(
                                  '📊 Temuan: ${inspection.jumlahTemuan} (C:${inspection.temuanCritical} M:${inspection.temuanMajor} m:${inspection.temuanMinor})'),
                              Row(
                                children: [
                                  Text(
                                      '${_getRiskColor(inspection.tingkatRisiko)} ${inspection.tingkatRisiko ?? "N/A"}'),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(inspection.status),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      inspection.status.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (inspection.fotoKondisiUnsafe.isNotEmpty ||
                                  inspection.fotoPerilakuUnsafe.isNotEmpty)
                                Text(
                                  '📷 ${inspection.fotoKondisiUnsafe.length + inspection.fotoPerilakuUnsafe.length} foto',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteInspection(inspection.id!),
                          ),
                          onTap: () => _navigateToForm(inspection: inspection),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToForm({SilentInspectionModel? inspection}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SilentInspectionFormScreen(
          inspection: inspection,
        ),
      ),
    );

    if (result == true) {
      _loadInspections();
    }
  }

  Future<void> _deleteInspection(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus data inspeksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.delete(id);
        _loadInspections();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inspeksi berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
