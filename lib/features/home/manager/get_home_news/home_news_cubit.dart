import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'home_news_state.dart';

class HomeNewsCubit extends Cubit<HomeNewsState> {
  HomeNewsCubit() : super(HomeNewsInitial());
  List screens = [];
  getHomeNews() async {
    emit(HomeNewsLoading());
    print("lodaing");
    try {
      final response = await http.get(Uri.parse(homeNews));
      if (response.statusCode == 200) {
        screens = jsonDecode(response.body)["data"]['screens'];
        emit(HomeNewssuccess(screens: screens));
        // print(response.body);
      } else {
        emit(HomeNewsFailure());
      }
    } catch (e) {
      emit(HomeNewsFailure());
    }
  }
}
