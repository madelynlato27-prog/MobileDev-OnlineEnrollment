// lib/models/payment_model.dart
class PaymentModel {
  int? paymentID;
  int enrollmentID;
  double amount;
  String paymentStatus; // Pending, Approved, Rejected
  DateTime paymentDate;

  PaymentModel({
    this.paymentID,
    required this.enrollmentID,
    required this.amount,
    this.paymentStatus = 'Pending',
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() => {
    'paymentID': paymentID,
    'enrollmentID': enrollmentID,
    'amount': amount,
    'paymentStatus': paymentStatus,
    'paymentDate': paymentDate.toIso8601String(),
  };

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentID: json['paymentID'],
      enrollmentID: json['enrollmentID'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      paymentDate: json['paymentDate'] != null 
          ? DateTime.parse(json['paymentDate']) 
          : DateTime.now(),
    );
  }

  bool get isPending => paymentStatus == 'Pending';
  bool get isApproved => paymentStatus == 'Approved';
  bool get isRejected => paymentStatus == 'Rejected';
  
  String get formattedAmount => '₱${amount.toStringAsFixed(2)}';
}

class PaymentRequest {
  final int enrollmentID;
  final double amount;

  PaymentRequest({
    required this.enrollmentID,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'enrollmentID': enrollmentID,
    'amount': amount,
  };
}