import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        // Display / Headings
        displayLarge: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        displaySmall: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          color: AppColors.primary,
        ),
        // Body / UI
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w400,
          color: AppColors.mutedText,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.mutedText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}
