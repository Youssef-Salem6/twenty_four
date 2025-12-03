part of 'home_news_cubit.dart';

@immutable
sealed class HomeNewsState {}

final class HomeNewsInitial extends HomeNewsState {}

final class HomeNewssuccess extends HomeNewsState {
  final List screens;
  HomeNewssuccess({required this.screens});
}

final class HomeNewsFailure extends HomeNewsState {}

final class HomeNewsLoading extends HomeNewsState {}
