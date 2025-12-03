import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasources/management_walkthrough_datasource.dart';
import '../../../data/models/management_walkthrough_model.dart';

class ManagementWalkthroughFormScreen extends StatefulWidget {
  final ManagementWalkthroughModel? walkthrough;

  const ManagementWalkthroughFormScreen({super.key, this.walkthrough});

  @override
  State<ManagementWalkthroughFormScreen> createState() => _ManagementWalkthroughFormScreenState();
}

class _ManagementWalkthroughFormScreenState extends State<ManagementWalkthroughFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _datasource = ManagementWalkthroughDatasource(Supabase.instance.client);
  final supabase = Supabase.instance.client;

  late TabController _tabController;
  bool _isLoading = false;
  bool _isEdit = false;

  // Tab 1: Info Umum
  final _nomorWalkthroughController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay? _endTime;
  String? _selectedUnitId;
  final _areaInspeksiController = TextEditingController();
  final _departemenController = TextEditingController();
  final _pimpinanWalkthroughController = TextEditingController();
  List<String> _anggotaTim = [];
  final _anggotaTimController = TextEditingController();
  final _tujuanWalkthroughController = TextEditingController();
  List<String> _fokusArea = [];
  final _fokusAreaController = TextEditingController();
  String _jenisWalkthrough = 'rutin';

  // Tab 2: Observasi Kondisi
  String _kondisiHousekeeping = 'baik';
  String _kondisiPencahayaan = 'baik';
  String _kondisiVentilasi = 'baik';
  String _kondisiAksesJalan = 'baik';

  // Tab 3: APD & Perilaku Kerja
  int _kepatuhanApd = 0;
  bool _apdTersedia = false;
  bool _apdKondisiBaik = false;
  bool _apdDigunakanBenar = false;
  List<String> _apdTidakSesuai = [];
  final _apdTidakSesuaiController = TextEditingController();
  int _pekerjaDiamati = 0;
  int _perilakuAman = 0;
  int _perilakuTidakAman = 0;

  // Tab 4: Interaksi Pekerja
  int _jumlahPekerjaDiwawancara = 0;
  List<String> _feedbackPekerja = [];
  final _feedbackController = TextEditingController();
  List<String> _saranPekerja = [];
  final _saranController = TextEditingController();
  bool _pekerjaAwareProsedur = false;

  // Tab 5: Temuan
  int _temuanKritis = 0;
  int _temuanMayor = 0;
  int _temuanMinor = 0;
  int _temuanObservasi = 0;
  List<String> _pelanggaranProsedur = [];
  final _pelanggaranProsedurController = TextEditingController();
  List<String> _pelanggaranPeraturan = [];
  final _pelanggaranPeraturanController = TextEditingController();

  // Tab 6: Positive Findings & Action Items
  List<String> _praktekBaik = [];
  final _praktekBaikController = TextEditingController();
  List<String> _pekerjaTeladan = [];
  final _pekerjaTeladanController = TextEditingController();
  List<String> _tindakanSegera = [];
  final _tindakanSegeraController = TextEditingController();

  // Tab 7: Dokumentasi & Ringkasan
  List<File> _photos = [];
  final _ringkasanObservasiController = TextEditingController();
  List<String> _rekomendasi = [];
  final _rekomendasiController = TextEditingController();
  final _catatanKhususController = TextEditingController();

  // Status & Scoring
  String _status = 'draft';
  String _tingkatUrgensi = 'normal';
  bool _perluFollowUp = false;

  List<Map<String, dynamic>> _units = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _isEdit = widget.walkthrough != null;
    _loadUnits();
    _generateNomorWalkthrough();
    if (_isEdit) {
      _loadWalkthroughData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomorWalkthroughController.dispose();
    _areaInspeksiController.dispose();
    _departemenController.dispose();
    _pimpinanWalkthroughController.dispose();
    _anggotaTimController.dispose();
    _tujuanWalkthroughController.dispose();
    _fokusAreaController.dispose();
    _apdTidakSesuaiController.dispose();
    _feedbackController.dispose();
    _saranController.dispose();
    _pelanggaranProsedurController.dispose();
    _pelanggaranPeraturanController.dispose();
    _praktekBaikController.dispose();
    _pekerjaTeladanController.dispose();
    _tindakanSegeraController.dispose();
    _ringkasanObservasiController.dispose();
    _rekomendasiController.dispose();
    _catatanKhususController.dispose();
    super.dispose();
  }

  Future<void> _loadUnits() async {
    try {
      final response = await supabase
          .from('units')
          .select('id, nama')
          .eq('aktif', true)
          .order('nama');

      setState(() {
        _units = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error loading units: $e');
    }
  }

  Future<void> _generateNomorWalkthrough() async {
    if (!_isEdit) {
      try {
        final nomor = await _datasource.generateNomorWalkthrough();
        setState(() {
          _nomorWalkthroughController.text = nomor;
        });
      } catch (e) {
        debugPrint('Error generating nomor: $e');
      }
    }
  }

  void _loadWalkthroughData() {
    final walkthrough = widget.walkthrough!;
    _nomorWalkthroughController.text = walkthrough.nomorWalkthrough;
    _selectedDate = walkthrough.tanggalWalkthrough;
    _startTime = TimeOfDay(
      hour: int.parse(walkthrough.waktuMulai.split(':')[0]),
      minute: int.parse(walkthrough.waktuMulai.split(':')[1]),
    );
    _selectedUnitId = walkthrough.unitId;
    _areaInspeksiController.text = walkthrough.areaInspeksi;
    _departemenController.text = walkthrough.departemen ?? '';
    _pimpinanWalkthroughController.text = walkthrough.pimpinanWalkthrough;
    _anggotaTim = walkthrough.anggotaTim;
    _tujuanWalkthroughController.text = walkthrough.tujuanWalkthrough ?? '';
    _fokusArea = walkthrough.fokusArea;
    _jenisWalkthrough = walkthrough.jenisWalkthrough;

    _kondisiHousekeeping = walkthrough.kondisiHousekeeping ?? 'baik';
    _kondisiPencahayaan = walkthrough.kondisiPencahayaan ?? 'baik';
    _kondisiVentilasi = walkthrough.kondisiVentilasi ?? 'baik';
    _kondisiAksesJalan = walkthrough.kondisiAksesJalan ?? 'baik';

    _kepatuhanApd = walkthrough.kepatuhanApd;
    _apdTersedia = walkthrough.apdTersedia;
    _apdKondisiBaik = walkthrough.apdKondisiBaik;
    _apdDigunakanBenar = walkthrough.apdDigunakanBenar;
    _apdTidakSesuai = walkthrough.apdTidakSesuai;
    _pekerjaDiamati = walkthrough.pekerjaDiamati;
    _perilakuAman = walkthrough.perilakuAman;
    _perilakuTidakAman = walkthrough.perilakuTidakAman;

    _jumlahPekerjaDiwawancara = walkthrough.jumlahPekerjaDiwawancara;
    _feedbackPekerja = walkthrough.feedbackPekerja;
    _saranPekerja = walkthrough.saranPekerja;
    _pekerjaAwareProsedur = walkthrough.pekerjaAwareProsedur;

    _temuanKritis = walkthrough.temuanKritis;
    _temuanMayor = walkthrough.temuanMayor;
    _temuanMinor = walkthrough.temuanMinor;
    _temuanObservasi = walkthrough.temuanObservasi;
    _pelanggaranProsedur = walkthrough.pelanggaranProsedur;
    _pelanggaranPeraturan = walkthrough.pelanggaranPeraturan;

    _praktekBaik = walkthrough.praktekBaik;
    _pekerjaTeladan = walkthrough.pekerjaTeladan;
    _tindakanSegera = walkthrough.tindakanSegera;

    _ringkasanObservasiController.text = walkthrough.ringkasanObservasi ?? '';
    _rekomendasi = walkthrough.rekomendasi;
    _catatanKhususController.text = walkthrough.catatanKhusus ?? '';

    _status = walkthrough.status;
    _tingkatUrgensi = walkthrough.tingkatUrgensi;
    _perluFollowUp = walkthrough.perluFollowUp;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(
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
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua field yang wajib')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Upload photos first
      List<String> photoUrls = [];
      if (_photos.isNotEmpty) {
        for (final photo in _photos) {
          final url = await _datasource.uploadPhoto(
            photo,
            _isEdit ? widget.walkthrough!.id! : 'temp',
          );
          photoUrls.add(url);
        }
      }

      final data = {
        'nomor_walkthrough': _nomorWalkthroughController.text,
        'tanggal_walkthrough': _selectedDate.toIso8601String(),
        'waktu_mulai': _formatTime(_startTime),
        'waktu_selesai': _endTime != null ? _formatTime(_endTime!) : null,
        'unit_id': _selectedUnitId,
        'area_inspeksi': _areaInspeksiController.text,
        'departemen': _departemenController.text.isEmpty ? null : _departemenController.text,
        'pimpinan_walkthrough': _pimpinanWalkthroughController.text,
        'anggota_tim': _anggotaTim,
        'jumlah_tim': _anggotaTim.length,
        'tujuan_walkthrough': _tujuanWalkthroughController.text.isEmpty ? null : _tujuanWalkthroughController.text,
        'fokus_area': _fokusArea,
        'jenis_walkthrough': _jenisWalkthrough,
        'kondisi_housekeeping': _kondisiHousekeeping,
        'kondisi_pencahayaan': _kondisiPencahayaan,
        'kondisi_ventilasi': _kondisiVentilasi,
        'kondisi_akses_jalan': _kondisiAksesJalan,
        'kepatuhan_apd': _kepatuhanApd,
        'apd_tersedia': _apdTersedia,
        'apd_kondisi_baik': _apdKondisiBaik,
        'apd_digunakan_benar': _apdDigunakanBenar,
        'apd_tidak_sesuai': _apdTidakSesuai,
        'pekerja_diamati': _pekerjaDiamati,
        'perilaku_aman': _perilakuAman,
        'perilaku_tidak_aman': _perilakuTidakAman,
        'jumlah_pekerja_diwawancara': _jumlahPekerjaDiwawancara,
        'feedback_pekerja': _feedbackPekerja,
        'saran_pekerja': _saranPekerja,
        'pekerja_aware_prosedur': _pekerjaAwareProsedur,
        'jumlah_temuan': _temuanKritis + _temuanMayor + _temuanMinor + _temuanObservasi,
        'temuan_kritis': _temuanKritis,
        'temuan_mayor': _temuanMayor,
        'temuan_minor': _temuanMinor,
        'temuan_observasi': _temuanObservasi,
        'pelanggaran_prosedur': _pelanggaranProsedur,
        'pelanggaran_peraturan': _pelanggaranPeraturan,
        'praktek_baik': _praktekBaik,
        'pekerja_teladan': _pekerjaTeladan,
        'tindakan_segera': _tindakanSegera,
        'foto_walkthrough': photoUrls,
        'ringkasan_observasi': _ringkasanObservasiController.text.isEmpty ? null : _ringkasanObservasiController.text,
        'rekomendasi': _rekomendasi,
        'catatan_khusus': _catatanKhususController.text.isEmpty ? null : _catatanKhususController.text,
        'status': _status,
        'tingkat_urgensi': _tingkatUrgensi,
        'perlu_follow_up': _perluFollowUp,
        'created_by': userId,
      };

      if (_isEdit) {
        await _datasource.update(widget.walkthrough!.id!, data);
      } else {
        await _datasource.create(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? 'Data berhasil diupdate' : 'Data berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
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
        title: Text(_isEdit ? 'Edit Management Walkthrough' : 'Walkthrough Baru'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Info Umum'),
            Tab(text: 'Observasi'),
            Tab(text: 'APD & Perilaku'),
            Tab(text: 'Interaksi'),
            Tab(text: 'Temuan'),
            Tab(text: 'Positive & Action'),
            Tab(text: 'Dokumentasi'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoUmumTab(),
            _buildObservasiTab(),
            _buildApdPerilakuTab(),
            _buildInteraksiTab(),
            _buildTemuanTab(),
            _buildPositiveActionTab(),
            _buildDokumentasiTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEdit ? 'Update' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoUmumTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _nomorWalkthroughController,
          decoration: const InputDecoration(
            labelText: 'Nomor Walkthrough *',
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          validator: (value) => value?.isEmpty ?? true ? 'Nomor harus diisi' : null,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Tanggal *',
              border: OutlineInputBorder(),
            ),
            child: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectStartTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Waktu Mulai *',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_formatTime(_startTime)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: _selectEndTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Waktu Selesai',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_endTime != null ? _formatTime(_endTime!) : '-'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedUnitId,
          decoration: const InputDecoration(
            labelText: 'Unit',
            border: OutlineInputBorder(),
          ),
          items: _units
              .map((unit) => DropdownMenuItem<String>(
                    value: unit['id'] as String,
                    child: Text(unit['nama'] as String),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedUnitId = value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _areaInspeksiController,
          decoration: const InputDecoration(
            labelText: 'Area Inspeksi *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Area harus diisi' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _departemenController,
          decoration: const InputDecoration(
            labelText: 'Departemen',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _pimpinanWalkthroughController,
          decoration: const InputDecoration(
            labelText: 'Pimpinan Walkthrough *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Pimpinan harus diisi' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _jenisWalkthrough,
          decoration: const InputDecoration(
            labelText: 'Jenis Walkthrough *',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'rutin', child: Text('Rutin')),
            DropdownMenuItem(value: 'terjadwal', child: Text('Terjadwal')),
            DropdownMenuItem(value: 'insidental', child: Text('Insidental')),
            DropdownMenuItem(value: 'follow_up', child: Text('Follow Up')),
            DropdownMenuItem(value: 'khusus', child: Text('Khusus')),
          ],
          onChanged: (value) => setState(() => _jenisWalkthrough = value!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _tujuanWalkthroughController,
          decoration: const InputDecoration(
            labelText: 'Tujuan Walkthrough',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Anggota Tim',
          _anggotaTim,
          _anggotaTimController,
          () => setState(() {
            if (_anggotaTimController.text.isNotEmpty) {
              _anggotaTim.add(_anggotaTimController.text);
              _anggotaTimController.clear();
            }
          }),
          (index) => setState(() => _anggotaTim.removeAt(index)),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Fokus Area',
          _fokusArea,
          _fokusAreaController,
          () => setState(() {
            if (_fokusAreaController.text.isNotEmpty) {
              _fokusArea.add(_fokusAreaController.text);
              _fokusAreaController.clear();
            }
          }),
          (index) => setState(() => _fokusArea.removeAt(index)),
        ),
      ],
    );
  }

  Widget _buildObservasiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Kondisi Observasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildKondisiDropdown('Housekeeping', _kondisiHousekeeping, (value) {
          setState(() => _kondisiHousekeeping = value!);
        }),
        const SizedBox(height: 16),
        _buildKondisiDropdown('Pencahayaan', _kondisiPencahayaan, (value) {
          setState(() => _kondisiPencahayaan = value!);
        }),
        const SizedBox(height: 16),
        _buildKondisiDropdown('Ventilasi', _kondisiVentilasi, (value) {
          setState(() => _kondisiVentilasi = value!);
        }),
        const SizedBox(height: 16),
        _buildKondisiDropdown('Akses Jalan', _kondisiAksesJalan, (value) {
          setState(() => _kondisiAksesJalan = value!);
        }),
      ],
    );
  }

  Widget _buildApdPerilakuTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'APD',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _kepatuhanApd.toString(),
          decoration: const InputDecoration(
            labelText: 'Kepatuhan APD (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _kepatuhanApd = int.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('APD Tersedia'),
          value: _apdTersedia,
          onChanged: (value) => setState(() => _apdTersedia = value!),
        ),
        CheckboxListTile(
          title: const Text('APD Kondisi Baik'),
          value: _apdKondisiBaik,
          onChanged: (value) => setState(() => _apdKondisiBaik = value!),
        ),
        CheckboxListTile(
          title: const Text('APD Digunakan dengan Benar'),
          value: _apdDigunakanBenar,
          onChanged: (value) => setState(() => _apdDigunakanBenar = value!),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'APD Tidak Sesuai',
          _apdTidakSesuai,
          _apdTidakSesuaiController,
          () => setState(() {
            if (_apdTidakSesuaiController.text.isNotEmpty) {
              _apdTidakSesuai.add(_apdTidakSesuaiController.text);
              _apdTidakSesuaiController.clear();
            }
          }),
          (index) => setState(() => _apdTidakSesuai.removeAt(index)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Perilaku Kerja',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _pekerjaDiamati.toString(),
          decoration: const InputDecoration(
            labelText: 'Jumlah Pekerja Diamati',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _pekerjaDiamati = int.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _perilakuAman.toString(),
          decoration: const InputDecoration(
            labelText: 'Perilaku Aman',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _perilakuAman = int.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _perilakuTidakAman.toString(),
          decoration: const InputDecoration(
            labelText: 'Perilaku Tidak Aman',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _perilakuTidakAman = int.tryParse(value) ?? 0,
        ),
      ],
    );
  }

  Widget _buildInteraksiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          initialValue: _jumlahPekerjaDiwawancara.toString(),
          decoration: const InputDecoration(
            labelText: 'Jumlah Pekerja Diwawancara',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => _jumlahPekerjaDiwawancara = int.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Pekerja Aware Prosedur'),
          value: _pekerjaAwareProsedur,
          onChanged: (value) => setState(() => _pekerjaAwareProsedur = value!),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Feedback Pekerja',
          _feedbackPekerja,
          _feedbackController,
          () => setState(() {
            if (_feedbackController.text.isNotEmpty) {
              _feedbackPekerja.add(_feedbackController.text);
              _feedbackController.clear();
            }
          }),
          (index) => setState(() => _feedbackPekerja.removeAt(index)),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Saran Pekerja',
          _saranPekerja,
          _saranController,
          () => setState(() {
            if (_saranController.text.isNotEmpty) {
              _saranPekerja.add(_saranController.text);
              _saranController.clear();
            }
          }),
          (index) => setState(() => _saranPekerja.removeAt(index)),
        ),
      ],
    );
  }

  Widget _buildTemuanTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Jumlah Temuan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _temuanKritis.toString(),
                decoration: const InputDecoration(
                  labelText: 'Kritis',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _temuanKritis = int.tryParse(value) ?? 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: _temuanMayor.toString(),
                decoration: const InputDecoration(
                  labelText: 'Mayor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _temuanMayor = int.tryParse(value) ?? 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _temuanMinor.toString(),
                decoration: const InputDecoration(
                  labelText: 'Minor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _temuanMinor = int.tryParse(value) ?? 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: _temuanObservasi.toString(),
                decoration: const InputDecoration(
                  labelText: 'Observasi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _temuanObservasi = int.tryParse(value) ?? 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildListField(
          'Pelanggaran Prosedur',
          _pelanggaranProsedur,
          _pelanggaranProsedurController,
          () => setState(() {
            if (_pelanggaranProsedurController.text.isNotEmpty) {
              _pelanggaranProsedur.add(_pelanggaranProsedurController.text);
              _pelanggaranProsedurController.clear();
            }
          }),
          (index) => setState(() => _pelanggaranProsedur.removeAt(index)),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Pelanggaran Peraturan',
          _pelanggaranPeraturan,
          _pelanggaranPeraturanController,
          () => setState(() {
            if (_pelanggaranPeraturanController.text.isNotEmpty) {
              _pelanggaranPeraturan.add(_pelanggaranPeraturanController.text);
              _pelanggaranPeraturanController.clear();
            }
          }),
          (index) => setState(() => _pelanggaranPeraturan.removeAt(index)),
        ),
      ],
    );
  }

  Widget _buildPositiveActionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Positive Findings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Praktek Baik',
          _praktekBaik,
          _praktekBaikController,
          () => setState(() {
            if (_praktekBaikController.text.isNotEmpty) {
              _praktekBaik.add(_praktekBaikController.text);
              _praktekBaikController.clear();
            }
          }),
          (index) => setState(() => _praktekBaik.removeAt(index)),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Pekerja Teladan',
          _pekerjaTeladan,
          _pekerjaTeladanController,
          () => setState(() {
            if (_pekerjaTeladanController.text.isNotEmpty) {
              _pekerjaTeladan.add(_pekerjaTeladanController.text);
              _pekerjaTeladanController.clear();
            }
          }),
          (index) => setState(() => _pekerjaTeladan.removeAt(index)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Action Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Tindakan Segera',
          _tindakanSegera,
          _tindakanSegeraController,
          () => setState(() {
            if (_tindakanSegeraController.text.isNotEmpty) {
              _tindakanSegera.add(_tindakanSegeraController.text);
              _tindakanSegeraController.clear();
            }
          }),
          (index) => setState(() => _tindakanSegera.removeAt(index)),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Perlu Follow Up'),
          value: _perluFollowUp,
          onChanged: (value) => setState(() => _perluFollowUp = value!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _tingkatUrgensi,
          decoration: const InputDecoration(
            labelText: 'Tingkat Urgensi',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'rendah', child: Text('Rendah')),
            DropdownMenuItem(value: 'normal', child: Text('Normal')),
            DropdownMenuItem(value: 'tinggi', child: Text('Tinggi')),
            DropdownMenuItem(value: 'kritis', child: Text('Kritis')),
          ],
          onChanged: (value) => setState(() => _tingkatUrgensi = value!),
        ),
      ],
    );
  }

  Widget _buildDokumentasiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Foto Dokumentasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Foto'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto'),
              ),
            ),
          ],
        ),
        if (_photos.isNotEmpty) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _photos.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_photos[index], fit: BoxFit.cover),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _photos.removeAt(index)),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        const SizedBox(height: 24),
        const Text(
          'Ringkasan & Rekomendasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ringkasanObservasiController,
          decoration: const InputDecoration(
            labelText: 'Ringkasan Observasi',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        _buildListField(
          'Rekomendasi',
          _rekomendasi,
          _rekomendasiController,
          () => setState(() {
            if (_rekomendasiController.text.isNotEmpty) {
              _rekomendasi.add(_rekomendasiController.text);
              _rekomendasiController.clear();
            }
          }),
          (index) => setState(() => _rekomendasi.removeAt(index)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _catatanKhususController,
          decoration: const InputDecoration(
            labelText: 'Catatan Khusus',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'draft', child: Text('Draft')),
            DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
          ],
          onChanged: (value) => setState(() => _status = value!),
        ),
      ],
    );
  }

  Widget _buildKondisiDropdown(String label, String value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'baik', child: Text('Baik')),
        DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
        DropdownMenuItem(value: 'kurang', child: Text('Kurang')),
        DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildListField(
    String label,
    List<String> items,
    TextEditingController controller,
    VoidCallback onAdd,
    void Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle),
              color: Colors.blue,
            ),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...items.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(entry.value),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onRemove(entry.key),
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
