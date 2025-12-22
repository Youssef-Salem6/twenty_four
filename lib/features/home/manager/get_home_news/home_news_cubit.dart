import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'home_news_state.dart';

class HomeNewsCubit extends Cubit<HomeNewsState> {
  HomeNewsCubit() : super(HomeNewsInitial());

  List screens = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  getHomeNews() async {
    emit(HomeNewsLoading());
    print("loading");
    currentPage = 1;
    hasMoreData = true;

    try {
      final response = await http.get(Uri.parse('$homeNews?page=$currentPage'));
      if (response.statusCode == 200) {
        screens = jsonDecode(response.body)["data"]['screens'];
        emit(HomeNewssuccess(screens: screens));
      } else {
        emit(HomeNewsFailure());
      }
    } catch (e) {
      emit(HomeNewsFailure());
    }
  }

  loadMoreNews() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    currentPage++;
    print("Loading page $currentPage");

    try {
      final response = await http.get(Uri.parse('$homeNews?page=$currentPage'));
      if (response.statusCode == 200) {
        final newScreens = jsonDecode(response.body)["data"]['screens'];

        if (newScreens.isEmpty) {
          hasMoreData = false;
          currentPage--;
        } else {
          screens.addAll(newScreens);
          emit(HomeNewssuccess(screens: screens));
        }
      }
    } catch (e) {
      print("Error loading more: $e");
      currentPage--;
    } finally {
      isLoadingMore = false;
    }
  }
}
