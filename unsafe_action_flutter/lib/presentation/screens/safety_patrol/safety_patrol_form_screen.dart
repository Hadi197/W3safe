import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/safety_patrol_model.dart';
import '../../../data/repositories/safety_patrol_repository.dart';

// Helper classes for dynamic lists
class UnsafeConditionItem {
  String kategori;
  String tingkatRisiko;
  String deskripsi;
  String lokasi;
  String tindakan;
  List<File> photos;

  UnsafeConditionItem({
    this.kategori = '',
    this.tingkatRisiko = 'sedang',
    this.deskripsi = '',
    this.lokasi = '',
    this.tindakan = '',
    List<File>? photos,
  }) : photos = photos ?? [];
}

class UnsafeActItem {
  String pekerja;
  String tingkatRisiko;
  String deskripsi;
  String lokasi;
  String tindakanLangsung;
  List<File> photos;

  UnsafeActItem({
    this.pekerja = '',
    this.tingkatRisiko = 'sedang',
    this.deskripsi = '',
    this.lokasi = '',
    this.tindakanLangsung = '',
    List<File>? photos,
  }) : photos = photos ?? [];
}

class SafetyPatrolFormScreen extends StatefulWidget {
  final SafetyPatrol? patrol;

  const SafetyPatrolFormScreen({Key? key, this.patrol}) : super(key: key);

  @override
  State<SafetyPatrolFormScreen> createState() => _SafetyPatrolFormScreenState();
}

class _SafetyPatrolFormScreenState extends State<SafetyPatrolFormScreen>
    with SingleTickerProviderStateMixin {
  final SafetyPatrolRepository _repository = SafetyPatrolRepository();
  final _formKey = GlobalKey<FormState>();
  
  late TabController _tabController;
  bool _isLoading = false;
  bool _isEditMode = false;

  // Form controllers - Tab 1: Data Dasar
  final _nomorPatrolController = TextEditingController();
  DateTime? _tanggalPatrol;
  final _waktuMulaiController = TextEditingController();
  final _waktuSelesaiController = TextEditingController();
  String? _shift;
  final _areaPatrolController = TextEditingController();
  final _lokasiSpesifikController = TextEditingController();
  final _ketuaPatrolController = TextEditingController();
  List<String> _anggotaPatrol = [];
  String? _jenisPatrol;
  final _tujuanPatrolController = TextEditingController();
  List<String> _fokusPatrol = [];

  // Tab 2: Kondisi Lingkungan
  String? _cuaca;
  final _suhuAreaController = TextEditingController();
  String? _kondisiPencahayaan;
  String? _kondisiVentilasi;
  String? _tingkatKebisingan;

  // Tab 3: Unsafe Condition & Act
  List<UnsafeConditionItem> _unsafeConditions = [];
  List<UnsafeActItem> _unsafeActs = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Tab 4: Kepatuhan APD
  final _pekerjaDiamatiController = TextEditingController(text: '0');
  final _pekerjaPatuhApdController = TextEditingController(text: '0');
  final _pekerjaTidakPatuhApdController = TextEditingController(text: '0');

  // Tab 5: Housekeeping & Peralatan
  final _skorHousekeepingController = TextEditingController();
  String? _kondisiHousekeeping;
  List<String> _areaKotor = [];
  List<String> _areaRapi = [];
  final _jumlahMesinDiperiksaController = TextEditingController(text: '0');
  final _mesinKondisiBaikController = TextEditingController(text: '0');
  final _mesinPerluPerbaikanController = TextEditingController(text: '0');

  // Tab 6: Peralatan K3
  bool _rambuK3Lengkap = false;
  List<String> _rambuK3Hilang = [];
  List<String> _rambuK3Rusak = [];
  bool _labelB3Lengkap = false;
  bool _jalurEvakuasiBebas = false;
  bool _pintuDaruratBerfungsi = false;
  bool _aparTersedia = false;
  final _aparExpireController = TextEditingController(text: '0');
  bool _emergencyLightBerfungsi = false;

  // Tab 7: Positif & Temuan
  List<String> _goodPractice = [];
  List<String> _areaExcellent = [];
  List<String> _pekerjaTeladan = [];
  final _temuanKritikalController = TextEditingController(text: '0');
  final _temuanMayorController = TextEditingController(text: '0');
  final _temuanMinorController = TextEditingController(text: '0');
  List<String> _rekomendasi = [];
  final _catatanPatrolController = TextEditingController();

  // Tab 8: Action Items & Status
  final _jumlahActionItemController = TextEditingController(text: '0');
  final _actionSelesaiController = TextEditingController(text: '0');
  final _actionProgressController = TextEditingController(text: '0');
  final _actionBelumMulaiController = TextEditingController(text: '0');
  bool _stopWorkIssued = false;
  List<String> _stopWorkArea = [];
  final _stopWorkAlasanController = TextEditingController();
  String _status = 'draft';
  String _tingkatUrgensi = 'normal';
  bool _perluFollowUp = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _isEditMode = widget.patrol != null;
    
    if (_isEditMode && widget.patrol != null) {
      _loadPatrolData(widget.patrol!);
    }
  }

  void _loadPatrolData(SafetyPatrol patrol) {
    _nomorPatrolController.text = patrol.nomorPatrol;
    _tanggalPatrol = patrol.tanggalPatrol;
    _waktuMulaiController.text = patrol.waktuMulai ?? '';
    _waktuSelesaiController.text = patrol.waktuSelesai ?? '';
    _shift = patrol.shift;
    _areaPatrolController.text = patrol.areaPatrol;
    _lokasiSpesifikController.text = patrol.lokasiSpesifik ?? '';
    _ketuaPatrolController.text = patrol.ketuaPatrol;
    _anggotaPatrol = List<String>.from(patrol.anggotaPatrol);
    _jenisPatrol = patrol.jenisPatrol;
    _tujuanPatrolController.text = patrol.tujuanPatrol ?? '';
    _fokusPatrol = List<String>.from(patrol.fokusPatrol);
    
    _cuaca = patrol.cuaca;
    _suhuAreaController.text = patrol.suhuArea?.toString() ?? '';
    _kondisiPencahayaan = patrol.kondisiPencahayaan;
    _kondisiVentilasi = patrol.kondisiVentilasi;
    _tingkatKebisingan = patrol.tingkatKebisingan;
    
    _jumlahUnsafeConditionController.text = patrol.jumlahUnsafeCondition.toString();
    _jumlahUnsafeActController.text = patrol.jumlahUnsafeAct.toString();
    
    _pekerjaDiamatiController.text = patrol.pekerjaDiamati.toString();
    _pekerjaPatuhApdController.text = patrol.pekerjaPatuhApd.toString();
    _pekerjaTidakPatuhApdController.text = patrol.pekerjaTidakPatuhApd.toString();
    
    _skorHousekeepingController.text = patrol.skorHousekeeping?.toString() ?? '';
    _kondisiHousekeeping = patrol.kondisiHousekeeping;
    _areaKotor = List<String>.from(patrol.areaKotor);
    _areaRapi = List<String>.from(patrol.areaRapi);
    _jumlahMesinDiperiksaController.text = patrol.jumlahMesinDiperiksa.toString();
    _mesinKondisiBaikController.text = patrol.mesinKondisiBaik.toString();
    _mesinPerluPerbaikanController.text = patrol.mesinPerluPerbaikan.toString();
    
    _rambuK3Lengkap = patrol.rambuK3Lengkap;
    _rambuK3Hilang = List<String>.from(patrol.rambuK3Hilang);
    _rambuK3Rusak = List<String>.from(patrol.rambuK3Rusak);
    _labelB3Lengkap = patrol.labelB3Lengkap;
    _jalurEvakuasiBebas = patrol.jalurEvakuasiBebas;
    _pintuDaruratBerfungsi = patrol.pintuDaruratBerfungsi;
    _aparTersedia = patrol.aparTersedia;
    _aparExpireController.text = patrol.aparExpire.toString();
    _emergencyLightBerfungsi = patrol.emergencyLightBerfungsi;
    
    _goodPractice = List<String>.from(patrol.goodPractice);
    _areaExcellent = List<String>.from(patrol.areaExcellent);
    _pekerjaTeladan = List<String>.from(patrol.pekerjaTeladan);
    _temuanKritikalController.text = patrol.temuanKritikal.toString();
    _temuanMayorController.text = patrol.temuanMayor.toString();
    _temuanMinorController.text = patrol.temuanMinor.toString();
    _rekomendasi = List<String>.from(patrol.rekomendasi);
    _catatanPatrolController.text = patrol.catatanPatrol ?? '';
    
    _jumlahActionItemController.text = patrol.jumlahActionItem.toString();
    _actionSelesaiController.text = patrol.actionSelesai.toString();
    _actionProgressController.text = patrol.actionProgress.toString();
    _actionBelumMulaiController.text = patrol.actionBelumMulai.toString();
    _stopWorkIssued = patrol.stopWorkIssued;
    _stopWorkArea = List<String>.from(patrol.stopWorkArea);
    _stopWorkAlasanController.text = patrol.stopWorkAlasan ?? '';
    _status = patrol.status;
    _tingkatUrgensi = patrol.tingkatUrgensi;
    _perluFollowUp = patrol.perluFollowUp;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomorPatrolController.dispose();
    _waktuMulaiController.dispose();
    _waktuSelesaiController.dispose();
    _areaPatrolController.dispose();
    _lokasiSpesifikController.dispose();
    _ketuaPatrolController.dispose();
    _tujuanPatrolController.dispose();
    _suhuAreaController.dispose();
    _jumlahUnsafeConditionController.dispose();
    _jumlahUnsafeActController.dispose();
    _pekerjaDiamatiController.dispose();
    _pekerjaPatuhApdController.dispose();
    _pekerjaTidakPatuhApdController.dispose();
    _skorHousekeepingController.dispose();
    _jumlahMesinDiperiksaController.dispose();
    _mesinKondisiBaikController.dispose();
    _mesinPerluPerbaikanController.dispose();
    _aparExpireController.dispose();
    _temuanKritikalController.dispose();
    _temuanMayorController.dispose();
    _temuanMinorController.dispose();
    _catatanPatrolController.dispose();
    _jumlahActionItemController.dispose();
    _actionSelesaiController.dispose();
    _actionProgressController.dispose();
    _actionBelumMulaiController.dispose();
    _stopWorkAlasanController.dispose();
    super.dispose();
  }

  // Photo management methods for Unsafe Condition
  Future<void> _takePictureForCondition(int conditionIndex) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (photo != null) {
        setState(() {
          _unsafeConditions[conditionIndex].photos.add(File(photo.path));
        });
        debugPrint('✅ Photo added to condition #${conditionIndex + 1}');
      }
    } catch (e) {
      debugPrint('❌ Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error mengambil foto: $e')),
        );
      }
    }
  }

  Future<void> _pickImagesForCondition(int conditionIndex) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(imageQuality: 85);
      
      if (images.isNotEmpty) {
        setState(() {
          _unsafeConditions[conditionIndex].photos.addAll(
            images.map((xFile) => File(xFile.path)).toList()
          );
        });
        debugPrint('✅ ${images.length} photos added to condition #${conditionIndex + 1}');
      }
    } catch (e) {
      debugPrint('❌ Error picking images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memilih foto: $e')),
        );
      }
    }
  }

  // Photo management methods for Unsafe Act
  Future<void> _takePictureForAct(int actIndex) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (photo != null) {
        setState(() {
          _unsafeActs[actIndex].photos.add(File(photo.path));
        });
        debugPrint('✅ Photo added to act #${actIndex + 1}');
      }
    } catch (e) {
      debugPrint('❌ Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error mengambil foto: $e')),
        );
      }
    }
  }

  Future<void> _pickImagesForAct(int actIndex) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(imageQuality: 85);
      
      if (images.isNotEmpty) {
        setState(() {
          _unsafeActs[actIndex].photos.addAll(
            images.map((xFile) => File(xFile.path)).toList()
          );
        });
        debugPrint('✅ ${images.length} photos added to act #${actIndex + 1}');
      }
    } catch (e) {
      debugPrint('❌ Error picking images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memilih foto: $e')),
        );
      }
    }
  }

  Future<void> _savePatrol() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi field yang wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Process Unsafe Condition Items with Photos
      List<Map<String, dynamic>> unsafeConditionData = [];
      for (int i = 0; i < _unsafeConditions.length; i++) {
        final item = _unsafeConditions[i];
        List<String> photoUrls = [];
        
        // Upload photos for this condition
        for (int j = 0; j < item.photos.length; j++) {
          try {
            final file = item.photos[j];
            final fileName = 'safety-patrol-unsafe-condition/${DateTime.now().millisecondsSinceEpoch}_${i}_$j.jpg';
            
            debugPrint('📤 Uploading condition #${i + 1} photo ${j + 1}/${item.photos.length}: $fileName');
            
            await Supabase.instance.client.storage
                .from('safety-patrol-photos')
                .upload(fileName, file);
            
            final photoUrl = Supabase.instance.client.storage
                .from('safety-patrol-photos')
                .getPublicUrl(fileName);
            
            photoUrls.add(photoUrl);
            debugPrint('✅ Condition #${i + 1} photo ${j + 1} uploaded');
          } catch (e) {
            debugPrint('⚠️ Failed to upload condition #${i + 1} photo ${j + 1}: $e');
          }
        }
        
        // Add condition data
        unsafeConditionData.add({
          'no': i + 1,
          'kategori': item.kategori,
          'tingkat_risiko': item.tingkatRisiko,
          'deskripsi': item.deskripsi,
          'lokasi': item.lokasi,
          'tindakan': item.tindakan,
          'foto_urls': photoUrls,
        });
      }

      // Process Unsafe Act Items with Photos
      List<Map<String, dynamic>> unsafeActData = [];
      for (int i = 0; i < _unsafeActs.length; i++) {
        final item = _unsafeActs[i];
        List<String> photoUrls = [];
        
        // Upload photos for this act
        for (int j = 0; j < item.photos.length; j++) {
          try {
            final file = item.photos[j];
            final fileName = 'safety-patrol-unsafe-act/${DateTime.now().millisecondsSinceEpoch}_${i}_$j.jpg';
            
            debugPrint('📤 Uploading act #${i + 1} photo ${j + 1}/${item.photos.length}: $fileName');
            
            await Supabase.instance.client.storage
                .from('safety-patrol-photos')
                .upload(fileName, file);
            
            final photoUrl = Supabase.instance.client.storage
                .from('safety-patrol-photos')
                .getPublicUrl(fileName);
            
            photoUrls.add(photoUrl);
            debugPrint('✅ Act #${i + 1} photo ${j + 1} uploaded');
          } catch (e) {
            debugPrint('⚠️ Failed to upload act #${i + 1} photo ${j + 1}: $e');
          }
        }
        
        // Add act data
        unsafeActData.add({
          'no': i + 1,
          'pekerja': item.pekerja,
          'tingkat_risiko': item.tingkatRisiko,
          'deskripsi': item.deskripsi,
          'lokasi': item.lokasi,
          'tindakan_langsung': item.tindakanLangsung,
          'foto_urls': photoUrls,
        });
      }

      final patrol = SafetyPatrol(
        id: widget.patrol?.id,
        nomorPatrol: _nomorPatrolController.text,
        tanggalPatrol: _tanggalPatrol,
        waktuMulai: _waktuMulaiController.text,
        waktuSelesai: _waktuSelesaiController.text,
        shift: _shift,
        areaPatrol: _areaPatrolController.text,
        lokasiSpesifik: _lokasiSpesifikController.text,
        ketuaPatrol: _ketuaPatrolController.text,
        anggotaPatrol: _anggotaPatrol,
        jumlahAnggota: _anggotaPatrol.length,
        jenisPatrol: _jenisPatrol,
        tujuanPatrol: _tujuanPatrolController.text,
        fokusPatrol: _fokusPatrol,
        cuaca: _cuaca,
        suhuArea: double.tryParse(_suhuAreaController.text),
        kondisiPencahayaan: _kondisiPencahayaan,
        kondisiVentilasi: _kondisiVentilasi,
        tingkatKebisingan: _tingkatKebisingan,
        jumlahUnsafeCondition: _unsafeConditions.length,
        unsafeCondition: unsafeConditionData,
        jumlahUnsafeAct: _unsafeActs.length,
        unsafeAct: unsafeActData,
        pekerjaDiamati: int.tryParse(_pekerjaDiamatiController.text) ?? 0,
        pekerjaPatuhApd: int.tryParse(_pekerjaPatuhApdController.text) ?? 0,
        pekerjaTidakPatuhApd: int.tryParse(_pekerjaTidakPatuhApdController.text) ?? 0,
        skorHousekeeping: int.tryParse(_skorHousekeepingController.text),
        kondisiHousekeeping: _kondisiHousekeeping,
        areaKotor: _areaKotor,
        areaRapi: _areaRapi,
        jumlahMesinDiperiksa: int.tryParse(_jumlahMesinDiperiksaController.text) ?? 0,
        mesinKondisiBaik: int.tryParse(_mesinKondisiBaikController.text) ?? 0,
        mesinPerluPerbaikan: int.tryParse(_mesinPerluPerbaikanController.text) ?? 0,
        rambuK3Lengkap: _rambuK3Lengkap,
        rambuK3Hilang: _rambuK3Hilang,
        rambuK3Rusak: _rambuK3Rusak,
        labelB3Lengkap: _labelB3Lengkap,
        jalurEvakuasiBebas: _jalurEvakuasiBebas,
        pintuDaruratBerfungsi: _pintuDaruratBerfungsi,
        aparTersedia: _aparTersedia,
        aparExpire: int.tryParse(_aparExpireController.text) ?? 0,
        emergencyLightBerfungsi: _emergencyLightBerfungsi,
        goodPractice: _goodPractice,
        areaExcellent: _areaExcellent,
        pekerjaTeladan: _pekerjaTeladan,
        temuanKritikal: int.tryParse(_temuanKritikalController.text) ?? 0,
        temuanMayor: int.tryParse(_temuanMayorController.text) ?? 0,
        temuanMinor: int.tryParse(_temuanMinorController.text) ?? 0,
        totalTemuan: (int.tryParse(_temuanKritikalController.text) ?? 0) +
            (int.tryParse(_temuanMayorController.text) ?? 0) +
            (int.tryParse(_temuanMinorController.text) ?? 0),
        rekomendasi: _rekomendasi,
        catatanPatrol: _catatanPatrolController.text,
        jumlahActionItem: int.tryParse(_jumlahActionItemController.text) ?? 0,
        actionSelesai: int.tryParse(_actionSelesaiController.text) ?? 0,
        actionProgress: int.tryParse(_actionProgressController.text) ?? 0,
        actionBelumMulai: int.tryParse(_actionBelumMulaiController.text) ?? 0,
        stopWorkIssued: _stopWorkIssued,
        stopWorkArea: _stopWorkArea,
        stopWorkAlasan: _stopWorkAlasanController.text,
        status: _status,
        tingkatUrgensi: _tingkatUrgensi,
        perluFollowUp: _perluFollowUp,
      );

      if (_isEditMode && widget.patrol?.id != null) {
        await _repository.update(widget.patrol!.id!, patrol);
      } else {
        await _repository.create(patrol);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Safety Patrol berhasil ${_isEditMode ? 'diupdate' : 'disimpan'}')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
        title: Text(_isEditMode ? 'Edit Safety Patrol' : 'Buat Safety Patrol'),
        backgroundColor: const Color(0xFFFF9800),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Data Dasar'),
            Tab(text: 'Kondisi'),
            Tab(text: 'Unsafe Condition'),
            Tab(text: 'Unsafe Act'),
            Tab(text: 'APD'),
            Tab(text: 'Housekeeping'),
            Tab(text: 'Emergency & Positif'),
            Tab(text: 'Action Items'),
            Tab(text: 'Status & Scoring'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDataDasarTab(),
            _buildKondisiTab(),
            _buildUnsafeConditionTab(),
            _buildUnsafeActTab(),
            _buildApdTab(),
            _buildHousekeepingPeralatanTab(),
            _buildEmergencyPositifTab(),
            _buildActionItemsTab(),
            _buildStatusScoringTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
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
                onPressed: _isLoading ? null : _savePatrol,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditMode ? 'Update' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Photo Methods
  Future<void> _takePicture(bool isUnsafeCondition) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          if (isUnsafeCondition) {
            _unsafeConditionPhotos.add(File(image.path));
          } else {
            _unsafeActPhotos.add(File(image.path));
          }
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickImages(bool isUnsafeCondition) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          if (isUnsafeCondition) {
            _unsafeConditionPhotos.addAll(images.map((image) => File(image.path)));
          } else {
            _unsafeActPhotos.addAll(images.map((image) => File(image.path)));
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void _removePhoto(bool isUnsafeCondition, int index) {
    setState(() {
      if (isUnsafeCondition) {
        _unsafeConditionPhotos.removeAt(index);
      } else {
        _unsafeActPhotos.removeAt(index);
      }
    });
  }

  // Tab 1: Data Dasar
  Widget _buildDataDasarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nomorPatrolController,
            decoration: const InputDecoration(
              labelText: 'Nomor Patrol',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _tanggalPatrol ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => _tanggalPatrol = date);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tanggal Patrol *',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _tanggalPatrol != null
                    ? '${_tanggalPatrol!.day}/${_tanggalPatrol!.month}/${_tanggalPatrol!.year}'
                    : 'Pilih tanggal',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _waktuMulaiController,
                  decoration: const InputDecoration(
                    labelText: 'Waktu Mulai *',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      _waktuMulaiController.text =
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _waktuSelesaiController,
                  decoration: const InputDecoration(
                    labelText: 'Waktu Selesai',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      _waktuSelesaiController.text =
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _shift,
            decoration: const InputDecoration(
              labelText: 'Shift',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'pagi', child: Text('Pagi')),
              DropdownMenuItem(value: 'siang', child: Text('Siang')),
              DropdownMenuItem(value: 'malam', child: Text('Malam')),
            ],
            onChanged: (value) => setState(() => _shift = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _areaPatrolController,
            decoration: const InputDecoration(
              labelText: 'Area Patrol *',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lokasiSpesifikController,
            decoration: const InputDecoration(
              labelText: 'Lokasi Spesifik',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ketuaPatrolController,
            decoration: const InputDecoration(
              labelText: 'Ketua Patrol *',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Anggota Patrol',
            _anggotaPatrol,
            (value) => setState(() => _anggotaPatrol.add(value)),
            (index) => setState(() => _anggotaPatrol.removeAt(index)),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _jenisPatrol,
            decoration: const InputDecoration(
              labelText: 'Jenis Patrol',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'rutin', child: Text('Rutin')),
              DropdownMenuItem(value: 'terjadwal', child: Text('Terjadwal')),
              DropdownMenuItem(value: 'insidental', child: Text('Insidental')),
              DropdownMenuItem(value: 'khusus', child: Text('Khusus')),
              DropdownMenuItem(value: 'malam', child: Text('Malam')),
              DropdownMenuItem(value: 'emergency', child: Text('Emergency')),
            ],
            onChanged: (value) => setState(() => _jenisPatrol = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tujuanPatrolController,
            decoration: const InputDecoration(
              labelText: 'Tujuan Patrol',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Fokus Patrol',
            _fokusPatrol,
            (value) => setState(() => _fokusPatrol.add(value)),
            (index) => setState(() => _fokusPatrol.removeAt(index)),
          ),
        ],
      ),
    );
  }

  // Tab 2: Kondisi Lingkungan
  Widget _buildKondisiTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _cuaca,
            decoration: const InputDecoration(
              labelText: 'Cuaca',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'cerah', child: Text('Cerah')),
              DropdownMenuItem(value: 'mendung', child: Text('Mendung')),
              DropdownMenuItem(value: 'hujan', child: Text('Hujan')),
              DropdownMenuItem(value: 'panas', child: Text('Panas')),
            ],
            onChanged: (value) => setState(() => _cuaca = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _suhuAreaController,
            decoration: const InputDecoration(
              labelText: 'Suhu Area (°C)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _kondisiPencahayaan,
            decoration: const InputDecoration(
              labelText: 'Kondisi Pencahayaan',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'baik', child: Text('Baik')),
              DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
              DropdownMenuItem(value: 'kurang', child: Text('Kurang')),
              DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
            ],
            onChanged: (value) => setState(() => _kondisiPencahayaan = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _kondisiVentilasi,
            decoration: const InputDecoration(
              labelText: 'Kondisi Ventilasi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'baik', child: Text('Baik')),
              DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
              DropdownMenuItem(value: 'kurang', child: Text('Kurang')),
              DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
            ],
            onChanged: (value) => setState(() => _kondisiVentilasi = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _tingkatKebisingan,
            decoration: const InputDecoration(
              labelText: 'Tingkat Kebisingan',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'normal', child: Text('Normal')),
              DropdownMenuItem(value: 'cukup_bising', child: Text('Cukup Bising')),
              DropdownMenuItem(value: 'bising', child: Text('Bising')),
              DropdownMenuItem(value: 'sangat_bising', child: Text('Sangat Bising')),
            ],
            onChanged: (value) => setState(() => _tingkatKebisingan = value),
          ),
        ],
      ),
    );
  }

  // Tab 3: Unsafe Condition
  // Tab 3: Unsafe Condition
  Widget _buildUnsafeConditionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kondisi Tidak Aman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[700]),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _unsafeConditions.add(UnsafeConditionItem());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Kondisi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List of Unsafe Conditions
          if (_unsafeConditions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Belum ada kondisi tidak aman.\nKlik "Tambah Kondisi" untuk menambahkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...List.generate(_unsafeConditions.length, (index) {
              final item = _unsafeConditions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.red[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red[200]!, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kondisi #${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _unsafeConditions.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Kategori
                      DropdownButtonFormField<String>(
                        value: item.kategori.isEmpty ? null : item.kategori,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'peralatan', child: Text('Peralatan Rusak')),
                          DropdownMenuItem(value: 'lantai', child: Text('Lantai/Permukaan')),
                          DropdownMenuItem(value: 'listrik', child: Text('Listrik/Kabel')),
                          DropdownMenuItem(value: 'struktur', child: Text('Struktur Bangunan')),
                          DropdownMenuItem(value: 'bahan_kimia', child: Text('Bahan Kimia')),
                          DropdownMenuItem(value: 'ventilasi', child: Text('Ventilasi')),
                          DropdownMenuItem(value: 'pencahayaan', child: Text('Pencahayaan')),
                          DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            item.kategori = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Tingkat Risiko
                      DropdownButtonFormField<String>(
                        value: item.tingkatRisiko,
                        decoration: const InputDecoration(
                          labelText: 'Tingkat Risiko',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'kritikal', child: Text('Kritikal')),
                          DropdownMenuItem(value: 'tinggi', child: Text('Tinggi')),
                          DropdownMenuItem(value: 'sedang', child: Text('Sedang')),
                          DropdownMenuItem(value: 'rendah', child: Text('Rendah')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            item.tingkatRisiko = value ?? 'sedang';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Deskripsi
                      TextFormField(
                        initialValue: item.deskripsi,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          item.deskripsi = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Lokasi
                      TextFormField(
                        initialValue: item.lokasi,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          item.lokasi = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Tindakan
                      TextFormField(
                        initialValue: item.tindakan,
                        decoration: const InputDecoration(
                          labelText: 'Tindakan',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 2,
                        onChanged: (value) {
                          item.tindakan = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Foto Bukti
                      const Text(
                        'Foto Bukti',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _takePictureForCondition(index),
                              icon: const Icon(Icons.camera_alt, size: 20),
                              label: const Text('Ambil Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImagesForCondition(index),
                              icon: const Icon(Icons.photo_library, size: 20),
                              label: const Text('Pilih dari Galeri'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📸 Ambil foto langsung atau pilih dari galeri. Foto akan dikompres otomatis jika >1MB',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      
                      // Photo Preview
                      if (item.photos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: item.photos.length,
                          itemBuilder: (context, photoIndex) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    item.photos[photoIndex],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        item.photos.removeAt(photoIndex);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  // Tab 4: Unsafe Act
  // Tab 4: Unsafe Act
  Widget _buildUnsafeActTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tindakan Tidak Aman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange[700]),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _unsafeActs.add(UnsafeActItem());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Tindakan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List of Unsafe Acts
          if (_unsafeActs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Belum ada tindakan tidak aman.\nKlik "Tambah Tindakan" untuk menambahkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...List.generate(_unsafeActs.length, (index) {
              final item = _unsafeActs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.orange[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.orange[200]!, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tindakan #${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.orange),
                            onPressed: () {
                              setState(() {
                                _unsafeActs.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Pekerja
                      TextFormField(
                        initialValue: item.pekerja,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pekerja',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          item.pekerja = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Tingkat Risiko
                      DropdownButtonFormField<String>(
                        value: item.tingkatRisiko,
                        decoration: const InputDecoration(
                          labelText: 'Tingkat Risiko',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'kritikal', child: Text('Kritikal')),
                          DropdownMenuItem(value: 'tinggi', child: Text('Tinggi')),
                          DropdownMenuItem(value: 'sedang', child: Text('Sedang')),
                          DropdownMenuItem(value: 'rendah', child: Text('Rendah')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            item.tingkatRisiko = value ?? 'sedang';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Deskripsi
                      TextFormField(
                        initialValue: item.deskripsi,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Tindakan Tidak Aman',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          item.deskripsi = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Lokasi
                      TextFormField(
                        initialValue: item.lokasi,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          item.lokasi = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Tindakan Langsung
                      TextFormField(
                        initialValue: item.tindakanLangsung,
                        decoration: const InputDecoration(
                          labelText: 'Tindakan Langsung yang Diambil',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 2,
                        onChanged: (value) {
                          item.tindakanLangsung = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Foto Bukti
                      const Text(
                        'Foto Bukti',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _takePictureForAct(index),
                              icon: const Icon(Icons.camera_alt, size: 20),
                              label: const Text('Ambil Foto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImagesForAct(index),
                              icon: const Icon(Icons.photo_library, size: 20),
                              label: const Text('Pilih dari Galeri'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📸 Ambil foto langsung atau pilih dari galeri. Foto akan dikompres otomatis jika >1MB',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      
                      // Photo Preview
                      if (item.photos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: item.photos.length,
                          itemBuilder: (context, photoIndex) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    item.photos[photoIndex],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        item.photos.removeAt(photoIndex);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  // Tab 4: Kepatuhan APD
  Widget _buildApdTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _pekerjaDiamatiController,
            decoration: const InputDecoration(
              labelText: 'Pekerja Diamati',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pekerjaPatuhApdController,
            decoration: const InputDecoration(
              labelText: 'Pekerja Patuh APD',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pekerjaTidakPatuhApdController,
            decoration: const InputDecoration(
              labelText: 'Pekerja Tidak Patuh APD',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Tab 6: Housekeeping & Peralatan
  Widget _buildHousekeepingPeralatanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Housekeeping Section
          Text(
            'Housekeeping',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _skorHousekeepingController,
            decoration: const InputDecoration(
              labelText: 'Skor Housekeeping (0-100)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _kondisiHousekeeping,
            decoration: const InputDecoration(
              labelText: 'Kondisi Housekeeping',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'sangat_baik', child: Text('Sangat Baik')),
              DropdownMenuItem(value: 'baik', child: Text('Baik')),
              DropdownMenuItem(value: 'cukup', child: Text('Cukup')),
              DropdownMenuItem(value: 'kurang', child: Text('Kurang')),
              DropdownMenuItem(value: 'buruk', child: Text('Buruk')),
            ],
            onChanged: (value) => setState(() => _kondisiHousekeeping = value),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Area Kotor',
            _areaKotor,
            (value) => setState(() => _areaKotor.add(value)),
            (index) => setState(() => _areaKotor.removeAt(index)),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Area Rapi',
            _areaRapi,
            (value) => setState(() => _areaRapi.add(value)),
            (index) => setState(() => _areaRapi.removeAt(index)),
          ),
          const SizedBox(height: 24),
          // Peralatan & Mesin Section
          Text(
            'Peralatan & Mesin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[700]),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _jumlahMesinDiperiksaController,
            decoration: const InputDecoration(
              labelText: 'Jumlah Mesin Diperiksa',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mesinKondisiBaikController,
            decoration: const InputDecoration(
              labelText: 'Mesin Kondisi Baik',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mesinPerluPerbaikanController,
            decoration: const InputDecoration(
              labelText: 'Mesin Perlu Perbaikan',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Tab 7: Emergency & Positif  
  Widget _buildEmergencyPositifTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Emergency Facilities Section
          Text(
            'Fasilitas Darurat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow[800]),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Rambu K3 Lengkap'),
            value: _rambuK3Lengkap,
            onChanged: (value) => setState(() => _rambuK3Lengkap = value ?? false),
          ),
          _buildListField(
            'Rambu K3 Hilang',
            _rambuK3Hilang,
            (value) => setState(() => _rambuK3Hilang.add(value)),
            (index) => setState(() => _rambuK3Hilang.removeAt(index)),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Rambu K3 Rusak',
            _rambuK3Rusak,
            (value) => setState(() => _rambuK3Rusak.add(value)),
            (index) => setState(() => _rambuK3Rusak.removeAt(index)),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Label B3 Lengkap'),
            value: _labelB3Lengkap,
            onChanged: (value) => setState(() => _labelB3Lengkap = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Jalur Evakuasi Bebas'),
            value: _jalurEvakuasiBebas,
            onChanged: (value) => setState(() => _jalurEvakuasiBebas = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Pintu Darurat Berfungsi'),
            value: _pintuDaruratBerfungsi,
            onChanged: (value) => setState(() => _pintuDaruratBerfungsi = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('APAR Tersedia'),
            value: _aparTersedia,
            onChanged: (value) => setState(() => _aparTersedia = value ?? false),
          ),
          TextFormField(
            controller: _aparExpireController,
            decoration: const InputDecoration(
              labelText: 'Jumlah APAR Expire',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Emergency Light Berfungsi'),
            value: _emergencyLightBerfungsi,
            onChanged: (value) => setState(() => _emergencyLightBerfungsi = value ?? false),
          ),
          const SizedBox(height: 24),
          // Positif Section
          Text(
            'Temuan Positif',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Good Practice',
            _goodPractice,
            (value) => setState(() => _goodPractice.add(value)),
            (index) => setState(() => _goodPractice.removeAt(index)),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Area Excellent',
            _areaExcellent,
            (value) => setState(() => _areaExcellent.add(value)),
            (index) => setState(() => _areaExcellent.removeAt(index)),
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Pekerja Teladan',
            _pekerjaTeladan,
            (value) => setState(() => _pekerjaTeladan.add(value)),
            (index) => setState(() => _pekerjaTeladan.removeAt(index)),
          ),
        ],
      ),
    );
  }

  // Tab 8: Action Items
  Widget _buildActionItemsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _jumlahActionItemController,
            decoration: const InputDecoration(
              labelText: 'Jumlah Action Item',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _actionSelesaiController,
            decoration: const InputDecoration(
              labelText: 'Action Selesai',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _actionProgressController,
            decoration: const InputDecoration(
              labelText: 'Action Progress',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _actionBelumMulaiController,
            decoration: const InputDecoration(
              labelText: 'Action Belum Mulai',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Stop Work Issued'),
            value: _stopWorkIssued,
            onChanged: (value) => setState(() => _stopWorkIssued = value ?? false),
          ),
          if (_stopWorkIssued) ...[
            _buildListField(
              'Stop Work Area',
              _stopWorkArea,
              (value) => setState(() => _stopWorkArea.add(value)),
              (index) => setState(() => _stopWorkArea.removeAt(index)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stopWorkAlasanController,
              decoration: const InputDecoration(
                labelText: 'Stop Work Alasan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // Tab 9: Status & Scoring
  Widget _buildStatusScoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Status',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              DropdownMenuItem(value: 'submitted', child: Text('Submitted')),
              DropdownMenuItem(value: 'reviewed', child: Text('Reviewed')),
              DropdownMenuItem(value: 'closed', child: Text('Closed')),
              DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            onChanged: (value) => setState(() => _status = value ?? 'draft'),
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
            onChanged: (value) => setState(() => _tingkatUrgensi = value ?? 'normal'),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Perlu Follow Up'),
            value: _perluFollowUp,
            onChanged: (value) => setState(() => _perluFollowUp = value ?? false),
          ),
          const SizedBox(height: 24),
          Text(
            'Temuan',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _temuanKritikalController,
            decoration: const InputDecoration(
              labelText: 'Temuan Kritikal',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _temuanMayorController,
            decoration: const InputDecoration(
              labelText: 'Temuan Mayor',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _temuanMinorController,
            decoration: const InputDecoration(
              labelText: 'Temuan Minor',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildListField(
            'Rekomendasi',
            _rekomendasi,
            (value) => setState(() => _rekomendasi.add(value)),
            (index) => setState(() => _rekomendasi.removeAt(index)),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _catatanPatrolController,
            decoration: const InputDecoration(
              labelText: 'Catatan Patrol',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Helper: Build list field with add/remove functionality
  Widget _buildListField(
    String label,
    List<String> items,
    Function(String) onAdd,
    Function(int) onRemove,
  ) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Tambah $label',
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.asMap().entries.map((entry) {
              return Chip(
                label: Text(entry.value),
                onDeleted: () => onRemove(entry.key),
                deleteIconColor: Colors.red,
              );
            }).toList(),
          ),
      ],
    );
  }
}
