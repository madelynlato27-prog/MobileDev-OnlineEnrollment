// lib/models/student_profile_model.dart

class StudentProfile {
  final int? studentId;
  final String? studentNumber;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? gender;
  final String? birthDate;
  final String? contactNumber;
  final String? email;
  final String? address;
  final String? studentType;
  final String? status;
  final String? profileImage; // Base64 or URL of profile image

  StudentProfile({
    this.studentId,
    this.studentNumber,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.gender,
    this.birthDate,
    this.contactNumber,
    this.email,
    this.address,
    this.studentType,
    this.status,
    this.profileImage,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      studentId: json['studentID'],
      studentNumber: json['studentNumber'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      address: json['address'],
      studentType: json['studentType'],
      status: json['status'],
      profileImage: json['profileImage'],
    );
  }

  String get fullName => '$firstName $lastName';

  String get fullNameWithMiddle =>
      '$firstName ${middleName ?? ''} $lastName'.trim();

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentId,
      'studentNumber': studentNumber,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'gender': gender,
      'birthDate': birthDate,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'studentType': studentType,
      'status': status,
      'profileImage': profileImage,
    };
  }
}
