import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/series.dart';
import '../../models/repost.dart';
import '../../services/feed_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int? _selectedCategoryIndex;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FeedService _feedService = FeedService();

  String _searchQuery = '';

  // Series state (T6)
  bool _isLoadingSeries = true;
  String? _seriesError;
  List<Series> _series = [];
  final Set<int> _followedSeries = {};
  final Set<int> _followLoadingIds = {};

  // Categories (Official T4 Requirements)
  final List<String> _categories = [
    'Architecture',
    'Quality',
    'Design',
    'Engineering',
  ];

  // Community state (T7)
  bool _isLoadingCommunity = true;
  String? _communityError;
  List<Repost> _communityPosts = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    _loadSeries();
    _loadCommunityPosts();
  }

  // ============================================================
  // LOAD SERIES (T6 Integration: GET /series)
  // ============================================================

  Future<void> _loadSeries() async {
    try {
      setState(() {
        _isLoadingSeries = true;
        _seriesError = null;
      });

      final series = await _feedService.getSeries();

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

  // ============================================================
  // TOGGLE FOLLOW (T6 Integration: POST /series/:id/follow)
  // ============================================================

  Future<void> _handleToggleFollow(int seriesId) async {
    if (_followLoadingIds.contains(seriesId)) return;

    setState(() {
      _followLoadingIds.add(seriesId);
    });

    try {
      final isFollowing = await _feedService.toggleFollow(seriesId);

      if (!mounted) return;

      setState(() {
        if (isFollowing) {
          _followedSeries.add(seriesId);
        } else {
          _followedSeries.remove(seriesId);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFollowing ? 'Followed series successfully!' : 'Unfollowed series.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update follow status. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _followLoadingIds.remove(seriesId);
        });
      }
    }
  }

  // ============================================================
  // LOAD COMMUNITY POSTS (T7 Integration: GET /feed/reposts)
  // ============================================================

  Future<void> _loadCommunityPosts() async {
    try {
      setState(() {
        _isLoadingCommunity = true;
        _communityError = null;
      });

      final posts = await _feedService.getReposts();

      if (!mounted) return;

      setState(() {
        _communityPosts = posts;
        _isLoadingCommunity = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingCommunity = false;
        _communityError = 'Failed to load community feed.';
      });

      debugPrint('[ExploreScreen] Error loading community posts: $e');
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
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: Scaffold(
          backgroundColor: AppConstants.backgroundCanvas,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTopTabBar(),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildExploreTab(),
                      _buildCommunityTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP TAB BAR
  // ============================================================

  Widget _buildTopTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppConstants.secondaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppConstants.primaryThemeColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.secondaryText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.explore_outlined, size: 18),
                SizedBox(width: 6),
                Text('Explore'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt_outlined, size: 18),
                SizedBox(width: 6),
                Text('Community'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EXPLORE TAB CONTENT
  // ============================================================

  Widget _buildExploreTab() {
    return RefreshIndicator(
      onRefresh: _loadSeries,
      color: AppConstants.primaryThemeColor,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
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
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMUNITY TAB CONTENT (T7 Reposts & Commentary)
  // ============================================================

  Widget _buildCommunityTab() {
    final filteredPosts = _filteredCommunityPosts;

    return RefreshIndicator(
      onRefresh: _loadCommunityPosts,
      color: AppConstants.primaryThemeColor,
      child: _isLoadingCommunity
          ? Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryThemeColor,
              ),
            )
          : _communityError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppConstants.primaryThemeColor,
                        size: 36,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _communityError!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _loadCommunityPosts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryThemeColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : filteredPosts.isEmpty
                  ? Center(
                      child: Text(
                        'No community posts found.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.secondaryText,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24, top: 8),
                      itemCount: filteredPosts.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildCommunityHeader();
                        }
                        return _buildCommunityPost(filteredPosts[index - 1]);
                      },
                    ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
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
                              color: AppConstants.primaryThemeColor,
                            ),
                            title: Text(
                              'Home',
                              style: TextStyle(
                                color: AppConstants.primaryText,
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.settings_outlined,
                              color: AppConstants.primaryThemeColor,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                color: AppConstants.primaryText,
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
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
                    _selectedCategoryIndex = null;
                  });
                },
                child: Text(
                  'View all paths',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryThemeColor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryThemeColor,
                            borderRadius: BorderRadius.circular(3),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Starting System Design path...'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryThemeColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Start Learning',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
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
  // CATEGORIES (Architecture, Quality, Design, Engineering)
  // ============================================================

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final selected = _selectedCategoryIndex == index;

            return GestureDetector(
              onTap: () {
                _dismissKeyboard();
                setState(() {
                  if (_selectedCategoryIndex == index) {
                    _selectedCategoryIndex = null;
                  } else {
                    _selectedCategoryIndex = index;
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 9),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppConstants.primaryThemeColor.withValues(alpha: 0.12)
                      : AppConstants.cardSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? AppConstants.primaryThemeColor
                        : AppConstants.secondaryColor.withValues(alpha: 0.08),
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
    List<Series> list = _series;

    if (_selectedCategoryIndex != null) {
      final selectedCategory =
          _categories[_selectedCategoryIndex!].toLowerCase();
      list = list.where((series) {
        final title = series.title.toLowerCase();
        final description = series.description.toLowerCase();
        final category = series.category?.toLowerCase() ?? '';
        return category.contains(selectedCategory) ||
            title.contains(selectedCategory) ||
            description.contains(selectedCategory);
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list.where((series) {
        final title = series.title.toLowerCase();
        final description = series.description.toLowerCase();
        return title.contains(_searchQuery) ||
            description.contains(_searchQuery);
      }).toList();
    }

    return list;
  }

  // ============================================================
  // POPULAR SERIES
  // ============================================================

  Widget _buildPopularSeries() {
    final filteredSeries = _filteredSeries;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    final isFollowed = _followedSeries.contains(series.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: AppConstants.primaryThemeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: AppConstants.primaryThemeColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  series.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.secondaryText,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Series #${series.id}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              _dismissKeyboard();
              _handleToggleFollow(series.id);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isFollowed
                  ? Colors.white
                  : AppConstants.primaryThemeColor,
              backgroundColor: isFollowed
                  ? AppConstants.primaryThemeColor
                  : Colors.transparent,
              side: BorderSide(
                color: AppConstants.primaryThemeColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
              ),
            ),
            child: _followLoadingIds.contains(series.id)
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isFollowed
                          ? Colors.white
                          : AppConstants.primaryThemeColor,
                    ),
                  )
                : Text(
                    isFollowed ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING STATE
  // ============================================================

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppConstants.primaryThemeColor,
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppConstants.primaryThemeColor,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            _seriesError ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppConstants.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadSeries,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryThemeColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER COMMUNITY POSTS
  // ============================================================

  List<Repost> get _filteredCommunityPosts {
    if (_searchQuery.isEmpty) {
      return _communityPosts;
    }

    return _communityPosts.where((post) {
      final name = post.authorName.toLowerCase();
      final commentary = (post.commentary ?? '').toLowerCase();
      final title = post.originalTitle.toLowerCase();
      final text = post.originalText.toLowerCase();

      return name.contains(_searchQuery) ||
          commentary.contains(_searchQuery) ||
          title.contains(_searchQuery) ||
          text.contains(_searchQuery);
    }).toList();
  }

  Widget _buildCommunityHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Feed',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'See what others are learning and sharing.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.people_alt_outlined,
            color: AppConstants.primaryThemeColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMUNITY POST / REPOST CARD
  // ============================================================

  Widget _buildCommunityPost(Repost post) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppConstants.secondaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor:
                    AppConstants.primaryThemeColor.withValues(alpha: 0.12),
                child: Text(
                  post.authorInitials,
                  style: TextStyle(
                    color: AppConstants.primaryThemeColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppConstants.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (post.isRepost)
                Row(
                  children: [
                    Icon(
                      Icons.repeat_rounded,
                      size: 16,
                      color: AppConstants.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reposted',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppConstants.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (post.commentary != null && post.commentary!.isNotEmpty) ...[
            const SizedBox(height: 13),
            Text(
              post.commentary!,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppConstants.primaryText,
              ),
            ),
          ],
          const SizedBox(height: 13),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppConstants.backgroundCanvas,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.originalTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryText,
                  ),
                ),
                if (post.originalText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    post.originalText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: AppConstants.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPostAction(
                icon: Icons.favorite_border_rounded,
                label: '${post.likes}',
                onTap: () {},
              ),
              const SizedBox(width: 18),
              _buildPostAction(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Comment',
                onTap: () {},
              ),
              const Spacer(),
              _buildPostAction(
                icon: Icons.repeat_rounded,
                label: '${post.reposts}',
                onTap: () => _showRepostDialog(post),
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
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 5,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppConstants.secondaryText,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppConstants.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REPOST DIALOG (T7 Integration: POST /posts/:id/repost)
  // ============================================================

  void _showRepostDialog(Repost post) {
    final controller = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppConstants.cardSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Repost',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppConstants.primaryText,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reposting: "${post.originalTitle}"',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryThemeColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add a comment to your repost (optional)',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConstants.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      filled: true,
                      fillColor: AppConstants.backgroundCanvas,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppConstants.secondaryText,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(dialogContext);

                          setDialogState(() {
                            isSubmitting = true;
                          });

                          try {
                            final newRepost = await _feedService.createRepost(
                              postId: post.originalPostId,
                              commentary: controller.text.trim(),
                            );

                            if (!mounted) return;
                            navigator.pop();

                            if (newRepost != null) {
                              setState(() {
                                _communityPosts.insert(0, newRepost);
                              });
                            } else {
                              _loadCommunityPosts();
                            }

                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Repost shared successfully!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            setDialogState(() {
                              isSubmitting = false;
                            });

                            if (!mounted) return;

                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to create repost. Please try again.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryThemeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Repost'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.cardSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13,
            color: AppConstants.secondaryText,
          ),
        ),
      ),
    );
  }
}