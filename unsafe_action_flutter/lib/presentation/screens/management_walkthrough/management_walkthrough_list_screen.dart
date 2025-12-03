import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasources/management_walkthrough_datasource.dart';
import '../../../data/models/management_walkthrough_model.dart';
import '../../../core/theme/app_theme.dart';
import 'management_walkthrough_form_screen.dart';

class ManagementWalkthroughListScreen extends StatefulWidget {
  const ManagementWalkthroughListScreen({super.key});

  @override
  State<ManagementWalkthroughListScreen> createState() => _ManagementWalkthroughListScreenState();
}

class _ManagementWalkthroughListScreenState extends State<ManagementWalkthroughListScreen> {
  final _datasource = ManagementWalkthroughDatasource(Supabase.instance.client);
  List<ManagementWalkthroughModel> _items = [];
  Map<String, dynamic> _stats = {
    'total': 0,
    'temuanKritis': 0,
    'temuanMayor': 0,
    'perluFollowUp': 0,
  };
  bool _isLoading = false;
  int _currentPage = 1;
  String? _selectedStatus;
  String? _selectedJenis;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadStats();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await _datasource.getAll(
        page: _currentPage,
        limit: 20,
        status: _selectedStatus,
        jenisWalkthrough: _selectedJenis,
      );
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _datasource.getStatistics();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      // Ignore stats loading error
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Selesai';
      case 'in_progress':
        return 'Berlangsung';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Draft';
    }
  }

  String _getJenisText(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'rutin':
        return 'Rutin';
      case 'terjadwal':
        return 'Terjadwal';
      case 'insidental':
        return 'Insidental';
      case 'follow_up':
        return 'Follow Up';
      case 'khusus':
        return 'Khusus';
      default:
        return jenis;
    }
  }

  Color _getUrgensiColor(String urgensi) {
    switch (urgensi.toLowerCase()) {
      case 'kritis':
        return Colors.red;
      case 'tinggi':
        return Colors.orange;
      case 'normal':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management Walkthrough'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadData();
              _loadStats();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    '${_stats['total']}',
                    Colors.blue,
                    Icons.assignment,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Kritis',
                    '${_stats['temuanKritis']}',
                    Colors.red,
                    Icons.warning,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Mayor',
                    '${_stats['temuanMayor']}',
                    Colors.orange,
                    Icons.error_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Follow Up',
                    '${_stats['perluFollowUp']}',
                    Colors.green,
                    Icons.follow_the_signs,
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Semua Status')),
                      DropdownMenuItem(value: 'draft', child: Text('Draft')),
                      DropdownMenuItem(value: 'in_progress', child: Text('Berlangsung')),
                      DropdownMenuItem(value: 'completed', child: Text('Selesai')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Dibatalkan')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedStatus = value);
                      _loadData();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedJenis,
                    decoration: const InputDecoration(
                      labelText: 'Jenis',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Semua Jenis')),
                      DropdownMenuItem(value: 'rutin', child: Text('Rutin')),
                      DropdownMenuItem(value: 'terjadwal', child: Text('Terjadwal')),
                      DropdownMenuItem(value: 'insidental', child: Text('Insidental')),
                      DropdownMenuItem(value: 'follow_up', child: Text('Follow Up')),
                      DropdownMenuItem(value: 'khusus', child: Text('Khusus')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedJenis = value);
                      _loadData();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? const Center(
                        child: Text('Belum ada data Management Walkthrough'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _loadData();
                          await _loadStats();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  // Navigate to detail or form
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManagementWalkthroughFormScreen(
                                        walkthrough: item,
                                      ),
                                    ),
                                  ).then((_) => _loadData());
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.nomorWalkthrough,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(item.status).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _getStatusText(item.status),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: _getStatusColor(item.status),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.areaInspeksi,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatDate(item.tanggalWalkthrough),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.waktuMulai,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item.pimpinanWalkthrough,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _getJenisText(item.jenisWalkthrough),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getUrgensiColor(item.tingkatUrgensi).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.tingkatUrgensi.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: _getUrgensiColor(item.tingkatUrgensi),
                                              ),
                                            ),
                                          ),
                                          if (item.perluFollowUp) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'FOLLOW UP',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (item.jumlahTemuan > 0) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            _buildTemuanBadge(
                                              'Kritis: ${item.temuanKritis}',
                                              Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            _buildTemuanBadge(
                                              'Mayor: ${item.temuanMayor}',
                                              Colors.orange,
                                            ),
                                            const SizedBox(width: 8),
                                            _buildTemuanBadge(
                                              'Minor: ${item.temuanMinor}',
                                              Colors.yellow,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManagementWalkthroughFormScreen(),
            ),
          ).then((_) {
            _loadData();
            _loadStats();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemuanBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color.withOpacity(1.0),
        ),
      ),
    );
  }
}
