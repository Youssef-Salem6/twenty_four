import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/core/widgets/login_alert.dart';
import 'package:twenty_four/main.dart';
// import 'app_themes.dart'; // Make sure to import your themes file

class CommentsView extends StatefulWidget {
  final List<dynamic> comments;
  final bool isDarkMode; // Add this parameter

  const CommentsView({
    super.key,
    required this.comments,
    required this.isDarkMode, // Add this parameter
  });

  // Function to show comments bottom sheet
  static void show(
    BuildContext context,
    List<dynamic> comments, {
    required bool isDarkMode,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CommentsView(comments: comments, isDarkMode: isDarkMode),
    );
  }

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: AppThemes.getCardColor(widget.isDarkMode),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        widget.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppThemes.getCardColor(widget.isDarkMode),
                    border: Border(
                      bottom: BorderSide(
                        color:
                            widget.isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: AppThemes.getIconColor(widget.isDarkMode),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              widget.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'التعليقات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.getTextColor(widget.isDarkMode),
                            ),
                          ),
                          Text(
                            '${widget.comments.length} تعليق',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppThemes.getHintColor(widget.isDarkMode),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48), // Balance the close button
                    ],
                  ),
                ),

                // Comments list
                Expanded(
                  child:
                      widget.comments.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  size: 64,
                                  color:
                                      widget.isDarkMode
                                          ? Colors.grey[600]
                                          : Colors.grey[300],
                                ),
                                const Gap(16),
                                Text(
                                  'لا توجد تعليقات بعد',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppThemes.getHintColor(
                                      widget.isDarkMode,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'كن أول من يعلق على هذا الخبر',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppThemes.getHintColor(
                                      widget.isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: widget.comments.length,
                            itemBuilder: (context, index) {
                              return _buildAnimatedComment(
                                widget.comments[index],
                                index,
                              );
                            },
                          ),
                ),

                // Add comment input
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemes.getCardColor(widget.isDarkMode),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop',
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              // color:
                              //     widget.isDarkMode
                              //         ? Colors.grey[700]
                              //         : Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(
                                color: AppThemes.getTextColor(
                                  widget.isDarkMode,
                                ),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    widget.isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
                                hintText: 'اكتب تعليقك...',
                                hintStyle: TextStyle(
                                  color: AppThemes.getHintColor(
                                    widget.isDarkMode,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  // Handle send comment
                                  _commentController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        const Gap(8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (prefs.getString("token") == null) {
                                await LoginAlert.show(context);
                              } else {
                                if (_commentController.text.trim().isNotEmpty) {
                                  // Handle send comment
                                  _commentController.clear();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedComment(Map<String, dynamic> comment, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: CommentItem(
        userName: comment['user'],
        comment: comment['comment'],
        time: 'منذ ${index + 1} ${index == 0 ? "ساعة" : "ساعات"}',
        likes: index * 3,
        userImage: comment['user_image'],
        isDarkMode: widget.isDarkMode,
      ),
    );
  }
}

class CommentItem extends StatefulWidget {
  final String userName;
  final String comment;
  final String time;
  final int likes;
  final String userImage;
  final bool isDarkMode;

  const CommentItem({
    super.key,
    required this.userName,
    required this.comment,
    required this.time,
    required this.likes,
    required this.userImage,
    required this.isDarkMode,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userImage),
          ),
          const Gap(12),
          // Comment content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[700] : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      widget.isDarkMode ? Colors.grey[600]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppThemes.getTextColor(widget.isDarkMode),
                          ),
                        ),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: AppThemes.getHintColor(widget.isDarkMode),
                          fontSize: 12,
                        ),
                      ),
                      const Gap(4),
                      Icon(
                        Icons.more_horiz,
                        size: 20,
                        color: AppThemes.getHintColor(widget.isDarkMode),
                      ),
                    ],
                  ),
                  const Gap(8),
                  // Comment text
                  Text(
                    widget.comment,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color:
                          widget.isDarkMode ? Colors.white70 : Colors.grey[800],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
