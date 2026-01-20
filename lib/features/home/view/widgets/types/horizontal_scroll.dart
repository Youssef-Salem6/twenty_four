import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/home/models/news_model.dart';
import 'package:twenty_four/features/news/view/news_details_view.dart';
import 'package:twenty_four/main.dart';

class HorizontalScroll extends StatelessWidget {
  final List news;
  final String description, title;
  final int id;
  const HorizontalScroll({
    super.key,
    required this.news,
    required this.description,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final isDarkMode = prefs.getBool("isDarkMode") ?? false;

    // Static source image for all news
    return SafeArea(
      child: Stack(
        children: [
          // Header container - takes 20% of background with gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF2B2F3A), Color(0xFF151924)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Gap(8),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsView(id: id),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Slider positioned below the header
          Positioned(
            top: size.height * 0.14,
            left: 0,
            right: 0,
            bottom: size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: news.length,
                itemBuilder: (context, index) {
                  NewsModel newsModel = NewsModel.fromJson(news[index]);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        NewsDetailsView(id: newsModel.id!),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width * 0.75,
                            height: size.height * 0.48,
                            decoration: BoxDecoration(
                              color: AppThemes.getCardColor(isDarkMode),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Image section
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: newsModel.imageUrl!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                color:
                                                    AppThemes.getSearchBarColor(
                                                      isDarkMode,
                                                    ),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          errorWidget:
                                              (
                                                context,
                                                url,
                                                error,
                                              ) => Container(
                                                color:
                                                    AppThemes.getSearchBarColor(
                                                      isDarkMode,
                                                    ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color:
                                                        AppThemes.getHintColor(
                                                          isDarkMode,
                                                        ),
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                      // Gradient overlay with source
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height:
                                              (size.height * 0.5 * 0.6) * 0.2,
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
                                                width: 24,
                                                height: 24,
                                                margin: EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        newsModel
                                                            .sourceImageUrl!,
                                                    width: 24,
                                                    height: 24,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.person,
                                                              size: 12,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.person,
                                                              size: 12,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              // Source name
                                              Expanded(
                                                child: Text(
                                                  newsModel.source!,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text section
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      color: AppThemes.getCardColor(isDarkMode),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Category
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isDarkMode
                                                      ? Color(
                                                        0xFF282828,
                                                      ).withOpacity(1)
                                                      : Color(
                                                        0xFF151924,
                                                      ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              newsModel.category!,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // Title
                                          Expanded(
                                            child: Text(
                                              newsModel.title!,
                                              style: TextStyle(
                                                color: AppThemes.getTextColor(
                                                  isDarkMode,
                                                ),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                height: 1.3,
                                              ),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // Bottom icons row
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.clock,
                                                    color:
                                                        AppThemes.getIconColor(
                                                          isDarkMode,
                                                        ),
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    newsModel.publishedAt!,
                                                    style: TextStyle(
                                                      color:
                                                          AppThemes.getHintColor(
                                                            isDarkMode,
                                                          ),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                              Row(
                                                children: [
                                                  Text(
                                                    newsModel.commentsCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          AppThemes.getTextColor(
                                                            isDarkMode,
                                                          ),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Gap(2),
                                                  Icon(
                                                    CupertinoIcons.chat_bubble,
                                                    color:
                                                        AppThemes.getIconColor(
                                                          isDarkMode,
                                                        ),
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Image(
                                                image: AssetImage(
                                                  "assets/images/icons/generative (1).png",
                                                ),
                                                width: 28,
                                                color:
                                                    isDarkMode
                                                        ? Colors.white70
                                                        : null,
                                              ),
                                              Icon(
                                                Icons.more_vert,
                                                size: 28,
                                                color: AppThemes.getIconColor(
                                                  isDarkMode,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Ad at bottom
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            height: size.height * 0.1,
            child: Center(child: _buildAdCard(size, context, isDarkMode)),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(Size size, BuildContext context, bool isDarkMode) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.1,
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ad image
          Container(
            width: size.width * 0.25,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl:
                    "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: AppThemes.getSearchBarColor(isDarkMode),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: AppThemes.getSearchBarColor(isDarkMode),
                      child: Center(
                        child: Icon(
                          Icons.error,
                          color: AppThemes.getHintColor(isDarkMode),
                          size: 30,
                        ),
                      ),
                    ),
              ),
            ),
          ),
          // Ad content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إعلان",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "عروض خاصة محدودة الوقت",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
