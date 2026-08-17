import '../models/series.dart';
import '../models/repost.dart';
import 'dio_client.dart';

class FeedService {
  final DioClient _dioClient = DioClient();

  /// Fetch all series (T6 Endpoint: GET /series)
  Future<List<Series>> getSeries() async {
    try {
      final response = await _dioClient.get('/series');
      final List<dynamic> data = response.data;

      return data
          .map((json) => Series.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load series: $e');
    }
  }

  /// Toggle follow/unfollow for a series (T6 Endpoint: POST /series/:id/follow)
  Future<bool> toggleFollow(int seriesId) async {
    try {
      final response = await _dioClient.post('/series/$seriesId/follow');
      if (response.data is Map<String, dynamic> && response.data['following'] != null) {
        return response.data['following'] as bool;
      }
      return true;
    } catch (e) {
      throw Exception('Failed to toggle follow for series $seriesId: $e');
    }
  }

  /// Fetch community reposts & commentary (T7 Endpoint: GET /feed/reposts)
  Future<List<Repost>> getReposts() async {
    try {
      final response = await _dioClient.get('/feed/reposts');
      final dynamic rawData = response.data;
      final List<dynamic> data = rawData is List
          ? rawData
          : (rawData is Map && rawData['reposts'] is List
              ? rawData['reposts']
              : []);

      return data
          .map((json) => Repost.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load community reposts: $e');
    }
  }

  /// Create a repost with commentary (T7 Endpoint: POST /posts/:id/repost)
  Future<Repost?> createRepost({
    required int postId,
    String? commentary,
  }) async {
    try {
      final response = await _dioClient.post(
        '/posts/$postId/repost',
        data: {'commentary': commentary ?? ''},
      );
      if (response.data is Map<String, dynamic>) {
        return Repost.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create repost for post $postId: $e');
    }
  }
}
