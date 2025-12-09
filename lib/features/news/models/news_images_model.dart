class NewsImagesModel {
  String? small, medium, large;

  NewsImagesModel({
    required this.large,
    required this.medium,
    required this.small,
  });

  NewsImagesModel.fromJson({required Map json}) {
    large = json["large"];
    medium = json["medium"];
    small = json["small"];
  }
}
