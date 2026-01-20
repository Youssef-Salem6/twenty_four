import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/features/comments/view/comments_view.dart';
import 'package:twenty_four/features/news/models/news_details_model.dart';
// import 'package:twenty_four/features/news/view/widgets/ai_summary_view.dart';
import 'package:twenty_four/features/news/view/widgets/faq_view.dart';
import 'package:twenty_four/features/webView/web_view.dart';
import 'package:twenty_four/main.dart';

class NewsContent extends StatefulWidget {
  final NewsDetailsModel newsDetails;
  final bool isDarkMode;

  const NewsContent({
    super.key,
    required this.newsDetails,
    required this.isDarkMode,
  });

  @override
  State<NewsContent> createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsData = {
      "source_image":
          "https://images.unsplash.com/photo-1568602471122-7832951cc4c5",
    };

    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleAndSource(theme, newsData),
                Divider(height: 1, color: theme.dividerColor),
                // _buildDescription(theme),
                _buildBodyContent(theme),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the WebView
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    WebView(url: widget.newsDetails.sourceUrl!),
                          ),
                        );
                      },
                      child: Text("الخبر كامل في الموقع الرسمي"),
                    ),
                  ],
                ),
                const Gap(30),
                // // عرض AI Summary فقط إذا كان موجوداً
                // if (widget.newsDetails.geminiSummary != null &&
                //     widget.newsDetails.geminiSummary!.isNotEmpty)
                //   AiSummaryView(
                //     summary: widget.newsDetails.geminiSummary!,
                //     isDarkMode: widget.isDarkMode,
                //   ),

                // if (widget.newsDetails.geminiSummary != null &&
                //     widget.newsDetails.geminiSummary!.isNotEmpty)
                //   const Gap(30),

                // عرض FAQ فقط إذا كان موجوداً
                if (widget.newsDetails.faqs != null &&
                    widget.newsDetails.faqs!.isNotEmpty)
                  SizedBox(
                    height: 400,
                    child: FaqView(
                      faqs: widget.newsDetails.faqs!,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),

                if (widget.newsDetails.faqs != null &&
                    widget.newsDetails.faqs!.isNotEmpty)
                  const Gap(30),

                // عرض قسم التعليقات فقط إذا كان هناك تعليقات
                if (_shouldShowCommentsSection()) _buildCommentsSection(theme),

                const Gap(100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowCommentsSection() {
    return (widget.newsDetails.comments != null &&
        widget.newsDetails.comments!.isNotEmpty);
  }

  Widget _buildTitleAndSource(ThemeData theme, Map<String, dynamic> newsData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.justify,
            widget.newsDetails.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 26,
              height: 1.4,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.newsDetails.sourceLogo!),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.justify,
                      widget.newsDetails.source!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "المصدر",
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Html(
        data: widget.newsDetails.description ?? "<p>لا يوجد محتوى لعرضه.</p>",
        style: {
          "body": Style(
            fontSize: FontSize(15),
            lineHeight: LineHeight(1.9),
            color: Colors.white,
            textAlign: TextAlign.justify,
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
          "p": Style(margin: Margins.only(bottom: 12)),
          "h1, h2, h3, h4, h5, h6": Style(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          "a": Style(
            color: Colors.blue[300],
            textDecoration: TextDecoration.underline,
          ),
          "ul, ol": Style(margin: Margins.only(left: 16, bottom: 12)),
        },
      ),
    );
  }

  Widget _buildCommentsSection(ThemeData theme) {
    return Column(
      children: [
        _buildCommentsHeader(theme),
        const Gap(10),

        // عرض قائمة التعليقات إذا كانت متوفرة
        if (widget.newsDetails.comments != null &&
            widget.newsDetails.comments!.isNotEmpty)
          _buildCommentsList(),

        const Gap(20),
      ],
    );
  }

  Widget _buildCommentsHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'التعليقات (${widget.newsDetails.commentCount})',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          TextButton(
            onPressed: () {
              CommentsView.show(
                id: widget.newsDetails.id!,
                context,
                isDarkMode: prefs.getBool("isDarkMode")!,
              );
            },
            child: Text(
              'عرض الكل',
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    final comments = widget.newsDetails.comments!;

    return Column(
      children: List.generate(comments.length, (index) {
        final comment = comments[index];

        return _buildCommentItem(
          comment,
          index,
          widget.isDarkMode,
          Theme.of(context),
        );
      }),
    );
  }

  Widget _buildCommentItem(
    dynamic comment,
    int index,
    bool isDarkMode,
    ThemeData theme,
  ) {
    // تأكد من أن الـ comment هو Map قبل استخدامه
    if (comment is! Map<String, dynamic>) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                comment['user_image'] ?? 'https://via.placeholder.com/40',
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment['user'] ?? 'مستخدم',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.more_vert,
                        size: 18,
                        color: theme.iconTheme.color,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Text(
                    comment['comment'] ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        comment['time'] ?? 'منذ قليل',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
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
