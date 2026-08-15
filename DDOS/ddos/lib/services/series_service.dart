import '../models/series.dart';
import 'dio_client.dart';

class SeriesService {
  final DioClient _dioClient = DioClient();

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
}