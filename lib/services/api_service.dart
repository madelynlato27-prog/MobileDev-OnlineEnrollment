// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.7:5080/api';
  static final _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _getHeaders({
    bool includeAuth = true,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth) {
      final token = await _storage.read(key: 'token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: false);
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (data['status'] == 200 && data['token'] != null) {
        await _storage.write(key: 'token', value: data['token']);
        if (data['data'] != null && data['data']['studentID'] != null) {
          await _storage.write(
            key: 'studentId',
            value: data['data']['studentID'].toString(),
          );
        }
      }
      return data;
    } catch (e) {
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createEnrollment(
    Map<String, dynamic> enrollmentData,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await http.post(
        Uri.parse('$_baseUrl/Enrollment'),
        headers: headers,
        body: jsonEncode(enrollmentData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'status': response.statusCode, 'message': response.body};
      }
    } catch (e) {
      return {'status': 500, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createStudent(
    Map<String, dynamic> studentData,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: false);

      print('📤 Creating student: ${jsonEncode(studentData)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/Student'),
        headers: headers,
        body: jsonEncode(studentData),
      );

      final responseBody = response.body;
      print('📥 Response: $responseBody');

      return jsonDecode(responseBody);
    } catch (e) {
      print('❌ Create student error: $e');
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getStudent(int studentId) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await http.get(
        Uri.parse('$_baseUrl/Student/$studentId'),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateStudent(
    Map<String, dynamic> studentData,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: true);

      print('📤 UPDATE URL: $_baseUrl/Student');
      print('📤 UPDATE BODY: ${jsonEncode(studentData)}');

      final response = await http.put(
        Uri.parse('$_baseUrl/Student'),
        headers: headers,
        body: jsonEncode(studentData),
      );

      print('📥 UPDATE RESPONSE: ${response.statusCode} - ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Update student error: $e');
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadDocument({
    required String studentId,
    required String enrollmentId,
    required String documentName,
    required List<int> fileBytes,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/Student/documents'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Form fields
      request.fields['studentID'] = studentId;
      request.fields['documentType'] = documentName;

      // Add photo file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: '${documentName.replaceAll(' ', '_')}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 Uploading photo: $documentName');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(responseBody);
        } catch (e) {
          return {'status': 200, 'message': 'Photo uploaded successfully'};
        }
      } else {
        return {'status': response.statusCode, 'message': 'Upload failed'};
      }
    } catch (e) {
      print('❌ Upload error: $e');
      return {'status': 500, 'message': 'Upload error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createPayment(
    int enrollmentId,
    double amount,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await http.post(
        Uri.parse('$_baseUrl/Payment'),
        headers: headers,
        body: jsonEncode({'enrollmentID': enrollmentId, 'amount': amount}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getEnrollmentsByStudent(
    int studentId,
  ) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await http.get(
        Uri.parse('$_baseUrl/Enrollment/student/$studentId'),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }

  static Future<int?> getStudentId() async {
    final studentIdStr = await _storage.read(key: 'studentId');
    if (studentIdStr != null) {
      return int.tryParse(studentIdStr);
    }
    return null;
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'studentId');
  }

  static Future<Map<String, dynamic>> getSubjects({
    required String course,
    required int yearLevel,
    required String semester,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/Subject/filter?course=$course&yearLevel=$yearLevel&semester=$semester',
        ),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 500, 'message': 'Connection error: $e'};
    }
  }
}
