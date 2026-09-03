import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const navy = Color(0xFF071221);
  static const navy2 = Color(0xFF0B1830);
  static const teal = Color(0xFF16C4B8);
  static const cyan = Color(0xFF25D7E8);
  static const blue = Color(0xFF586BFF);
  static const lightBg = Color(0xFFF4F8FC);
  static const text = Color(0xFF0A1426);
  static const muted = Color(0xFF62758C);
  static const border = Color(0xFFD8E2EC);
  static const dark = Color(0xFF06101F);

  static ThemeData get data {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: teal,
        brightness: Brightness.light,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
        displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
        headlineLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
        headlineMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
        titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800),
        bodyLarge: GoogleFonts.inter(),
        bodyMedium: GoogleFonts.inter(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: teal, width: 2),
        ),
      ),
    );
  }
}
