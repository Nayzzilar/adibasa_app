import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff462f00),
      surfaceTint: Color(0xff785922),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff61450f), // Matsu Foreground
      onPrimaryContainer: Color(0xffdbb474),
      secondary: Color(0xff6a5d43),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff1dfbe),
      onSecondaryContainer: Color(0xff6f6248),
      tertiary: Color(0xff5e6220),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa3a85e),
      onTertiaryContainer: Color(0xff383c00),
      error: Color(0xff66150e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff852c22),
      onErrorContainer: Color(0xffffa294),
      surface: Color(0xfff2e3c6), // Matsu Card
      onSurface: Color(0xff1d1b19),
      onSurfaceVariant: Color(0xff4d463c),
      outline: Color(0xffC0A77E), // Matsu Border
      outlineVariant: Color(0xffd0c5b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff32302e),
      inversePrimary: Color(0xffe9c07f),
      primaryFixed: Color(0xffffdeac),
      onPrimaryFixed: Color(0xff281900),
      primaryFixedDim: Color(0xffe9c07f),
      onPrimaryFixedVariant: Color(0xff5d420c),
      secondaryFixed: Color(0xfff3e0bf),
      onSecondaryFixed: Color(0xff231a06),
      secondaryFixedDim: Color(0xffd6c5a5),
      onSecondaryFixedVariant: Color(0xff51452d),
      tertiaryFixed: Color(0xffe3e897),
      onTertiaryFixed: Color(0xff1b1d00),
      tertiaryFixedDim: Color(0xffc7cc7e),
      onTertiaryFixedVariant: Color(0xff464a08),
      surfaceDim: Color(0xffded9d5),
      surfaceBright: Color(0xfffef8f4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f3ee),
      surfaceContainer: Color(0xfff2ede9),
      surfaceContainerHigh: Color(0xffede7e3),
      surfaceContainerHighest: Color(0xffe7e1dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.ptSerifTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.ptSerif(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: colorScheme.primaryContainer,
        letterSpacing: 2.0,
      ),
    ),
    scaffoldBackgroundColor: colorScheme.secondaryContainer,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.tertiaryContainer,
        foregroundColor: colorScheme.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline, // e.g. Matsu border color
          width: 2,
        ),
      ),
      margin: const EdgeInsets.all(8), // Optional: standard spacing
    ),
  );
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
