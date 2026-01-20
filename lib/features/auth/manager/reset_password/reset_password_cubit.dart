import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final response = await http.post(
        Uri.parse(resetPasswordApi),
        body: {
          'reset_token': token,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        emit(ResetPasswordSuccess());
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ??
            'حدث خطأ أثناء إعادة تعيين كلمة المرور';
        emit(ResetPasswordFailure(errorMessage));
      }
    } catch (e) {
      emit(
        ResetPasswordFailure('تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت'),
      );
    }
  }
}
