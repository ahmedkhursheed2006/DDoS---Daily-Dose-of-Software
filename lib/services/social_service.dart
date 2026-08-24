import 'package:flutter/foundation.dart';
import '../models/comment.dart';
import 'dio_client.dart';

class SocialService {
  static final DioClient _dioClient = DioClient();

  static Future<bool> markPostAsRead(String postId) async {
    try {
      await _dioClient.post('/posts/$postId/read');
      return true;
    } catch (e) {
      debugPrint("❌ Read-receipt sync error: $e");
      return false;
    }
  }

  static Future<bool> toggleLike(String postId, bool currentStatus) async {
    try {
      final response = await _dioClient.post('/posts/$postId/like');
      return (response.data as Map<String, dynamic>)['liked'] as bool? ?? !currentStatus;
    } catch (e) {
      debugPrint("❌ Like API error: $e");
      return currentStatus;
    }
  }

  static Future<bool> toggleSave(String postId, bool currentStatus) async {
    try {
      final response = await _dioClient.post('/posts/$postId/save');
      return (response.data as Map<String, dynamic>)['saved'] as bool? ?? !currentStatus;
    } catch (e) {
      debugPrint("❌ Save API error: $e");
      return currentStatus;
    }
  }

  static Future<Comment?> addComment({
    required String postId,
    required String body,
    required String userId,
    required String userName,
  }) async {
    try {
      final response = await _dioClient.post(
        '/posts/$postId/comments',
        data: {'content': body},
      );
      final data = response.data is Map && response.data['data'] is Map
          ? response.data['data'] as Map<String, dynamic>
          : response.data as Map<String, dynamic>;
      return Comment.fromJson(data);
    } catch (e) {
      debugPrint("❌ Add comment error: $e");
      return null;
    }
  }

  static Future<bool> editComment(String commentId, String updatedBody) async {
    try {
      await _dioClient.instance.patch('/comments/$commentId', data: {'content': updatedBody});
      return true;
    } catch (e) {
      debugPrint("❌ Edit comment error: $e");
      return false;
    }
  }

  static Future<bool> deleteComment(String commentId) async {
    try {
      await _dioClient.delete('/comments/$commentId');
      return true;
    } catch (e) {
      debugPrint("❌ Delete comment error: $e");
      return false;
    }
  }
}