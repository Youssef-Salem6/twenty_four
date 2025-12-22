part of 'get_sources_cubit.dart';

@immutable
sealed class GetSourcesState {}

final class GetSourcesInitial extends GetSourcesState {}

final class GetSourcesLoading extends GetSourcesState {}

final class GetSourcesSuccess extends GetSourcesState {
  final List sources;
  GetSourcesSuccess({required this.sources});
}

final class GetSourcesFailure extends GetSourcesState {}
