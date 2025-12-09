part of 'get_all_comments_cubit.dart';

@immutable
sealed class GetAllCommentsState {}

final class GetAllCommentsInitial extends GetAllCommentsState {}

final class GetAllCommentsLoading extends GetAllCommentsState {}

final class GetAllCommentsSuccess extends GetAllCommentsState {
  final List comments;
  GetAllCommentsSuccess({required this.comments});
}

final class GetAllCommentsFailure extends GetAllCommentsState {}
