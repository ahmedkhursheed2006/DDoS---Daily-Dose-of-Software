import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/series.dart';
import '../../services/series_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategory = 0;

  final TextEditingController _searchController =
  TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  final SeriesService _seriesService = SeriesService();

  String _searchQuery = '';

  bool _isLoadingSeries = true;
  String? _seriesError;

  // Categories
  final List<String> _categories = [
    'All',
    'Frontend',
    'AI',
    'Infrastructure',
  ];

  // API Series
  List<Series> _series = [];

  // Followed series IDs
  final Set<int> _followedSeries = {};

  // Community posts
  final List<Map<String, dynamic>> _communityPosts = [
    {
      'name': 'Ahmed Khursheed',
      'initials': 'AK',
      'time': '2h ago',
      'isRepost': true,
      'commentary':
      'Clean architecture becomes much easier to understand when you start separating responsibilities.',
      'originalTitle': 'Understanding Clean Architecture',
      'originalText':
      'A good architecture keeps business logic independent from UI and external frameworks.',
      'likes': 24,
      'reposts': 5,
    },
    {
      'name': 'Tarun Rawat',
      'initials': 'TR',
      'time': '4h ago',
      'isRepost': false,
      'commentary':
      'Small improvements in code quality can make a big difference in large projects.',
      'originalTitle': 'Software Quality Matters',
      'originalText':
      'Quality is not only about finding bugs. It is also about building software that is reliable, maintainable and easy to understand.',
      'likes': 18,
      'reposts': 3,
    },
    {
      'name': 'Aashu Chhantyal',
      'initials': 'AC',
      'time': '6h ago',
      'isRepost': true,
      'commentary':
      'This is a useful reminder for anyone learning software engineering.',
      'originalTitle': 'Good Engineering Practices',
      'originalText':
      'Writing readable code and following consistent practices helps teams work together effectively.',
      'likes': 31,
      'reposts': 8,
    },
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });

    _loadSeries();
  }

  // ============================================================
  // LOAD SERIES FROM API
  // ============================================================

  Future<void> _loadSeries() async {
    try {
      setState(() {
        _isLoadingSeries = true;
        _seriesError = null;
      });

      final series = await _seriesService.getSeries();

      if (!mounted) return;

      setState(() {
        _series = series;
        _isLoadingSeries = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingSeries = false;
        _seriesError = 'Failed to load series.';
      });

      debugPrint('[ExploreScreen] Error loading series: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundCanvas,
        body: SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),

              SliverToBoxAdapter(
                child: _buildFeaturedPath(),
              ),

              SliverToBoxAdapter(
                child: _buildCategories(),
              ),

              SliverToBoxAdapter(
                child: _buildPopularSeries(),
              ),

              SliverToBoxAdapter(
                child: _buildCommunityHeader(),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _buildCommunityPost(
                      _filteredCommunityPosts[index],
                    );
                  },
                  childCount: _filteredCommunityPosts.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 22,
                color: AppConstants.primaryThemeColor,
              ),
              const SizedBox(width: 7),
              Text(
                'DDoS',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.primaryText,
                ),
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            onPressed: () {
              _dismissKeyboard();

              showModalBottomSheet(
                context: context,
                backgroundColor: AppConstants.cardSurface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.home_outlined,
                              color:
                              AppConstants.primaryThemeColor,
                            ),
                            title: Text(
                              'Home',
                              style: TextStyle(
                                color:
                                AppConstants.primaryText,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.settings_outlined,
                              color:
                              AppConstants.primaryThemeColor,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                color:
                                AppConstants.primaryText,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.menu_rounded,
              color: AppConstants.primaryText,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search software concepts...',
          hintStyle: TextStyle(
            color: AppConstants.secondaryText,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppConstants.secondaryText,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              _dismissKeyboard();
            },
            icon: Icon(
              Icons.close_rounded,
              color: AppConstants.secondaryText,
              size: 19,
            ),
          )
              : null,
          filled: true,
          fillColor: AppConstants.cardSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FEATURED PATH
  // ============================================================

  Widget _buildFeaturedPath() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Featured Path',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryText,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _dismissKeyboard();

                  setState(() {
                    _selectedCategory = 0;
                  });
                },
                child: Text(
                  'View all paths',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                    AppConstants.primaryThemeColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            height: 285,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE8E4DC),
                            Color(0xFFCFC8BA),
                            Color(0xFF737373),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_tree_rounded,
                          size: 120,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.78),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                            AppConstants.primaryThemeColor,
                            borderRadius:
                            BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'PROFESSIONAL TRACK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Mastering System\nDesign',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            height: 1.05,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Scale architectures to millions of\n'
                              'users. Learn distributed systems,\n'
                              'load balancing, and high availability\n'
                              'from industry experts.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 14),

                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Starting System Design path...',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppConstants.primaryThemeColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(24),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Start Learning',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 4,
      ),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding:
          const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final selected =
                _selectedCategory == index;

            if (index == 0) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: () {
                _dismissKeyboard();

                setState(() {
                  _selectedCategory = index;
                });
              },
              child: Container(
                margin:
                const EdgeInsets.only(right: 9),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 17,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppConstants.primaryThemeColor
                      .withValues(alpha: 0.12)
                      : AppConstants.cardSurface,
                  borderRadius:
                  BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? AppConstants.primaryThemeColor
                        : AppConstants.secondaryColor
                        .withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppConstants.primaryThemeColor
                        : AppConstants.primaryText,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FILTER SERIES
  // ============================================================

  List<Series> get _filteredSeries {
    if (_searchQuery.isEmpty) {
      return _series;
    }

    return _series.where((series) {
      final title =
      series.title.toLowerCase();

      final description =
      series.description.toLowerCase();

      return title.contains(_searchQuery) ||
          description.contains(_searchQuery);
    }).toList();
  }

  // ============================================================
  // POPULAR SERIES
  // ============================================================

  Widget _buildPopularSeries() {
    final filteredSeries = _filteredSeries;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        8,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Series',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppConstants.primaryText,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Follow a series and keep learning.',
            style: TextStyle(
              fontSize: 13,
              color: AppConstants.secondaryText,
            ),
          ),

          const SizedBox(height: 14),

          if (_isLoadingSeries)
            _buildLoadingState()
          else if (_seriesError != null)
            _buildErrorState()
          else if (filteredSeries.isEmpty)
              _buildEmptyState('No series found.')
            else
              ...filteredSeries.map(_buildSeriesCard),
        ],
      ),
    );
  }

  // ============================================================
  // SERIES CARD
  // ============================================================

  Widget _buildSeriesCard(Series series) {
    final isFollowed =
    _followedSeries.contains(series.id);

    return Container(
      margin:
      const EdgeInsets.only(bottom: 12),
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppConstants.primaryThemeColor
                  .withValues(alpha: 0.12),
              borderRadius:
              BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color:
              AppConstants.primaryThemeColor,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  series.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    AppConstants.primaryText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  series.description,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    AppConstants.secondaryText,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Series #${series.id}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppConstants.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          OutlinedButton(
            onPressed: () {
              _dismissKeyboard();

              setState(() {
                if (isFollowed) {
                  _followedSeries
                      .remove(series.id);
                } else {
                  _followedSeries
                      .add(series.id);
                }
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isFollowed
                  ? Colors.white
                  : AppConstants
                  .primaryThemeColor,
              backgroundColor: isFollowed
                  ? AppConstants
                  .primaryThemeColor
                  : Colors.transparent,
              side: BorderSide(
                color: AppConstants
                    .primaryThemeColor,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 11,
              ),
            ),
            child: Text(
              isFollowed
                  ? 'Following'
                  : 'Follow',
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color:
          AppConstants.primaryThemeColor,
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color:
            AppConstants.primaryThemeColor,
            size: 32,
          ),

          const SizedBox(height: 10),

          Text(
            _seriesError ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color:
              AppConstants.secondaryText,
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _loadSeries,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppConstants.primaryThemeColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMUNITY
  // ============================================================

  List<Map<String, dynamic>>
  get _filteredCommunityPosts {
    if (_searchQuery.isEmpty) {
      return _communityPosts;
    }

    return _communityPosts.where((post) {
      final name =
      post['name'].toString().toLowerCase();

      final commentary =
      post['commentary']
          .toString()
          .toLowerCase();

      final title =
      post['originalTitle']
          .toString()
          .toLowerCase();

      final text =
      post['originalText']
          .toString()
          .toLowerCase();

      return name.contains(_searchQuery) ||
          commentary.contains(_searchQuery) ||
          title.contains(_searchQuery) ||
          text.contains(_searchQuery);
    }).toList();
  }

  Widget _buildCommunityHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    AppConstants.primaryText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'See what others are learning and sharing.',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                    AppConstants.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.people_alt_outlined,
            color:
            AppConstants.primaryThemeColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMUNITY POST
  // ============================================================

  Widget _buildCommunityPost(
      Map<String, dynamic> post) {
    return Container(
      margin:
      const EdgeInsets.fromLTRB(
        20,
        6,
        20,
        10,
      ),
      padding:
      const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color:
        AppConstants.cardSurface,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppConstants
              .secondaryColor
              .withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor:
                AppConstants
                    .primaryThemeColor
                    .withValues(alpha: 0.12),
                child: Text(
                  post['initials'],
                  style: TextStyle(
                    color: AppConstants
                        .primaryThemeColor,
                    fontWeight:
                    FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        AppConstants
                            .primaryText,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      post['time'],
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        AppConstants
                            .secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              if (post['isRepost'])
                Row(
                  children: [
                    Icon(
                      Icons.repeat_rounded,
                      size: 16,
                      color: AppConstants
                          .secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reposted',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        AppConstants
                            .secondaryText,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            post['commentary'],
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color:
              AppConstants.primaryText,
            ),
          ),

          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppConstants
                  .backgroundCanvas,
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  post['originalTitle'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    AppConstants.primaryText,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  post['originalText'],
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color:
                    AppConstants.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildPostAction(
                icon:
                Icons.favorite_border_rounded,
                label:
                '${post['likes']}',
                onTap: () {},
              ),

              const SizedBox(width: 18),

              _buildPostAction(
                icon:
                Icons.chat_bubble_outline_rounded,
                label: 'Comment',
                onTap: () {},
              ),

              const Spacer(),

              _buildPostAction(
                icon:
                Icons.repeat_rounded,
                label:
                '${post['reposts']}',
                onTap: () =>
                    _showRepostDialog(post),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // POST ACTION
  // ============================================================

  Widget _buildPostAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(10),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 5,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color:
              AppConstants.secondaryText,
            ),

            const SizedBox(width: 5),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color:
                AppConstants.secondaryText,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REPOST DIALOG
  // ============================================================

  void _showRepostDialog(
      Map<String, dynamic> post) {
    final controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          AppConstants.cardSurface,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: Text(
            'Repost',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
              color:
              AppConstants.primaryText,
            ),
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Add a comment to your repost (optional)',
                style: TextStyle(
                  fontSize: 13,
                  color:
                  AppConstants.secondaryText,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                controller,
                maxLines: 3,
                decoration:
                InputDecoration(
                  hintText:
                  'Write something...',
                  filled: true,
                  fillColor: AppConstants
                      .backgroundCanvas,
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                        14),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppConstants
                      .secondaryText,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Repost will be sent when the API is connected.',
                    ),
                  ),
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppConstants
                    .primaryThemeColor,
                foregroundColor:
                Colors.white,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      12),
                ),
              ),
              child:
              const Text('Repost'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
      String message) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
        AppConstants.cardSurface,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color:
            AppConstants.secondaryText,
          ),
        ),
      ),
    );
  }
}