import 'package:flutter/material.dart';

class AppTheme {
  static const Color seed = Color(0xFF6366F1); // indigo

  static ThemeData _build(Brightness b) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: b);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // Transparent so the gradient behind every screen shows through
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static Color priorityColor(String level) {
    switch (level) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF22C55E);
    }
  }
}
