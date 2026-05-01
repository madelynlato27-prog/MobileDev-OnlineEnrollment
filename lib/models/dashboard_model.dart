// lib/models/dashboard_model.dart
class DashboardStats {
  final int totalEnrollments;
  final int pendingEnrollments;
  final int approvedEnrollments;
  final int completedEnrollments;
  final double totalPayments;
  final double pendingPayments;

  DashboardStats({
    required this.totalEnrollments,
    required this.pendingEnrollments,
    required this.approvedEnrollments,
    required this.completedEnrollments,
    required this.totalPayments,
    required this.pendingPayments,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalEnrollments: json['totalEnrollments'] ?? 0,
      pendingEnrollments: json['pendingEnrollments'] ?? 0,
      approvedEnrollments: json['approvedEnrollments'] ?? 0,
      completedEnrollments: json['completedEnrollments'] ?? 0,
      totalPayments: (json['totalPayments'] ?? 0).toDouble(),
      pendingPayments: (json['pendingPayments'] ?? 0).toDouble(),
    );
  }
}

// Pure data model without Flutter UI dependencies
class DashboardItem {
  final String title;
  final String iconData; // Changed from IconData to String
  final String color; // Changed from Color to String
  final List<String> gradient; // Changed from List<Color> to List<String>
  final String? route;
  final String description;

  const DashboardItem({
    required this.title,
    required this.iconData,
    required this.color,
    required this.gradient,
    this.route,
    required this.description,
  });
}