class Post {
  final String id;
  final String title;
  final String content;
  final String category;
  final int readTimeMinutes;
  final bool isCompleted;
  final bool isSaved;
  final String? seriesId;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.readTimeMinutes = 3,
    this.isCompleted = false,
    this.isSaved = false,
    this.seriesId,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      readTimeMinutes: json['readTimeMinutes'] ?? 3,
      isCompleted: json['isCompleted'] ?? false,
      isSaved: json['isSaved'] ?? false,
      seriesId: json['seriesId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Post copyWith({bool? isCompleted, bool? isSaved}) {
    return Post(
      id: id,
      title: title,
      content: content,
      category: category,
      readTimeMinutes: readTimeMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isSaved: isSaved ?? this.isSaved,
      seriesId: seriesId,
      createdAt: createdAt,
    );
  }
}
