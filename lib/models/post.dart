class QuizOption {
  final String text;
  final bool isCorrect;
  final String explanation;

  QuizOption({
    required this.text,
    required this.isCorrect,
    required this.explanation,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: json['text']?.toString() ?? '',
      isCorrect: json['is_correct'] == true,
      explanation: json['explanation']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'is_correct': isCorrect,
        'explanation': explanation,
      };
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;

  QuizQuestion({required this.question, required this.options});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question']?.toString() ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options.map((e) => e.toJson()).toList(),
      };
}

class Post {
  final String id;
  final String seriesId;
  final String seriesTitle;
  final String title;
  final String bodyText;
  final String keyTakeaway;
  final String codeSnippet;
  final String codeLanguage;
  final String audioDuration;
  final QuizQuestion? quiz;
  final String imageUrl;
  final String sourceReference;
  final int positionInSeries;
  final int totalSeriesSteps;
  final int estReadMinutes;
  final DateTime publishedAt;
  bool isLiked;
  bool isSaved;
  int likeCount;
  int commentCount;

  Post({
    required this.id,
    required this.seriesId,
    this.seriesTitle = 'Software Architecture & Systems',
    required this.title,
    required this.bodyText,
    this.keyTakeaway = 'Pointers allow direct memory addressing, eliminating data duplication across boundaries.',
    this.codeSnippet = '',
    this.codeLanguage = 'cpp',
    this.audioDuration = '4 min 30 sec',
    this.quiz,
    required this.imageUrl,
    required this.sourceReference,
    required this.positionInSeries,
    this.totalSeriesSteps = 5,
    required this.estReadMinutes,
    required this.publishedAt,
    this.isLiked = false,
    this.isSaved = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      seriesId: json['series_id']?.toString() ?? '',
      seriesTitle: json['series_title']?.toString() ?? 'Software Architecture',
      title: json['title']?.toString() ?? 'Untitled Technical Lesson',
      bodyText: json['body_text']?.toString() ?? '',
      keyTakeaway: json['key_takeaway']?.toString() ??
          'Understanding core memory layouts boosts execution performance.',
      codeSnippet: json['code_snippet']?.toString() ?? '',
      codeLanguage: json['code_language']?.toString() ?? 'cpp',
      audioDuration: json['audio_duration']?.toString() ?? '4 min 30 sec',
      quiz: json['quiz'] != null ? QuizQuestion.fromJson(json['quiz']) : null,
      imageUrl: json['image_url']?.toString() ?? '',
      sourceReference: json['source_reference']?.toString() ??
          'Verified Industry Architecture Paper',
      positionInSeries:
          int.tryParse(json['position_in_series']?.toString() ?? '1') ?? 1,
      totalSeriesSteps:
          int.tryParse(json['total_series_steps']?.toString() ?? '5') ?? 5,
      estReadMinutes:
          int.tryParse(json['est_read_minutes']?.toString() ?? '5') ?? 5,
      publishedAt: DateTime.tryParse(json['published_at']?.toString() ?? '') ??
          DateTime.now(),
      isLiked: json['is_liked'] == true,
      isSaved: json['is_saved'] == true,
      likeCount: int.tryParse(json['like_count']?.toString() ?? '0') ?? 0,
      commentCount:
          int.tryParse(json['comment_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'series_id': seriesId,
      'series_title': seriesTitle,
      'title': title,
      'body_text': bodyText,
      'key_takeaway': keyTakeaway,
      'code_snippet': codeSnippet,
      'code_language': codeLanguage,
      'audio_duration': audioDuration,
      'quiz': quiz?.toJson(),
      'image_url': imageUrl,
      'source_reference': sourceReference,
      'position_in_series': positionInSeries,
      'total_series_steps': totalSeriesSteps,
      'est_read_minutes': estReadMinutes,
      'published_at': publishedAt.toIso8601String(),
      'is_liked': isLiked,
      'is_saved': isSaved,
      'like_count': likeCount,
      'comment_count': commentCount,
    };
  }
}