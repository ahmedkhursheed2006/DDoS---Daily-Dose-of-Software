import 'post.dart';

class Series {
  final String id;
  final String title;
  final String description;
  final String category;
  final int totalPosts;
  final int completedPosts;
  final List<Post> posts;

  Series({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.totalPosts = 0,
    this.completedPosts = 0,
    this.posts = const [],
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    var rawPosts = json['posts'] as List? ?? [];
    List<Post> postList = rawPosts.map((p) => Post.fromJson(p)).toList();

    return Series(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      totalPosts: json['totalPosts'] ?? postList.length,
      completedPosts: json['completedPosts'] ?? 0,
      posts: postList,
    );
  }
}
