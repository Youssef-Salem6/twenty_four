import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/home/models/news_model.dart';
import 'package:twenty_four/features/news/view/news_details_view.dart';
import 'package:twenty_four/main.dart';

class HomeFirstTypeNewsCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const HomeFirstTypeNewsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = prefs.getBool("isDarkMode") ?? false;
    NewsModel newsModel = NewsModel.fromJson(data);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsView(id: newsModel.id!),
            ),
          );
        },
        child: Container(
          // margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppThemes.getCardColor(isDarkMode),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        // borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: newsModel.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey[600],
                                    size: 50,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      // Updated Gradient Container
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            stops: [0.3, 0.95],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xFF151924)],
                          ),
                        ),
                      ),
                      // Updated Source with circular image (no background container)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          children: [
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
                                child: CachedNetworkImage(
                                  imageUrl: newsModel.sourceImageUrl!,
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
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
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
                            ),
                            // Source name without background
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Text(
                                newsModel.source!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsModel.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppThemes.getTextColor(isDarkMode),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            newsModel.publishedAt!,
                            style: TextStyle(
                              color: AppThemes.getHintColor(isDarkMode),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              Text(
                                newsModel.commentsCount.toString(),
                                style: TextStyle(
                                  color: AppThemes.getTextColor(isDarkMode),
                                ),
                              ),
                              const Gap(2),
                              GestureDetector(
                                onTap: () {
                                  // CommentsView.show(context);
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: AppThemes.getIconColor(isDarkMode),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image(
                            image: AssetImage(
                              "assets/images/icons/generative (1).png",
                            ),
                            width: 30,
                            color: AppThemes.getIconColor(isDarkMode),
                          ),
                          // Icon(
                          //   Icons.more_vert,
                          //   size: 24,
                          //   color: AppThemes.getIconColor(isDarkMode),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
