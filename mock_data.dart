class Lesson {
  final String title;
  final String summary;
  final String category;

  const Lesson({
    required this.title,
    required this.summary,
    required this.category,
  });
}

Future<List<Lesson>> fetchLessons() async {
  return const [
    Lesson(
      title: 'Pointers and Memory Architecture',
      summary: 'Understand how pointers reference data in memory.',
      category: 'Systems',
    ),
    Lesson(
      title: 'Designing Reliable APIs',
      summary: 'Explore practical patterns for dependable services.',
      category: 'Backend',
    ),
    Lesson(
      title: 'Flutter State Management',
      summary: 'Choose the right state approach for your Flutter app.',
      category: 'Flutter',
    ),
  ];
}

Future<List<String>> fetchCategories() async {
  return const ['All', 'Systems', 'Backend', 'Flutter'];
}