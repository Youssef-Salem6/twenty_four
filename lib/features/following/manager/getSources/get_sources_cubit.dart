import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
import 'package:twenty_four/main.dart';
part 'get_sources_state.dart';

class GetSourcesCubit extends Cubit<GetSourcesState> {
  GetSourcesCubit() : super(GetSourcesInitial());
  List sources = [];
  getSources() async {
    emit(GetSourcesLoading());
    try {
      final response = await http.get(
        Uri.parse(getSourcesUrl),
        headers: {
          'Authorization': 'Bearer ${userPref.getString("token")}',
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        sources = jsonDecode(response.body)["data"]["news_sources"];
        print(response.body);
        emit(GetSourcesSuccess(sources: sources));
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body)["message"]);
        emit(GetSourcesFailure());
      }
    } catch (e) {
      print(e.toString());
      emit(GetSourcesFailure());
    }
  }
}
