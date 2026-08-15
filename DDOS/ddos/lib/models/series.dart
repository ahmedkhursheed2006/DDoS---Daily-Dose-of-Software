class Series {
  final int id;
  final String title;
  final String description;

  Series({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}