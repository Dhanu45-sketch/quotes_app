import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double kScreenPadding = 28;

abstract final class AppColors {
  static const Color primary = Color(0xFF4699FA);
  static const Color textSecondary = Color(0xFF797979); // authors
  static const Color titleGrey = Color(0xFF8D8D8D); // screen titles
  static const Color card = Color(0xFFEFEFEF);
  static const Color navBar = Color(0xFFE4E4E4);
  static const Color navUnselected = Color(0xFF5B5B5B);
}

abstract final class AppTextStyles {
  static TextStyle get screenTitle => GoogleFonts.quicksand(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.titleGrey,
      );

  static TextStyle get quoteLarge => GoogleFonts.quicksand(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: Colors.black,
      );

  static TextStyle get authorLarge => GoogleFonts.quicksand(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get quoteCard => GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: Colors.black,
      );

  static TextStyle get authorCard => GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get navLabel =>
      GoogleFonts.quicksand(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get splashTitle => GoogleFonts.quicksand(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        shadows: const [
          Shadow(offset: Offset(0, 4), blurRadius: 4, color: Color(0x40000000)),
        ],
      );
}

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
    );

    return base.copyWith(
      textTheme: GoogleFonts.quicksandTextTheme(base.textTheme),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
