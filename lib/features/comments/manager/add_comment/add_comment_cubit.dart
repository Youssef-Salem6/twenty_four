import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'add_comment_state.dart';

class AddCommentCubit extends Cubit<AddCommentState> {
  AddCommentCubit() : super(AddCommentInitial());
  addComment({required String articalId, required String comment}) async {
    emit(AddCommentLoading());
    print("loading");
    try {
      print("waiting");
      var response = await http.post(
        headers: headers,
        Uri.parse("$getNewsDetailsUrl/$articalId/comments"),
        body: {"comment": comment, "parent_id": ""},
      );
      if (response.statusCode == 200) {
        print("done");
        emit(AddCommentSuccess());
      } else {
        emit(AddCommentFailure(message: "Failed to add comment"));
        print(response.body);
      }
    } catch (e) {
      print(e);
      emit(AddCommentFailure(message: e.toString()));
    }
  }
}
