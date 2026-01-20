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
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  PageController pageController = PageController();
  int currentPage = 0;
  int nextPage = 1;
  int selectedCategoryIndex = 0;
  bool _isFlippingUp = true; // Track flip direction

  final List<String> categories = [
    'سياسة',
    'رياضة',
    'فن',
    'حروب',
    'علم',
    'عالمية',
  ];

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;

  final GlobalKey _currentPageKey = GlobalKey();
  final GlobalKey _nextPageKey = GlobalKey();
  ui.Image? _currentPageImage;
  ui.Image? _nextPageImage;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeNewsCubit>(context).getHomeNews();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
    ]).animate(_flipController);
  }

  void _checkAndLoadMore(int currentIndex) {
    final cubit = BlocProvider.of<HomeNewsCubit>(context);
    final totalScreens = cubit.screens.length;

    if (currentIndex >= totalScreens - 3 &&
        cubit.hasMoreData &&
        !cubit.isLoadingMore) {
      print("Loading more news - Current: $currentIndex, Total: $totalScreens");
      cubit.loadMoreNews();
    }
  }

  Future<ui.Image?> _captureWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      return image;
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  Future<void> _prepareFlipAnimation(int direction) async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
      nextPage = currentPage + direction;
      _isFlippingUp = direction > 0; // true for next page, false for previous
    });

    await Future.delayed(const Duration(milliseconds: 50));

    _currentPageImage = await _captureWidget(_currentPageKey);
    _nextPageImage = await _captureWidget(_nextPageKey);

    setState(() {
      _isCapturing = false;
    });

    if (_currentPageImage != null && _nextPageImage != null) {
      _flipController.forward(from: 0).then((_) {
        setState(() {
          currentPage = nextPage;
          _currentPageImage = null;
          _nextPageImage = null;
        });
        _flipController.reset();
        _checkAndLoadMore(currentPage);
      });
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    _flipController.dispose();
    _currentPageImage?.dispose();
    _nextPageImage?.dispose();
    super.dispose();
  }

  Widget _buildPage(
    int type, {
    required List data,
    required int id,
    required String title,
    required String description,
  }) {
    if (type == 1) {
      return MainType(data: data);
    } else if (type == 2) {
      return ThreeNewsCard(data: data);
    } else if (type == 4) {
      return FullNews(data: data[0]);
    } else if (type == 3) {
      return HorizontalScroll(
        news: data,
        description: description,
        title: title,
        id: id,
      );
    } else {
      return MainType(data: data);
    }
  }

  Widget _buildFlipPage() {
    final cubit = BlocProvider.of<HomeNewsCubit>(context);
    List data = cubit.screens;

    if (data.isEmpty || currentPage >= data.length) {
      return const SizedBox.shrink();
    }

    final screenHeight = MediaQuery.of(context).size.height;

    if (_currentPageImage != null && _nextPageImage != null) {
      return AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          final rotationValue = _flipAnimation.value * math.pi;
          final isUnder = (rotationValue > math.pi / 2);
          final scale = _scaleAnimation.value;

          if (_isFlippingUp) {
            // Original animation: flips from bottom to top (swipe up)
            return Transform.scale(
              scale: scale,
              child: Stack(
                children: [
                  // Next page bottom half - Always visible underneath
                  Positioned(
                    top: screenHeight * 0.5,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: CustomPaint(
                      painter: _ImagePainter(
                        image: _nextPageImage!,
                        cropTop: false,
                      ),
                    ),
                  ),

                  // Top Half - Static (switches when flip is halfway)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: ClipRect(
                      child: CustomPaint(
                        painter: _ImagePainter(
                          image: isUnder ? _nextPageImage! : _currentPageImage!,
                          cropTop: true,
                        ),
                      ),
                    ),
                  ),

                  // Bottom Half - Flipping part
                  Positioned(
                    top: screenHeight * 0.5,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: Transform(
                      alignment: Alignment.topCenter,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(-rotationValue),
                      child: ClipRect(
                        child:
                            rotationValue <= math.pi / 2
                                ? CustomPaint(
                                  painter: _ImagePainter(
                                    image: _currentPageImage!,
                                    cropTop: false,
                                  ),
                                )
                                : Transform(
                                  alignment: Alignment.center,
                                  transform:
                                      Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateX(math.pi),
                                  child: CustomPaint(
                                    painter: _ImagePainter(
                                      image: _nextPageImage!,
                                      cropTop: true,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),

                  // Center divider line
                  Positioned(
                    top: screenHeight * 0.5 - 1,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Reversed animation: flips from top to bottom (swipe down)
            return Transform.scale(
              scale: scale,
              child: Stack(
                children: [
                  // Next page top half - Always visible underneath
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: CustomPaint(
                      painter: _ImagePainter(
                        image: _nextPageImage!,
                        cropTop: true,
                      ),
                    ),
                  ),

                  // Bottom Half - Static (switches when flip is halfway)
                  Positioned(
                    top: screenHeight * 0.5,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: ClipRect(
                      child: CustomPaint(
                        painter: _ImagePainter(
                          image: isUnder ? _nextPageImage! : _currentPageImage!,
                          cropTop: false,
                        ),
                      ),
                    ),
                  ),

                  // Top Half - Flipping part
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.5,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(rotationValue),
                      child: ClipRect(
                        child:
                            rotationValue <= math.pi / 2
                                ? CustomPaint(
                                  painter: _ImagePainter(
                                    image: _currentPageImage!,
                                    cropTop: true,
                                  ),
                                )
                                : Transform(
                                  alignment: Alignment.center,
                                  transform:
                                      Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateX(math.pi),
                                  child: CustomPaint(
                                    painter: _ImagePainter(
                                      image: _nextPageImage!,
                                      cropTop: false,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),

                  // Center divider line
                  Positioned(
                    top: screenHeight * 0.5 - 1,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    }

    // Show pages off-screen for capturing
    return Stack(
      children: [
        // Visible current page
        RepaintBoundary(
          key: _currentPageKey,
          child: _buildPage(
            data[currentPage]["screen_type"],
            id: data[currentPage]["id"] ?? 0,
            title: data[currentPage]["title"] ?? "title" ?? "title",
            description: data[currentPage]["description"] ?? "description",
            data: data[currentPage]["news"],
          ),
        ),
        // Hidden next page for capture
        if (nextPage >= 0 && nextPage < data.length)
          Positioned(
            left: -10000,
            child: RepaintBoundary(
              key: _nextPageKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildPage(
                  data[nextPage]["screen_type"],
                  id: data[currentPage]["id"] ?? 0,
                  title: data[currentPage]["title"] ?? "title",
                  description:
                      data[currentPage]["description"] ?? "description",
                  data: data[nextPage]["news"],
                ),
              ),
            ),
          ),
      ],
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
            onTap: () async {
              if (_flipController.isAnimating || _isCapturing) return;
              if (currentPage > 0) {
                await _prepareFlipAnimation(-currentPage);
              }
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
            prefs.getBool("isDarkMode") ?? false,
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
                  : GestureDetector(
                    onVerticalDragEnd: (details) async {
                      final cubit = BlocProvider.of<HomeNewsCubit>(context);
                      if (_flipController.isAnimating || _isCapturing) return;

                      if (details.primaryVelocity! < -500) {
                        // Swipe up - next page
                        if (currentPage < cubit.screens.length - 1) {
                          await _prepareFlipAnimation(1);
                        }
                      } else if (details.primaryVelocity! > 500) {
                        // Swipe down - previous page
                        if (currentPage > 0) {
                          await _prepareFlipAnimation(-1);
                        }
                      }
                    },
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.transparent,
                      child: _buildFlipPage(),
                    ),
                  ),
        );
      },
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final bool cropTop;

  _ImagePainter({required this.image, required this.cropTop});

  @override
  void paint(Canvas canvas, Size size) {
    final imageHeight = image.height.toDouble();
    final imageWidth = image.width.toDouble();

    final scaleX = size.width / imageWidth;
    final scaleY = (size.height * 2) / imageHeight;
    final scale = math.max(scaleX, scaleY);

    final scaledWidth = imageWidth * scale;
    final scaledHeight = imageHeight * scale;

    final offsetX = (size.width - scaledWidth) / 2;
    final offsetY = 0.0;

    final srcRect =
        cropTop
            ? Rect.fromLTWH(0, 0, imageWidth, imageHeight / 2)
            : Rect.fromLTWH(0, imageHeight / 2, imageWidth, imageHeight / 2);

    final dstRect = Rect.fromLTWH(
      offsetX,
      offsetY,
      scaledWidth,
      scaledHeight / 2,
    );

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ImagePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.cropTop != cropTop;
  }
}
