import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasources/silent_inspection_datasource.dart';
import '../../../data/repositories/silent_inspection_repository.dart';
import '../../../data/models/silent_inspection_model.dart';

class SilentInspectionFormScreen extends StatefulWidget {
  final SilentInspectionModel? inspection;

  const SilentInspectionFormScreen({Key? key, this.inspection})
      : super(key: key);

  @override
  State<SilentInspectionFormScreen> createState() =>
      _SilentInspectionFormScreenState();
}

class _SilentInspectionFormScreenState
    extends State<SilentInspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = SilentInspectionRepository(
    SilentInspectionDatasource(Supabase.instance.client),
  );
  final supabase = Supabase.instance.client;

  // Form controllers
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay? _endTime;
  String _selectedUnit = '';
  final _areaController = TextEditingController();
  String _kategoriBahaya = '';
  int _temuanCritical = 0;
  int _temuanMajor = 0;
  int _temuanMinor = 0;
  final _deskripsiTemuanController = TextEditingController();
  double _skorKepatuhan = 0;
  String _tingkatRisiko = '';
  String _kondisiHousekeeping = '';
  String _penggunaanApd = '';
  final _rekomendasiController = TextEditingController();
  final _tindakanKorektifController = TextEditingController();
  final _picTindakLanjutController = TextEditingController();
  DateTime? _targetPenyelesaian;
  String _statusTindakLanjut = 'open';
  String _status = 'draft';
  final _catatanController = TextEditingController();

  List<File> _fotoKondisi = [];
  List<File> _fotoPerilaku = [];
  List<Map<String, dynamic>> _unitsFromDb = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUnits();
    if (widget.inspection != null) {
      _populateForm();
    }
  }

  Future<void> _loadUnits() async {
    try {
      final response = await supabase
          .from('units')
          .select('id, nama')
          .eq('aktif', true)
          .order('nama');

      setState(() {
        _unitsFromDb = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error loading units: $e');
    }
  }

  void _populateForm() {
    // TODO: Populate form with existing data
  }

  Future<void> _pickImages(bool isKondisi) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (images != null) {
      setState(() {
        if (isKondisi) {
          _fotoKondisi.addAll(images.map((xfile) => File(xfile.path)));
        } else {
          _fotoPerilaku.addAll(images.map((xfile) => File(xfile.path)));
        }
      });
    }
  }

  Future<void> _takePicture(bool isKondisi) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        if (isKondisi) {
          _fotoKondisi.add(File(image.path));
        } else {
          _fotoPerilaku.add(File(image.path));
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_areaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Area inspeksi harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get current user ID
      String userId;
      final session = supabase.auth.currentSession;
      final userEmail = session?.user.email ?? 'Unknown';

      if (session != null && session.user.id.isNotEmpty) {
        userId = session.user.id;
        debugPrint('✅ User logged in: $userEmail (ID: $userId)');
      } else {
        final user = supabase.auth.currentUser;
        if (user != null && user.id.isNotEmpty) {
          userId = user.id;
          debugPrint('⚠️ Using currentUser fallback: $userEmail (ID: $userId)');
        } else {
          throw Exception('User not authenticated');
        }
      }

      // Upload photos kondisi unsafe
      List<String> kondisiUrls = [];
      if (_fotoKondisi.isNotEmpty) {
        debugPrint('📷 Uploading ${_fotoKondisi.length} kondisi photos...');
        for (int i = 0; i < _fotoKondisi.length; i++) {
          try {
            final file = _fotoKondisi[i];
            final fileName =
                'silent-inspection-kondisi/temp_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

            debugPrint('📤 Uploading kondisi photo ${i + 1}/${_fotoKondisi.length}: $fileName');

            await supabase.storage
                .from('silent-inspection-photos')
                .upload(fileName, file);

            final photoUrl = supabase.storage
                .from('silent-inspection-photos')
                .getPublicUrl(fileName);

            kondisiUrls.add(photoUrl);
            debugPrint('✅ Kondisi photo ${i + 1} uploaded: $photoUrl');
          } catch (e) {
            debugPrint('⚠️ Failed to upload kondisi photo ${i + 1}: $e');
          }
        }
      }

      // Upload photos perilaku unsafe
      List<String> perilakuUrls = [];
      if (_fotoPerilaku.isNotEmpty) {
        debugPrint('📷 Uploading ${_fotoPerilaku.length} perilaku photos...');
        for (int i = 0; i < _fotoPerilaku.length; i++) {
          try {
            final file = _fotoPerilaku[i];
            final fileName =
                'silent-inspection-perilaku/temp_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

            debugPrint('📤 Uploading perilaku photo ${i + 1}/${_fotoPerilaku.length}: $fileName');

            await supabase.storage
                .from('silent-inspection-photos')
                .upload(fileName, file);

            final photoUrl = supabase.storage
                .from('silent-inspection-photos')
                .getPublicUrl(fileName);

            perilakuUrls.add(photoUrl);
            debugPrint('✅ Perilaku photo ${i + 1} uploaded: $photoUrl');
          } catch (e) {
            debugPrint('⚠️ Failed to upload perilaku photo ${i + 1}: $e');
          }
        }
      }

      // Calculate total temuan
      final totalTemuan = _temuanCritical + _temuanMajor + _temuanMinor;

      // Prepare data
      final data = {
        'tanggal': _selectedDate.toIso8601String().split('T')[0],
        'waktu_mulai':
            '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00',
        'waktu_selesai': _endTime != null
            ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00'
            : null,
        'unit_id': _selectedUnit.isNotEmpty ? _selectedUnit : null,
        'area_inspeksi': _areaController.text,
        'kategori_bahaya':
            _kategoriBahaya.isNotEmpty ? _kategoriBahaya : null,
        'temuan_critical': _temuanCritical,
        'temuan_major': _temuanMajor,
        'temuan_minor': _temuanMinor,
        'jumlah_temuan': totalTemuan,
        'deskripsi_temuan': _deskripsiTemuanController.text.isNotEmpty
            ? _deskripsiTemuanController.text
            : null,
        'skor_kepatuhan': _skorKepatuhan,
        'tingkat_risiko': _tingkatRisiko.isNotEmpty ? _tingkatRisiko : null,
        'kondisi_housekeeping':
            _kondisiHousekeeping.isNotEmpty ? _kondisiHousekeeping : null,
        'penggunaan_apd': _penggunaanApd.isNotEmpty ? _penggunaanApd : null,
        'rekomendasi': _rekomendasiController.text.isNotEmpty
            ? _rekomendasiController.text
            : null,
        'tindakan_korektif': _tindakanKorektifController.text.isNotEmpty
            ? _tindakanKorektifController.text
            : null,
        'pic_tindak_lanjut': _picTindakLanjutController.text.isNotEmpty
            ? _picTindakLanjutController.text
            : null,
        'target_penyelesaian': _targetPenyelesaian != null
            ? _targetPenyelesaian!.toIso8601String().split('T')[0]
            : null,
        'status_tindak_lanjut': _statusTindakLanjut,
        'status': _status,
        'foto_kondisi_unsafe': kondisiUrls,
        'foto_perilaku_unsafe': perilakuUrls,
        'catatan':
            _catatanController.text.isNotEmpty ? _catatanController.text : null,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('🔵 Saving silent inspection data: $data');

      // Save to database
      final response =
          await supabase.from('silent_inspection').insert(data).select().single();

      debugPrint('✅ Silent inspection saved with ID: ${response['id']}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '✅ Inspeksi berhasil disimpan${kondisiUrls.length + perilakuUrls.length > 0 ? " dengan ${kondisiUrls.length + perilakuUrls.length} foto" : ""}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ Error saving silent inspection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.inspection == null ? 'Tambah Inspeksi' : 'Edit Inspeksi'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Data Dasar
                  const Text(
                    '📅 Data Dasar Inspeksi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Tanggal
                  ListTile(
                    title: const Text('Tanggal Inspeksi *'),
                    subtitle: Text(_formatDate(_selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),

                  // Unit
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedUnit.isEmpty ? null : _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit *',
                      border: OutlineInputBorder(),
                    ),
                    items: _unitsFromDb.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit['id'].toString(),
                        child: Text(unit['nama'] ?? 'N/A'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedUnit = value ?? '');
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Unit harus dipilih' : null,
                  ),

                  // Waktu Mulai & Selesai
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Waktu Mulai *'),
                          subtitle: Text(_formatTime(_startTime)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () => _selectStartTime(),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Waktu Selesai'),
                          subtitle:
                              Text(_endTime != null ? _formatTime(_endTime!) : '-'),
                          trailing: const Icon(Icons.access_time),
                          onTap: () => _selectEndTime(),
                        ),
                      ),
                    ],
                  ),

                  // Area Inspeksi
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _areaController,
                    decoration: const InputDecoration(
                      labelText: 'Area Inspeksi *',
                      hintText: 'Contoh: Dermaga 1, Gudang A',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Area inspeksi harus diisi'
                        : null,
                  ),

                  // Kategori Bahaya
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _kategoriBahaya.isEmpty ? null : _kategoriBahaya,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Bahaya',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Pilih Kategori')),
                      DropdownMenuItem(
                          value: 'fisik_mekanik', child: Text('Fisik & Mekanik')),
                      DropdownMenuItem(value: 'kimia', child: Text('Kimia')),
                      DropdownMenuItem(value: 'biologis', child: Text('Biologis')),
                      DropdownMenuItem(value: 'ergonomi', child: Text('Ergonomi')),
                      DropdownMenuItem(
                          value: 'psikososial', child: Text('Psikososial')),
                      DropdownMenuItem(value: 'kombinasi', child: Text('Kombinasi')),
                    ],
                    onChanged: (value) {
                      setState(() => _kategoriBahaya = value ?? '');
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    '🔍 Temuan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Jumlah Temuan
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _temuanCritical.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Critical',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _temuanCritical = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: _temuanMajor.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Major',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _temuanMajor = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: _temuanMinor.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minor',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _temuanMinor = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Total Temuan: ${_temuanCritical + _temuanMajor + _temuanMinor}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Deskripsi Temuan
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiTemuanController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Temuan',
                      hintText: 'Detail temuan kondisi dan perilaku tidak aman...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    '📊 Penilaian',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Skor Kepatuhan
                  TextFormField(
                    initialValue: _skorKepatuhan.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Skor Kepatuhan (%)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _skorKepatuhan = double.tryParse(value) ?? 0;
                      });
                    },
                  ),

                  // Tingkat Risiko
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _tingkatRisiko.isEmpty ? null : _tingkatRisiko,
                    decoration: const InputDecoration(
                      labelText: 'Tingkat Risiko',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Pilih Tingkat Risiko')),
                      DropdownMenuItem(value: 'rendah', child: Text('🟢 Rendah')),
                      DropdownMenuItem(value: 'sedang', child: Text('🟡 Sedang')),
                      DropdownMenuItem(value: 'tinggi', child: Text('🟠 Tinggi')),
                      DropdownMenuItem(
                          value: 'sangat_tinggi', child: Text('🔴 Sangat Tinggi')),
                    ],
                    onChanged: (value) {
                      setState(() => _tingkatRisiko = value ?? '');
                    },
                  ),

                  // Kondisi Housekeeping
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _kondisiHousekeeping.isEmpty ? null : _kondisiHousekeeping,
                    decoration: const InputDecoration(
                      labelText: 'Kondisi Housekeeping',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Pilih Kondisi')),
                      DropdownMenuItem(value: 'baik', child: Text('Baik')),
                      DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
                      DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
                    ],
                    onChanged: (value) {
                      setState(() => _kondisiHousekeeping = value ?? '');
                    },
                  ),

                  // Penggunaan APD
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _penggunaanApd.isEmpty ? null : _penggunaanApd,
                    decoration: const InputDecoration(
                      labelText: 'Penggunaan APD',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Pilih Kondisi')),
                      DropdownMenuItem(value: 'baik', child: Text('Baik')),
                      DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
                      DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
                    ],
                    onChanged: (value) {
                      setState(() => _penggunaanApd = value ?? '');
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    '📝 Tindak Lanjut',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Rekomendasi
                  TextFormField(
                    controller: _rekomendasiController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Rekomendasi',
                      hintText: 'Rekomendasi perbaikan...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Tindakan Korektif
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tindakanKorektifController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Tindakan Korektif',
                      hintText: 'Tindakan yang harus dilakukan...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // PIC Tindak Lanjut
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _picTindakLanjutController,
                    decoration: const InputDecoration(
                      labelText: 'PIC Tindak Lanjut',
                      hintText: 'Nama penanggung jawab',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Target Penyelesaian
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Target Penyelesaian'),
                    subtitle: Text(_targetPenyelesaian != null
                        ? _formatDate(_targetPenyelesaian!)
                        : 'Belum dipilih'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() => _targetPenyelesaian = date);
                      }
                    },
                  ),

                  // Status Tindak Lanjut
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _statusTindakLanjut,
                    decoration: const InputDecoration(
                      labelText: 'Status Tindak Lanjut',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'open', child: Text('Open')),
                      DropdownMenuItem(
                          value: 'in_progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'closed', child: Text('Closed')),
                    ],
                    onChanged: (value) {
                      setState(() => _statusTindakLanjut = value ?? 'open');
                    },
                  ),

                  // Status Laporan
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status Laporan',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'draft', child: Text('Draft')),
                      DropdownMenuItem(value: 'approved', child: Text('Approved')),
                      DropdownMenuItem(value: 'closed', child: Text('Closed')),
                    ],
                    onChanged: (value) {
                      setState(() => _status = value ?? 'draft');
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    '📷 Upload Foto Kondisi Unsafe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _takePicture(true),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Kamera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImages(true),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galeri'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_fotoKondisi.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _fotoKondisi.map((photo) {
                        return Stack(
                          children: [
                            Image.file(photo, width: 100, height: 100, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() => _fotoKondisi.remove(photo));
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Text(
                    '📷 Upload Foto Perilaku Unsafe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _takePicture(false),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Kamera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImages(false),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galeri'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_fotoPerilaku.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _fotoPerilaku.map((photo) {
                        return Stack(
                          children: [
                            Image.file(photo, width: 100, height: 100, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() => _fotoPerilaku.remove(photo));
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],

                  // Catatan
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan Tambahan',
                      hintText: 'Catatan lainnya...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Submit Button
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Simpan',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _areaController.dispose();
    _deskripsiTemuanController.dispose();
    _rekomendasiController.dispose();
    _tindakanKorektifController.dispose();
    _picTindakLanjutController.dispose();
    _catatanController.dispose();
    super.dispose();
  }
}
