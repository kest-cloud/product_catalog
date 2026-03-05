import 'dart:ui';

import 'package:flutter/material.dart';

/// Central place for all theming and design system configuration.
abstract final class AppTheme {
  static const double _borderRadiusL = 24;

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4F46E5),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF1E1B4B),
      secondary: Color(0xFF22C55E),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD1FAE5),
      onSecondaryContainer: Color(0xFF064E3B),
      tertiary: Color(0xFF0EA5E9),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFECFEFF),
      onTertiaryContainer: Color(0xFF0E7490),
      error: Color(0xFFEF4444),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      background: Color(0xFFF9FAFB),
      onBackground: Color(0xFF020617),
      surface: Color(0xFFF9FAFB),
      onSurface: Color(0xFF020617),
      surfaceVariant: Color(0xFFE5E7EB),
      onSurfaceVariant: Color(0xFF4B5563),
      outline: Color(0xFFE5E7EB),
      outlineVariant: Color(0xFFD1D5DB),
      shadow: Colors.black54,
      scrim: Colors.black87,
      inverseSurface: Color(0xFF020617),
      onInverseSurface: Color(0xFFF9FAFB),
      inversePrimary: Color(0xFFA5B4FC),
      surfaceTint: Color(0xFF4F46E5),
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA5B4FC),
      onPrimary: Color(0xFF020617),
      primaryContainer: Color(0xFF1E1B4B),
      onPrimaryContainer: Color(0xFFE0E7FF),
      secondary: Color(0xFF4ADE80),
      onSecondary: Color(0xFF022C22),
      secondaryContainer: Color(0xFF064E3B),
      onSecondaryContainer: Color(0xFFD1FAE5),
      tertiary: Color(0xFF38BDF8),
      onTertiary: Color(0xFF02131A),
      tertiaryContainer: Color(0xFF0F172A),
      onTertiaryContainer: Color(0xFFE0F2FE),
      error: Color(0xFFFCA5A5),
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFEE2E2),
      background: Color(0xFF020617),
      onBackground: Color(0xFFE5E7EB),
      surface: Color(0xFF020617),
      onSurface: Color(0xFFE5E7EB),
      surfaceVariant: Color(0xFF020617),
      onSurfaceVariant: Color(0xFF9CA3AF),
      outline: Color(0xFF1F2937),
      outlineVariant: Color(0xFF111827),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFE5E7EB),
      onInverseSurface: Color(0xFF020617),
      inversePrimary: Color(0xFF4F46E5),
      surfaceTint: Color(0xFFA5B4FC),
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData _baseTheme(final ColorScheme colorScheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'SF Pro Display',
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onBackground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colorScheme.surface.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusL),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.9),
      ),
    );
  }

  /// Creates a subtle radial gradient for the scaffold background.
  static Color scaffoldGradientBackground(final BuildContext context) {
    return Theme.of(context).colorScheme.background;
  }

  /// Standard glassmorphism card decoration used across the app.
  static BoxDecoration glassCardDecoration(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(_borderRadiusL),
      border: Border.all(
        color: colorScheme.surfaceVariant.withOpacity(0.7),
        width: 1,
      ),
      color: colorScheme.surface.withOpacity(0.7),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.25),
          blurRadius: 32,
          offset: const Offset(0, 24),
        ),
      ],
      backgroundBlendMode: BlendMode.overlay,
    );
  }

  /// Returns a blur for frosted glass surfaces.
  static ImageFilter glassBlur() {
    return ImageFilter.blur(sigmaX: 18, sigmaY: 18);
  }
}
