import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/features/comments/view/comments_view.dart';
import 'package:twenty_four/core/widgets/login_alert.dart';
import 'package:twenty_four/main.dart';

class FloatingCommentButton extends StatelessWidget {
  final int newsId;
  final bool isDarkMode;

  const FloatingCommentButton({
    super.key,
    required this.newsId,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 20,
      right: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                onTap: () => _onCommentPressed(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
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
                color: Colors.red[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _onCommentPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCommentPressed(BuildContext context) async {
    if (prefs.getString("token") == null) {
      await LoginAlert.show(context);
    } else {
      CommentsView.show(
        id: newsId,
        context,
        isDarkMode: prefs.getBool("isDarkMode")!,
      );
    }
  }
}
