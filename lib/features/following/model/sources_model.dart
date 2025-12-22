class SourcesModel {
  int? id;
  String? name, logo;
  bool? isFollowing;
  SourcesModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.isFollowing,
  });
  factory SourcesModel.fromJson(Map<String, dynamic> json) {
    return SourcesModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      isFollowing: json['is_following'],
    );
  }
}
