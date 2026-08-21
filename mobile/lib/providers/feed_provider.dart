import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/series.dart';
import '../services/api_service.dart';

class FeedProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Post> _dailyPosts = [];
  List<Series> _seriesList = [];
  List<Post> _searchResults = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String _selectedCategory = 'All';

  List<Post> get dailyPosts => _dailyPosts;
  List<Series> get seriesList => _seriesList;
  List<Post> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get selectedCategory => _selectedCategory;

  Future<void> loadHomeScreenData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dailyPosts = await _apiService.getDailyPosts();
      _seriesList = await _apiService.getSeriesList();
    } catch (e) {
      debugPrint('Error loading feed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchPosts(query);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> markComplete(String postId) async {
    final success = await _apiService.markPostCompleted(postId);
    if (success) {
      final index = _dailyPosts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _dailyPosts[index] = _dailyPosts[index].copyWith(isCompleted: true);
        notifyListeners();
      }
    }
  }
}
