import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFFAF8F5);
  static const Color foreground = Color(0xFF252B37);
  static const Color card = Color(0xFFFDFDFC);
  static const Color border = Color(0xFFEBE6E0);
  static const Color muted = Color(0xFFF1EEEA);
  static const Color mutedForeground = Color(0xFF737B8C);
  static const Color primary = Color(0xFFEF8239);
  static const Color primaryForeground = Color(0xFFFDFDFC);
  static const Color secondary = Color(0xFFD9E8E2);
  static const Color secondaryForeground = Color(0xFF2D5346);
  static const Color accent = Color(0xFFD1E0F0);
  static const Color accentForeground = Color(0xFF264059);
  static const Color sage = Color(0xFF9FC6B6);
  static const Color sageForeground = Color(0xFF244236);
  static const Color warm = Color(0xFFF7EDDE);
  static const Color warmForeground = Color(0xFF735326);
  static const Color coral = Color(0xFFE47C67);
  static const Color coralForeground = Color(0xFF521F14);
  static const Color destructive = Color(0xFFDF3A3A);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color sidebarBackground = Color(0xFFF8F6F2);
  static const Color sidebarForeground = Color(0xFF414958);

  static const double radius = 16;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    textTheme: _buildTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      surface: card,
      onSurface: foreground,
      error: destructive,
      onError: destructiveForeground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: foreground),
      iconTheme: const IconThemeData(color: foreground),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: mutedForeground),
    ),
    dividerColor: border,
    chipTheme: const ChipThemeData(
      backgroundColor: muted,
      labelStyle: TextStyle(color: mutedForeground, fontWeight: FontWeight.w600),
      side: BorderSide(color: border),
      shape: StadiumBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        side: const BorderSide(color: border),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1D23);
  static const Color darkForeground = Color(0xFFF5F5F5);
  static const Color darkCard = Color(0xFF252931);
  static const Color darkBorder = Color(0xFF313740);
  static const Color darkMuted = Color(0xFF2A2F38);
  static const Color darkMutedForeground = Color(0xFFB8BCC8);

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: darkBackground,
    textTheme: _buildTextTheme(isDark: true),
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      surface: darkCard,
      onSurface: darkForeground,
      error: destructive,
      onError: destructiveForeground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkForeground,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: darkForeground),
      iconTheme: const IconThemeData(color: darkForeground),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: darkBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: darkMutedForeground),
    ),
    dividerColor: darkBorder,
    chipTheme: const ChipThemeData(
      backgroundColor: darkMuted,
      labelStyle: TextStyle(color: darkMutedForeground, fontWeight: FontWeight.w600),
      side: BorderSide(color: darkBorder),
      shape: StadiumBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkForeground,
        side: const BorderSide(color: darkBorder),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static TextTheme _buildTextTheme({bool isDark = false}) {
    final base = GoogleFonts.dmSansTextTheme();
    final textColor = isDark ? darkForeground : foreground;
    final mutedColor = isDark ? darkMutedForeground : mutedForeground;
    
    return base.copyWith(
      headlineLarge: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: textColor),
      headlineMedium: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: textColor),
      titleLarge: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: textColor),
      titleMedium: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
      bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: textColor),
      bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: textColor),
      bodySmall: base.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: mutedColor),
    );
  }
}
