import 'package:flutter/material.dart';
import 'package:twenty_four/features/news/models/news_details_model.dart';

class NewsHeader extends StatelessWidget {
  final NewsDetailsModel newsDetails;
  final double scrollOffset;
  final VoidCallback onBackPressed;

  const NewsHeader({
    super.key,
    required this.newsDetails,
    required this.scrollOffset,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 400, // زودنا الارتفاع لاستيعاب العنوان
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: _buildIconButton(
        context,
        icon: Icons.arrow_forward,
        onPressed: onBackPressed,
        isDarkMode: isDarkMode,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildParallaxImage(context),
            _buildGradientOverlay(),
            // وضع المحتوى في الأسفل
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);

    return Padding(
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
          icon: Icon(icon, color: theme.iconTheme.color),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildParallaxImage(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: Offset(0, scrollOffset * 0.5),
      child: Image.network(
        newsDetails.image!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
              color: theme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.9), // جريديان أقوى في الأسفل
          ],
          stops: [0.0, 0.5, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge في الأعلى
          _buildCategoryBadge(context),
          const SizedBox(height: 12),
          // العنوان تحته
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          newsDetails.sectionModel!.title!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      newsDetails.imageTitle!,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
        shadows: [
          const Shadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
