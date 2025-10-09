import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/news/view/news_details_view.dart';
import 'package:twenty_four/main.dart';

class SideImageNewsCard extends StatefulWidget {
  final bool fromSearch;
  final Map<String, dynamic>? data;
  const SideImageNewsCard({
    super.key,
    required this.data,
    required this.fromSearch,
  });

  @override
  State<SideImageNewsCard> createState() => _SideImageNewsCardState();
}

class _SideImageNewsCardState extends State<SideImageNewsCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final bool isDarkMode = prefs.getBool("isDarkMode") ?? false;

    // التحقق من أن البيانات موجودة
    if (widget.data == null) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            "لا توجد بيانات",
            style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
          ),
        ),
      );
    }

    // استخراج البيانات مع قيم افتراضية
    final String title = widget.data?["title"]?.toString() ?? "بدون عنوان";
    final String source =
        widget.data?["source"]?.toString() ?? "مصدر غير معروف";
    final String description =
        widget.data?["description"]?.toString() ?? "بدون وصف";
    final String imageUrl = widget.data?["image"]?.toString() ?? "";
    final String sourceImage = widget.data?["source_image"]?.toString() ?? "";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailsView()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppThemes.getCardColor(isDarkMode),
              ),
              height:
                  widget.fromSearch ? size.height * 0.2 : size.height * 0.25,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Visibility(
                            child: Text(
                              description,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppThemes.getTextColor(isDarkMode),
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "3:50 AM",
                                style: TextStyle(
                                  color: AppThemes.getHintColor(isDarkMode),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(5),
                              Row(
                                children: [
                                  Text(
                                    "4",
                                    style: TextStyle(
                                      color: AppThemes.getTextColor(isDarkMode),
                                    ),
                                  ),
                                  Gap(2),
                                  GestureDetector(
                                    // onTap: () => CommentsView.show(context),
                                    child: Icon(
                                      CupertinoIcons.chat_bubble,
                                      size: 20,
                                      color: AppThemes.getIconColor(isDarkMode),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Image(
                                image: AssetImage(
                                  "assets/images/icons/generative (1).png",
                                ),
                                width: 25,
                                color: AppThemes.getIconColor(isDarkMode),
                              ),
                              Icon(
                                Icons.more_vert,
                                size: 25,
                                color: AppThemes.getIconColor(isDarkMode),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 150,
                      child: Stack(
                        children: [
                          ClipRRect(
                            child:
                                imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder:
                                          (context, url) => Container(
                                            height: 100,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                      fadeInDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      fadeOutDuration: const Duration(
                                        milliseconds: 100,
                                      ),
                                    )
                                    : Container(
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                          ),
                          // Gradient container with source name and circular image
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: size.height * 0.25 * 0.2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF151924),
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  // Circular source image
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child:
                                          sourceImage.isNotEmpty
                                              ? CachedNetworkImage(
                                                imageUrl:
                                                    "https://images.unsplash.com/photo-1664575602554-2087b04935a5",
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) => Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 10,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 10,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                              )
                                              : Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                  // Source name
                                  Expanded(
                                    child: Text(
                                      source,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
