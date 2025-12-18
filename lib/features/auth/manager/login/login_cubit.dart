import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twenty_four/core/apis.dart';
import 'package:twenty_four/main.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse(loginApi),
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserData(data);
        emit(LoginSuccess(message: data["message"]));
      } else {
        emit(LoginFailure(message: data["message"] ?? "Login failed"));
      }
    } catch (e) {
      emit(LoginFailure(message: "Network error: $e"));
    }
  }

  Future<void> _saveUserData(Map data) async {
    await userPref.setString("email", data["email"]);
    await userPref.setString("firstName", data["name"]);
    await userPref.setString("image", data["avatar"] ?? "");
    await userPref.setString("token", data["access_token"]);
  }
}
