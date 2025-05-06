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
      secondaryContainer: Color(0xfff1dfbe), // matsu background
      onSecondaryContainer: Color(0xff6f6248),
      tertiary: Color(0xff7F833A), // primary border (outline finish card)
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
      outline: Color(0xffC0A77E), // Matsu Border (outline ongoing card)
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
      surfaceContainer: Color(0xff9B9B9B), // font
      surfaceContainerHigh: Color(0xffD6D6D6), // card locked
      surfaceContainerHighest: Color(0xffDEE3E5), //outline card locked
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
      headlineMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: colorScheme.primaryContainer,
        letterSpacing: 0.5,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.primaryContainer,
        letterSpacing: 0.25,
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
    splashColor: colorScheme.tertiary.withAlpha(50),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline, // Default border color
          width: 2,
        ),
      ),
      margin: EdgeInsets.all(8), // Optional: standard spacing
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomCardThemes(
        lockedCardTheme: CardTheme(
          color: colorScheme.surfaceContainerHigh, // Warna untuk card locked
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outline, // Outline card locked
              width: 2,
            ),
          ),
          margin: const EdgeInsets.only(right: 8, left: 8, bottom: 10),
        ),
        finishedCardTheme: CardTheme(
          color: colorScheme.surface, // Warna untuk card selesai
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outline, // Border untuk card selesai
              width: 2,
            ),
          ),
          margin: const EdgeInsets.only(right: 8, left: 8, bottom: 10),
        ),
      ),
      FeedbackColors(
        correctBackground: const Color(0xFFE6F4EA),
        correctForeground: const Color(0xFF2E7D32),
        correctButton: const Color(0xFF4B6B2D),
        wrongBackground: const Color(0xFFFFE6E6),
        wrongForeground: const Color(0xFFD32F2F),
        wrongButton: const Color(0xFFA13A2C),
      ),
    ],
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

class CustomColors {
  static const Color slideOnboarding = Color(0xFFAEA6A8);
  static const Color buttonColor = Color(0xFF7F833A);
  static const Color borderButton = Color(0xFF9BA85B);
}

class CustomCardThemes extends ThemeExtension<CustomCardThemes> {
  final CardTheme lockedCardTheme;
  final CardTheme finishedCardTheme;

  const CustomCardThemes({
    required this.lockedCardTheme,
    required this.finishedCardTheme,
  });

  @override
  CustomCardThemes copyWith({
    CardTheme? lockedCardTheme,
    CardTheme? finishedCardTheme,
  }) {
    return CustomCardThemes(
      lockedCardTheme: lockedCardTheme ?? this.lockedCardTheme,
      finishedCardTheme: finishedCardTheme ?? this.finishedCardTheme,
    );
  }

  @override
  CustomCardThemes lerp(ThemeExtension<CustomCardThemes>? other, double t) {
    if (other is! CustomCardThemes) return this;
    return CustomCardThemes(
      lockedCardTheme: CardTheme.lerp(
        lockedCardTheme,
        other.lockedCardTheme,
        t,
      ),
      finishedCardTheme: CardTheme.lerp(
        finishedCardTheme,
        other.finishedCardTheme,
        t,
      ),
    );
  }
}

class FeedbackColors extends ThemeExtension<FeedbackColors> {
  final Color correctBackground;
  final Color correctForeground;
  final Color correctButton;
  final Color wrongBackground;
  final Color wrongForeground;
  final Color wrongButton;

  const FeedbackColors({
    required this.correctBackground,
    required this.correctForeground,
    required this.correctButton,
    required this.wrongBackground,
    required this.wrongForeground,
    required this.wrongButton,
  });

  @override
  FeedbackColors copyWith({
    Color? correctBackground,
    Color? correctForeground,
    Color? correctButton,
    Color? wrongBackground,
    Color? wrongForeground,
    Color? wrongButton,
  }) {
    return FeedbackColors(
      correctBackground: correctBackground ?? this.correctBackground,
      correctForeground: correctForeground ?? this.correctForeground,
      correctButton: correctButton ?? this.correctButton,
      wrongBackground: wrongBackground ?? this.wrongBackground,
      wrongForeground: wrongForeground ?? this.wrongForeground,
      wrongButton: wrongButton ?? this.wrongButton,
    );
  }

  @override
  FeedbackColors lerp(ThemeExtension<FeedbackColors>? other, double t) {
    if (other is! FeedbackColors) return this;
    return FeedbackColors(
      correctBackground:
          Color.lerp(correctBackground, other.correctBackground, t)!,
      correctForeground:
          Color.lerp(correctForeground, other.correctForeground, t)!,
      correctButton: Color.lerp(correctButton, other.correctButton, t)!,
      wrongBackground: Color.lerp(wrongBackground, other.wrongBackground, t)!,
      wrongForeground: Color.lerp(wrongForeground, other.wrongForeground, t)!,
      wrongButton: Color.lerp(wrongButton, other.wrongButton, t)!,
    );
  }
}
