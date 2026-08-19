import 'package:dio/dio.dart';

class FeedApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> getTodayFeed() async {
    final response = await _dio.get('/feed/today');

    return Map<String, dynamic>.from(response.data);
  }
}
