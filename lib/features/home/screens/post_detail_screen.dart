import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class PostDetailScreen extends StatelessWidget {
  final SeriesPost post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(post.seriesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.postTitle, style: AppTextStyles.heading1),
            const SizedBox(height: 8),
            Text(
              '${post.readTimeLabel} · ${post.difficultyLabel}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 20),
            const Text(
              'Post content placeholder — wire this up in the Post Detail task.',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
