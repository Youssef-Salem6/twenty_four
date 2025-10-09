import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twenty_four/features/home/view/widgets/components/home_first_type_news_card.dart';
import 'package:twenty_four/features/news/view/news_details_view.dart';
import 'package:twenty_four/main.dart';

class MainType extends StatelessWidget {
  final List data;
  const MainType({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // الرابط الثابت للصورة الدائرية
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsDetailsView()),
              );
            },
            child: ClipRRect(
              child: Stack(
                children: [
                  // Background Image with Caching
                  CachedNetworkImage(
                    imageUrl: data[0]["image"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[300],
                          child: Center(child: CircularProgressIndicator()),
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
                  // Gradient Overlay and Content
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.05, 0.75],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xFF151924)],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 12,
                          children: [
                            Row(
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
                                    "الخبر اليوم",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
                            Text(
                              data[0]["title"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.time,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Gap(5),
                                Text(
                                  data[0]["source"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Gap(10),
                                GestureDetector(
                                  // onTap: () => CommentsView.show(context),
                                  child: Icon(
                                    CupertinoIcons.chat_bubble,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Gap(5),
                                Text(
                                  "33",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Spacer(),
                                Image(
                                  image: AssetImage(
                                    "assets/images/icons/generative.png",
                                  ),
                                  width: 28,
                                ),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                            Gap(10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color:
                prefs.getBool("isDarkMode") ?? false
                    ? Color(0xFF424242)
                    : Color(0xFFE2E2E2),
            child: Row(
              children: [
                Expanded(child: HomeFirstTypeNewsCard(data: data[1])),
                Gap(8),
                // VerticalDivider(
                //   thickness: 1,
                //   color: Color(0xFF8E8E8E),
                //   endIndent: 40,
                //   indent: 20,
                // ),
                Expanded(child: HomeFirstTypeNewsCard(data: data[2])),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
