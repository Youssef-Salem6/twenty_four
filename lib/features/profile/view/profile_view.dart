import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/themes/manager/themesCubit/themes_cubit.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/auth/manager/logout/log_out_cubit.dart';
import 'package:twenty_four/features/auth/view/login_view.dart';
import 'package:twenty_four/main.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesCubit, ThemesState>(
      builder: (context, state) {
        // Check if user is logged in
        final bool isLoggedIn = userPref.getString("token") != null;

        return Scaffold(
          backgroundColor: AppThemes.getScaffoldColor(
            prefs.getBool("isDarkMode") ?? false,
          ),
          body: CustomScrollView(
            slivers: [
              // Gradient App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                automaticallyImplyLeading: false,
                expandedHeight: 50,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Almarai",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Gradient Background
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    // Profile Content
                    Column(
                      children: [
                        const SizedBox(height: 40),

                        // Conditional rendering based on login status
                        if (isLoggedIn) ...[
                          // Profile Image (only when logged in)
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1160&q=80',
                              ),
                              radius: 60,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Name
                          Text(
                            userPref.getString("firstName")!,
                            style: TextStyle(
                              color: AppThemes.getTextColor(state.isDarkMode),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Username
                          Text(
                            userPref.getString("email")!,
                            style: TextStyle(
                              color: AppThemes.getTextColor(
                                state.isDarkMode,
                              ).withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ] else ...[
                          // Guest icon when not logged in
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppThemes.getCardColor(state.isDarkMode),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 60,
                              color: AppThemes.getIconColor(state.isDarkMode),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Guest text
                          Text(
                            'زائر',
                            style: TextStyle(
                              color: AppThemes.getTextColor(state.isDarkMode),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Sign up message
                          Text(
                            'قم بإنشاء حساب للاستمتاع بجميع المميزات',
                            style: TextStyle(
                              color: AppThemes.getTextColor(
                                state.isDarkMode,
                              ).withOpacity(0.6),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Sign up button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 40,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.person_add, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Profile Options
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Show these options only when logged in
                              if (isLoggedIn) ...[
                                _buildProfileOption(
                                  context,
                                  Icons.bookmark,
                                  'الأخبار المحفوظة',
                                  state.isDarkMode,
                                ),
                                _buildProfileOption(
                                  context,
                                  Icons.notifications,
                                  'إعدادات الإشعارات',
                                  state.isDarkMode,
                                ),
                              ],

                              // Theme Switch (always visible)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: AppThemes.getCardColor(
                                    state.isDarkMode,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    state.isDarkMode
                                        ? Icons.brightness_2
                                        : Icons.brightness_7,
                                    color: AppThemes.getIconColor(
                                      state.isDarkMode,
                                    ),
                                    size: 24,
                                  ),
                                  title: Text(
                                    'الوضع المظلم',
                                    style: TextStyle(
                                      color: AppThemes.getTextColor(
                                        state.isDarkMode,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    state.isDarkMode ? 'مفعل' : 'غير مفعل',
                                    style: TextStyle(
                                      color: AppThemes.getTextColor(
                                        state.isDarkMode,
                                      ).withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Switch(
                                    value: state.isDarkMode,
                                    onChanged: (value) async {
                                      try {
                                        await context
                                            .read<ThemesCubit>()
                                            .toggleTheme();

                                        _showSuccessMessage(
                                          context,
                                          value
                                              ? 'تم تفعيل الوضع المظلم'
                                              : 'تم تفعيل الوضع الفاتح',
                                        );
                                      } catch (e) {
                                        _showErrorMessage(
                                          context,
                                          'حدث خطأ في حفظ الإعدادات',
                                        );
                                      }
                                    },
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    inactiveThumbColor: Colors.grey,
                                  ),
                                ),
                              ),

                              // Logout button (only when logged in)
                              if (isLoggedIn)
                                _buildProfileOption(
                                  context,
                                  Icons.logout,
                                  'تسجيل الخروج',
                                  state.isDarkMode,
                                  isLogout: true,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String text,
    bool isDarkMode, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDarkMode),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : AppThemes.getIconColor(isDarkMode),
          size: 24,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isLogout ? Colors.red : AppThemes.getTextColor(isDarkMode),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            isLogout
                ? null
                : Icon(
                  Icons.arrow_forward_ios,
                  color: AppThemes.getIconColor(isDarkMode).withOpacity(0.5),
                  size: 16,
                ),
        onTap: () {
          if (isLogout) {
            _showLogoutConfirmation(context, isDarkMode);
          }
          // Handle other option taps
        },
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider(
            create: (context) => LogOutCubit(),
            child: BlocConsumer<LogOutCubit, LogOutState>(
              listener: (context, state) {
                if (state is LogOutSuccess) {
                  Navigator.pop(dialogContext); // Close dialog
                  _showSuccessMessage(context, state.message);
                  // Refresh the page to show guest view
                  setState(() {});
                } else if (state is LogOutFailure) {
                  Navigator.pop(dialogContext); // Close dialog
                  _showErrorMessage(context, state.errorMessage);
                }
              },
              builder: (context, state) {
                final isLoading = state is LogOutLoading;

                return AlertDialog(
                  backgroundColor: AppThemes.getCardColor(isDarkMode),
                  title: Text(
                    'تأكيد تسجيل الخروج',
                    style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                  ),
                  content:
                      isLoading
                          ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'جاري تسجيل الخروج...',
                                style: TextStyle(
                                  color: AppThemes.getTextColor(isDarkMode),
                                ),
                              ),
                            ],
                          )
                          : Text(
                            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                            style: TextStyle(
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                  actions:
                      isLoading
                          ? []
                          : [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Trigger logout
                                context.read<LogOutCubit>().logout();
                                prefs.setBool("isDarkMode", false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                'تسجيل الخروج',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                );
              },
            ),
          ),
    );
  }
}
