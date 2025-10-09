import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twenty_four/core/fake_api.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/search/view/widgets/featured_body.dart';
import 'package:twenty_four/main.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  int _selectedTabIndex = 0;
  late PageController _pageController;

  // List of tab names
  final List<String> _tabNames = [
    'مميز', // Featured
    'شائع', // Trending
    'منتشر', // Popular
    'جديد', // New
    'أعلى', // Top
    'حديث', // Recent
    'نشط', // Hot
    'ممتاز', // Best
    'متابعة', // Following
    'مقترح', // Recommended
    'اكتشاف', // Discover
    'استكشاف', // Explore
  ];

  // Fixed: Make sure each widget is properly instantiated
  late final List<Widget> _bodies;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);

    // Initialize the bodies list in initState to avoid recreation
    _bodies = List.generate(
      _tabNames.length,
      (index) => FeaturedBody(
        key: ValueKey('featured_$index'),
        data: response["data"][1]["news"],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_selectedTabIndex != index) {
      setState(() {
        _selectedTabIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    if (_selectedTabIndex != index) {
      setState(() {
        _selectedTabIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme brightness
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppThemes.getScaffoldColor(prefs.getBool("isDarkMode")!),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2b2f3a), Color(0xFF151924)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          "أبحث",
          style: TextStyle(color: Colors.white, fontFamily: "Almarai"),
        ),
      ),
      body: Column(
        children: [
          // Gradient Container behind Search Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "بحث",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2b2f3a), Color(0xFF151924)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _tabNames.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  isSelected ? Colors.red : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          _tabNames[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // PageView content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _tabNames.length,
              itemBuilder: (context, index) {
                // Add error handling and debugging
                try {
                  return Container(
                    key: ValueKey('page_$index'),
                    child: _bodies[index],
                  );
                } catch (e) {
                  // Fallback content if there's an issue
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading ${_tabNames[index]} content',
                          style: TextStyle(
                            color: AppThemes.getTextColor(isDarkMode),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: $e',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
