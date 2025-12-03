class AppConstants {
  // App Info
  static const String appName = 'Unsafe Action/Condition';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Image
  static const int maxImageSizeMB = 1;
  static const int imageQuality = 85;
  static const int maxPhotosPerIncident = 10;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  
  // Validation
  static const int minDescriptionLength = 20;
  static const int maxDescriptionLength = 1000;
  
  // Priority levels
  static const List<String> priorityLevels = ['low', 'medium', 'high', 'critical'];
  
  // Status
  static const List<String> statusList = [
    'draft',
    'reported',
    'investigating',
    'resolved',
    'closed'
  ];
  
  // Jenis Kejadian
  static const String jenisUnsafeAction = 'unsafe_action';
  static const String jenisUnsafeCondition = 'unsafe_condition';
  
  // Categories for Unsafe Action
  static const List<String> unsafeActionCategories = [
    'Tidak Menggunakan APD',
    'Bekerja di Ketinggian Tanpa Pengaman',
    'Merokok di Area Terlarang',
    'Mengoperasikan Alat Tanpa Izin',
    'Melakukan Shortcut',
    'Bekerja Dalam Kondisi Lelah',
    'Mengabaikan Prosedur',
    'Lainnya',
  ];
  
  // Categories for Unsafe Condition
  static const List<String> unsafeConditionCategories = [
    'Pencahayaan Kurang',
    'Ventilasi Buruk',
    'Lantai Licin/Basah',
    'Akses Terhalang',
    'Kabel/Kabel Listrik Terbuka',
    'Material Berbahaya Tidak Diberi Label',
    'Housekeeping Buruk',
    'Lainnya',
  ];
  
  // Unit Kerja (should be fetched from API, but these are defaults)
  static const List<String> unitKerjaList = [
    'Unit Banjarmasin',
    'Unit Samarinda',
    'Unit Balikpapan',
    'Unit Jakarta',
    'Unit Surabaya',
  ];
}
