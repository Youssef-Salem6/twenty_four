import 'package:flutter/material.dart';
import 'package:twenty_four/features/following/model/sources_model.dart';
import 'package:twenty_four/features/following/view/widgets/source_card.dart';

class SourcesListView extends StatelessWidget {
  final List<SourcesModel> sources;
  final bool isDarkMode;
  final Map<String, bool> followStates;
  final Function(String, bool) onFollowChanged;

  const SourcesListView({
    super.key,
    required this.sources,
    required this.isDarkMode,
    required this.followStates,
    required this.onFollowChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sources.length,
      itemBuilder: (context, index) {
        final source = sources[index];
        return _buildAnimatedListItem(source, index);
      },
    );
  }

  Widget _buildAnimatedListItem(SourcesModel source, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: SourceCard(
              source: source,
              index: index,
              isDarkMode: isDarkMode,
              isFollowing:
                  followStates['${source.id}-$index'] ??
                  source.isFollowing ??
                  false,
              onFollowChanged: (value) {
                onFollowChanged('${source.id}-$index', value);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مصادر',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: "Almarai",
            ),
          ),
        ],
      ),
    );
  }
}
