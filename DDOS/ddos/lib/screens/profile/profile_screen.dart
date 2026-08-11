import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import 'favorite_topics_screen.dart';
import 'download_offline_screen.dart';
import 'account_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isWarmLightTheme = true;

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppConstants.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryText,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: AppConstants.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.secondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await AuthService.deleteToken();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundCanvas,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundCanvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppConstants.primaryThemeColor),
          onPressed: () {},
        ),
        title: const Text(
          'DDoS',
          style: TextStyle(
            color: AppConstants.primaryThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department_outlined, color: AppConstants.primaryThemeColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            // User Avatar Section
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.primaryThemeColor,
                              Color(0xFFDBC2B0),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: AppConstants.backgroundCanvas,
                          child: CircleAvatar(
                            radius: 53,
                            backgroundImage: const NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCPrLUs5u0KMfYocr41nCLBAoFtdm5Ye7gGuM76ZLbJ6DXn8hiYtcVNK_vcojDeK6cOjU_c1vynmDADBj3yB1x0tNqmu3S1EyPWeRkAdX-VqGiQr0k2eV_G5pWEnmZN6tCBR3XFeH_HOFpLfbyRj1dY4X5KGlmNI8oPtqUDZHNszty5aeiJ4uJANwFeziBzti6Yl4mUz1qCR3QgR7Kbw_dalvjwAU6iTJLgZ_bQhZ7doYsTbmOusA',
                            ),
                            child: null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppConstants.primaryThemeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Alex Chen',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F3F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: AppConstants.secondaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Member since 2023',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Bento Grid (2 Cards)
            Row(
              children: [
                // Daily Streak Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x0F8D4B00),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'DAILY STREAK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            color: AppConstants.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.bolt,
                              color: AppConstants.primaryThemeColor,
                              size: 26,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '12 Days',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Total Points Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x0F8D4B00),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'TOTAL POINTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            color: AppConstants.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.analytics_outlined,
                              color: AppConstants.primaryThemeColor,
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '14.2k',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Settings Section Card
            Container(
              decoration: BoxDecoration(
                color: AppConstants.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0F8D4B00),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Favorite Topics
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E8E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.star_outline,
                        color: AppConstants.primaryThemeColor,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Favorite Topics',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFDBC2B0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoriteTopicsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),

                  // Download for Offline
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E8E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.download_for_offline_outlined,
                        color: AppConstants.primaryThemeColor,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Download for Offline',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFDBC2B0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DownloadOfflineScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),

                  // Theme Toggle Switch
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E8E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.light_mode_outlined,
                        color: AppConstants.primaryThemeColor,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    subtitle: const Text(
                      'Warm Light',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.secondaryColor,
                      ),
                    ),
                    trailing: Switch(
                      value: _isWarmLightTheme,
                      activeTrackColor: AppConstants.primaryThemeColor,
                      onChanged: (val) {
                        setState(() {
                          _isWarmLightTheme = val;
                        });
                      },
                    ),
                  ),
                  Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),

                  // Account Settings
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E8E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: AppConstants.primaryThemeColor,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFDBC2B0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Log Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showLogoutDialog,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: const Color(0xFFBA1A1A).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  backgroundColor: AppConstants.cardSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFBA1A1A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Version Caption
            const Center(
              child: Text(
                'Version 2.4.0 (Build 892)',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFDBC2B0),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
