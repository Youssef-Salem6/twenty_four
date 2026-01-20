import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';

part 'forget_pssword_state.dart';

class ForgetPsswordCubit extends Cubit<ForgetPsswordState> {
  ForgetPsswordCubit() : super(ForgetPsswordInitial());

  forgetPssword({required String email}) async {
    emit(ForgetPsswordLoading());
    try {
      final response = await http.post(
        Uri.parse(forgetPsswordApi),
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        emit(ForgetPsswordSuccess(token: jsonDecode(response.body)['token']));
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ??
            'حدث خطأ أثناء إرسال البريد الإلكتروني';
        emit(ForgetPsswordFailure(message: errorMessage));
        print(errorMessage);
      }
    } catch (e) {
      emit(
        ForgetPsswordFailure(
          message: 'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت',
        ),
      );
    }
  }
}
