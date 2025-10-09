import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/following/view/following_view.dart';
import 'package:twenty_four/features/home/view/home_view.dart';
import 'package:twenty_four/features/profile/view/profile_view.dart';
import 'package:twenty_four/features/search/view/search_view.dart';
import 'package:twenty_four/main.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Different pages that correspond to each navigation item
  static final List<Widget> _pages = <Widget>[
    const HomeView(), // Index 0 - Home
    const SearchView(), // Index 1 - Search
    const FollowingView(), // Index 2 - Following (Explore)
    const ProfileView(), // Index 3 - Profile (Settings)
  ];

  // Icons and labels for the navigation bar (4 items with gap in center)
  final List<IconData> _icons = [
    Icons.home, // Home
    Icons.search, // Search
    Icons.explore, // Explore (Following)
    Icons.settings, // Settings (Profile)
  ];

  final List<String> _labels = ['الرئيسيه', 'البحث', 'المتابعين', 'اعدادات'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to refresh the navbar when theme changes
  void refreshNavBar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = prefs.getBool("isDarkMode") ?? false;

    return Scaffold(
      backgroundColor: AppThemes.getScaffoldColor(isDarkMode),
      body: Center(child: _pages.elementAt(_selectedIndex)),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xff2b2f3a), Color(0xFF151924)],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/images/icons/generative.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _icons.length,
        tabBuilder: (int index, bool isActive) {
          final color =
              isActive
                  ? (isDarkMode ? Colors.white : Colors.white)
                  : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icons[index], size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                _labels[index],
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              // Add red underline for active tab
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          );
        },
        activeIndex: _selectedIndex,
        backgroundGradient: const LinearGradient(
          colors: [Color(0xff2b2f3a), Color(0xFF151924)],
        ),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) {
          _onItemTapped(index);
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
