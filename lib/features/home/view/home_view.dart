import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/home/manager/get_home_news/home_news_cubit.dart';
import 'package:twenty_four/features/home/view/widgets/types/full_news.dart';
import 'package:twenty_four/features/home/view/widgets/types/horizontal_scroll.dart';
import 'package:twenty_four/features/home/view/widgets/types/main_type.dart';
import 'package:twenty_four/features/home/view/widgets/types/three_news_card.dart';
import 'package:twenty_four/main.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  PageController pageController = PageController();
  int currentPage = 0;
  double pageOffset = 0.0;
  int selectedCategoryIndex = 0;

  // Categories list
  final List<String> categories = [
    'سياسة',
    'رياضة',
    'فن',
    'حروب',
    'علم',
    'عالمية',
  ];

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeNewsCubit>(context).getHomeNews();
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Add page controller listener
    pageController.addListener(() {
      if (pageController.page != null) {
        setState(() {
          pageOffset = pageController.page!;
        });
      }
    });

    // Start initial animations
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
  }

  void _resetAndStartAnimations() {
    _fadeController.reset();
    _scaleController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildPage(int type, {required List data}) {
    if (type == 1) {
      return MainType(data: data);
    } else if (type == 2) {
      return ThreeNewsCard(data: data);
    } else if (type == 4) {
      return FullNews(data: data[0]);
    } else if (type == 3) {
      return HorizontalScroll(news: data);
    } else {
      return MainType(data: data);
    }
  }

  Widget _buildAnimatedPage(int index) {
    // Calculate the page's position relative to current page
    double pagePosition = (index - pageOffset).clamp(-1.0, 1.0);

    // Calculate transform values safely
    double scale = (1 - (pagePosition.abs() * 0.1)).clamp(0.8, 1.0);
    double opacity = (1 - pagePosition.abs()).clamp(0.0, 1.0);
    double horizontalMargin = (pagePosition.abs() * 15).clamp(0.0, 30.0);
    double verticalMargin = (pagePosition.abs() * 8).clamp(0.0, 15.0);

    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
      builder: (context, child) {
        List data = BlocProvider.of<HomeNewsCubit>(context).screens;
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: Opacity(
              opacity: opacity,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildPage(
                    data[index]["screen_type"],
                    data: data[index]["news"],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                border:
                    isSelected
                        ? Border(
                          bottom: BorderSide(color: Colors.red, width: 3),
                        )
                        : null,
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.red, width: 3)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'للأخبار',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              HapticFeedback.mediumImpact();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(Icons.close, color: Colors.red, size: 25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.red, strokeWidth: 3),
          const SizedBox(height: 20),
          Text(
            'جاري تحميل الأخبار...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
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
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد أخبار متاحة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'يرجى المحاولة مرة أخرى لاحقاً',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<HomeNewsCubit>(context).getHomeNews();
            },
            icon: Icon(Icons.refresh),
            label: Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'حدث خطأ أثناء تحميل الأخبار',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'يرجى التحقق من الاتصال بالإنترنت',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<HomeNewsCubit>(context).getHomeNews();
            },
            icon: Icon(Icons.refresh),
            label: Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return BlocBuilder<HomeNewsCubit, HomeNewsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppThemes.getScaffoldColor(
            prefs.getBool("isDarkMode")!,
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(66),
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child:
                        currentPage == 0
                            ? Container(
                              key: ValueKey('categories'),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  // Logo section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 8,
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 80,
                                      height: 30,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // Categories list
                                  Expanded(child: _buildCategoriesList()),
                                ],
                              ),
                            )
                            : Container(
                              key: ValueKey('back'),
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: _buildBackHeader(),
                            ),
                  ),
                ),
              ),
            ),
          ),
          body:
              state is HomeNewsLoading
                  ? _buildLoadingState()
                  : state is HomeNewsFailure
                  ? _buildErrorState()
                  : state is HomeNewssuccess &&
                      BlocProvider.of<HomeNewsCubit>(context).screens.isEmpty
                  ? _buildEmptyState()
                  : PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                      _resetAndStartAnimations();
                      HapticFeedback.mediumImpact();
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: size.width,
                        height: size.height,
                        child: _buildAnimatedPage(index),
                      );
                    },
                    itemCount:
                        BlocProvider.of<HomeNewsCubit>(context).screens.length,
                  ),
        );
      },
    );
  }
}
