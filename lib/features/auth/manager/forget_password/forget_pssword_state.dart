part of 'forget_pssword_cubit.dart';

@immutable
sealed class ForgetPsswordState {}

final class ForgetPsswordInitial extends ForgetPsswordState {}

final class ForgetPsswordLoading extends ForgetPsswordState {}

final class ForgetPsswordSuccess extends ForgetPsswordState {
  final String token;
  ForgetPsswordSuccess({required this.token});
}

final class ForgetPsswordFailure extends ForgetPsswordState {
  final String message;
  ForgetPsswordFailure({required this.message});
}
