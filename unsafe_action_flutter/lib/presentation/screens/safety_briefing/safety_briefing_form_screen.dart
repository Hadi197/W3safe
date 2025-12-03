import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasources/safety_briefing_datasource.dart';
import '../../../core/theme/app_theme.dart';

class SafetyBriefingFormScreen extends StatefulWidget {
  final String? briefingId;

  const SafetyBriefingFormScreen({super.key, this.briefingId});

  @override
  State<SafetyBriefingFormScreen> createState() => _SafetyBriefingFormScreenState();
}

class _SafetyBriefingFormScreenState extends State<SafetyBriefingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _datasource = SafetyBriefingDatasource(Supabase.instance.client);
  final supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  List<File> _photos = [];
  List<String> _participants = [];
  final _participantController = TextEditingController();

  // Form fields
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay? _endTime;
  String _selectedUnit = '';
  final _topicController = TextEditingController();
  final _materialController = TextEditingController();
  int _participantCount = 0;
  String _status = 'draft';
  final _notesController = TextEditingController();

  final List<Map<String, String>> _units = [
    // Leave empty - will be loaded from database
  ];

  List<Map<String, dynamic>> _unitsFromDb = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
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
      debugPrint('✅ Loaded ${_unitsFromDb.length} units');
    } catch (e) {
      debugPrint('⚠️ Failed to load units: $e');
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _materialController.dispose();
    _notesController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    
    if (images.isNotEmpty) {
      setState(() {
        _photos.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,  // Limit resolution
      maxHeight: 1920,
      imageQuality: 85, // Compress quality
    );
    
    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  void _addParticipant() {
    if (_participantController.text.isNotEmpty) {
      setState(() {
        _participants.add(_participantController.text);
        _participantController.clear();
      });
    }
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topik harus diisi')),
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

      // Upload photos first
      List<String> photoUrls = [];
      if (_photos.isNotEmpty) {
        debugPrint('📷 Uploading ${_photos.length} photos...');
        
        for (int i = 0; i < _photos.length; i++) {
          try {
            final file = _photos[i];
            final fileName = 'safety-briefing-photos/temp_${DateTime.now().millisecondsSinceEpoch}_$i.${file.path.split('.').last}';
            
            debugPrint('📤 Uploading photo ${i + 1}/${_photos.length}: $fileName');
            
            await supabase.storage
                .from('safety-briefing-photos')
                .upload(fileName, file);
            
            final photoUrl = supabase.storage
                .from('safety-briefing-photos')
                .getPublicUrl(fileName);
            
            photoUrls.add(photoUrl);
            debugPrint('✅ Photo ${i + 1} uploaded: $photoUrl');
          } catch (e) {
            debugPrint('⚠️ Failed to upload photo ${i + 1}: $e');
          }
        }
      }

      // Prepare data
      final data = {
        'tanggal': _selectedDate.toIso8601String().split('T')[0],
        'waktu_mulai': '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00',
        'waktu_selesai': _endTime != null 
            ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00'
            : null,
        'unit_id': _selectedUnit.isNotEmpty ? _selectedUnit : null,
        'topik': _topicController.text,
        'materi': _materialController.text.isNotEmpty ? _materialController.text : null,
        'jumlah_peserta': _participantCount,
        'foto_dokumentasi': photoUrls,
        'status': _status,
        'catatan': _notesController.text.isNotEmpty ? _notesController.text : null,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Add daftar_peserta only if not empty
      if (_participants.isNotEmpty) {
        data['daftar_peserta'] = _participants;
      }

      debugPrint('🔵 Saving safety briefing data: $data');

      // Save to database
      final response = await supabase
          .from('safety_briefing')
          .insert(data)
          .select()
          .single();

      debugPrint('✅ Safety briefing saved with ID: ${response['id']}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Safety briefing berhasil disimpan${photoUrls.isNotEmpty ? " dengan ${photoUrls.length} foto" : ""}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ Error saving safety briefing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.briefingId == null ? 'Tambah Safety Briefing' : 'Edit Safety Briefing'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tanggal
            const Text('Tanggal *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Waktu
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Waktu Mulai *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectStartTime,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTime(_startTime)),
                              const Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Waktu Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectEndTime,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_endTime != null ? _formatTime(_endTime!) : '-'),
                              const Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Unit
            const Text('Unit Kerja', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedUnit.isEmpty ? null : _selectedUnit,
              decoration: const InputDecoration(
                hintText: 'Pilih unit kerja',
                border: OutlineInputBorder(),
              ),
              items: _unitsFromDb.map((unit) {
                return DropdownMenuItem(
                  value: unit['id'] as String,
                  child: Text(unit['nama'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),

            // Topik
            const Text('Topik *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _topicController,
              decoration: const InputDecoration(
                hintText: 'Masukkan topik briefing',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Topik harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Materi
            const Text('Materi', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _materialController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Uraian materi briefing',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Jumlah Peserta
            const Text('Jumlah Peserta', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _participantCount = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),

            // Daftar Peserta
            const Text('Daftar Peserta', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _participantController,
                    decoration: const InputDecoration(
                      hintText: 'Nama peserta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addParticipant,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (_participants.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._participants.asMap().entries.map((entry) {
                return Card(
                  child: ListTile(
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeParticipant(entry.key),
                    ),
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 16),

            // Foto Dokumentasi
            const Text('Foto Dokumentasi', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeri'),
                  ),
                ),
              ],
            ),
            if (_photos.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_photos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: InkWell(
                            onTap: () => setState(() => _photos.removeAt(index)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Status
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                DropdownMenuItem(value: 'approved', child: Text('Disetujui')),
                DropdownMenuItem(value: 'rejected', child: Text('Ditolak')),
              ],
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Catatan
            const Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Catatan tambahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
