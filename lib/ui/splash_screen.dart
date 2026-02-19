import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final scaleFactor = isSmallScreen ? 0.8 : 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  SizedBox(
                    width: 140 * scaleFactor,
                    height: 140 * scaleFactor,
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 32 * scaleFactor),
                  Text(
                    'Offline CV',
                    style: GoogleFonts.inter(
                      fontSize: 36 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12 * scaleFactor),
                  Text(
                    'Professional Resume Builder',
                    style: GoogleFonts.inter(
                      fontSize: 18 * scaleFactor,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 48 * scaleFactor),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainLayout()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 48 * scaleFactor,
                        vertical: 16 * scaleFactor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 18 * scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Add some bottom padding for smaller screens to avoid overlap with branding
                  SizedBox(height: 100 * scaleFactor),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: size.height * 0.05,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Powered by',
                    style: GoogleFonts.inter(
                      fontSize: 12 * scaleFactor,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/images/novabyte_logo_white_v2.png',
                    height: 80 * scaleFactor, // Increased size
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
