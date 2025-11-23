import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Theme Colors - Luxurious Palette
  static const Color backgroundDark = Color(0xFF0f172a); // Rich Slate 900
  static const Color backgroundSecondaryDark = Color(0xFF1e293b); // Slate 800
  static const Color cardColorDark = Color(0xFF1e293b); // Slate 800
  
  // Light Theme Colors - Clean & Elegant
  static const Color backgroundLight = Color(0xFFf8fafc); // Slate 50
  static const Color backgroundSecondaryLight = Color(0xFFffffff);
  static const Color cardColorLight = Color(0xFFffffff);
  
  // Common Colors
  static const Color primaryColor = Color(0xFF3b82f6); // Blue Accent
  static const Color successGreen = Color(0xFF10b981); // More vibrant green
  static const Color dangerRed = Color(0xFFef4444);
  static const Color warningOrange = Color(0xFFf59e0b);
  
  // Dark Theme Text Colors
  static const Color textPrimaryDark = Color(0xFFf3f4f6); // Brighter white
  static const Color textSecondaryDark = Color(0xFF9ca3af);
  
  // Light Theme Text Colors
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6b7280);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColorDark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: successGreen,
        error: dangerRed,
        surface: cardColorDark,
        background: backgroundDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryDark,
        onBackground: textPrimaryDark,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: textPrimaryDark),
          bodyLarge: TextStyle(color: textPrimaryDark),
          bodyMedium: TextStyle(color: textPrimaryDark),
          bodySmall: TextStyle(color: textSecondaryDark),
          labelLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(color: textSecondaryDark),
          labelSmall: TextStyle(color: textSecondaryDark),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColorDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColorDark,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundSecondaryDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed),
        ),
        labelStyle: GoogleFonts.cairo(color: textSecondaryDark),
        hintStyle: GoogleFonts.cairo(color: textSecondaryDark),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: backgroundSecondaryDark,
        selectedColor: successGreen.withOpacity(0.2),
        labelStyle: GoogleFonts.cairo(color: textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardColorLight,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: successGreen,
        error: dangerRed,
        surface: cardColorLight,
        background: backgroundLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
        onBackground: textPrimaryLight,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: textPrimaryLight),
          bodyLarge: TextStyle(color: textPrimaryLight),
          bodyMedium: TextStyle(color: textPrimaryLight),
          bodySmall: TextStyle(color: textSecondaryLight),
          labelLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(color: textSecondaryLight),
          labelSmall: TextStyle(color: textSecondaryLight),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 2,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColorLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.3),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerRed),
        ),
        labelStyle: GoogleFonts.cairo(color: textSecondaryLight),
        hintStyle: GoogleFonts.cairo(color: textSecondaryLight),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: successGreen.withOpacity(0.2),
        labelStyle: GoogleFonts.cairo(color: textPrimaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
    );
  }
}

