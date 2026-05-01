// lib/models/notification_model.dart
class NotificationModel {
  int? notificationID;
  int studentID;
  String message;
  bool isRead;
  DateTime createdDate;

  NotificationModel({
    this.notificationID,
    required this.studentID,
    required this.message,
    this.isRead = false,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'notificationID': notificationID,
    'studentID': studentID,
    'message': message,
    'isRead': isRead,
    'createdDate': createdDate.toIso8601String(),
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationID: json['notificationID'],
      studentID: json['studentID'] ?? 0,
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      createdDate: json['createdDate'] != null 
          ? DateTime.parse(json['createdDate']) 
          : DateTime.now(),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdDate);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}