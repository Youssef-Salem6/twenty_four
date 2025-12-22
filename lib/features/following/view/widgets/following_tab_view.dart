import 'package:flutter/material.dart';
import 'package:twenty_four/features/following/model/sources_model.dart';

import 'sources_list_view.dart';

class FollowingTabView extends StatefulWidget {
  final TabController tabController;
  final Animation<double> gradientAnimation;
  final List<SourcesModel> followingSources;
  final List<SourcesModel> recommendedSources;
  final bool isDarkMode;

  const FollowingTabView({
    super.key,
    required this.tabController,
    required this.gradientAnimation,
    required this.followingSources,
    required this.recommendedSources,
    required this.isDarkMode,
  });

  @override
  State<FollowingTabView> createState() => _FollowingTabViewState();
}

class _FollowingTabViewState extends State<FollowingTabView> {
  final Map<String, bool> _followStates = {};

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        SourcesListView(
          sources: widget.followingSources,
          isDarkMode: widget.isDarkMode,
          followStates: _followStates,
          onFollowChanged: _updateFollowState,
        ),
        SourcesListView(
          sources: widget.recommendedSources,
          isDarkMode: widget.isDarkMode,
          followStates: _followStates,
          onFollowChanged: _updateFollowState,
        ),
      ],
    );
  }

  void _updateFollowState(String key, bool value) {
    setState(() {
      _followStates[key] = value;
    });
    // TODO: Call API to update follow status
  }
}