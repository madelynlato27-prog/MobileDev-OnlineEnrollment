// lib/models/enrollment_model.dart

class EnrollmentModel {
  int? enrollmentID;
  int studentID;
  String course;
  int yearLevel; // ✅ Change from String? to int
  String schoolYear;
  String semester;
  String enrollmentStatus;

  EnrollmentModel({
    this.enrollmentID,
    required this.studentID,
    required this.course,
    required this.yearLevel, // ✅ Required int
    required this.schoolYear,
    required this.semester,
    this.enrollmentStatus = 'Pending',
  });

  Map<String, dynamic> toJson() => {
    'studentID': studentID, // ✅ camelCase (matches your SP)
    'course': course, // ✅ camelCase
    'yearLevel': yearLevel, // ✅ camelCase int
    'schoolYear': schoolYear, // ✅ camelCase
    'semester': semester, // ✅ camelCase
  };
  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      enrollmentID: json['enrollmentID'],
      studentID: json['studentID'] ?? 0,
      course: json['course'] ?? '',
      yearLevel: json['yearLevel'] ?? 0, // ✅ int
      schoolYear: json['schoolYear'] ?? '',
      semester: json['semester'] ?? '',
      enrollmentStatus: json['enrollmentStatus'] ?? 'Pending',
    );
  }

  bool get isPending => enrollmentStatus == 'Pending';
  bool get isApproved => enrollmentStatus == 'Approved';
  bool get isRejected => enrollmentStatus == 'Rejected';
  bool get isEnrolled => enrollmentStatus == 'Enrolled';

  String get statusText => enrollmentStatus;

  String get statusColorValue {
    switch (enrollmentStatus) {
      case 'Approved':
        return 'green';
      case 'Pending':
        return 'orange';
      case 'Rejected':
        return 'red';
      case 'Enrolled':
        return 'blue';
      default:
        return 'grey';
    }
  }
}
