import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppConstants {
  // Base API configuration (10.0.2.2 for Android Emulator)
  // Use localhost for Web/iOS, 10.0.2.2 for Android Emulator
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  // Secure Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';

  // Theme Colors
  static const Color primaryColor = Color(0xFFD97706);
  static const Color primaryTheme = Color(0xFF8D4B00);
  static const Color backgroundColor = Color(0xFFFAF9F8);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1A1C1C);
  static const Color secondaryText = Color(0xFF554336);
}
