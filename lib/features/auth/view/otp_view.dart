import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:twenty_four/features/auth/manager/send_otp/send_otp_cubit.dart';
import 'package:twenty_four/features/auth/view/reset_password_view.dart';

class OtpView extends StatefulWidget {
  final String token;
  const OtpView({super.key, required this.token});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> with TickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

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
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleVerifyOtp(BuildContext context) {
    if (_pinController.text.trim().isEmpty) {
      _showSnackBar(context, 'الرجاء إدخال رمز التحقق', Colors.orange);
      return;
    }

    if (_pinController.text.trim().length < 6) {
      _showSnackBar(
        context,
        'الرجاء إدخال الرمز كاملاً (6 أرقام)',
        Colors.orange,
      );
      return;
    }

    context.read<SendOtpCubit>().sendOtp(
      code: _pinController.text.trim(),
      token: "", // enter token here
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
      create: (context) => SendOtpCubit(),
      child: BlocConsumer<SendOtpCubit, SendOtpState>(
        listener: (context, state) {
          if (state is SendOtpSuccess) {
            _showSnackBar(context, 'تم التحقق من الرمز بنجاح', Colors.green);

            // الانتقال للصفحة التالية (صفحة إعادة تعيين كلمة المرور)
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ResetPasswordView(token: state.token),
                    ),
                  );
                }
              });
            }
          } else if (state is SendOtpFailure) {
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
                                  // أيقونة الرسالة
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
                                            Icons.mark_email_read_outlined,
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
                                    'التحقق من البريد الإلكتروني',
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
                                    'أدخل رمز التحقق المكون من 6 أرقام المرسل إلى',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      fontFamily: 'Almarai',
                                    ),
                                  ),

                                  const SizedBox(height: 50),
                                  // حقل إدخال OTP
                                  _buildPinput(),
                                  const SizedBox(height: 30),

                                  // زر التحقق
                                  _buildVerifyButton(context, state),
                                  const SizedBox(height: 20),

                                  // إعادة إرسال الرمز
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'لم يصلك الرمز؟ ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontFamily: 'Almarai',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _showSnackBar(
                                            context,
                                            'تم إعادة إرسال الرمز',
                                            Colors.blue,
                                          );
                                          // TODO: Implement resend OTP logic
                                        },
                                        child: Text(
                                          'إعادة الإرسال',
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

                  // شاشة التحميل
                  if (state is SendOtpLoading)
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
                                'جاري التحقق...',
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

  Widget _buildPinput() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontFamily: 'Almarai',
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.blue.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.blue.shade400),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red.shade400, width: 2),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: _pinController,
        focusNode: _focusNode,
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        cursor: Container(width: 2, height: 24, color: Colors.blue.shade300),
        onCompleted: (pin) {
          // يمكن التحقق تلقائياً عند إكمال الإدخال
          // _handleVerifyOtp(context);
        },
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, SendOtpState state) {
    bool isLoading = state is SendOtpLoading;

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
          onTap: isLoading ? null : () => _handleVerifyOtp(context),
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
                      'تحقق من الرمز',
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
