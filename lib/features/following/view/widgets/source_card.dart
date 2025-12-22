import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/following/model/sources_model.dart';

class SourceCard extends StatelessWidget {
  final SourcesModel source;
  final int index;
  final bool isDarkMode;
  final bool isFollowing;
  final ValueChanged<bool> onFollowChanged;

  const SourceCard({
    super.key,
    required this.source,
    required this.index,
    required this.isDarkMode,
    required this.isFollowing,
    required this.onFollowChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDarkMode),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLogo(),
          const SizedBox(width: 16),
          _buildSourceName(),
          const SizedBox(width: 12),
          _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Hero(
            tag: 'logo-${source.name}-$index',
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400.withOpacity(0.3),
                    Colors.blue.shade700.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: source.logo ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: AppThemes.getSearchBarColor(isDarkMode),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.blue.shade600,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.newspaper,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceName() {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Text(
              source.name ?? 'Unknown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppThemes.getTextColor(isDarkMode),
                fontFamily: "Almarai",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFollowButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: () {
                onFollowChanged(!isFollowing);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isFollowing
                        ? (isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200)
                        : Colors.blue,
                foregroundColor:
                    isFollowing
                        ? AppThemes.getTextColor(isDarkMode)
                        : Colors.white,
                elevation: isFollowing ? 0 : 4,
                shadowColor: Colors.blue.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isFollowing ? Icons.check : Icons.add,
                      key: ValueKey(isFollowing),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFollowing ? 'متابَع' : 'متابعة',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Almarai",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
