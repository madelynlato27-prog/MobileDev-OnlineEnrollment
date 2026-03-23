import 'package:dio/dio.dart';

class EnrollmentService {
  final baseUrl = 'http://10.155.6.150:5080';
  final dio = Dio();

  Future<dynamic> createEnrollment({
    required String course,
    required String schoolYear,
    required String semester,


  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/Enrollment',
        data: {
          "course": course,
          "schoolYear": schoolYear,
          "semester": semester,
        
         
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