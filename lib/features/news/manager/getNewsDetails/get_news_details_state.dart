part of 'get_news_details_cubit.dart';

@immutable
sealed class GetNewsDetailsState {}

final class GetNewsDetailsInitial extends GetNewsDetailsState {}

final class GetNewsDetailsLoading extends GetNewsDetailsState {}

final class GetNewsDetailsSuccess extends GetNewsDetailsState {
  final NewsDetailsModel newsDetailsModel;

  GetNewsDetailsSuccess({required this.newsDetailsModel});
}

final class GetNewsDetailsFailure extends GetNewsDetailsState {
  final String message;

  GetNewsDetailsFailure({required this.message});
}
