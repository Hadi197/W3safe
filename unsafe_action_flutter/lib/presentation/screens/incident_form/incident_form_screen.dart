import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/unit_model.dart';
import '../../../data/datasources/unit_remote_datasource.dart';

class IncidentFormScreen extends StatefulWidget {
  final String? incidentId;
  
  const IncidentFormScreen({super.key, this.incidentId});

  @override
  State<IncidentFormScreen> createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final UnitRemoteDatasource _unitDatasource;
  
  // Form controllers
  final _tanggalController = TextEditingController();
  final _waktuController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _penyebabDidugaController = TextEditingController();
  final _potensiRisikoController = TextEditingController();
  final _pelaporController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _kontakController = TextEditingController();
  final _tindakanController = TextEditingController();
  
  String _jenisKejadian = 'unsafe_condition';
  String _kategori = '';
  String? _unitId;
  String _unitKerja = '';
  String _prioritas = 'medium';
  bool _areaDiamankan = false;
  bool _korbanAda = false;
  int _korbanJumlah = 0;
  List<File> _photos = [];
  bool _isLoading = false;
  
  List<UnitModel> _units = [];
  bool _isLoadingUnits = true;

  @override
  void initState() {
    super.initState();
    _unitDatasource = UnitRemoteDatasource(Supabase.instance.client);
    _tanggalController.text = DateTime.now().toString().split(' ')[0];
    // Initialize waktu after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _waktuController.text = TimeOfDay.now().format(context);
      }
    });
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    try {
      debugPrint('🔵 Loading units from database...');
      final units = await _unitDatasource.getUnits(status: 'aktif');
      debugPrint('✅ Units loaded: ${units.length} items');
      for (var unit in units) {
        debugPrint('   - ${unit.namaUnit} (${unit.id})');
      }
      setState(() {
        _units = units;
        _isLoadingUnits = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading units: $e');
      setState(() => _isLoadingUnits = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data unit: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _waktuController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    _penyebabDidugaController.dispose();
    _potensiRisikoController.dispose();
    _pelaporController.dispose();
    _jabatanController.dispose();
    _kontakController.dispose();
    _tindakanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _photos.add(File(image.path));
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _photos.addAll(images.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_kategori.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori harus dipilih')),
      );
      return;
    }
    
    if (_unitId == null || _unitId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit harus dipilih')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      
      // Refresh session to ensure it's valid
      await supabase.auth.refreshSession();
      
      // Get current session after refresh
      final session = supabase.auth.currentSession;
      
      String userId;
      String userEmail;
      
      if (session != null && session.user.id.isNotEmpty) {
        userId = session.user.id;
        userEmail = session.user.email ?? 'unknown';
        debugPrint('✅ User logged in: $userEmail (ID: $userId)');
      } else {
        // Fallback: get user directly
        final user = supabase.auth.currentUser;
        if (user != null && user.id.isNotEmpty) {
          userId = user.id;
          userEmail = user.email ?? 'unknown';
          debugPrint('⚠️ Using currentUser fallback: $userEmail (ID: $userId)');
        } else {
          throw Exception('Tidak dapat mengakses data user. Silakan logout dan login kembali.');
        }
      }
      
      // Parse tanggal dan waktu
      final tanggalParts = _tanggalController.text.split('-');
      
      // Parse waktu (format HH:mm)
      int hour = 0;
      int minute = 0;
      
      if (_waktuController.text.isNotEmpty) {
        try {
          final waktuParts = _waktuController.text.split(':');
          
          if (waktuParts.isNotEmpty && waktuParts[0].isNotEmpty) {
            hour = int.parse(waktuParts[0].trim());
          }
          
          if (waktuParts.length > 1 && waktuParts[1].isNotEmpty) {
            minute = int.parse(waktuParts[1].trim());
          }
          
          debugPrint('🕐 Parsed time: $hour:$minute');
        } catch (e) {
          debugPrint('⚠️ Error parsing time: ${_waktuController.text}, error: $e');
          debugPrint('⚠️ Using 00:00 as fallback');
        }
      }
      
      final tanggalKejadian = DateTime(
        int.parse(tanggalParts[0]),
        int.parse(tanggalParts[1]),
        int.parse(tanggalParts[2]),
        hour,
        minute,
      );
      
      // Prepare data untuk insert (sesuai dengan struktur tabel database)
      final data = {
        'jenis_kejadian': _jenisKejadian,
        'kategori': _kategori,
        'tanggal_kejadian': _tanggalController.text, // date only (YYYY-MM-DD)
        'waktu_kejadian': '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00', // time (HH:MM:SS)
        'lokasi_kejadian': _lokasiController.text,
        'unit_kerja': _unitKerja,
        'deskripsi_kejadian': _deskripsiController.text,
        'penyebab_diduga': _penyebabDidugaController.text.isNotEmpty 
            ? _penyebabDidugaController.text 
            : null,
        'potensi_risiko': _potensiRisikoController.text.isNotEmpty 
            ? _potensiRisikoController.text 
            : null,
        'tindakan_segera': _tindakanController.text.isNotEmpty 
            ? _tindakanController.text 
            : null,
        'prioritas': _prioritas,
        'area_diamankan': _areaDiamankan,
        'korban_ada': _korbanAda,
        'korban_jumlah': _korbanJumlah,
        'pelapor_nama': _pelaporController.text,
        'pelapor_jabatan': _jabatanController.text.isNotEmpty 
            ? _jabatanController.text 
            : null,
        'pelapor_kontak': _kontakController.text.isNotEmpty 
            ? _kontakController.text 
            : null,
        'status': 'reported',
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      debugPrint('🔵 Saving incident data: $data');
      
      // Insert to database
      final response = await supabase
          .from('unsafe_action_condition')
          .insert(data)
          .select()
          .single();
      
      debugPrint('✅ Incident saved with ID: ${response['id']}');
      
      // Upload photos to Supabase Storage if any
      List<String> uploadedPhotoUrls = [];
      if (_photos.isNotEmpty) {
        debugPrint('📷 Uploading ${_photos.length} photos...');
        
        for (int i = 0; i < _photos.length; i++) {
          try {
            final file = _photos[i];
            final fileName = 'unsafe-action-condition-photos/temp_${DateTime.now().millisecondsSinceEpoch}_$i.${file.path.split('.').last}';
            
            debugPrint('📤 Uploading photo ${i + 1}/${_photos.length}: $fileName');
            
            await supabase.storage
                .from('unsafe-action-condition-files')
                .upload(fileName, file);
            
            final photoUrl = supabase.storage
                .from('unsafe-action-condition-files')
                .getPublicUrl(fileName);
            
            uploadedPhotoUrls.add(photoUrl);
            debugPrint('✅ Photo ${i + 1} uploaded: $photoUrl');
          } catch (e) {
            debugPrint('⚠️ Failed to upload photo ${i + 1}: $e');
          }
        }
        
        // Update incident with photo URLs
        if (uploadedPhotoUrls.isNotEmpty) {
          debugPrint('📸 Updating incident with ${uploadedPhotoUrls.length} photo URLs');
          await supabase
              .from('unsafe_action_condition')
              .update({'foto_kejadian': uploadedPhotoUrls})
              .eq('id', response['id']);
          debugPrint('✅ Photos saved to database');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Laporan berhasil disimpan${uploadedPhotoUrls.isNotEmpty ? " dengan ${uploadedPhotoUrls.length} foto" : ""}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      debugPrint('❌ Error saving incident: $e');
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
        title: Text(widget.incidentId == null ? 'Laporan Baru' : 'Edit Laporan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Jenis Kejadian
            const Text('Jenis Kejadian *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Unsafe Action'),
                    value: 'unsafe_action',
                    groupValue: _jenisKejadian,
                    onChanged: (value) {
                      setState(() {
                        _jenisKejadian = value!;
                        _kategori = '';
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Unsafe Condition'),
                    value: 'unsafe_condition',
                    groupValue: _jenisKejadian,
                    onChanged: (value) {
                      setState(() {
                        _jenisKejadian = value!;
                        _kategori = '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Kategori
            const Text('Kategori *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kategori.isEmpty ? null : _kategori,
              decoration: const InputDecoration(
                hintText: 'Pilih kategori',
              ),
              items: (_jenisKejadian == 'unsafe_action'
                      ? AppConstants.unsafeActionCategories
                      : AppConstants.unsafeConditionCategories)
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => _kategori = value ?? ''),
            ),
            const SizedBox(height: 16),
            
            // Tanggal & Waktu
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tanggalController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal *',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        _tanggalController.text = date.toString().split(' ')[0];
                      }
                    },
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Tanggal harus diisi' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _waktuController,
                    decoration: const InputDecoration(
                      labelText: 'Waktu *',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null && mounted) {
                        // Format waktu sebagai HH:mm (24-hour format)
                        final hour = time.hour.toString().padLeft(2, '0');
                        final minute = time.minute.toString().padLeft(2, '0');
                        _waktuController.text = '$hour:$minute';
                      }
                    },
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Waktu harus diisi' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lokasi & Unit
            TextFormField(
              controller: _lokasiController,
              decoration: const InputDecoration(
                labelText: 'Lokasi Kejadian *',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Lokasi harus diisi' : null,
            ),
            const SizedBox(height: 16),
            
            // Unit Kerja - from database
            _isLoadingUnits
                ? const Center(child: CircularProgressIndicator())
                : _units.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '⚠️ Tidak ada data unit. Total: ${_units.length}',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Unit: ${_units.length}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _unitId,
                            decoration: const InputDecoration(
                              labelText: 'Unit Kerja *',
                              prefixIcon: Icon(Icons.business),
                              helperText: 'Pilih Wilayah 3, Area, atau Unit spesifik',
                            ),
                            isExpanded: true,
                            items: _units
                                .map((unit) {
                                  // Determine level: Wilayah, Area, or Unit
                                  final isWilayah = unit.namaUnit.contains('Wilayah');
                                  final isArea = unit.namaUnit.startsWith('Area');
                                  final indent = isWilayah ? 0.0 : (isArea ? 8.0 : 24.0);
                                  
                                  return DropdownMenuItem(
                                      value: unit.id,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: indent),
                                        child: Row(
                                          children: [
                                            if (isWilayah)
                                              const Icon(Icons.location_city, size: 18, color: Colors.blue)
                                            else if (isArea)
                                              const Icon(Icons.map, size: 16, color: Colors.orange)
                                            else
                                              const Icon(Icons.business, size: 14, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                unit.namaUnit,
                                                style: TextStyle(
                                                  fontWeight: isWilayah ? FontWeight.bold : (isArea ? FontWeight.w600 : FontWeight.normal),
                                                  fontSize: isWilayah ? 15 : (isArea ? 14 : 13),
                                                  color: isWilayah ? Colors.blue[800] : (isArea ? Colors.orange[800] : Colors.black87),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                })
                                .toList(),
                            onChanged: (value) {
                              debugPrint('🔵 Unit selected: $value');
                              setState(() {
                                _unitId = value;
                                _unitKerja = _units
                                    .firstWhere((u) => u.id == value)
                                    .namaUnit;
                              });
                            },
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Unit kerja harus dipilih' : null,
                          ),
                        ],
                      ),
            const SizedBox(height: 16),
            
            // Deskripsi
            TextFormField(
              controller: _deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Kejadian *',
                hintText: 'Jelaskan detail kejadian...',
              ),
              maxLines: 4,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Deskripsi harus diisi';
                if (value!.length < 20) return 'Deskripsi minimal 20 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Penyebab Diduga
            TextFormField(
              controller: _penyebabDidugaController,
              decoration: const InputDecoration(
                labelText: 'Penyebab Diduga',
                hintText: 'Apa yang menyebabkan kejadian ini...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Potensi Risiko
            TextFormField(
              controller: _potensiRisikoController,
              decoration: const InputDecoration(
                labelText: 'Potensi Risiko',
                hintText: 'Risiko yang dapat terjadi...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Prioritas
            const Text('Prioritas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'low', label: Text('Low')),
                ButtonSegment(value: 'medium', label: Text('Medium')),
                ButtonSegment(value: 'high', label: Text('High')),
                ButtonSegment(value: 'critical', label: Text('Critical')),
              ],
              selected: {_prioritas},
              onSelectionChanged: (Set<String> selection) {
                setState(() => _prioritas = selection.first);
              },
            ),
            const SizedBox(height: 16),
            
            // Checkboxes
            CheckboxListTile(
              title: const Text('Area sudah diamankan'),
              value: _areaDiamankan,
              onChanged: (value) => setState(() => _areaDiamankan = value ?? false),
            ),
            CheckboxListTile(
              title: const Text('Ada korban'),
              value: _korbanAda,
              onChanged: (value) => setState(() => _korbanAda = value ?? false),
            ),
            if (_korbanAda) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Korban',
                    prefixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _korbanJumlah.toString(),
                  onChanged: (value) {
                    setState(() => _korbanJumlah = int.tryParse(value) ?? 0);
                  },
                  validator: (value) {
                    if (_korbanAda && (int.tryParse(value ?? '0') ?? 0) <= 0) {
                      return 'Jumlah korban harus diisi';
                    }
                    return null;
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            
            // Tindakan Segera
            TextFormField(
              controller: _tindakanController,
              decoration: const InputDecoration(
                labelText: 'Tindakan Segera',
                hintText: 'Apa yang sudah dilakukan...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Photos
            const Text('Foto Kejadian', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._photos.map((photo) => Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(photo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => setState(() => _photos.remove(photo)),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  if (_photos.length < 10) ...[
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 32),
                            SizedBox(height: 4),
                            Text('Camera', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 32),
                            SizedBox(height: 4),
                            Text('Gallery', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Pelapor Info
            const Text('Informasi Pelapor', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pelaporController,
              decoration: const InputDecoration(
                labelText: 'Nama Pelapor *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Nama pelapor harus diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jabatanController,
              decoration: const InputDecoration(
                labelText: 'Jabatan',
                prefixIcon: Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kontakController,
              decoration: const InputDecoration(
                labelText: 'Kontak',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan Laporan'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
