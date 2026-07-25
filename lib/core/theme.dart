import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF29ABE2);
  static const Color lightBlue = Color(0xFFB3DFF7); // disabled button state
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGrey = Color(0xFF757575);
  static const Color inputFill = Color(0xFFEFEFEF);
  static const Color white = Color(0xFFFFFFFF);

  // Aliases used by some screens - kept in sync with the colors above
  static const Color fieldFill = inputFill;
  static const Color bodyGrey = textGrey;
  static const Color hintGrey = textGrey;
  static const Color disabledBlue = lightBlue;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: 'Poppins', // body font, we'll add this below
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}