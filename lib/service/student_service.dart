import 'package:dio/dio.dart';

class StudentService   {
  final baseUrl = 'http://192.168.254.102:5080';
  final dio = Dio();

  Future<dynamic> createEnrollment({
    required String firstName,
    required String lastName,
    required String middleName,
    required int age,
    required String gender,
    required String contact,
    required String email,
    required String address,
    required String birthdate,
 
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/auth/login',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "middleName": middleName,
          "age": age,
          "gender": gender,
          "contact": contact,
          "email": email,
          "address": address,
          "birthdate": birthdate,
         
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}