import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class DefaultAvatar {
  final String id;
  final String label;
  final String emoji;
  final IconData icon;
  final List<Color> gradientColors;
  final Color primaryColor;

  const DefaultAvatar({
    required this.id,
    required this.label,
    required this.emoji,
    required this.icon,
    required this.gradientColors,
    required this.primaryColor,
  });
}

class AvatarHelper {
  static const String _avatarPrefPrefix = 'user_avatar_';

  static const List<DefaultAvatar> defaultAvatars = [
    DefaultAvatar(
      id: 'preset:1',
      label: 'Code Ninja',
      emoji: '💻',
      icon: Icons.code,
      gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      primaryColor: Color(0xFF3B82F6),
    ),
    DefaultAvatar(
      id: 'preset:2',
      label: 'Rocket Dev',
      emoji: '🚀',
      icon: Icons.rocket_launch,
      gradientColors: [Color(0xFFD97706), Color(0xFFB45309)],
      primaryColor: Color(0xFFD97706),
    ),
    DefaultAvatar(
      id: 'preset:3',
      label: 'Cyber Hacker',
      emoji: '⚡',
      icon: Icons.bolt,
      gradientColors: [Color(0xFF10B981), Color(0xFF047857)],
      primaryColor: Color(0xFF10B981),
    ),
    DefaultAvatar(
      id: 'preset:4',
      label: 'AI Architect',
      emoji: '🧠',
      icon: Icons.psychology,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
      primaryColor: Color(0xFF8B5CF6),
    ),
    DefaultAvatar(
      id: 'preset:5',
      label: 'UI Wizard',
      emoji: '🎨',
      icon: Icons.palette_outlined,
      gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
      primaryColor: Color(0xFFEC4899),
    ),
    DefaultAvatar(
      id: 'preset:6',
      label: 'Security Pro',
      emoji: '🛡️',
      icon: Icons.security,
      gradientColors: [Color(0xFF06B6D4), Color(0xFF0E7490)],
      primaryColor: Color(0xFF06B6D4),
    ),
    DefaultAvatar(
      id: 'preset:7',
      label: 'Bug Hunter',
      emoji: '🐛',
      icon: Icons.pest_control_outlined,
      gradientColors: [Color(0xFFF97316), Color(0xFFC2410C)],
      primaryColor: Color(0xFFF97316),
    ),
    DefaultAvatar(
      id: 'preset:8',
      label: 'Cosmic Explorer',
      emoji: '🌌',
      icon: Icons.auto_awesome,
      gradientColors: [Color(0xFF6366F1), Color(0xFF4338CA)],
      primaryColor: Color(0xFF6366F1),
    ),
  ];

  /// Returns a deterministic or random default avatar ID based on user email/id
  static String getRandomDefaultAvatarId([String? seed]) {
    if (seed != null && seed.isNotEmpty) {
      final hash = seed.codeUnits.fold<int>(0, (prev, curr) => prev + curr);
      final index = hash % defaultAvatars.length;
      return defaultAvatars[index].id;
    }
    final randomIndex = DateTime.now().millisecondsSinceEpoch % defaultAvatars.length;
    return defaultAvatars[randomIndex].id;
  }

  /// Get stored avatar choice from SharedPreferences
  static Future<String?> getSavedAvatar(String userIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('$_avatarPrefPrefix$userIdentifier');
    } catch (e) {
      debugPrint('[AvatarHelper] Error reading avatar from SharedPreferences: $e');
      return null;
    }
  }

  /// Save avatar choice to SharedPreferences
  static Future<void> saveAvatar(String userIdentifier, String avatarPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_avatarPrefPrefix$userIdentifier', avatarPath);
    } catch (e) {
      debugPrint('[AvatarHelper] Error saving avatar to SharedPreferences: $e');
    }
  }

  /// Find preset avatar metadata by ID
  static DefaultAvatar? getPreset(String? id) {
    if (id == null || !id.startsWith('preset:')) return null;
    try {
      return defaultAvatars.firstWhere((preset) => preset.id == id);
    } catch (_) {
      return defaultAvatars[0];
    }
  }

  /// Checks whether an avatar path is a local file
  static bool isLocalFile(String? path) {
    if (path == null || path.isEmpty) return false;
    if (path.startsWith('preset:') || path.startsWith('http://') || path.startsWith('https://')) {
      return false;
    }
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  /// Builds a complete avatar widget that handles Presets, Local Files, URLs, and Initials
  static Widget buildAvatar({
    required String? avatarPath,
    required String name,
    required double radius,
    Color? fallbackBackgroundColor,
    double? fontSize,
    double? iconSize,
  }) {
    final preset = getPreset(avatarPath);
    final userInitial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    if (preset != null) {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: preset.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: preset.primaryColor.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                preset.emoji,
                style: TextStyle(
                  fontSize: fontSize ?? (radius * 0.9),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (avatarPath != null && avatarPath.isNotEmpty) {
      if (avatarPath.startsWith('http://') || avatarPath.startsWith('https://')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppConstants.backgroundCanvas,
          backgroundImage: NetworkImage(avatarPath),
        );
      }
      try {
        final file = File(avatarPath);
        if (file.existsSync()) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: AppConstants.backgroundCanvas,
            backgroundImage: FileImage(file),
          );
        }
      } catch (e) {
        debugPrint('[AvatarHelper] Error rendering avatar file: $e');
      }
    }

    // Default colored circle with initials
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppConstants.primaryThemeColor, Color(0xFFDBC2B0)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Center(
        child: Text(
          userInitial,
          style: TextStyle(
            fontSize: fontSize ?? (radius * 0.75),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
