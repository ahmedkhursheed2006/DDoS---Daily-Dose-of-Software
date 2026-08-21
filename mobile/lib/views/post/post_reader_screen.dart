import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../../providers/feed_provider.dart';
import '../../utils/constants.dart';

class PostReaderScreen extends StatelessWidget {
  final Post post;

  const PostReaderScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.category), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${post.readTimeMinutes} min read',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppConstants.primaryColor,
              ),
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Mark as Completed',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Provider.of<FeedProvider>(
                  context,
                  listen: false,
                ).markComplete(post.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
