import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post.dart';
import 'social_service.dart';

class OfflineCacheService {
  static const String _postsBoxName = 'offline_posts';
  static const String _readEventsBoxName = 'pending_read_events';

  static Future<Box<String>> _openPostsBox() async {
    if (Hive.isBoxOpen(_postsBoxName)) {
      return Hive.box<String>(_postsBoxName);
    }
    return await Hive.openBox<String>(_postsBoxName);
  }

  static Future<void> savePost(Post post) async {
    final box = await _openPostsBox();
    await box.put(post.id, jsonEncode(post.toJson()));
  }

  static Future<Post?> getPost(String postId) async {
    final box = await _openPostsBox();
    final jsonString = box.get(postId);
    if (jsonString == null) return null;
    return Post.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  static Future<List<Post>> getAllSavedPosts() async {
    final box = await _openPostsBox();
    return box.values
        .map((s) => Post.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<bool> isPostDownloaded(String postId) async {
    final box = await _openPostsBox();
    return box.containsKey(postId);
  }

  static Future<void> removePost(String postId) async {
    final box = await _openPostsBox();
    await box.delete(postId);
  }

  static Future<Box<String>> _openReadEventsBox() async {
    if (Hive.isBoxOpen(_readEventsBoxName)) {
      return Hive.box<String>(_readEventsBoxName);
    }
    return await Hive.openBox<String>(_readEventsBoxName);
  }

  /// Records that a post was read. If online, sends immediately.
  /// If offline (or the send fails), queues it for later sync.
  static Future<void> recordReadEvent(String postId, {required bool isOnline}) async {
    if (isOnline) {
      final success = await SocialService.markPostAsRead(postId);
      if (success) return;
    }
    final box = await _openReadEventsBox();
    await box.put(
      '\${postId}_\${DateTime.now().millisecondsSinceEpoch}',
      jsonEncode({'post_id': postId, 'queued_at': DateTime.now().toIso8601String()}),
    );
  }

  /// Call when connectivity returns. Sends every queued read event
  /// and clears successful ones from the queue.
  static Future<void> flushPendingReadEvents() async {
    final box = await _openReadEventsBox();
    final keys = box.keys.toList();

    for (final key in keys) {
      final jsonString = box.get(key);
      if (jsonString == null) continue;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final postId = data['post_id'] as String;

      final success = await SocialService.markPostAsRead(postId);
      if (success) {
        await box.delete(key);
      }
    }
  }

  static Future<int> pendingReadEventCount() async {
    final box = await _openReadEventsBox();
    return box.length;
  }
}
