import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/offline_service.dart';
import '../services/storage_service.dart';

class OfflineProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final OfflineService _offlineService = OfflineService();

  List<Post> _savedPosts = [];
  List<Post> _cachedFeed = [];
  bool _isOfflineMode = false;

  List<Post> get savedPosts => _savedPosts;
  List<Post> get cachedFeed => _cachedFeed;
  bool get isOfflineMode => _isOfflineMode;

  Future<void> loadSavedData() async {
    _savedPosts = await _storageService.getSavedPosts();
    _cachedFeed = await _offlineService.getCachedDailyFeed();
    notifyListeners();
  }

  Future<void> toggleSavePost(Post post) async {
    final isSaved = _savedPosts.any((p) => p.id == post.id);
    if (isSaved) {
      await _storageService.removePostLocally(post.id);
      _savedPosts.removeWhere((p) => p.id == post.id);
    } else {
      await _storageService.savePostLocally(post);
      _savedPosts.add(post);
    }
    notifyListeners();
  }

  void setOfflineState(bool isOffline) {
    _isOfflineMode = isOffline;
    notifyListeners();
  }
}
