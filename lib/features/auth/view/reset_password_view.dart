import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/features/auth/manager/reset_password/reset_password_cubit.dart';
import 'package:twenty_four/features/auth/view/login_view.dart';

class ResetPasswordView extends StatefulWidget {
  final String token;
  const ResetPasswordView({super.key, required this.token});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView>
    with TickerProviderStateMixin {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
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
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // التحقق من الحقول الفارغة
    if (newPassword.isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال كلمة المرور الجديدة', Colors.orange);
      return;
    }

    if (confirmPassword.isEmpty) {
      _showSnackBar(context, 'الرجاء تأكيد كلمة المرور', Colors.orange);
      return;
    }

    // التحقق من طول كلمة المرور
    if (newPassword.length < 8) {
      _showSnackBar(
        context,
        'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
        Colors.orange,
      );
      return;
    }

    // التحقق من تطابق كلمات المرور
    if (newPassword != confirmPassword) {
      _showSnackBar(context, 'كلمات المرور غير متطابقة', Colors.red);
      return;
    }

    context.read<ResetPasswordCubit>().resetPassword(
      token: widget.token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
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
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            _showSnackBar(context, 'تم تغيير كلمة المرور بنجاح', Colors.green);

            // العودة لصفحة تسجيل الدخول
            if (mounted) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                }
              });
            }
          } else if (state is ResetPasswordFailure) {
            _showSnackBar(context, state.errorMessage, Colors.red);
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
                                  // أيقونة القفل
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
                                                color: Colors.blue.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.vpn_key,
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
                                    'إعادة تعيين كلمة المرور',
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
                                    'أدخل كلمة المرور الجديدة الخاصة بك',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                  const SizedBox(height: 50),

                                  // كلمة المرور الجديدة
                                  _buildTextField(
                                    controller: _newPasswordController,
                                    hintText: 'كلمة المرور الجديدة',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    obscurePassword: _obscureNewPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscureNewPassword =
                                            !_obscureNewPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // تأكيد كلمة المرور
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    hintText: 'تأكيد كلمة المرور',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    obscurePassword: _obscureConfirmPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // متطلبات كلمة المرور
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'متطلبات كلمة المرور:',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Almarai',
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildRequirement(
                                          '• 8 أحرف على الأقل',
                                          _newPasswordController.text.length >=
                                              8,
                                        ),
                                        _buildRequirement(
                                          '• يجب أن تتطابق كلمات المرور',
                                          _newPasswordController
                                                  .text
                                                  .isNotEmpty &&
                                              _newPasswordController.text ==
                                                  _confirmPasswordController
                                                      .text,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // زر تغيير كلمة المرور
                                  _buildResetButton(context, state),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // شاشة التحميل
                  if (state is ResetPasswordLoading)
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
                                'جاري تغيير كلمة المرور...',
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

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color:
                isMet ? Colors.green.shade400 : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color:
                  isMet ? Colors.green.shade400 : Colors.white.withOpacity(0.6),
              fontFamily: 'Almarai',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscurePassword = true,
    VoidCallback? onToggleVisibility,
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
        obscureText: isPassword && obscurePassword,
        onChanged: (value) => setState(() {}), // لتحديث المؤشرات
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
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
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

  Widget _buildResetButton(BuildContext context, ResetPasswordState state) {
    bool isLoading = state is ResetPasswordLoading;

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
          onTap: isLoading ? null : () => _handleResetPassword(context),
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
                      'تغيير كلمة المرور',
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
