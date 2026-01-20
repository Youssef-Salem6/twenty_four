import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
part 'send_otp_state.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit() : super(SendOtpInitial());
  sendOtp({required String code, required String token}) async {
    emit(SendOtpLoading());
    try {
      final response = await http.post(
        Uri.parse(verifyCodeApi),
        body: {'token': token, 'otp': code},
      );

      if (response.statusCode == 200) {
        emit(SendOtpSuccess(token: jsonDecode(response.body)['token']));
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ??
            'حدث خطأ أثناء التحقق من الرمز';
        emit(SendOtpFailure(message: errorMessage));
      }
    } catch (e) {
      emit(
        SendOtpFailure(
          message: 'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت',
        ),
      );
    }
  }
}
