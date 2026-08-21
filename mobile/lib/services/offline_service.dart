import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class OfflineService {
  static const String _cachedFeedKey = 'offline_feed_posts';

  Future<void> cacheDailyFeed(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = posts
        .map(
          (p) => jsonEncode({
            'id': p.id,
            'title': p.title,
            'content': p.content,
            'category': p.category,
            'readTimeMinutes': p.readTimeMinutes,
            'createdAt': p.createdAt.toIso8601String(),
          }),
        )
        .toList();

    await prefs.setStringList(_cachedFeedKey, encoded);
  }

  Future<List<Post>> getCachedDailyFeed() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = prefs.getStringList(_cachedFeedKey) ?? [];
    return encoded.map((str) => Post.fromJson(jsonDecode(str))).toList();
  }
}
// cSpell: ignore prefs