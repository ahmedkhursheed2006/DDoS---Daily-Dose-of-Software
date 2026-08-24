import 'package:flutter/material.dart';
import '../../../services/feed_service.dart';
import '../models/progress_stats.dart';
import 'post_detail_screen.dart';

class DailyDoseScreen extends StatefulWidget {
  const DailyDoseScreen({super.key});

  @override
  State<DailyDoseScreen> createState() => _DailyDoseScreenState();
}

class _DailyDoseScreenState extends State<DailyDoseScreen> {
  final FeedService _feedService = FeedService();
  late Future<List<SeriesPost>> _feed;

  @override
  void initState() {
    super.initState();
    _feed = _feedService.getTodayFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Dose')),
      body: FutureBuilder<List<SeriesPost>>(
        future: _feed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load your daily dose.'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('Follow a series to receive a daily dose.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                child: ListTile(
                  title: Text(post.postTitle),
                  subtitle: Text('${post.seriesTitle} · ${post.readTimeLabel}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}