class SectionModel {
  int? id;
  String? title, slug;
  SectionModel({this.id, this.slug, this.title});
  SectionModel.fromJson({required Map json}) {
    id = json["id"];
    title = json["title"]["ar"];
    slug = json["slug"];
  }
}
