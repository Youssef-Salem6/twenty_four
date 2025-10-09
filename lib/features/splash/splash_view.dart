import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:twenty_four/features/auth/view/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bgController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Background animation controller
    _bgController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Fade and scale animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                    ),
                  ),
                  child: CustomPaint(
                    painter: AnimatedCirclesPainter(_bgController.value),
                    size: Size.infinite,
                  ),
                );
              },
            ),

            // Content
            Center(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Your logo
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // App name in Arabic
                          const Text(
                            'The 24',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أهلاً بك',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCirclesPainter extends CustomPainter {
  final double animationValue;

  AnimatedCirclesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Circle 1
    paint.color = const Color(0xff3d4452).withOpacity(0.3);
    final offset1 = Offset(
      size.width * 0.2 + math.sin(animationValue * 2 * math.pi) * 50,
      size.height * 0.3 + math.cos(animationValue * 2 * math.pi) * 50,
    );
    canvas.drawCircle(offset1, 150, paint);

    // Circle 2
    paint.color = const Color(0xff1e222d).withOpacity(0.4);
    final offset2 = Offset(
      size.width * 0.8 + math.cos(animationValue * 2 * math.pi + 1) * 40,
      size.height * 0.2 + math.sin(animationValue * 2 * math.pi + 1) * 60,
    );
    canvas.drawCircle(offset2, 120, paint);

    // Circle 3
    paint.color = const Color(0xff404654).withOpacity(0.25);
    final offset3 = Offset(
      size.width * 0.7 + math.sin(animationValue * 2 * math.pi + 2) * 30,
      size.height * 0.7 + math.cos(animationValue * 2 * math.pi + 2) * 40,
    );
    canvas.drawCircle(offset3, 100, paint);

    // Circle 4
    paint.color = const Color(0xff252935).withOpacity(0.35);
    final offset4 = Offset(
      size.width * 0.15 + math.cos(animationValue * 2 * math.pi + 3) * 45,
      size.height * 0.75 + math.sin(animationValue * 2 * math.pi + 3) * 35,
    );
    canvas.drawCircle(offset4, 130, paint);
  }

  @override
  bool shouldRepaint(AnimatedCirclesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
