import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/incident_list/incident_list_screen.dart';
import 'presentation/screens/incident_form/incident_form_screen.dart';
import 'presentation/screens/incident_detail/incident_detail_screen.dart';
import 'presentation/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Supabase
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key';
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsafe Action/Condition',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/incidents': (context) => const IncidentListScreen(),
        '/incident/create': (context) => const IncidentFormScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/incident/detail') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => IncidentDetailScreen(
              incidentId: args?['id'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}
