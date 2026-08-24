import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/post.dart';
import '../../services/offline_cache_service.dart';
import '../post_detail_screen.dart';

class DownloadOfflineScreen extends StatefulWidget {
  const DownloadOfflineScreen({super.key});

  @override
  State<DownloadOfflineScreen> createState() => _DownloadOfflineScreenState();
}

class _DownloadOfflineScreenState extends State<DownloadOfflineScreen> {
  List<Post> _downloadedPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    final posts = await OfflineCacheService.getAllSavedPosts();
    if (mounted) {
      setState(() {
        _downloadedPosts = posts;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeDownload(Post post) async {
    await OfflineCacheService.removePost(post.id);
    _loadDownloads();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from offline downloads.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundCanvas,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundCanvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.primaryThemeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Download for Offline',
          style: TextStyle(
            color: AppConstants.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloadedPosts.isEmpty
              ? _buildEmptyState()
              : _buildDownloadsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFE9E8E7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download_for_offline_outlined,
              size: 56,
              color: AppConstants.primaryThemeColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Downloads Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Download topics and lessons to read offline, anytime and anywhere — even without internet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.secondaryText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _downloadedPosts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = _downloadedPosts[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFE8DE)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                post.seriesTitle,
                style: const TextStyle(fontSize: 12, color: AppConstants.secondaryText),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => _removeDownload(post),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
              );
            },
          ),
        );
      },
    );
  }
}
