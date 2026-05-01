// lib/models/service_response.dart
class ServiceResponse<T> {
  final int status;
  final String? message;
  final T? data;
  final String? token;

  ServiceResponse({
    required this.status,
    this.message,
    this.data,
    this.token,
  });

  factory ServiceResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ServiceResponse(
      status: json['status'] ?? 0,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      token: json['token'],
    );
  }

  bool get isSuccess => status >= 200 && status < 300;
}