import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FollowingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<double> gradientAnimation;

  const FollowingAppBar({super.key, required this.gradientAnimation});

  @override
  Size get preferredSize => const Size.fromHeight(115);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: _buildGradientBackground(),
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
        child: Column(children: [_buildSearchField(), _buildTabBar()]),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return AnimatedBuilder(
      animation: gradientAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:
                  Alignment.lerp(
                    Alignment.centerLeft,
                    Alignment.topLeft,
                    gradientAnimation.value,
                  )!,
              end:
                  Alignment.lerp(
                    Alignment.centerRight,
                    Alignment.bottomRight,
                    gradientAnimation.value,
                  )!,
              colors: const [Color(0xff2b2f3a), Color(0xFF151924)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return AnimatedBuilder(
      animation: gradientAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:
                  Alignment.lerp(
                    Alignment.centerLeft,
                    Alignment.topLeft,
                    gradientAnimation.value,
                  )!,
              end:
                  Alignment.lerp(
                    Alignment.centerRight,
                    Alignment.bottomRight,
                    gradientAnimation.value,
                  )!,
              colors: const [Color(0xff2b2f3a), Color(0xFF151924)],
            ),
          ),
          child: TabBar(
            controller: TabController(length: 2, vsync: Scaffold.of(context)),
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
            tabs: const [Tab(text: 'المتابَعون'), Tab(text: 'الموصى بها')],
          ),
        );
      },
    );
  }
}
