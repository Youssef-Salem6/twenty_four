import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FollowNewsCard extends StatelessWidget {
  final String title, description;
  const FollowNewsCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage("assets/images/The-News-1-11.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // 3-Color Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF151924).withOpacity(0.9), // Dark at bottom
                      Colors.transparent, // Transparent in middle
                      Color(0xFF2b2f3a).withOpacity(0.7), // Lighter dark at top
                    ],
                    stops: [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row with title and menu icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hashtag and Title at top left
                      Row(
                        children: [
                          Text(
                            "#",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.25),
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          Gap(4),
                          Text(
                            title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Menu icon at top right
                      Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),

                  // Bottom Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source info above description
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
                                width: 1.2,
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              "قناة العربية", // Arabic source name
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
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
                      Gap(6),

                      // Description
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.8),
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          textDirection: TextDirection.rtl, // For Arabic text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
