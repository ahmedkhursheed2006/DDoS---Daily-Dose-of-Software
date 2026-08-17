import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'DDoS (Daily Dose of Software)';

  // ── Backend Base URL ──────────────────────────────────────────────────────
  // Override at runtime with:
  //   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000/api
  //   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
  //
  // Default behavior:
  // - Web: http://localhost:3000/api
  // - Android emulator: http://10.0.2.2:3000/api
  // - Physical device / other machines: use a LAN IP via --dart-define
  static final String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb
        ? 'http://localhost:3000/api'
        : (Platform.isAndroid ? 'http://10.0.2.2:3000/api' : 'http://localhost:3000/api'),
  );

  // PRIMARY COLORS (From Stitch Design System)
  static const Color primaryColor = Color(0xFFD97706); // Golden Amber - CTAs, buttons, active tabs
  static const Color primaryThemeColor = Color(0xFF8D4B00); // Deep Amber - Material primary token
  static const Color primaryContainer = Color(0xFFB15F00); // Container shade

  // SECONDARY COLOR
  static const Color secondaryColor = Color(0xFF5F5E5E); // Neutral slate gray - secondary buttons, captions, borders

  // SURFACE & CANVAS COLORS
  static const Color backgroundCanvas = Color(0xFFFAF9F8); // Warm off-white canvas background
  static const Color cardSurface = Color(0xFFFFFFFF); // Pure white elevated surfaces
  static const Color primaryText = Color(0xFF1A1C1C); // High-contrast dark charcoal text
  static const Color secondaryText = Color(0xFF554336); // Muted slate brown text

  // UI CONSTANTS
  static const double defaultPadding = 24.0;
  static const double borderRadius = 12.0;
  static const int passwordMinLength = 8;

  // LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primarySwatch: Colors.amber, // Since #D97706 is amber shade
      scaffoldBackgroundColor: backgroundCanvas,
      cardColor: cardSurface,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryText,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: primaryText),
        bodyMedium: TextStyle(color: secondaryText),
      ),
      useMaterial3: true,
    );
  }
}
