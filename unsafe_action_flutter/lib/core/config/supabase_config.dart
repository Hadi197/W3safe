import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  static const String storagePhotoBucket = 'unsafe-action-condition-photos';
  static const String storageVideoBucket = 'unsafe-action-condition-videos';
  static const String storageAudioBucket = 'unsafe-action-condition-audio';
  
  // Table names
  static const String unsafeActionConditionTable = 'unsafe_action_condition';
  static const String pegawaiTable = 'pegawai';
  static const String unitsTable = 'units';
}
