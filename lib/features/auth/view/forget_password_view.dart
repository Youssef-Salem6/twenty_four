import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/features/auth/manager/forget_password/forget_pssword_cubit.dart';
import 'package:twenty_four/features/auth/view/otp_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

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
    _animationController.dispose();
    _gradientController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgetPassword(BuildContext context) {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال البريد الإلكتروني', Colors.orange);
      return;
    }

    // التحقق من صيغة البريد الإلكتروني
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      _showSnackBar(context, 'الرجاء إدخال بريد إلكتروني صحيح', Colors.orange);
      return;
    }

    context.read<ForgetPsswordCubit>().forgetPssword(
      email: _emailController.text.trim(),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Almarai')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPsswordCubit(),
      child: BlocConsumer<ForgetPsswordCubit, ForgetPsswordState>(
        listener: (context, state) {
          if (state is ForgetPsswordSuccess) {
            _showSnackBar(
              context,
              'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
              Colors.green,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OtpView(token: state.token);
                },
              ),
            );
            // العودة إلى صفحة تسجيل الدخول بعد ثانيتين
            if (mounted) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
          } else if (state is ForgetPsswordFailure) {
            _showSnackBar(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _gradientAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(
                                const Color(0xff2b2f3a),
                                const Color(0xff1a4d7a),
                                _gradientAnimation.value,
                              )!,
                              Color.lerp(
                                const Color(0xFF151924),
                                const Color(0xff0d1b2a),
                                _gradientAnimation.value,
                              )!,
                            ],
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: SafeArea(
                      child: Column(
                        children: [
                          // زر الرجوع في الأعلى
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),

                          // باقي المحتوى
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // أيقونة القفل
                                        TweenAnimationBuilder(
                                          tween: Tween<double>(
                                            begin: 0.8,
                                            end: 1.0,
                                          ),
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          curve: Curves.elasticOut,
                                          builder: (
                                            context,
                                            double scale,
                                            child,
                                          ) {
                                            return Transform.scale(
                                              scale: scale,
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue.shade400,
                                                      Colors.blue.shade700,
                                                    ],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.blue
                                                          .withOpacity(0.3),
                                                      blurRadius: 20,
                                                      spreadRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.lock_reset,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 40),

                                        // العنوان
                                        const Text(
                                          'نسيت كلمة المرور؟',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Almarai',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'لا تقلق! أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontFamily: 'Almarai',
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 50),

                                        // حقل البريد الإلكتروني
                                        _buildTextField(
                                          controller: _emailController,
                                          hintText: 'البريد الإلكتروني',
                                          icon: Icons.email_outlined,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: 30),

                                        // زر الإرسال
                                        _buildSubmitButton(context, state),
                                        const SizedBox(height: 30),

                                        // رابط العودة لتسجيل الدخول
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'تذكرت كلمة المرور؟ ',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontFamily: 'Almarai',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(
                                                  color: Colors.blue.shade300,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Almarai',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // شاشة التحميل
                  if (state is ForgetPsswordLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xff2b2f3a),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.blue.shade400,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'جاري الإرسال...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Almarai',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'Almarai',
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade300),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ForgetPsswordState state) {
    bool isLoading = state is ForgetPsswordLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isLoading
                  ? [Colors.grey.shade400, Colors.grey.shade600]
                  : [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isLoading ? Colors.grey : Colors.blue).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => _handleForgetPassword(context),
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    : const Text(
                      'إرسال رابط إعادة التعيين',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Almarai',
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
