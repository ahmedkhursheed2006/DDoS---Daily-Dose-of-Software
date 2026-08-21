import 'package:dio/dio.dart';
import '../models/post.dart';
import '../models/series.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  Future<List<Post>> getDailyPosts() async {
    try {
      final response = await _dioClient.dio.get('/posts/daily');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load daily posts',
      );
    }
    return [];
  }

  Future<List<Series>> getSeriesList() async {
    try {
      final response = await _dioClient.dio.get('/series');
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        return data.map((json) => Series.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load series');
    }
    return [];
  }

  Future<List<Post>> searchPosts(String query) async {
    try {
      final response = await _dioClient.dio.get(
        '/search',
        queryParameters: {'q': query},
      );
      if (response.statusCode == 200) {
        final List data = response.data['posts'] ?? response.data['data'] ?? [];
        return data.map((json) => Post.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Search failed');
    }
    return [];
  }

  Future<bool> markPostCompleted(String postId) async {
    try {
      final response = await _dioClient.dio.post('/posts/$postId/complete');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
