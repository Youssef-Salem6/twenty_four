class CommentModel {
  int? id;
  String? comment, createdAt , username;

  CommentModel({this.id, this.comment, this.createdAt , this.username});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    username = json["user"]["name"];
  }
}
