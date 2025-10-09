import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/widgets/comments_view.dart';
import 'package:twenty_four/main.dart';

class NewsDetailsView extends StatefulWidget {
  const NewsDetailsView({super.key});

  @override
  State<NewsDetailsView> createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends State<NewsDetailsView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  double _scrollOffset = 0.0;

  // Sample data from API
  final Map<String, dynamic> newsData = {
    "id": 1,
    "title": "اجتماع قادة الدول العربية يناقش قضايا المنطقة",
    "image": "https://images.unsplash.com/photo-1580137189272-c9379f8864fd",
    "source": "الاربعاء 03:25 AM",
    "category": "سياسة",
    "description":
        "عقد قادة الدول العربية اجتماعاً هاماً في العاصمة المصرية القاهرة لمناقشة القضايا الإقليمية والدولية التي تؤثر على المنطقة.",
    "content":
        "في بداية الاجتماع، أكد الرئيس المصري عبد الفتاح السيسي على أهمية الوحدة العربية والتضامن في مواجهة التحديات التي تواجهها المنطقة. وأشار إلى أن التعاون بين الدول العربية هو السبيل الوحيد لتحقيق الاستقرار والتنمية.\n\nمن جانبه، تحدث الملك سلمان بن عبد العزيز عن الجهود التي تبذلها المملكة العربية السعودية لدعم السلام في اليمن، مشدداً على ضرورة إيجاد حل سياسي شامل ينهي الأزمة الإنسانية هناك.\n\nكما تناول الاجتماع الأوضاع في سوريا، حيث دعا الأمين العام لجامعة الدول العربية أحمد أبو الغيط إلى ضرورة دعم الحل السياسي الذي يضمن وحدة الأراضي السورية ويعيد الأمن والاستقرار للشعب السوري.\n\nوفيما يتعلق بالتعاون الاقتصادي، تم الاتفاق على تعزيز التكامل الاقتصادي بين الدول العربية من خلال إطلاق مشاريع مشتركة في مجالات البنية التحتية والطاقة والتجارة.",
    "comments": [
      {
        "user_image":
            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop",
        "user": "محمد علي",
        "comment": "مقال رائع ومفيد جداً!",
      },
      {
        "user_image":
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop",
        "user": "سارة أحمد",
        "comment": "شكراً على المعلومات القيمة.",
      },
      {
        "user_image":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
        "user": "خالد حسن",
        "comment": "أتمنى المزيد من المقالات بهذا المستوى.",
      },
    ],
    "source_image":
        "https://images.unsplash.com/photo-1568602471122-7832951cc4c5",
  };

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

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar with parallax effect
                SliverAppBar(
                  expandedHeight: 350,
                  pinned: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.7)
                                : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: theme.iconTheme.color,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.share, color: theme.iconTheme.color),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_border,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Parallax image
                        Transform.translate(
                          offset: Offset(0, _scrollOffset * 0.5),
                          child: Image.network(
                            newsData['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Category badge
                        Positioned(
                          top: 100,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              newsData['category'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and source
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsData['title'],
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
                                        backgroundImage: NetworkImage(
                                          newsData['source_image'],
                                        ),
                                      ),
                                      const Gap(12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'المصدر الرسمي',
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Text(
                                              newsData['source'],
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Divider
                            Divider(height: 1, color: theme.dividerColor),

                            // Description
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                newsData['description'],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  height: 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                newsData['content'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  height: 1.9,
                                ),
                              ),
                            ),

                            const Gap(30),

                            // Comments Section Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'التعليقات (${newsData['comments'].length})',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      CommentsView.show(
                                        context,
                                        newsData['comments'],
                                        isDarkMode:
                                            prefs.getBool("isDarkMode")!,
                                      );
                                    },
                                    child: Text(
                                      'عرض الكل',
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Gap(10),

                            // Comments List
                            ...List.generate(
                              newsData['comments'].length,
                              (index) => _buildCommentItem(
                                newsData['comments'][index],
                                index,
                                isDarkMode,
                                theme,
                              ),
                            ),

                            const Gap(100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Floating comment button
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
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
                      child: GestureDetector(
                        onTap: () {
                          CommentsView.show(
                            context,
                            newsData['comments'],
                            isDarkMode: prefs.getBool("isDarkMode")!,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'اكتب تعليقك...',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          CommentsView.show(
                            context,
                            newsData['comments'],
                            isDarkMode: prefs.getBool("isDarkMode")!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    Map<String, dynamic> comment,
    int index,
    bool isDarkMode,
    ThemeData theme,
  ) {
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
              backgroundImage: NetworkImage(comment['user_image']),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment['user'],
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
                    comment['comment'],
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
                        'منذ ساعة',
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
