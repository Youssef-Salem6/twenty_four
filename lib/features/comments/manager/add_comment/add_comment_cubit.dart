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
        Uri.parse("$getNewsDetailsUrl/$articalId/comments"),
        headers: headers,
        body: {"comment": comment, "parent_id": ""},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("done");
        emit(AddCommentSuccess());
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
        emit(AddCommentFailure(message: "فشل في إضافة التعليق"));
      }
    } catch (e) {
      print("Error: $e");
      emit(AddCommentFailure(message: "حدث خطأ في الاتصال"));
    }
  }
}
