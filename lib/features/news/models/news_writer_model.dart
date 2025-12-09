class NewsWriterModel {
  String? name;
  int? id;

  NewsWriterModel({required this.id, required this.name});

  NewsWriterModel.fromJson({required Map json}) {
    id = json["id"];
    name = json["name"];
  }
}
