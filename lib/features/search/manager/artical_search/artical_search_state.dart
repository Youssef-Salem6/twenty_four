part of 'artical_search_cubit.dart';

@immutable
sealed class ArticalSearchState {}

final class ArticalSearchInitial extends ArticalSearchState {}

final class ArticalSearchLoading extends ArticalSearchState {}

final class ArticalSearchSuccess extends ArticalSearchState {
  final List data;
  ArticalSearchSuccess(this.data);
}

final class ArticalSearchFailure extends ArticalSearchState {
  final String error;
  ArticalSearchFailure(this.error);
}
