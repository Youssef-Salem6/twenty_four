part of 'toggle_follow_cubit.dart';

@immutable
sealed class ToggleFollowState {}

final class ToggleFollowInitial extends ToggleFollowState {}

final class ToggleFollowSuccess extends ToggleFollowState {}

final class ToggleFollowFailure extends ToggleFollowState {}

final class ToggleFollowLoading extends ToggleFollowState {}
