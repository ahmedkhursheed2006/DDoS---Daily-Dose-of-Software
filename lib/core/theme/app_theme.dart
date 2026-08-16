import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF7F3EE);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryOrange = Color(0xFFC1440E);
  static const Color primaryOrangeDark = Color(0xFF8F3308);
  static const Color accentPeach = Color(0xFFF3D9C4);
  static const Color textPrimary = Color(0xFF2B2622);
  static const Color textSecondary = Color(0xFF8A8078);
  static const Color divider = Color(0xFFE7E0D8);
  static const Color success = Color(0xFF3E8E5A);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle statNumber = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        surface: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.heading1,
      ),
      fontFamily: 'Segoe UI',
      useMaterial3: true,
    );
  }
}
