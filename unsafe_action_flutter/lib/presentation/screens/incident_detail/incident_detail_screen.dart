import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class IncidentDetailScreen extends StatelessWidget {
  final String incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final incident = {
      'id': incidentId,
      'tanggal': '2025-12-01',
      'waktu': '14:30',
      'jenis': 'unsafe_condition',
      'kategori': 'Pencahayaan Kurang',
      'lokasi': 'Dermaga Utama',
      'unit': 'Unit Banjarmasin',
      'deskripsi': 'Area bongkar muat memiliki pencahayaan yang sangat kurang terutama pada malam hari. Kondisi ini berpotensi menyebabkan kecelakaan kerja.',
      'pelapor': 'Ahmad Rizki',
      'jabatan': 'Safety Officer',
      'kontak': '081234567890',
      'prioritas': 'high',
      'status': 'reported',
      'tindakan': 'Area telah dipasang lampu sementara dan diberi tanda bahaya',
      'area_diamankan': true,
      'korban': false,
      'photos': [
        'https://via.placeholder.com/400x300?text=Photo+1',
        'https://via.placeholder.com/400x300?text=Photo+2',
      ],
    };

    final isUnsafeAction = incident['jenis'] == 'unsafe_action';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/incident/create',
                arguments: {'id': incidentId},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status & Type Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isUnsafeAction ? AppTheme.errorColor : AppTheme.warningColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUnsafeAction ? AppTheme.errorColor : AppTheme.warningColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isUnsafeAction ? Icons.warning_amber_rounded : Icons.flash_on,
                        color: isUnsafeAction ? AppTheme.errorColor : AppTheme.warningColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isUnsafeAction ? 'Unsafe Action' : 'Unsafe Condition',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnsafeAction ? AppTheme.errorColor : AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.getPriorityColor(incident['prioritas'] as String)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.getPriorityColor(incident['prioritas'] as String),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.priority_high,
                        color: AppTheme.getPriorityColor(incident['prioritas'] as String),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (incident['prioritas'] as String).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getPriorityColor(incident['prioritas'] as String),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusColor(incident['status'] as String)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.getStatusColor(incident['status'] as String),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.getStatusColor(incident['status'] as String),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        incident['status'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getStatusColor(incident['status'] as String),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Kategori
          Text(
            incident['kategori'] as String,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Info Grid
          _buildInfoCard(
            icon: Icons.calendar_today,
            label: 'Tanggal & Waktu',
            value: '${incident['tanggal']} ${incident['waktu']}',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on,
            label: 'Lokasi',
            value: incident['lokasi'] as String,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.business,
            label: 'Unit Kerja',
            value: incident['unit'] as String,
          ),
          const SizedBox(height: 24),
          
          // Deskripsi
          const Text(
            'Deskripsi Kejadian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                incident['deskripsi'] as String,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Tindakan Segera
          if (incident['tindakan'] != null) ...[
            const Text(
              'Tindakan Segera',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  incident['tindakan'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Status Flags
          Row(
            children: [
              Expanded(
                child: Card(
                  color: incident['area_diamankan'] == true
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          incident['area_diamankan'] == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: incident['area_diamankan'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Area Diamankan',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: incident['korban'] == true
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          incident['korban'] == true
                              ? Icons.warning
                              : Icons.check_circle,
                          color: incident['korban'] == true
                              ? Colors.red
                              : Colors.green,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          incident['korban'] == true ? 'Ada Korban' : 'Tidak Ada Korban',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Photos
          if ((incident['photos'] as List).isNotEmpty) ...[
            const Text(
              'Foto Kejadian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (incident['photos'] as List).length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        (incident['photos'] as List)[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 48, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Pelapor
          const Text(
            'Informasi Pelapor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        incident['pelapor'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.work, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        incident['jabatan'] as String,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        incident['kontak'] as String,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
