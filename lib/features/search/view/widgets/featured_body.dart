import 'package:flutter/material.dart';
import 'package:twenty_four/features/home/models/news_model.dart';
import 'package:twenty_four/features/home/view/widgets/components/side_image_news_card.dart';

class FeaturedBody extends StatelessWidget {
  final List data;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const FeaturedBody({
    super.key,
    required this.data,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من وجود البيانات
    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "لا توجد أخبار لعرضها",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics:
          shrinkWrap
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final newsItem = data[index];

        // استخدام ID الأخبار كمفتاح إذا كان موجوداً
        final itemKey =
            newsItem.containsKey('id')
                ? ValueKey('news_${newsItem['id']}')
                : ValueKey('news_$index');

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SideImageNewsCard(
            key: itemKey,
            newsModel: NewsModel.fromJson(newsItem),
            fromSearch: true,
          ),
        );
      },
    );
  }
}
