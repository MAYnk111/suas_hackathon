import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFF5E6C9);
  static const Color foreground = Color(0xFF2D1B0E);
  static const Color card = Color(0xFFFFF8E1);
  static const Color border = Color(0xFFDFC189);
  static const Color muted = Color(0xFFF1E2C4);
  static const Color mutedForeground = Color(0xFF7A5A39);
  static const Color primary = Color(0xFF800000);
  static const Color primaryForeground = Color(0xFFDAA520);
  static const Color secondary = Color(0xFFDAA520);
  static const Color secondaryForeground = Color(0xFF2D1B0E);
  static const Color accent = Color(0xFFCD853F);
  static const Color accentForeground = Color(0xFF2D1B0E);
  static const Color sage = Color(0xFF8A6F4D);
  static const Color sageForeground = Color(0xFFF5E6C9);
  static const Color warm = Color(0xFFF2DEC1);
  static const Color warmForeground = Color(0xFF2D1B0E);
  static const Color coral = Color(0xFFC86B5C);
  static const Color coralForeground = Color(0xFFF5E6C9);
  static const Color destructive = Color(0xFFB71C1C);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color sidebarBackground = Color(0xFFF5E6C9);
  static const Color sidebarForeground = Color(0xFF2D1B0E);

  static const double radius = 12;

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
      backgroundColor: Colors.transparent,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: 1.1,
      ),
      iconTheme: const IconThemeData(color: primary),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: secondary.withOpacity(0.5), width: 1),
      ),
      surfaceTintColor: secondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.4),
      border: UnderlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(4),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primary.withOpacity(0.5)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: secondary, width: 2),
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
        foregroundColor: secondary,
        textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: secondary, width: 1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
      ),
    ),
  );

  // Dark theme colors
  static const Color darkBackground = Color(0xFF3E2723);
  static const Color darkForeground = Color(0xFFF5E6C9);
  static const Color darkCard = Color(0xFF4E342E);
  static const Color darkBorder = Color(0xFF5D4037);
  static const Color darkMuted = Color(0xFF4E342E);
  static const Color darkMutedForeground = Color(0xFFD8C2A2);

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
      backgroundColor: Colors.transparent,
      foregroundColor: darkForeground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: darkForeground,
        letterSpacing: 1.1,
      ),
      iconTheme: const IconThemeData(color: secondary),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: secondary.withOpacity(0.5), width: 1),
      ),
      surfaceTintColor: secondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: UnderlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(4),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primary.withOpacity(0.5)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: secondary, width: 2),
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
        foregroundColor: secondary,
        textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: secondary, width: 1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkForeground,
        side: const BorderSide(color: primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
      ),
    ),
  );

  static TextTheme _buildTextTheme({bool isDark = false}) {
    final base = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final textColor = isDark ? darkForeground : foreground;
    final mutedColor = isDark ? darkMutedForeground : mutedForeground;

    return base.copyWith(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleLarge: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: GoogleFonts.crimsonText(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleSmall: GoogleFonts.crimsonText(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.crimsonText(
        fontSize: 18,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.crimsonText(
        fontSize: 16,
        color: textColor,
      ),
      bodySmall: GoogleFonts.crimsonText(
        fontSize: 14,
        color: mutedColor,
      ),
      labelLarge: GoogleFonts.cinzel(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
