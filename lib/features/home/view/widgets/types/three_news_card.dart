import 'package:flutter/material.dart';
import 'package:twenty_four/features/home/models/news_model.dart';
import 'package:twenty_four/features/home/view/widgets/components/side_image_news_card.dart';
import 'package:twenty_four/main.dart';
import 'package:twenty_four/core/themes/themes.dart';

class ThreeNewsCard extends StatelessWidget {
  final List data;
  const ThreeNewsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = prefs.getBool("isDarkMode") ?? false;

    // التحقق من وجود البيانات
    if (data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "لا توجد أخبار",
            style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: List.generate(
          data.length > 3 ? 3 : data.length, // أقصى 3 عناصر
          (index) => RepaintBoundary(
            key: ValueKey('news_card_$index'), // مفتاح فريد لكل عنصر
            child: SideImageNewsCard(
              newsModel: NewsModel.fromJson(data[index]),
              fromSearch: false,
            ),
          ),
        ),
      ),
    );
  }
}

// إضافة: كلاس مساعد للقوائم الطويلة (اختياري)
class OptimizedNewsListView extends StatelessWidget {
  final List<Map<String, dynamic>> newsList;
  const OptimizedNewsListView({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = prefs.getBool("isDarkMode") ?? false;

    return Container(
      color: AppThemes.getScaffoldColor(isDarkMode),
      child: ListView.builder(
        // تحسينات الأداء
        physics: const ClampingScrollPhysics(),
        cacheExtent: 200, // تقليل cache
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,

        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            // key: ValueKey('news_$index'),
            child: SideImageNewsCard(
              newsModel: NewsModel.fromJson(newsList[index]),
              fromSearch: false,
            ),
          );
        },
      ),
    );
  }
}
