import 'package:dio/dio.dart';

class EnrollmentService {
  final baseUrl = 'http://10.155.6.150:5080';
  final dio = Dio();

  Future<dynamic> createEnrollment({
    required String enrollmentId,
    required String studentId,
    required String course,
    required String schoolYear,
    required String semester,
    required String enrollmentStatus
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/Enrollment',
        data: {
          "enrollmentId" : enrollmentId,
          "studentId": studentId,
          "course": course,
          "schoolYear": schoolYear,
          "semester": semester,
          "enrollmentStatus": enrollmentStatus,
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