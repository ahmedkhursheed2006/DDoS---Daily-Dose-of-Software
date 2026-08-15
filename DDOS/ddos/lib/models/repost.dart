class Repost {
  final int id;
  final String authorName;
  final String authorInitials;
  final String time;
  final bool isRepost;
  final String? commentary;
  final int originalPostId;
  final String originalTitle;
  final String originalText;
  final int likes;
  final int reposts;

  Repost({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.time,
    this.isRepost = true,
    this.commentary,
    required this.originalPostId,
    required this.originalTitle,
    required this.originalText,
    this.likes = 0,
    this.reposts = 0,
  });

  factory Repost.fromJson(Map<String, dynamic> json) {
    // Parse author name
    final author = json['authorName'] ??
        json['author_name'] ??
        json['username'] ??
        (json['user'] is Map
            ? json['user']['name'] ?? json['user']['username']
            : null) ??
        'Community Member';

    // Compute initials
    final initials = json['authorInitials'] ??
        json['initials'] ??
        _extractInitials(author.toString());

    // Parse time / created at
    final timeStr = json['time'] ??
        json['createdAt'] ??
        json['created_at'] ??
        'Just now';

    // Parse original post info
    final origPost = json['originalPost'] ?? json['post'];
    final origPostId = json['originalPostId'] ??
        json['original_post_id'] ??
        json['postId'] ??
        (origPost is Map ? origPost['id'] : null) ??
        (json['id'] is int ? json['id'] as int : 0);

    final origTitle = json['originalTitle'] ??
        json['original_title'] ??
        (origPost is Map ? origPost['title'] : null) ??
        'Software Engineering Concept';

    final origText = json['originalText'] ??
        json['original_text'] ??
        json['content'] ??
        (origPost is Map ? origPost['content'] ?? origPost['body'] : null) ??
        '';

    return Repost(
      id: json['id'] is int ? json['id'] as int : 0,
      authorName: author.toString(),
      authorInitials: initials.toString(),
      time: timeStr.toString(),
      isRepost: json['isRepost'] ?? json['is_repost'] ?? true,
      commentary: json['commentary'] ?? json['comment'] ?? json['text'],
      originalPostId: origPostId is int
          ? origPostId
          : int.tryParse(origPostId.toString()) ?? 0,
      originalTitle: origTitle.toString(),
      originalText: origText.toString(),
      likes: json['likes'] is int
          ? json['likes'] as int
          : (json['likesCount'] is int ? json['likesCount'] as int : 0),
      reposts: json['reposts'] is int
          ? json['reposts'] as int
          : (json['repostsCount'] is int ? json['repostsCount'] as int : 0),
    );
  }

  static String _extractInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'D';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'D';
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorInitials': authorInitials,
      'time': time,
      'isRepost': isRepost,
      'commentary': commentary,
      'originalPostId': originalPostId,
      'originalTitle': originalTitle,
      'originalText': originalText,
      'likes': likes,
      'reposts': reposts,
    };
  }
}
