import 'package:flutter/material.dart';
import '../../../data/models/safety_patrol_model.dart';
import '../../../data/repositories/safety_patrol_repository.dart';
import 'safety_patrol_form_screen.dart';

class SafetyPatrolListScreen extends StatefulWidget {
  const SafetyPatrolListScreen({Key? key}) : super(key: key);

  @override
  State<SafetyPatrolListScreen> createState() => _SafetyPatrolListScreenState();
}

class _SafetyPatrolListScreenState extends State<SafetyPatrolListScreen> {
  final SafetyPatrolRepository _repository = SafetyPatrolRepository();
  List<SafetyPatrol> _items = [];
  Map<String, dynamic> _stats = {};
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
      final items = await _repository.getAll(
        status: _selectedStatus,
        jenis: _selectedJenis,
        page: _currentPage,
      );
      setState(() {
        _items = items;
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

  Future<void> _loadStats() async {
    try {
      final stats = await _repository.getStatistics();
      setState(() => _stats = stats);
    } catch (e) {
      // Ignore stats error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Patrol'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
          await _loadStats();
        },
        child: Column(
          children: [
            // Stats cards
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    'Total',
                    _stats['total']?.toString() ?? '0',
                    Icons.list_alt,
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Kritikal',
                    _stats['temuanKritikal']?.toString() ?? '0',
                    Icons.warning,
                    Colors.red,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Mayor',
                    _stats['temuanMayor']?.toString() ?? '0',
                    Icons.error_outline,
                    Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Follow Up',
                    _stats['perluFollowUp']?.toString() ?? '0',
                    Icons.follow_the_signs,
                    Colors.green,
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
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(value: 'submitted', child: Text('Submitted')),
                        DropdownMenuItem(value: 'reviewed', child: Text('Reviewed')),
                        DropdownMenuItem(value: 'closed', child: Text('Closed')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedStatus = value);
                        _loadData();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedJenis,
                      decoration: const InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(value: 'rutin', child: Text('Rutin')),
                        DropdownMenuItem(value: 'terjadwal', child: Text('Terjadwal')),
                        DropdownMenuItem(value: 'insidental', child: Text('Insidental')),
                        DropdownMenuItem(value: 'khusus', child: Text('Khusus')),
                        DropdownMenuItem(value: 'malam', child: Text('Malam')),
                        DropdownMenuItem(value: 'emergency', child: Text('Emergency')),
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

            const SizedBox(height: 16),

            // List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const Center(child: Text('Tidak ada data'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return _buildPatrolCard(_items[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SafetyPatrolFormScreen(),
            ),
          ).then((_) => _loadData());
        },
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatrolCard(SafetyPatrol patrol) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SafetyPatrolFormScreen(patrol: patrol),
            ),
          ).then((_) => _loadData());
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      patrol.nomorPatrol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildStatusBadge(patrol.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    patrol.tanggalPatrol != null
                        ? '${patrol.tanggalPatrol!.day}/${patrol.tanggalPatrol!.month}/${patrol.tanggalPatrol!.year}'
                        : '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    patrol.waktuMulai ?? '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (patrol.shift != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        patrol.shift!.toUpperCase(),
                        style: const TextStyle(fontSize: 10, color: Colors.purple),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      patrol.areaPatrol,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    patrol.ketuaPatrol,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (patrol.jenisPatrol != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        patrol.jenisPatrol!.toUpperCase(),
                        style: const TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    ),
                    if (patrol.tingkatUrgensi != 'normal') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getUrgensiColor(patrol.tingkatUrgensi).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          patrol.tingkatUrgensi.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getUrgensiColor(patrol.tingkatUrgensi),
                          ),
                        ),
                      ),
                    ],
                    if (patrol.perluFollowUp) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'FOLLOW UP',
                          style: TextStyle(fontSize: 10, color: Colors.green),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTemuanBadge('K', patrol.temuanKritikal, Colors.red),
                  const SizedBox(width: 8),
                  _buildTemuanBadge('M', patrol.temuanMayor, Colors.orange),
                  const SizedBox(width: 8),
                  _buildTemuanBadge('m', patrol.temuanMinor, Colors.yellow[700]!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'draft':
        color = Colors.grey;
        break;
      case 'submitted':
        color = Colors.blue;
        break;
      case 'reviewed':
        color = Colors.green;
        break;
      case 'closed':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTemuanBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getUrgensiColor(String urgensi) {
    switch (urgensi) {
      case 'kritis':
        return Colors.red;
      case 'tinggi':
        return Colors.orange;
      case 'rendah':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
