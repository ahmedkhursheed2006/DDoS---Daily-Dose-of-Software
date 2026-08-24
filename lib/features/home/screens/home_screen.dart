import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

import '../widgets/today_dose_card.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/recommended_card.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/empty_state.dart';

import 'post_detail_screen.dart';
import '../../../services/feed_service.dart';

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
  bool _isLoading = true;
  String? _loadError;
  final FeedService _feedService = FeedService();

  final bool _simulateEmptyFeed = false;

  @override
  void initState() {
    super.initState();

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
    _loadTodayFeed();
  }

  Future<void> _loadTodayFeed() async {
    try {
      final feed = await _feedService.getTodayFeed();
      if (!mounted) return;
      setState(() {
        _feed = feed;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Unable to load your daily feed.';
      });
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

    // IMPORTANT:
    //
    // Do NOT use:
    //
    // _feed[0] = ...
    //
    // We replace the entire list instead.

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
    Navigator.pushNamed(context, '/explore');
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
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_loadError != null)
                  Center(child: Text(_loadError!))
                else if (_feed.isEmpty)
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          'Continue Learning',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading1,
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'View History',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: AppColors.primaryOrange,
                              ),
                            ],
                          ),
                        ),
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

                      separatorBuilder: (_, _) => const SizedBox(width: 12),

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
