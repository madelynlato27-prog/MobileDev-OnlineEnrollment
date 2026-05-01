// lib/models/grades_model.dart
class GradesModel {
  int? gradeID;
  int studentID;
  String subjectName;
  String schoolYear;
  String semester;
  double? grade;
  String? remarks;

  GradesModel({
    this.gradeID,
    required this.studentID,
    required this.subjectName,
    required this.schoolYear,
    required this.semester,
    this.grade,
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
    'gradeID': gradeID,
    'studentID': studentID,
    'subjectName': subjectName,
    'schoolYear': schoolYear,
    'semester': semester,
    'grade': grade,
    'remarks': remarks,
  };

  factory GradesModel.fromJson(Map<String, dynamic> json) {
    return GradesModel(
      gradeID: json['gradeID'],
      studentID: json['studentID'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      schoolYear: json['schoolYear'] ?? '',
      semester: json['semester'] ?? '',
      grade: json['grade'] != null ? (json['grade'] as num).toDouble() : null,
      remarks: json['remarks'],
    );
  }

  String get letterGrade {
    if (grade == null) return 'N/A';
    if (grade! >= 96) return 'A+';
    if (grade! >= 91) return 'A';
    if (grade! >= 86) return 'B+';
    if (grade! >= 81) return 'B';
    if (grade! >= 75) return 'C';
    if (grade! >= 70) return 'D';
    return 'F';
  }
  
  bool get isPassed => grade != null && grade! >= 75;
}