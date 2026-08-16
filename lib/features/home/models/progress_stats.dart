class StreakData {
  final int currentStreakDays;
  final List<bool> weekActivity;

  const StreakData({
    required this.currentStreakDays,
    required this.weekActivity,
  });

  StreakData copyWith({int? currentStreakDays, List<bool>? weekActivity}) {
    return StreakData(
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      weekActivity: weekActivity ?? this.weekActivity,
    );
  }
}

class ProgressStats {
  final int conceptsMastered;
  final int blueprintsFinished;
  final double hoursLearned;
  final double accuracyPercent;

  const ProgressStats({
    required this.conceptsMastered,
    required this.blueprintsFinished,
    required this.hoursLearned,
    required this.accuracyPercent,
  });
}

class SeriesPost {
  final String id;
  final String seriesTitle;
  final String postTitle;
  final String readTimeLabel;
  final String difficultyLabel;
  final bool isRead;

  const SeriesPost({
    required this.id,
    required this.seriesTitle,
    required this.postTitle,
    required this.readTimeLabel,
    required this.difficultyLabel,
    this.isRead = false,
  });

  SeriesPost copyWith({bool? isRead}) {
    return SeriesPost(
      id: id,
      seriesTitle: seriesTitle,
      postTitle: postTitle,
      readTimeLabel: readTimeLabel,
      difficultyLabel: difficultyLabel,
      isRead: isRead ?? this.isRead,
    );
  }
}

class SkillProgress {
  final String name;
  final int percent;

  const SkillProgress({required this.name, required this.percent});
}

class ContinueLearningItem {
  final String id;
  final String title;
  final String description;
  final int progressPercent;
  final String timeLeftLabel;

  const ContinueLearningItem({
    required this.id,
    required this.title,
    required this.description,
    required this.progressPercent,
    required this.timeLeftLabel,
  });
}

class RecommendedItem {
  final String id;
  final String tag;
  final String title;
  final String readTimeLabel;

  const RecommendedItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.readTimeLabel,
  });
}

class AchievementItem {
  final String title;
  final String description;

  const AchievementItem({required this.title, required this.description});
}

class FeaturedRecommendation {
  final String id;
  final String badge;
  final String title;
  final String description;
  final List<String> tags;

  const FeaturedRecommendation({
    required this.id,
    required this.badge,
    required this.title,
    required this.description,
    required this.tags,
  });
}

class MockHomeRepository {
  // ------------------------------------------------------------
  // STREAK
  // ------------------------------------------------------------

  static StreakData getStreak() {
    return const StreakData(
      currentStreakDays: 14,
      weekActivity: [true, true, true, true, true, false, false],
    );
  }

  // ------------------------------------------------------------
  // PROGRESS STATS
  // ------------------------------------------------------------

  static ProgressStats getProgress() {
    return const ProgressStats(
      conceptsMastered: 32,
      blueprintsFinished: 8,
      hoursLearned: 4.2,
      accuracyPercent: 92,
    );
  }

  // ------------------------------------------------------------
  // TODAY'S FEED
  // ------------------------------------------------------------

  static List<SeriesPost> getTodaysFeed({bool simulateEmpty = false}) {
    if (simulateEmpty) {
      return [];
    }

    return const [
      SeriesPost(
        id: 'p1',
        seriesTitle: 'The Magic of Pointers',
        postTitle: 'Memory & References',
        readTimeLabel: '5 min read',
        difficultyLabel: 'Intermediate',
      ),
      SeriesPost(
        id: 'p2',
        seriesTitle: 'Mental Models: Event Loops',
        postTitle: 'The Call Stack',
        readTimeLabel: '6 min read',
        difficultyLabel: 'Intermediate',
      ),
      SeriesPost(
        id: 'p3',
        seriesTitle: 'System Design',
        postTitle: 'Scaling to Millions',
        readTimeLabel: '8 min read',
        difficultyLabel: 'Advanced',
      ),
    ];
  }

  // ------------------------------------------------------------
  // CONTINUE LEARNING
  // ------------------------------------------------------------

  static List<ContinueLearningItem> getContinueLearning() {
    return const [
      ContinueLearningItem(
        id: 'c1',
        title: 'Closure in JS',
        description:
            'Master lexical scoping and private variables in modern...',
        progressPercent: 80,
        timeLeftLabel: '',
      ),
      ContinueLearningItem(
        id: 'c2',
        title: 'B-Trees',
        description: 'The backbone of database indexing...',
        progressPercent: 45,
        timeLeftLabel: '',
      ),
    ];
  }

  // ------------------------------------------------------------
  // FEATURED RECOMMENDATION
  // ------------------------------------------------------------

  static FeaturedRecommendation getFeaturedRecommendation() {
    return const FeaturedRecommendation(
      id: 'f1',
      badge: 'New Course',
      title: 'System Design: Scaling to Millions',
      description:
          'Learn how top tech giants handle massive traffic through load balancing and caching.',
      tags: ['Backend', 'Infrastructure'],
    );
  }

  // ------------------------------------------------------------
  // RECOMMENDED
  // ------------------------------------------------------------

  static List<RecommendedItem> getRecommended() {
    return const [
      RecommendedItem(
        id: 'r1',
        tag: 'Writing idiomatic code for...',
        title: 'Pythonic Patterns',
        readTimeLabel: '3 min read',
      ),
      RecommendedItem(
        id: 'r2',
        tag: 'Why AI needs efficient search.',
        title: 'Vector Databases',
        readTimeLabel: '7 min read',
      ),
      RecommendedItem(
        id: 'r3',
        tag: 'Secure your APIs with tokens.',
        title: 'JWT Authentication',
        readTimeLabel: '4 min read',
      ),
    ];
  }

  // ------------------------------------------------------------
  // SKILLS MASTERY
  // ------------------------------------------------------------

  static List<SkillProgress> getSkillsMastery() {
    return const [
      SkillProgress(name: 'Algorithms', percent: 85),
      SkillProgress(name: 'Databases', percent: 62),
      SkillProgress(name: 'System Design', percent: 48),
      SkillProgress(name: 'Cloud Native', percent: 30),
    ];
  }

  // ------------------------------------------------------------
  // CORE STRENGTHS
  // ------------------------------------------------------------

  static List<String> getCoreStrengths() {
    return const ['Python', 'SQL', 'Recursion'];
  }

  // ------------------------------------------------------------
  // RECENT ACHIEVEMENTS
  // ------------------------------------------------------------

  static List<AchievementItem> getRecentAchievements() {
    return const [
      AchievementItem(
        title: 'Early Bird',
        description: 'Finished 5 lessons before 8 AM.',
      ),
      AchievementItem(
        title: 'Consistency King',
        description: 'Maintained a 7-day learning streak.',
      ),
    ];
  }
}
