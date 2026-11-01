import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/resume_provider.dart';
import 'services/storage_service.dart';
import 'ui/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fonts are bundled in assets/fonts so they work without internet.
  GoogleFonts.config.allowRuntimeFetching = false;

  final savedResume = await StorageService.loadResume();

  runApp(
    ProviderScope(
      overrides: [initialResumeProvider.overrideWithValue(savedResume)],
      child: const OfflineResumeApp(),
    ),
  );
}

class OfflineResumeApp extends StatelessWidget {
  const OfflineResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          primary: const Color(0xFF3B82F6),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
