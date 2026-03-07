import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onlineenrollment/model/login_response.dart';

class AuthService {
  final baseUrl = 'http://172.20.10.3:5080';
  final dio = Dio();

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    String loginUrl =
        '$baseUrl/Login/authenticate?username=$username&password=$password';

    debugPrint('username: $username');
    debugPrint('password: $password');
    try {
      final response = await dio.post(
        loginUrl,
        options: Options(headers: {"accept": "*/*"}),
      );

      final data = LoginResponse.fromJson(response.data);
      return data;
    } catch (e) {
      // gamita ang e(value)
      rethrow;
    }
  }
}
