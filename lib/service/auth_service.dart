import 'package:dio/dio.dart';

class LoginResponse {
  final int status;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'])
          : null,
    );
  }
}


class LoginData {
  final int loginID;
  final int studentID;
  final String username;
  final String passwordHash;

  LoginData({
    required this.loginID,
    required this.studentID,
    required this.username,
    required this.passwordHash,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      loginID: json['loginID'] ?? 0,
      studentID: json['studentID'] ?? 0,
      username: json['username'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
    );
  }
}


class AuthService {

  final String baseUrl = 'http://192.168.51.230:5080';

  late Dio _dio;

  AuthService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          "username": username,
          "password": password,
        },
      );

     
      print('========================');
      print('REQUEST: /api/auth/login');
      print('USERNAME: $username');
      print('RESPONSE: ${response.data}');
      print('========================');

      return LoginResponse.fromJson(response.data);

    } on DioException catch (e) {
      print('DIO ERROR TYPE: ${e.type}');
      print('DIO ERROR MESSAGE: ${e.message}');
      print('DIO ERROR RESPONSE: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Check your internet.');
      } 
      else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Cannot connect to server. Check if API is running.');
      } 
      else if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } 
      else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}