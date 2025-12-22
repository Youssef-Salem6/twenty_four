import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/auth/view/login_view.dart';
import 'package:twenty_four/features/following/manager/getSources/get_sources_cubit.dart';
import 'package:twenty_four/features/following/manager/toggleFollow/toggle_follow_cubit.dart';
import 'package:twenty_four/features/following/model/sources_model.dart';
import 'package:twenty_four/main.dart';

class FollowingView extends StatefulWidget {
  const FollowingView({super.key});

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  // Track which source is being toggled to show loading on specific button
  int? _togglingSourceId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _gradientController.forward();

    // Check and fetch sources
    _checkAndFetchSources();
  }

  // Function to check login and fetch sources
  void _checkAndFetchSources() {
    final token = prefs.getString("token");
    if (token != null && token.isNotEmpty) {
      // Add a small delay to ensure cubit is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          BlocProvider.of<GetSourcesCubit>(context).getSources();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-check when returning to this screen
    _checkAndFetchSources();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  // Widget to show when user is not logged in
  Widget _buildLoginPrompt(bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade400.withOpacity(0.3),
                          Colors.red.shade700.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Column(
                    children: [
                      Text(
                        'تسجيل الدخول مطلوب',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.getTextColor(isDarkMode),
                          fontFamily: "Almarai",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'للوصول إلى المصادر المتابعة والتوصيات\nيرجى تسجيل الدخول إلى حسابك',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                          fontFamily: "Almarai",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to login and wait for result
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );

                      // After returning, refresh the state
                      if (mounted) {
                        setState(() {
                          _checkAndFetchSources();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.red.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.login, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Almarai",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final isDarkMode = prefs.getBool("isDarkMode") ?? false;
    final token = prefs.getString("token");
    final isLoggedIn = token != null && token.isNotEmpty;

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
        bottom:
            isLoggedIn
                ? PreferredSize(
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
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
                                colors: const [
                                  Color(0xff2b2f3a),
                                  Color(0xFF151924),
                                ],
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
                )
                : null,
      ),
      body:
          !isLoggedIn
              ? _buildLoginPrompt(isDarkMode)
              : MultiBlocListener(
                listeners: [
                  BlocListener<ToggleFollowCubit, ToggleFollowState>(
                    listener: (context, state) {
                      if (state is ToggleFollowSuccess) {
                        // Refetch sources after successful toggle
                        context.read<GetSourcesCubit>().getSources();

                        // Reset toggling state
                        setState(() {
                          _togglingSourceId = null;
                        });

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'تم تحديث المتابعة بنجاح',
                              style: TextStyle(fontFamily: "Almarai"),
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else if (state is ToggleFollowFailure) {
                        // Reset toggling state
                        setState(() {
                          _togglingSourceId = null;
                        });

                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'فشل تحديث المتابعة، حاول مرة أخرى',
                              style: TextStyle(fontFamily: "Almarai"),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<GetSourcesCubit, GetSourcesState>(
                  builder: (context, state) {
                    if (state is GetSourcesLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      );
                    } else if (state is GetSourcesFailure) {
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
                    } else if (state is GetSourcesSuccess) {
                      // Parse sources into SourcesModel
                      final sources =
                          state.sources
                              .map((json) => SourcesModel.fromJson(json))
                              .toList();

                      // Separate following and recommendations
                      final followingSources =
                          sources.where((s) => s.isFollowing == true).toList();
                      final recommendedSources =
                          sources.where((s) => s.isFollowing == false).toList();

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildSourcesList(followingSources, isDarkMode),
                          _buildSourcesList(recommendedSources, isDarkMode),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
    );
  }

  Widget _buildSourcesList(List<SourcesModel> sources, bool isDarkMode) {
    if (sources.isEmpty) {
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

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetSourcesCubit>().getSources();
      },
      color: Colors.blue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sources.length,
        itemBuilder: (context, index) {
          final source = sources[index];
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
                    source: source,
                    isDarkMode: isDarkMode,
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSourceCard({
    required SourcesModel source,
    required bool isDarkMode,
    required int index,
  }) {
    final isFollowing = source.isFollowing ?? false;
    final isToggling = _togglingSourceId == source.id;

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
          TweenAnimationBuilder<double>(
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
          ),
          const SizedBox(width: 16),
          Expanded(
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
          ),
          const SizedBox(width: 12),
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
                    onPressed:
                        isToggling
                            ? null
                            : () {
                              if (source.id != null) {
                                setState(() {
                                  _togglingSourceId = source.id;
                                });
                                context
                                    .read<ToggleFollowCubit>()
                                    .toggleFollowSource(sourceId: source.id!);
                              }
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
                      disabledBackgroundColor:
                          isFollowing
                              ? (isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200)
                              : Colors.blue.shade300,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isToggling)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isFollowing
                                    ? AppThemes.getTextColor(isDarkMode)
                                    : Colors.white,
                              ),
                            ),
                          )
                        else
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
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
          ),
        ],
      ),
    );
  }
}
