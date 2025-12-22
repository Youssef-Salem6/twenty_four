import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/nav_bar.dart';
import 'package:twenty_four/features/auth/manager/login/login_cubit.dart';
import 'package:twenty_four/features/auth/view/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال البريد الإلكتروني', Colors.orange);
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال كلمة المرور', Colors.orange);
      return;
    }

    context.read<LoginCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
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
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _showSnackBar(context, state.message, Colors.green);

            // FIX: Check if widget is still mounted before navigating
            if (mounted) {
              // Use WidgetsBinding to ensure navigation happens after frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const NavBar()),
                    (route) => false,
                  );
                }
              });
            }
          } else if (state is LoginFailure) {
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
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.8, end: 1.0),
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.elasticOut,
                                    builder: (context, double scale, child) {
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
                                                color: Colors.blue.withOpacity(0.3),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.lock_outline,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  const Text(
                                    'مرحباً بعودتك',
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
                                    'سجل الدخول للمتابعة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  _buildTextField(
                                    controller: _emailController,
                                    hintText: 'البريد الإلكتروني',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _passwordController,
                                    hintText: 'كلمة المرور',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        _showSnackBar(
                                          context,
                                          'ميزة استعادة كلمة المرور قريباً',
                                          Colors.blue,
                                        );
                                      },
                                      child: Text(
                                        'نسيت كلمة المرور؟',
                                        style: TextStyle(
                                          color: Colors.blue.shade300,
                                          fontFamily: 'Almarai',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  _buildLoginButton(context, state),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'أو',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.6),
                                            fontFamily: 'Almarai',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  _buildGoogleButton(),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ليس لديك حساب؟ ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontFamily: 'Almarai',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const RegisterView(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'إنشاء حساب',
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
                  ),
                  if (state is LoginLoading)
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
                                'جاري تسجيل الدخول...',
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
    bool isPassword = false,
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
        obscureText: isPassword && _obscurePassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'Almarai',
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade300),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
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

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    bool isLoading = state is LoginLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
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
          onTap: isLoading ? null : () => _handleLogin(context),
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'تسجيل الدخول',
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

  Widget _buildGoogleButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showSnackBar(context, 'تسجيل الدخول بجوجل قريباً', Colors.blue);
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.google.com/favicon.ico',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.g_mobiledata, size: 24);
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'متابعة باستخدام جوجل',
                style: TextStyle(
                  color: Color(0xff2b2f3a),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Almarai',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}