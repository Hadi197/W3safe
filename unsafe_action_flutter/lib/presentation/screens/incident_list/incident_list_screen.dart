import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  String _selectedJenis = '';
  String _selectedStatus = '';
  String _selectedPrioritas = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data
  final List<Map<String, dynamic>> _incidents = [
    {
      'id': '1',
      'tanggal': '2025-12-01',
      'waktu': '14:30',
      'jenis': 'unsafe_condition',
      'kategori': 'Pencahayaan Kurang',
      'lokasi': 'Dermaga Utama',
      'unit': 'Unit Banjarmasin',
      'pelapor': 'Ahmad Rizki',
      'prioritas': 'high',
      'status': 'reported',
    },
    {
      'id': '2',
      'tanggal': '2025-11-30',
      'waktu': '10:15',
      'jenis': 'unsafe_action',
      'kategori': 'Tidak Menggunakan APD',
      'lokasi': 'Gudang B',
      'unit': 'Unit Samarinda',
      'pelapor': 'Budi Santoso',
      'prioritas': 'critical',
      'status': 'investigating',
    },
    {
      'id': '3',
      'tanggal': '2025-11-29',
      'waktu': '08:00',
      'jenis': 'unsafe_condition',
      'kategori': 'Lantai Licin/Basah',
      'lokasi': 'Area Produksi',
      'unit': 'Unit Balikpapan',
      'pelapor': 'Citra Dewi',
      'prioritas': 'medium',
      'status': 'resolved',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Laporan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari laporan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Filter Chips
          if (_selectedJenis.isNotEmpty ||
              _selectedStatus.isNotEmpty ||
              _selectedPrioritas.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedJenis.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(_selectedJenis == 'unsafe_action'
                            ? 'Unsafe Action'
                            : 'Unsafe Condition'),
                        onDeleted: () => setState(() => _selectedJenis = ''),
                      ),
                    ),
                  if (_selectedStatus.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(_selectedStatus),
                        onDeleted: () => setState(() => _selectedStatus = ''),
                      ),
                    ),
                  if (_selectedPrioritas.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(_selectedPrioritas),
                        onDeleted: () => setState(() => _selectedPrioritas = ''),
                      ),
                    ),
                ],
              ),
            ),
          
          // Incident List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _incidents.length,
                itemBuilder: (context, index) {
                  final incident = _incidents[index];
                  return _buildIncidentCard(incident);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/incident/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIncidentCard(Map<String, dynamic> incident) {
    final isUnsafeAction = incident['jenis'] == 'unsafe_action';
    final jenisColor = isUnsafeAction ? AppTheme.errorColor : AppTheme.warningColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/incident/detail',
            arguments: {'id': incident['id']},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: jenisColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isUnsafeAction ? 'Unsafe Action' : 'Unsafe Condition',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: jenisColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.getPriorityColor(incident['prioritas'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      incident['prioritas'].toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getPriorityColor(incident['prioritas']),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.getStatusColor(incident['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      incident['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getStatusColor(incident['status']),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                incident['kategori'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    incident['lokasi'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${incident['tanggal']} ${incident['waktu']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jenis Kejadian', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Unsafe Action'),
                    selected: _selectedJenis == 'unsafe_action',
                    onSelected: (selected) {
                      setState(() =>
                          _selectedJenis = selected ? 'unsafe_action' : '');
                      Navigator.pop(context);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Unsafe Condition'),
                    selected: _selectedJenis == 'unsafe_condition',
                    onSelected: (selected) {
                      setState(() =>
                          _selectedJenis = selected ? 'unsafe_condition' : '');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppConstants.statusList.map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: _selectedStatus == status,
                    onSelected: (selected) {
                      setState(() => _selectedStatus = selected ? status : '');
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedJenis = '';
                _selectedStatus = '';
                _selectedPrioritas = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
