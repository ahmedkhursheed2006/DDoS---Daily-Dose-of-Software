import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class StorageService {
  static const String _savedPostsKey = 'saved_posts_cache';

  Future<void> savePostLocally(Post post) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentSaved = prefs.getStringList(_savedPostsKey) ?? [];

    Map<String, dynamic> postMap = {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'category': post.category,
      'readTimeMinutes': post.readTimeMinutes,
      'createdAt': post.createdAt.toIso8601String(),
    };

    currentSaved.removeWhere((item) => jsonDecode(item)['id'] == post.id);
    currentSaved.add(jsonEncode(postMap));
    await prefs.setStringList(_savedPostsKey, currentSaved);
  }

  Future<List<Post>> getSavedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawSaved = prefs.getStringList(_savedPostsKey) ?? [];

    return rawSaved.map((item) {
      final json = jsonDecode(item);
      return Post.fromJson(json);
    }).toList();
  }

  Future<void> removePostLocally(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentSaved = prefs.getStringList(_savedPostsKey) ?? [];
    currentSaved.removeWhere((item) => jsonDecode(item)['id'] == postId);
    await prefs.setStringList(_savedPostsKey, currentSaved);
  }
}
// cSpell: ignore prefs