// lib/models/document_model.dart
class DocumentModel {
  int? documentID;
  int studentID;
  String documentType;
  String filePath;
  bool isApproved;
  DateTime uploadedDate;

  DocumentModel({
    this.documentID,
    required this.studentID,
    required this.documentType,
    required this.filePath,
    this.isApproved = false,
    required this.uploadedDate,
  });

  Map<String, dynamic> toJson() => {
    'documentID': documentID,
    'studentID': studentID,
    'documentType': documentType,
    'filePath': filePath,
    'isApproved': isApproved,
    'uploadedDate': uploadedDate.toIso8601String(),
  };

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentID: json['documentID'],
      studentID: json['studentID'] ?? 0,
      documentType: json['documentType'] ?? '',
      filePath: json['filePath'] ?? '',
      isApproved: json['isApproved'] ?? false,
      uploadedDate: json['uploadedDate'] != null 
          ? DateTime.parse(json['uploadedDate']) 
          : DateTime.now(),
    );
  }

  String get documentIcon {
    switch (documentType.toLowerCase()) {
      case 'birth certificate':
        return '📄';
      case 'report card':
        return '📊';
      case 'good moral certificate':
        return '⭐';
      case 'transfer credentials':
        return '🔄';
      case '2x2 id picture':
        return '📷';
      default:
        return '📎';
    }
  }
}