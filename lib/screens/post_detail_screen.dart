// ============================================================================
// PROJECT: DDoS - Daily Dose of Software
// MODULE: Task 3 - Post Reader Screen, Social Actions & Interactive Engine
// AUTHOR: Muhammad Suleman Rashid
// ARCHITECTURE: Fully Isolated Null-Safe Screen with Native TTS & Micro-UX
// ============================================================================
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/social_service.dart';
import '../widgets/comment_tile.dart';

enum ReaderTheme { warmPaper, sepiaKindle, oledDark }

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final String currentUserId;
  final String currentUserName;

  const PostDetailScreen({
    super.key,
    required this.post,
    this.currentUserId = 'user_suleman_115',
    this.currentUserName = 'Muhammad Suleman Rashid',
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with TickerProviderStateMixin {
  late Post currentPost;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();

  double _readingProgress = 0.0;
  double _fontScale = 1.0;
  ReaderTheme _currentTheme = ReaderTheme.warmPaper;
  bool _isLoadingComment = false;

  final Map<int, Color> _paragraphHighlights = {};
  final Map<int, String> _paragraphNotes = {};

  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;
  late AnimationController _bookmarkAnimController;
  late Animation<double> _bookmarkScaleAnim;

  List<Comment> comments = [
    Comment(
      id: 'c1',
      userId: 'user_alex',
      userName: 'Alex Chen',
      postId: 'p101',
      body: 'Visualizing memory pointers and address pointers completely clarifies how low-latency systems execute!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Comment(
      id: 'c2',
      userId: 'user_suleman_115',
      userName: 'Muhammad Suleman Rashid',
      postId: 'p101',
      body: 'Zero-copy architecture combined with verified academic citations. Flawless structure!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          final progress = _scrollController.offset / maxScroll;
          setState(() {
            _readingProgress = progress.clamp(0.0, 1.0);
          });
        }
      }
    });

    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
    );

    _bookmarkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _bookmarkScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkAnimController, curve: Curves.easeOutBack),
    );

    SocialService.markPostAsRead(currentPost.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _likeAnimController.dispose();
    _bookmarkAnimController.dispose();
    super.dispose();
  }

  Color get _bgSurface {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return const Color(0xFFFAF7F2);
      case ReaderTheme.sepiaKindle:
        return const Color(0xFFF3EADF);
      case ReaderTheme.oledDark:
        return const Color(0xFF141210);
    }
  }

  Color get _cardBg {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return Colors.white;
      case ReaderTheme.sepiaKindle:
        return const Color(0xFFEFE4D6);
      case ReaderTheme.oledDark:
        return const Color(0xFF1F1C18);
    }
  }

  Color get _primaryTerracotta {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return const Color(0xFFC26D2B);
      case ReaderTheme.sepiaKindle:
        return const Color(0xFFA85A1E);
      case ReaderTheme.oledDark:
        return const Color(0xFFE58F4E);
    }
  }

  Color get _textHeader {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return const Color(0xFF1C1917);
      case ReaderTheme.sepiaKindle:
        return const Color(0xFF2C241D);
      case ReaderTheme.oledDark:
        return const Color(0xFFFAF7F2);
    }
  }

  Color get _textBody {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return const Color(0xFF44403C);
      case ReaderTheme.sepiaKindle:
        return const Color(0xFF52473D);
      case ReaderTheme.oledDark:
        return const Color(0xFFD6D1C9);
    }
  }

  Color get _borderSubtle {
    switch (_currentTheme) {
      case ReaderTheme.warmPaper:
        return const Color(0xFFEFE8DE);
      case ReaderTheme.sepiaKindle:
        return const Color(0xFFDFCFC0);
      case ReaderTheme.oledDark:
        return const Color(0xFF2E2924);
    }
  }

  void _handleLike() async {
    HapticFeedback.lightImpact();
    _likeAnimController.forward().then((_) => _likeAnimController.reverse());

    final nextState = !currentPost.isLiked;
    setState(() {
      currentPost.isLiked = nextState;
      nextState ? currentPost.likeCount++ : currentPost.likeCount--;
    });

    await SocialService.toggleLike(currentPost.id, !nextState);
  }

  void _handleSave() async {
    HapticFeedback.selectionClick();
    _bookmarkAnimController.forward().then((_) => _bookmarkAnimController.reverse());

    final nextState = !currentPost.isSaved;
    setState(() {
      currentPost.isSaved = nextState;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C1917),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              nextState ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
              color: _primaryTerracotta,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              nextState ? "Saved to your profile library." : "Removed from bookmarks.",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    await SocialService.toggleSave(currentPost.id, !nextState);
  }

  void _toggleFontScale() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_fontScale == 1.0) {
        _fontScale = 1.15;
      } else if (_fontScale == 1.15) {
        _fontScale = 1.3;
      } else {
        _fontScale = 1.0;
      }
    });
  }

  void _cycleReaderTheme() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_currentTheme == ReaderTheme.warmPaper) {
        _currentTheme = ReaderTheme.sepiaKindle;
      } else if (_currentTheme == ReaderTheme.sepiaKindle) {
        _currentTheme = ReaderTheme.oledDark;
      } else {
        _currentTheme = ReaderTheme.warmPaper;
      }
    });
  }

  void _openDiagramLightbox() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF090D16),
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 5.0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131B2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.hub_rounded, size: 72, color: _primaryTerracotta),
                        const SizedBox(height: 16),
                        Text(
                          "Pointers & Memory Bus Topology",
                          style: TextStyle(
                            color: _primaryTerracotta,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Heap Buffer [0x7FFEE4] <--- 8-Byte Pointer (Stack Frame)\nZero-Copy Direct Addressing Bus",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 24),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSocialQuoteCardModal() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1917), Color(0xFF292524)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF44403C)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryTerracotta.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _primaryTerracotta.withOpacity(0.4)),
                    ),
                    child: Text(
                      "⚡ DAILY DOSE OF SOFTWARE",
                      style: TextStyle(
                        color: _primaryTerracotta,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Icon(Icons.format_quote_rounded, size: 36, color: Color(0xFFC26D2B)),
              Text(
                "\"${currentPost.keyTakeaway}\"",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.45,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Lesson: ${currentPost.title}",
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFA8A29E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: _primaryTerracotta,
                    child: Text(
                      widget.currentUserName.isNotEmpty ? widget.currentUserName[0] : 'S',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Curated by ${widget.currentUserName}",
                      style: const TextStyle(color: Color(0xFFE7E5E4), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryTerracotta,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 14),
                    label: const Text("Copy Quote", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: "\"${currentPost.keyTakeaway}\"\n\nFrom: ${currentPost.title} (Daily Dose of Software)",
                      ));
                      HapticFeedback.lightImpact();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Quote copied for social sharing!")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openHighlightPalette(int paragraphIdx) {
    HapticFeedback.selectionClick();
    final noteController = TextEditingController(text: _paragraphNotes[paragraphIdx] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Annotate Paragraph #${paragraphIdx + 1}",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: _textHeader),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildColorHighlightButton(ctx, paragraphIdx, "Amber", const Color(0xFFFDE68A)),
                _buildColorHighlightButton(ctx, paragraphIdx, "Terracotta", const Color(0xFFFED7AA)),
                _buildColorHighlightButton(ctx, paragraphIdx, "Sage", const Color(0xFFBBF7D0)),
                _buildColorHighlightButton(ctx, paragraphIdx, "Remove", Colors.transparent, isClear: true),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: "Add a quick sticky note for this paragraph...",
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: _bgSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _borderSubtle)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryTerracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    if (noteController.text.trim().isNotEmpty) {
                      _paragraphNotes[paragraphIdx] = noteController.text.trim();
                      if (!_paragraphHighlights.containsKey(paragraphIdx)) {
                        _paragraphHighlights[paragraphIdx] = const Color(0xFFFDE68A);
                      }
                    } else {
                      _paragraphNotes.remove(paragraphIdx);
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: const Text("Save Note", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorHighlightButton(BuildContext ctx, int pIdx, String label, Color color, {bool isClear = false}) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          if (isClear) {
            _paragraphHighlights.remove(pIdx);
            _paragraphNotes.remove(pIdx);
          } else {
            _paragraphHighlights[pIdx] = color;
          }
        });
        Navigator.pop(ctx);
      },
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isClear ? Colors.grey.shade200 : color,
              shape: BoxShape.circle,
              border: Border.all(color: _borderSubtle, width: 1.5),
            ),
            child: isClear ? const Icon(Icons.close, size: 18, color: Colors.grey) : null,
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textBody)),
        ],
      ),
    );
  }

  void _submitComment(StateSetter setSheetState) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setSheetState(() => _isLoadingComment = true);

    final newComment = await SocialService.addComment(
      postId: currentPost.id,
      body: text,
      userId: widget.currentUserId,
      userName: widget.currentUserName,
    );

    if (newComment != null) {
      setState(() {
        comments.insert(0, newComment);
        currentPost.commentCount++;
      });
      _commentController.clear();
    }
    setSheetState(() => _isLoadingComment = false);
  }

  void _openCommentsBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 24,
                offset: Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: _borderSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Community Discussion (${comments.length})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _textHeader,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: _textBody),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: _bgSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _borderSubtle),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(fontSize: 14, color: _textHeader),
                        decoration: const InputDecoration(
                          hintText: "Add your technical perspective...",
                          hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    _isLoadingComment
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(_primaryTerracotta),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_upward_rounded, color: _primaryTerracotta),
                            onPressed: () => _submitComment(setSheetState),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: comments.isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        alignment: Alignment.center,
                        child: const Text(
                          "No perspectives shared yet.\nBe the first to comment!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (cContext, index) {
                          final c = comments[index];
                          return CommentTile(
                            comment: c,
                            currentUserId: widget.currentUserId,
                            onEdit: (newText) {
                              setState(() => c.body = newText);
                              setSheetState(() {});
                            },
                            onDelete: () {
                              setState(() {
                                comments.removeAt(index);
                                currentPost.commentCount--;
                              });
                              setSheetState(() {});
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = currentPost.bodyText.split('\n\n');

    return Scaffold(
      backgroundColor: _bgSurface,
      appBar: AppBar(
        backgroundColor: _bgSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textHeader, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _primaryTerracotta.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.code_rounded, size: 16, color: _primaryTerracotta),
            ),
            const SizedBox(width: 8),
            Text(
              "DAILY DOSE",
              style: TextStyle(
                color: _primaryTerracotta,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Switch Reader Palette",
            icon: Icon(
              _currentTheme == ReaderTheme.warmPaper
                  ? Icons.wb_sunny_outlined
                  : (_currentTheme == ReaderTheme.sepiaKindle
                      ? Icons.menu_book_rounded
                      : Icons.nightlight_round_rounded),
              color: _primaryTerracotta,
              size: 20,
            ),
            onPressed: _cycleReaderTheme,
          ),
          IconButton(
            tooltip: "Adjust Font Size",
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: _borderSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fontScale == 1.0 ? "A" : (_fontScale == 1.15 ? "A+" : "A++"),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: _textHeader),
              ),
            ),
            onPressed: _toggleFontScale,
          ),
          ScaleTransition(
            scale: _bookmarkScaleAnim,
            child: IconButton(
              icon: Icon(
                currentPost.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: currentPost.isSaved ? _primaryTerracotta : _textHeader,
                size: 26,
              ),
              onPressed: _handleSave,
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: LinearProgressIndicator(
            value: _readingProgress,
            backgroundColor: _borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(_primaryTerracotta),
            minHeight: 3.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlueprintJourneyHeader(),
            const SizedBox(height: 18),
            
            // Native Windows Voice Audio Bar
            _EmbeddedAudioBar(
              title: currentPost.title,
              fullLessonText: "${currentPost.title}. ${currentPost.bodyText}",
              durationText: currentPost.audioDuration,
              primaryColor: _primaryTerracotta,
              cardBg: _cardBg,
              textHeader: _textHeader,
              textBody: _textBody,
            ),

            const SizedBox(height: 8),
            Text(
              currentPost.title,
              style: TextStyle(
                fontSize: 28 * _fontScale,
                fontWeight: FontWeight.w900,
                color: _textHeader,
                height: 1.2,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _openDiagramLightbox,
              borderRadius: BorderRadius.circular(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _borderSubtle),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildGraphicPlaceholder(),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1917).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text("Interactive Zoom", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: BorderSide(color: _primaryTerracotta, width: 4.5),
                  top: BorderSide(color: _borderSubtle),
                  right: BorderSide(color: _borderSubtle),
                  bottom: BorderSide(color: _borderSubtle),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CORE ARCHITECTURAL PRINCIPLE",
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: _primaryTerracotta,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentPost.keyTakeaway,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textHeader,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ...paragraphs.asMap().entries.map((entry) {
              final idx = entry.key;
              final text = entry.value;
              final highlightColor = _paragraphHighlights[idx];
              final note = _paragraphNotes[idx];

              return InkWell(
                onLongPress: () => _openHighlightPalette(idx),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: highlightColor != null ? const EdgeInsets.all(10) : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: highlightColor?.withOpacity(_currentTheme == ReaderTheme.oledDark ? 0.25 : 0.65),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.5 * _fontScale,
                          height: 1.75,
                          color: _textBody,
                          letterSpacing: 0.1,
                        ),
                      ),
                      if (note != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _cardBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _primaryTerracotta.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit_note_rounded, size: 16, color: _primaryTerracotta),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  note,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: _textHeader,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            if (currentPost.codeSnippet.isNotEmpty)
              _EmbeddedCodeBox(code: currentPost.codeSnippet, language: currentPost.codeLanguage),
            if (currentPost.quiz != null)
              _EmbeddedQuizWidget(quiz: currentPost.quiz!),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderSubtle),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryTerracotta.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.verified_user_rounded, size: 20, color: _primaryTerracotta),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CURATED SOURCE & CITATION",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF78716C),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          currentPost.sourceReference,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontStyle: FontStyle.italic,
                            color: _textHeader,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: _borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: _handleLike,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        children: [
                          ScaleTransition(
                            scale: _likeScaleAnim,
                            child: Icon(
                              currentPost.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: currentPost.isLiked ? Colors.red : _textBody,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${currentPost.likeCount}",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textHeader),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _openCommentsBottomSheet,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 22, color: _textBody),
                          const SizedBox(width: 8),
                          Text(
                            "${currentPost.commentCount}",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textHeader),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "Generate Viral Quote Card",
                    icon: Icon(Icons.auto_awesome_rounded, size: 22, color: _primaryTerracotta),
                    onPressed: _openSocialQuoteCardModal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueprintJourneyHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryTerracotta.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "BLUEPRINT JOURNEY",
                      style: TextStyle(
                        color: _primaryTerracotta,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Step #${currentPost.positionInSeries} of ${currentPost.totalSeriesSteps}",
                    style: TextStyle(
                      color: _textBody.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: (currentPost.positionInSeries / currentPost.totalSeriesSteps).clamp(0.0, 1.0),
                      strokeWidth: 3,
                      backgroundColor: _borderSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryTerracotta),
                    ),
                  ),
                  Text(
                    "${((currentPost.positionInSeries / currentPost.totalSeriesSteps) * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: _textHeader,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentPost.seriesTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _textHeader,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "A structured architectural pathway through core distributed systems and memory engines.",
            style: TextStyle(fontSize: 12.5, color: _textBody, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.terminal_rounded, size: 48, color: _primaryTerracotta),
        const SizedBox(height: 8),
        Text(
          "Memory Architecture & Pointers",
          style: TextStyle(
            color: _primaryTerracotta,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// Live Real-Audio Narration Component (Windows Native TTS)
// -------------------------------------------------------------
class _EmbeddedAudioBar extends StatefulWidget {
  final String title;
  final String fullLessonText;
  final String durationText;
  final Color primaryColor;
  final Color cardBg;
  final Color textHeader;
  final Color textBody;

  const _EmbeddedAudioBar({
    required this.title,
    required this.fullLessonText,
    required this.durationText,
    required this.primaryColor,
    required this.cardBg,
    required this.textHeader,
    required this.textBody,
  });

  @override
  State<_EmbeddedAudioBar> createState() => _EmbeddedAudioBarState();
}

class _EmbeddedAudioBarState extends State<_EmbeddedAudioBar> {
  bool _isPlaying = false;
  double _progress = 0.0;
  double _playbackSpeed = 1.0;
  Timer? _playbackTimer;
  Process? _ttsProcess;

  final List<String> _narrationLines = [
    "Pointers unlock the core memory concept that separates great architects...",
    "Allocating dynamically on heap avoids costly deep cloning...",
    "Understanding memory layout enables zero-copy network serialization.",
  ];
  int _currentLineIdx = 0;

  @override
  void dispose() {
    _stopVoice();
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _stopVoice() {
    if (_ttsProcess != null) {
      _ttsProcess!.kill();
      _ttsProcess = null;
    }
  }

  void _speakLessonAudio(double speed) async {
    _stopVoice();
    if (Platform.isWindows) {
      int sapiRate = 0;
      if (speed == 1.25) sapiRate = 2;
      if (speed == 1.5) sapiRate = 4;
      if (speed == 2.0) sapiRate = 7;

      final sanitized = widget.fullLessonText
          .replaceAll('"', ' ')
          .replaceAll("'", ' ')
          .replaceAll('\n', ' ');

      final script =
          'Add-Type -AssemblyName System.Speech; '
          '\$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer; '
          '\$voice.Rate = $sapiRate; '
          '\$voice.Speak("$sanitized");';

      try {
        _ttsProcess = await Process.start('powershell', ['-WindowStyle', 'Hidden', '-Command', script]);
      } catch (e) {
        debugPrint("Speech process error: $e");
      }
    }
  }

  void _togglePlay() {
    HapticFeedback.mediumImpact();
    setState(() => _isPlaying = !_isPlaying);

    if (_isPlaying) {
      _speakLessonAudio(_playbackSpeed);

      _playbackTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (_progress >= 1.0) {
          timer.cancel();
          _stopVoice();
          setState(() {
            _isPlaying = false;
            _progress = 0.0;
            _currentLineIdx = 0;
          });
        } else {
          setState(() {
            _progress += 0.007 * _playbackSpeed;
            _currentLineIdx = ((_progress * _narrationLines.length).floor()).clamp(0, _narrationLines.length - 1);
          });
        }
      });
    } else {
      _stopVoice();
      _playbackTimer?.cancel();
    }
  }

  void _cycleSpeed() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });

    if (_isPlaying) {
      _speakLessonAudio(_playbackSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: _togglePlay,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPlaying ? "AI Voice Narrating Lesson..." : "Listen to Audio Dose",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: widget.textHeader),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Real Speech • ${widget.durationText}",
                      style: TextStyle(fontSize: 11, color: widget.textBody.withOpacity(0.8), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _cycleSpeed,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.primaryColor.withOpacity(0.25)),
                  ),
                  child: Text(
                    "${_playbackSpeed}x",
                    style: TextStyle(color: widget.primaryColor, fontSize: 11.5, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
          if (_isPlaying) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.volume_up_rounded, size: 15, color: widget.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _narrationLines[_currentLineIdx],
                      style: TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: widget.textHeader,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress.clamp(0.0, 1.0),
              minHeight: 3.5,
              backgroundColor: widget.primaryColor.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Embedded Code Box Component
// -------------------------------------------------------------
class _EmbeddedCodeBox extends StatefulWidget {
  final String code;
  final String language;

  const _EmbeddedCodeBox({required this.code, required this.language});

  @override
  State<_EmbeddedCodeBox> createState() => _EmbeddedCodeBoxState();
}

class _EmbeddedCodeBoxState extends State<_EmbeddedCodeBox> {
  bool _copied = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.code));
    HapticFeedback.mediumImpact();
    setState(() => _copied = true);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C1917),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 18),
            SizedBox(width: 8),
            Text("Code snippet copied to clipboard!", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.code.trim().split('\n');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                    const SizedBox(width: 14),
                    Text(
                      widget.language.toUpperCase(),
                      style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _copy,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(_copied ? Icons.check_rounded : Icons.copy_rounded, size: 13, color: _copied ? const Color(0xFF4ADE80) : const Color(0xFF94A3B8)),
                        const SizedBox(width: 5),
                        Text(_copied ? "Copied" : "Copy", style: TextStyle(color: _copied ? const Color(0xFF4ADE80) : const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      lines.length,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text("${i + 1}", style: const TextStyle(fontFamily: 'Consolas', fontSize: 12.5, color: Color(0xFF475569))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lines.map((line) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: SelectableText(
                          line,
                          style: const TextStyle(fontFamily: 'Consolas', fontSize: 13, color: Color(0xFFE2E8F0), height: 1.3),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Embedded Interactive Quiz Component
// -------------------------------------------------------------
class _EmbeddedQuizWidget extends StatefulWidget {
  final QuizQuestion quiz;

  const _EmbeddedQuizWidget({required this.quiz});

  @override
  State<_EmbeddedQuizWidget> createState() => _EmbeddedQuizWidgetState();
}

class _EmbeddedQuizWidgetState extends State<_EmbeddedQuizWidget> {
  int? _selectedIndex;
  bool _submitted = false;

  void _handleSelect(int index) {
    if (_submitted) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndex = index;
      _submitted = true;
    });

    if (widget.quiz.options[index].isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFE8DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFD97706)),
              ),
              const SizedBox(width: 8),
              const Text(
                "KNOWLEDGE CHECK",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFD97706),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.quiz.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1917),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.quiz.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isChosen = _selectedIndex == idx;

            Color bgColor = const Color(0xFFFAF7F2);
            Color borderColor = const Color(0xFFEFE8DE);
            Color textColor = const Color(0xFF44403C);

            if (_submitted) {
              if (option.isCorrect) {
                bgColor = const Color(0xFFDCFCE7);
                borderColor = const Color(0xFF16A34A);
                textColor = const Color(0xFF14532D);
              } else if (isChosen && !option.isCorrect) {
                bgColor = const Color(0xFFFEE2E2);
                borderColor = const Color(0xFFDC2626);
                textColor = const Color(0xFF7F1D1D);
              }
            }

            return InkWell(
              onTap: () => _handleSelect(idx),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: isChosen ? 1.5 : 1.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      _submitted
                          ? (option.isCorrect
                              ? Icons.check_circle_rounded
                              : (isChosen ? Icons.cancel_rounded : Icons.circle_outlined))
                          : (isChosen ? Icons.radio_button_checked : Icons.radio_button_off),
                      size: 18,
                      color: _submitted
                          ? (option.isCorrect
                              ? const Color(0xFF16A34A)
                              : (isChosen ? const Color(0xFFDC2626) : const Color(0xFF94A3B8)))
                          : const Color(0xFF78716C),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.text,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isChosen || (_submitted && option.isCorrect)
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_submitted) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF78716C)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.quiz.options[_selectedIndex!].explanation,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF44403C),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}