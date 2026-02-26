import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VatsalyaTheme {
  // Vedic / Ancient Indian Palette
  static const Color primaryColor = Color(0xFF800000); // Deep Maroon
  static const Color secondaryColor = Color(0xFFDAA520); // Antique Gold
  static const Color accentColor = Color(0xFFCD853F); // Bronze

  // Parchment Backgrounds
  static const Color parchmentLight = Color(0xFFF5E6C9);
  static const Color parchmentDark = Color(0xFF3E2723);

  // Text Colors
  static const Color textDark = Color(0xFF2D1B0E);
  static const Color textLight = Color(0xFFF5E6C9);

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      tertiary: accentColor,
      background: isDark ? parchmentDark : parchmentLight,
      surface: isDark ? const Color(0xFF4E342E) : const Color(0xFFFFF8E1),
      onSurface: isDark ? textLight : textDark,
      onBackground: isDark ? textLight : textDark,
    );

    final baseTextTheme =
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    final textTheme = baseTextTheme.copyWith(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? textLight : textDark,
      ),
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? textLight : textDark,
      ),
      headlineSmall: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: isDark ? textLight : textDark,
      ),
      titleLarge: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
      titleMedium: GoogleFonts.crimsonText(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
      titleSmall: GoogleFonts.crimsonText(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? textLight : textDark,
      ),
      bodyLarge: GoogleFonts.crimsonText(
        fontSize: 18,
        color: isDark ? textLight : textDark,
      ),
      bodyMedium: GoogleFonts.crimsonText(
        fontSize: 16,
        color: isDark ? textLight : textDark,
      ),
      bodySmall: GoogleFonts.crimsonText(
        fontSize: 14,
        color: isDark
            ? textLight.withOpacity(0.8)
            : textDark.withOpacity(0.8),
      ),
      labelLarge: GoogleFonts.cinzel(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? textLight : textDark,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? parchmentDark : parchmentLight,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? textLight : primaryColor,
        centerTitle: true,
        iconTheme:
            IconThemeData(color: isDark ? secondaryColor : primaryColor),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? textLight : primaryColor,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: secondaryColor.withOpacity(0.5), width: 1),
        ),
        color: isDark ? const Color(0xFF4E342E) : const Color(0xFFFFF8E1),
        surfaceTintColor: secondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          side: const BorderSide(color: secondaryColor, width: 1),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.black.withOpacity(0.2)
            : Colors.white.withOpacity(0.4),
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 2),
        ),
        labelStyle: TextStyle(
          color:
              isDark ? textLight.withOpacity(0.7) : textDark.withOpacity(0.7),
          fontFamily: GoogleFonts.crimsonText().fontFamily,
          fontSize: 18,
        ),
        prefixIconColor: primaryColor,
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
    );
  }
}
