class LoginResponse {
  final int status;
  final String message;
  final LoginData data;
  final String token;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
      token: json['token'],
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
      loginID: json['loginID'],
      studentID: json['studentID'],
      username: json['username'],
      passwordHash: json['passwordHash'],
    );
  }
}
