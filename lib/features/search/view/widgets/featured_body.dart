import 'package:flutter/material.dart';
import 'package:twenty_four/features/home/view/widgets/components/side_image_news_card.dart';

class FeaturedBody extends StatelessWidget {
  final List data;

  const FeaturedBody({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    // التحقق من وجود البيانات
    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("لا توجد أخبار")),
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
              fromSearch: true,
              data: data[index] as Map<String, dynamic>?,
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
    return ListView.builder(
      // تحسينات الأداء
      physics: const ClampingScrollPhysics(),
      cacheExtent: 200, // تقليل cache
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,

      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          // key: ValueKey('news_$index'),
          child: SideImageNewsCard(data: newsList[index], fromSearch: true),
        );
      },
    );
  }
}
