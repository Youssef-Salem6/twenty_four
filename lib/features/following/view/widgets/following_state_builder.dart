import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/following/manager/getSources/get_sources_cubit.dart';
import 'package:twenty_four/features/following/model/sources_model.dart';

import 'following_tab_view.dart';

class FollowingStateBuilder extends StatelessWidget {
  final TabController tabController;
  final Animation<double> gradientAnimation;
  final bool isDarkMode;

  const FollowingStateBuilder({
    super.key,
    required this.tabController,
    required this.gradientAnimation,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSourcesCubit, GetSourcesState>(
      builder: (context, state) {
        if (state is GetSourcesLoading) {
          return _buildLoadingState();
        } else if (state is GetSourcesFailure) {
          return _buildErrorState(context);
        } else if (state is GetSourcesSuccess) {
          final sources = state.sources
              .map((json) => SourcesModel.fromJson(json))
              .toList();

          final followingSources =
              sources.where((s) => s.isFollowing == true).toList();
          final recommendedSources =
              sources.where((s) => s.isFollowing == false).toList();

          return FollowingTabView(
            tabController: tabController,
            gradientAnimation: gradientAnimation,
            followingSources: followingSources,
            recommendedSources: recommendedSources,
            isDarkMode: isDarkMode,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'فشل تحميل المصادر',
            style: TextStyle(
              fontSize: 18,
              color: AppThemes.getTextColor(isDarkMode),
              fontFamily: "Almarai",
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<GetSourcesCubit>().getSources();
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              'إعادة المحاولة',
              style: TextStyle(fontFamily: "Almarai"),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}