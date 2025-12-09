class NewsModel {
  int? id, commentsCount;
  String? title, imageUrl, source, category, sourceImageUrl, description;
  String? publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.category,
    required this.sourceImageUrl,
    required this.description,
    required this.commentsCount,
    required this.publishedAt,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json["image"];
    source = json['source'];
    category = json['category'];
    sourceImageUrl = json['source_image'];
    description = json['description'];
    commentsCount = json['comments_count'];
    publishedAt = json['published_date'];
  }
}

  