import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/core/themes/manager/themesCubit/themes_cubit.dart';
import 'package:twenty_four/core/themes/themes.dart';
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
        return Scaffold(
          backgroundColor: AppThemes.getScaffoldColor(
            prefs.getBool("isDarkMode")!,
          ),

          body: CustomScrollView(
            slivers: [
              // Gradient App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                automaticallyImplyLeading: false,
                expandedHeight: 50, // Height until half of profile image
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
                    // Gradient Background (until half of profile image)
                    Container(
                      height:
                          100, // Half of profile image height (120/2 = 60) + some padding
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
                        const SizedBox(
                          height: 40,
                        ), // Space for the profile image to overlap
                        // Profile Image (overlapping the gradient)
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
                          'أحمد محمد',
                          style: TextStyle(
                            color: AppThemes.getTextColor(state.isDarkMode),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Username
                        Text(
                          '@ahmed_mohamed',
                          style: TextStyle(
                            color: AppThemes.getTextColor(
                              state.isDarkMode,
                            ).withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Profile Options
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
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

                              // Theme Switch using Cubit with async handling
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
                                        // Call the async toggleTheme method
                                        await context
                                            .read<ThemesCubit>()
                                            .toggleTheme();

                                        // Show success message
                                        _showSuccessMessage(
                                          context,
                                          value
                                              ? 'تم تفعيل الوضع المظلم'
                                              : 'تم تفعيل الوضع الفاتح',
                                        );
                                      } catch (e) {
                                        // Show error message
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

  // Success message
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

  // Error message
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

  // Logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppThemes.getCardColor(isDarkMode),
            title: Text(
              'تأكيد تسجيل الخروج',
              style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
            ),
            content: Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle logout logic here
                  _showSuccessMessage(context, 'تم تسجيل الخروج بنجاح');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
