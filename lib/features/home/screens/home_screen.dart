import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';
import '../../../services/feed_api_services.dart';

import '../widgets/today_dose_card.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/recommended_card.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/empty_state.dart';

import 'post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<SeriesPost> _feed;

  late List<ContinueLearningItem> _continueLearning;

  late FeaturedRecommendation _featured;

  late List<RecommendedItem> _recommended;

  final FeedApiService _feedApiService = FeedApiService();

  final bool _simulateEmptyFeed = false;

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // Load existing UI data first.
    //
    // This keeps the screen usable even if the API is unavailable.
    // ----------------------------------------------------------

    _feed = List<SeriesPost>.from(
      MockHomeRepository.getTodaysFeed(simulateEmpty: _simulateEmptyFeed),
    );

    _continueLearning = List<ContinueLearningItem>.from(
      MockHomeRepository.getContinueLearning(),
    );

    _featured = MockHomeRepository.getFeaturedRecommendation();

    _recommended = List<RecommendedItem>.from(
      MockHomeRepository.getRecommended(),
    );

    // Load Today's Dose from the backend.
    _loadTodayFeed();
  }

  // ============================================================
  // LOAD TODAY'S FEED FROM API
  // ============================================================

  Future<void> _loadTodayFeed() async {
    try {
      final data = await _feedApiService.getTodayFeed();

      final posts = data['posts'];

      if (posts is! List || posts.isEmpty) {
        return;
      }

      final firstFeedItem = posts.first;

      if (firstFeedItem is! Map) {
        return;
      }

      final post = firstFeedItem['post'];

      // Backend can return null when there is no post for a series.
      if (post is! Map) {
        return;
      }

      final apiPostId = post['id']?.toString();
      final apiSeriesId = post['seriesId']?.toString();
      final apiIsRead = post['read'] == true;

      if (apiPostId == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _feed = [
          SeriesPost(
            id: apiPostId,
            seriesTitle: 'Series ${apiSeriesId ?? ''}',
            postTitle: 'Post $apiPostId',
            readTimeLabel: '5 min read',
            difficultyLabel: 'Intermediate',
            isRead: apiIsRead,
          ),
        ];
      });

      debugPrint(
        'Today feed loaded successfully: '
        'postId=$apiPostId, seriesId=$apiSeriesId, read=$apiIsRead',
      );
    } catch (e) {
      // Keep the existing dummy feed if API is unavailable.
      debugPrint('Failed to load today feed: $e');
    }
  }

  // ============================================================
  // TODAY'S DOSE
  // ============================================================

  void _openTodayDose() {
    if (_feed.isEmpty) {
      return;
    }

    final SeriesPost post = _feed.first;

    if (!post.isRead) {
      setState(() {
        _feed = [post.copyWith(isRead: true), ..._feed.skip(1)];
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
    );
  }

  // ============================================================
  // RECOMMENDED
  // ============================================================

  void _openRecommended(String tag, String title, String readTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          post: SeriesPost(
            id: title,
            seriesTitle: tag,
            postTitle: title,
            readTimeLabel: readTime,
            difficultyLabel: 'Recommended',
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EXPLORE
  // ============================================================

  void _goToExplore() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Explore will be available soon.')),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              children: [
                // ==================================================
                // HEADER
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DDoS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryOrangeDark,
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentPeach,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 12)),

                              SizedBox(width: 5),

                              Text(
                                '14-day streak',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryOrangeDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Icon(Icons.menu, color: AppColors.textPrimary),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ==================================================
                // TODAY'S DOSE
                // ==================================================
                if (_feed.isEmpty)
                  FeedEmptyState(onExplore: _goToExplore)
                else
                  TodayDoseCard(post: _feed.first, onStart: _openTodayDose),

                const SizedBox(height: 28),

                // ==================================================
                // CONTINUE LEARNING
                // ==================================================
                if (_continueLearning.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Continue Learning',
                        style: AppTextStyles.heading1,
                      ),

                      Row(
                        children: [
                          Text(
                            'View History',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryOrange,
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: AppColors.primaryOrange,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _continueLearning.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return ContinueLearningCard(
                          item: _continueLearning[index],
                          onResume: () {},
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),
                ],

                // ==================================================
                // RECOMMENDED FOR YOU
                // ==================================================
                const Text(
                  'Recommended for You',
                  style: AppTextStyles.heading1,
                ),

                const SizedBox(height: 12),

                RecommendedFeaturedCard(
                  item: _featured,
                  onTap: () {
                    _openRecommended(_featured.badge, _featured.title, '');
                  },
                ),

                const SizedBox(height: 8),

                ..._recommended.map((item) {
                  return RecommendedListItem(
                    item: item,
                    onTap: () {
                      _openRecommended(
                        item.tag,
                        item.title,
                        item.readTimeLabel,
                      );
                    },
                  );
                }),

                const SizedBox(height: 26),

                // ==================================================
                // NEWSLETTER
                // ==================================================
                const NewsletterSection(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
