import 'package:twenty_four/features/news/models/news_writer_model.dart';
import 'package:twenty_four/features/news/models/section_model.dart';

class NewsDetailsModel {
  int? id, likeCount, commentCount;
  String? title, description, imageTitle, source, sourceLogo;
  String? publishedAt, geminiSummary, body, image, sourceUrl;
  List? tags, keyWords, comments, faqs;
  // NewsImagesModel? newsImagesModel;
  NewsWriterModel? newsWriterModel;
  SectionModel? sectionModel;
  bool? liked;

  NewsDetailsModel({
    required this.faqs,
    required this.source,
    required this.id,
    required this.description,
    required this.geminiSummary,
    required this.imageTitle,
    required this.keyWords,
    required this.newsWriterModel,
    required this.publishedAt,
    required this.tags,
    required this.title,
    required this.sectionModel,
    required this.body,
    required this.comments,
    required this.commentCount,
    required this.likeCount,
    required this.liked,
    required this.image,
    required this.sourceLogo,
    required this.sourceUrl,
  });

  NewsDetailsModel.fromJson({required Map json}) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    imageTitle = json["image_title"];
    publishedAt = json["published_at"];
    body = json["body"]["data"]["text"];
    commentCount = json["comments_count"];
    liked = json["liked"];
    likeCount = json["likes_count"];
    source = json["source"] ?? "Twenty Four";
    sourceLogo = json["source_logo"];
    sourceUrl = json["source_url"];

    // Fix: Check if section exists and is not null
    if (json["section"] != null && json["section"] is Map) {
      sectionModel = SectionModel.fromJson(json: json["section"]);
    } else if (json["section_data"] != null && json["section_data"] is Map) {
      // Try section_data as fallback
      sectionModel = SectionModel.fromJson(json: json["section_data"]);
    } else {
      sectionModel = null;
    }

    tags = json["tags"] ?? [];
    keyWords = json["keywords"] ?? [];
    comments = json["last_comments"] ?? [];
    faqs = json["gemini_faq"] ?? [];
    geminiSummary = json["gemini_summary"];

    // Handle image - check if exists and is not null
    image = json["image"];

    // Handle writer - check if exists and is not null
    if (json["writer"] != null && json["writer"] is Map) {
      newsWriterModel = NewsWriterModel.fromJson(json: json["writer"]);
    } else {
      newsWriterModel = NewsWriterModel.fromJson(
        json: {"id": 5, "name": "د. سارة أحمد"},
      );
    }
  }
}
