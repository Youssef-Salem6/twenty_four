import 'dart:convert';

import 'package:bloc/bloc.dart';
// import 'package:el_etehad/core/paths/apis.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'artical_search_state.dart';

class ArticalSearchCubit extends Cubit<ArticalSearchState> {
  ArticalSearchCubit() : super(ArticalSearchInitial());

  List searchData = [];

  void search(String data) async {
    if (data.isEmpty) {
      emit(ArticalSearchInitial());
      searchData = [];
      return;
    }

    emit(ArticalSearchLoading());

    try {
      var response = await http.get(Uri.parse("$searchArticalUrl=$data"));

      if (response.statusCode == 200) {
        // Parse your response here
        // Example: searchData = json.decode(response.body);
        searchData =
            jsonDecode(response.body)["data"]; // Add your parsed data here
        emit(ArticalSearchSuccess(searchData));
      } else {
        emit(ArticalSearchFailure('فشل في البحث'));
      }
    } catch (e) {
      emit(ArticalSearchFailure('حدث خطأ: ${e.toString()}'));
    }
  }

  void clearSearch() {
    searchData = [];
    emit(ArticalSearchInitial());
  }
}
