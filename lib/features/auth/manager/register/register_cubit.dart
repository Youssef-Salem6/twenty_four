import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:twenty_four/core/apis.dart';
import 'package:twenty_four/main.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({required Map body}) async {
    emit(RegisterLoading());
    try {
      final response = await http.post(Uri.parse(registerApi), body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _saveUserData(data);
        emit(RegisterSuccess(message: data["message"]));
      } else {
        emit(
          RegisterFailure(message: data["message"] ?? "Registration failed"),
        );
      }
    } catch (e) {
      emit(RegisterFailure(message: "Network error: $e"));
    }
  }

  Future<void> _saveUserData(Map data) async {
    await userPref.setString("email", data["email"]);
    await userPref.setString("firstName", data["name"]);
    await userPref.setString("image", data["avatar"] ?? "");
    await userPref.setString("token", data["access_token"]);
  }
}
