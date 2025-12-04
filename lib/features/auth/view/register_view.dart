import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/nav_bar.dart';
import 'package:twenty_four/features/auth/manager/register/register_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

    // Gradient animation controller
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Start gradient animation once (non-repeating)
    _gradientController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gradientController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال الاسم الكامل', Colors.orange);
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال البريد الإلكتروني', Colors.orange);
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال كلمة المرور', Colors.orange);
      return;
    }
    if (_confirmPasswordController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء تأكيد كلمة المرور', Colors.orange);
      return;
    }
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showSnackBar(context, 'كلمات المرور غير متطابقة', Colors.orange);
      return;
    }

    // Call register
    context.read<RegisterCubit>().register(
      body: {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "password_confirmation": _confirmPasswordController.text.trim(),
      },
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
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // Close loading dialog if exists
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
              (route) => false,
            );

            _showSnackBar(context, state.message, Colors.green);
          } else if (state is RegisterFailure) {
            // Close loading dialog if exists
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            _showSnackBar(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Stack(
                children: [
                  // Main content
                  AnimatedBuilder(
                    animation: _gradientAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin:
                                Alignment.lerp(
                                  Alignment.topLeft,
                                  Alignment.topRight,
                                  _gradientAnimation.value,
                                )!,
                            end:
                                Alignment.lerp(
                                  Alignment.bottomRight,
                                  Alignment.bottomLeft,
                                  _gradientAnimation.value,
                                )!,
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
                                  const SizedBox(height: 20),

                                  // Logo with pulse animation
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.8, end: 1.0),
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.elasticOut,
                                    builder: (context, double scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          width: 90,
                                          height: 90,
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
                                                color: Colors.blue.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.person_add_outlined,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 30),

                                  // Welcome Text
                                  const Text(
                                    'إنشاء حساب جديد',
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
                                    'أنشئ حسابك للبدء',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Name Field
                                  _buildTextField(
                                    controller: _nameController,
                                    hintText: 'الاسم الكامل',
                                    icon: Icons.person_outline,
                                    keyboardType: TextInputType.name,
                                  ),
                                  const SizedBox(height: 16),

                                  // Email Field
                                  _buildTextField(
                                    controller: _emailController,
                                    hintText: 'البريد الإلكتروني',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Field
                                  _buildTextField(
                                    controller: _passwordController,
                                    hintText: 'كلمة المرور',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    obscureText: _obscurePassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Confirm Password Field
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    hintText: 'تأكيد كلمة المرور',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    obscureText: _obscureConfirmPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 30),

                                  // Register Button
                                  _buildRegisterButton(context, state),
                                  const SizedBox(height: 30),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'أو',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
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

                                  // Google Register Button
                                  _buildGoogleButton(),
                                  const SizedBox(height: 30),

                                  // Login Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'لديك حساب بالفعل؟ ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
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
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Loading overlay
                  if (state is RegisterLoading)
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
                                'جاري إنشاء الحساب...',
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
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
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
        obscureText: isPassword && obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'Almarai',
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade300),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: onToggleVisibility,
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

  Widget _buildRegisterButton(BuildContext context, RegisterState state) {
    bool isLoading = state is RegisterLoading;

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
          onTap: isLoading ? null : () => _handleRegister(context),
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
                      'إنشاء حساب',
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
            // Add Google registration logic here
            _showSnackBar(context, 'التسجيل بجوجل قريباً', Colors.blue);
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
                'التسجيل باستخدام جوجل',
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
