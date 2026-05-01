// lib/models/validation_model.dart
class ValidationModel {
  bool hasIncompleteGrades;
  bool hasPendingBalance;
  bool hasPendingEnrollment;
  bool canEnroll;

  ValidationModel({
    this.hasIncompleteGrades = false,
    this.hasPendingBalance = false,
    this.hasPendingEnrollment = false,
    this.canEnroll = true,
  });

  factory ValidationModel.fromJson(Map<String, dynamic> json) {
    return ValidationModel(
      hasIncompleteGrades: json['hasIncompleteGrades'] ?? false,
      hasPendingBalance: json['hasPendingBalance'] ?? false,
      hasPendingEnrollment: json['hasPendingEnrollment'] ?? false,
      canEnroll: json['canEnroll'] ?? true,
    );
  }

  List<String> get issues {
    final List<String> issuesList = [];
    if (hasIncompleteGrades) issuesList.add('Incomplete Grades');
    if (hasPendingBalance) issuesList.add('Pending Balance');
    if (hasPendingEnrollment) issuesList.add('Pending Enrollment');
    return issuesList;
  }
}