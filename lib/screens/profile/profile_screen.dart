import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import 'favorite_topics_screen.dart';
import 'download_offline_screen.dart';
import 'account_settings_screen.dart';
import '../../services/feed_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isWarmLightTheme = true;

  final List<Map<String, dynamic>> _streakBadges = [
    {
      'name': '7-Day Flame',
      'emoji': '🔥',
      'subtitle': '7 Days Active',
      'unlocked': true,
      'color': const Color(0xFFFF9800),
    },
    {
      'name': '30-Day Master',
      'emoji': '🏆',
      'subtitle': '30 Days Active',
      'unlocked': true,
      'color': const Color(0xFFFFC107),
    },
    {
      'name': 'Fast Learner',
      'emoji': '⚡',
      'subtitle': '10 Topics Done',
      'unlocked': true,
      'color': const Color(0xFF00BCD4),
    },
    {
      'name': 'Bug Hunter',
      'emoji': '🐛',
      'subtitle': '5 Quizzes Passed',
      'unlocked': true,
      'color': const Color(0xFF4CAF50),
    },
  ];

  final List<Map<String, dynamic>> _savedPosts = [];
  final FeedService _feedService = FeedService();
  bool _savedPostsLoading = true;

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
      await AuthService.logout(); // clears token + user data
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    try {
      final posts = await _feedService.getSavedPosts();
      if (!mounted) return;
      setState(() {
        _savedPosts
          ..clear()
          ..addAll(posts.map((post) => {
                'id': post['id']?.toString() ?? '',
                'title': post['title']?.toString() ?? 'Untitled post',
                'tag': post['seriesTitle']?.toString() ?? 'Saved post',
                'readTime': '${post['readTimeMinutes'] ?? 5} min read',
                'isSaved': true,
              }));
        _savedPostsLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _savedPostsLoading = false);
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

            // ── Section 1: Streak Badges ─────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Streak Badges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_streakBadges.where((b) => b['unlocked'] == true).length} Earned',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryThemeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _streakBadges.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final badge = _streakBadges[index];
                      final Color badgeColor = badge['color'] as Color;
                      return Container(
                        width: 130,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F8D4B00),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                badge['emoji'] as String,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              badge['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              badge['subtitle'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppConstants.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section 2: Saved Posts ───────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saved Posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoriteTopicsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryThemeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_savedPostsLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_savedPosts.isEmpty)
                  const Text(
                    'No saved posts yet.',
                    style: TextStyle(color: AppConstants.secondaryColor),
                  )
                else
                  Column(
                    children: List.generate(_savedPosts.length, (index) {
                    final post = _savedPosts[index];
                    final bool isSaved = post['isSaved'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppConstants.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F8D4B00),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppConstants.primaryThemeColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        post['tag'] as String,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.primaryThemeColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: AppConstants.secondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      post['readTime'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppConstants.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  post['title'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.primaryText,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? AppConstants.primaryThemeColor : AppConstants.secondaryColor,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                post['isSaved'] = !isSaved;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                    }),
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
