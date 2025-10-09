import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/main.dart';

class FollowingView extends StatefulWidget {
  const FollowingView({super.key});

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  final Map<String, bool> _followStates = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Gradient animation for header
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _gradientController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = prefs.getBool("isDarkMode") ?? false;

    return Scaffold(
      backgroundColor: AppThemes.getScaffoldColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:
                      Alignment.lerp(
                        Alignment.centerLeft,
                        Alignment.topLeft,
                        _gradientAnimation.value,
                      )!,
                  end:
                      Alignment.lerp(
                        Alignment.centerRight,
                        Alignment.bottomRight,
                        _gradientAnimation.value,
                      )!,
                  colors: const [Color(0xff2b2f3a), Color(0xFF151924)],
                ),
              ),
            );
          },
        ),
        title: const Text(
          'المتابَع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            fontFamily: "Almarai",
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(115),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.95 + (0.05 * value),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ابحث في المتابَع',
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _gradientAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin:
                            Alignment.lerp(
                              Alignment.centerLeft,
                              Alignment.topLeft,
                              _gradientAnimation.value,
                            )!,
                        end:
                            Alignment.lerp(
                              Alignment.centerRight,
                              Alignment.bottomRight,
                              _gradientAnimation.value,
                            )!,
                        colors: const [Color(0xff2b2f3a), Color(0xFF151924)],
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.red,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Almarai",
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Almarai",
                      ),
                      tabs: const [
                        Tab(text: 'المتابَعون'),
                        Tab(text: 'الموصى بها'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowingList(isDarkMode),
          _buildRecommendationList(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildFollowingList(bool isDarkMode) {
    final followingList = [
      {
        'name': 'الجزيرة',
        'logo': 'https://images.unsplash.com/photo-1679678691006-0ad24fecb769',
        'isFollowing': true,
      },
      {
        'name': 'العربية',
        'logo': 'https://images.unsplash.com/photo-1679678691250-a14e09c004c7',
        'isFollowing': true,
      },
      {
        'name': 'سكاي نيوز',
        'logo': 'https://images.unsplash.com/photo-1679678691170-7781f11f9d86',
        'isFollowing': true,
      },
      {
        'name': 'بي بي سي عربي',
        'logo': 'https://images.unsplash.com/photo-1679678691328-54929d271c3c',
        'isFollowing': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: followingList.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildSourceCard(
                  name: followingList[index]['name'] as String,
                  logoUrl: followingList[index]['logo'] as String,
                  isFollowing: followingList[index]['isFollowing'] as bool,
                  isDarkMode: isDarkMode,
                  index: index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommendationList(bool isDarkMode) {
    final recommendationList = [
      {
        'name': 'CNN عربية',
        'logo': 'https://images.unsplash.com/photo-1664575602554-2087b04935a5',
        'isFollowing': false,
      },
      {
        'name': 'رويترز',
        'logo': 'https://images.unsplash.com/photo-1679678691006-0ad24fecb769',
        'isFollowing': false,
      },
      {
        'name': 'فرانس 24',
        'logo': 'https://images.unsplash.com/photo-1679678691250-a14e09c004c7',
        'isFollowing': false,
      },
      {
        'name': 'الشرق الأوسط',
        'logo': 'https://images.unsplash.com/photo-1679678691170-7781f11f9d86',
        'isFollowing': false,
      },
      {
        'name': 'الاهرام',
        'logo': 'https://images.unsplash.com/photo-1679678691328-54929d271c3c',
        'isFollowing': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendationList.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildSourceCard(
                  name: recommendationList[index]['name'] as String,
                  logoUrl: recommendationList[index]['logo'] as String,
                  isFollowing: recommendationList[index]['isFollowing'] as bool,
                  isDarkMode: isDarkMode,
                  index: index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSourceCard({
    required String name,
    required String logoUrl,
    required bool isFollowing,
    required bool isDarkMode,
    required int index,
  }) {
    final key = '$name-$index';
    final currentState = _followStates[key] ?? isFollowing;

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
          // Animated logo
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Hero(
                  tag: 'logo-$name-$index',
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
                        imageUrl: logoUrl,
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
          ),
          const SizedBox(width: 16),
          // Name with fade in
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    name,
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
          ),
          const SizedBox(width: 12),
          // Animated follow button
          TweenAnimationBuilder<double>(
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
                      setState(() {
                        _followStates[key] = !currentState;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentState
                              ? (isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200)
                              : Colors.blue,
                      foregroundColor:
                          currentState
                              ? AppThemes.getTextColor(isDarkMode)
                              : Colors.white,
                      elevation: currentState ? 0 : 4,
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
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            currentState ? Icons.check : Icons.add,
                            key: ValueKey(currentState),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          currentState ? 'متابَع' : 'متابعة',
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
          ),
        ],
      ),
    );
  }
}
