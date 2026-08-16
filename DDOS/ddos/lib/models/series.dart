class Series {
  final int id;
  final String title;
  final String description;
  final String? category;

  Series({
    required this.id,
    required this.title,
    required this.description,
    this.category,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      if (category != null) 'category': category,
    };
  }
}