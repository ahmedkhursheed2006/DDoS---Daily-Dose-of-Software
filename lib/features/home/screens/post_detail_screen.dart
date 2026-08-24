import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';
import '../../../services/dio_client.dart';
import '../../../services/social_service.dart';
import '../../../services/content_repository.dart';

class PostDetailScreen extends StatefulWidget {
  final SeriesPost post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Map<String, dynamic>> _postDetails;

  @override
  void initState() {
    super.initState();
    _postDetails = _loadPost();
  }

  Future<Map<String, dynamic>> _loadPost() async {
    try {
      await SocialService.markPostAsRead(widget.post.id);
      final response = await DioClient().get('/posts/${widget.post.id}');
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return ContentRepository.loadPost(widget.post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.post.seriesTitle)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _postDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load this post.'));
          }
          final data = snapshot.data!;
          final imageUrl = data['imageUrl']?.toString();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              Text(data['title']?.toString() ?? widget.post.postTitle, style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text('${data['readTimeMinutes'] ?? widget.post.readTimeLabel} min read', style: AppTextStyles.caption),
              const SizedBox(height: 20),
              MarkdownBody(
                data: data['content']?.toString() ?? 'No content available.',
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: AppTextStyles.body,
                  h1: AppTextStyles.heading1,
                  h2: AppTextStyles.heading2,
                ),
              ),
              const SizedBox(height: 24),
              Text('Source: ${data['sourceReference'] ?? 'Not provided'}', style: AppTextStyles.caption),
            ],
          );
        },
      ),
    );
  }
}
