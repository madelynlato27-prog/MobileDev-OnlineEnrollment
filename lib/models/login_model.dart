// lib/models/login_model.dart
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

class LoginResponse {
  final int status;
  final String message;
  final String? token;
  final UserData? userData;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.userData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      token: json['token'],
      userData: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  bool get isSuccess => status == 200;
}

class UserData {
  final int? userId;
  final int? studentId;
  final String username;
  final String? role;
  final String? studentName;

  UserData({
    this.userId,
    this.studentId,
    required this.username,
    this.role,
    this.studentName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userID'],
      studentId: json['studentID'],
      username: json['username'] ?? '',
      role: json['role'],
      studentName: json['studentName'],
    );
  }
}

class StudentCreateModel {
  final int studentID;
  final String username;
  final String password;

  StudentCreateModel({
    required this.studentID,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'studentID': studentID,
    'username': username,
    'password': password,
  };
}

class StaffCreateModel {
  final String username;
  final String password;
  final String role;

  StaffCreateModel({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'role': role,
  };
}