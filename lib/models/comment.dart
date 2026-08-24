class Comment {
  final String id;
  final String userId;
  final String userName;
  final String postId;
  String body;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.postId,
    required this.body,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      userId: (json['user_id'] ?? json['userId'])?.toString() ?? '',
      userName: (json['user_name'] ?? json['authorName'] ?? json['userName'])?.toString() ?? 'Learner',
      postId: (json['post_id'] ?? json['postId'])?.toString() ?? '',
      body: (json['body'] ?? json['content'])?.toString() ?? '',
      createdAt: DateTime.tryParse((json['created_at'] ?? json['createdAt'])?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'post_id': postId,
        'body': body,
        'created_at': createdAt.toIso8601String(),
      };

  String get timeAgo {
    try {
      final diff = DateTime.now().difference(createdAt);
      if (diff.inDays >= 1) return '${diff.inDays}d ago';
      if (diff.inHours >= 1) return '${diff.inHours}h ago';
      if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return 'Just now';
    }
  }
}