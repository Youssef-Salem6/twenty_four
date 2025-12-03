import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/home/models/news_model.dart';
import 'package:twenty_four/features/home/view/widgets/components/share_dialog.dart';
import 'package:twenty_four/main.dart';

class FullNews extends StatefulWidget {
  final Map<String, dynamic> data;
  const FullNews({super.key, required this.data});

  @override
  State<FullNews> createState() => _FullNewsState();
}

class _FullNewsState extends State<FullNews>
    with SingleTickerProviderStateMixin {
  // int _commentCount = 444;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    // Initialize like count from data or default
    // _commentCount = widget.data['comments'] as int? ?? 444;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _shareNews() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder:
          (context) => ShareDialog(
            newsLink:
                widget.data["url"] ??
                "https://example.com/news/${widget.data["id"] ?? "1"}",
            newsTitle: widget.data["title"] ?? "News Title",
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = prefs.getBool("isDarkMode") ?? false;
    NewsModel newsModel = NewsModel.fromJson(widget.data);
    return Scaffold(
      backgroundColor: AppThemes.getScaffoldColor(isDarkMode),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section with aspect ratio
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: newsModel.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, url) => Container(
                              color: AppThemes.getCardColor(isDarkMode),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: AppThemes.getCardColor(isDarkMode),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: AppThemes.getHintColor(isDarkMode),
                                  size: 50,
                                ),
                              ),
                            ),
                      ),
                    ),

                    // Content section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            newsModel.title!,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                          const Gap(8),

                          // Source and date
                          Row(
                            children: [
                              Text(
                                newsModel.source ?? 'Unknown source',
                                style: TextStyle(
                                  color: AppThemes.getHintColor(isDarkMode),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (newsModel.publishedAt != null) ...[
                                const Gap(8),
                                Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppThemes.getHintColor(isDarkMode),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  newsModel.publishedAt ?? '',
                                  style: TextStyle(
                                    color: AppThemes.getHintColor(isDarkMode),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const Gap(16),

                          // Description/Content
                          Text(
                            newsModel.description!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                          const Gap(24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom action bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppThemes.getScaffoldColor(isDarkMode),
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Comments
                  InkWell(
                    // onTap: () => CommentsView.show(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble,
                            size: 24,
                            color: AppThemes.getIconColor(isDarkMode),
                          ),
                          const Gap(4),
                          Text(
                            newsModel.commentsCount.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Share
                  InkWell(
                    onTap: _shareNews,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 24,
                            color: AppThemes.getIconColor(isDarkMode),
                          ),
                          const Gap(4),
                          Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
