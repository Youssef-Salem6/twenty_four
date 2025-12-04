import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
import 'package:twenty_four/main.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitial());

  Future<void> logout() async {
    emit(LogOutLoading());
    try {
      final token = prefs.getString("token");
      if (token == null || token.isEmpty) {
        await _clearPrefs();
        emit(LogOutFailure(errorMessage: "No active session"));
        return;
      }

      final response = await http.post(
        Uri.parse(logOutApi),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      );

      await _clearPrefs();

      if (response.statusCode == 200) {
        emit(LogOutSuccess(message: jsonDecode(response.body)["message"]));
      } else {
        emit(
          LogOutFailure(
            errorMessage:
                jsonDecode(response.body)["message"] ?? "Logout failed",
          ),
        );
      }
    } catch (e) {
      await _clearPrefs();
      emit(LogOutFailure(errorMessage: "Network error: $e"));
    }
  }

  Future<void> _clearPrefs() async {
    await prefs.clear();
  }
}
