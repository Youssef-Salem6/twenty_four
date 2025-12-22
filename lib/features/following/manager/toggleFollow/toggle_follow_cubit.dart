import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
import 'package:twenty_four/main.dart';
part 'toggle_follow_state.dart';

class ToggleFollowCubit extends Cubit<ToggleFollowState> {
  ToggleFollowCubit() : super(ToggleFollowInitial());
  toggleFollowSource({required int sourceId}) async {
    emit(ToggleFollowLoading());
    try {
      var response = await http.post(
        Uri.parse(toggleFollowSourceUrl(sourceId: sourceId.toString())),
        headers: {
          'Authorization': 'Bearer ${userPref.getString("token")}',
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        emit(ToggleFollowSuccess());
        print(response.body);
      } else {
        emit(ToggleFollowFailure());
      }
    } catch (e) {
      emit(ToggleFollowFailure());
    }
  }
}
