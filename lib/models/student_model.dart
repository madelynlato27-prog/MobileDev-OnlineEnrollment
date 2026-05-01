// lib/models/student_model.dart
class StudentModel {
  int? studentID;
  String? studentNumber;
  String firstName;
  String lastName;
  String? middleName;
  String gender;
  DateTime birthDate;
  String? contactNumber;
  String? email;
  String? address;
  String studentType; // New / Old
  String? status; // Pending / Approved
  DateTime? dateCreated;

  StudentModel({
    this.studentID,
    this.studentNumber,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.gender,
    required this.birthDate,
    this.contactNumber,
    this.email,
    this.address,
    required this.studentType,
    this.status,
    this.dateCreated,
  });

  Map<String, dynamic> toJson() => {
    'studentID': studentID,
    'studentNumber': studentNumber,
    'firstName': firstName,
    'lastName': lastName,
    'middleName': middleName,
    'gender': gender,
    'birthDate': birthDate.toIso8601String(),
    'contactNumber': contactNumber,
    'email': email,
    'address': address,
    'studentType': studentType,
    'status': status,
    'dateCreated': dateCreated?.toIso8601String(),
  };

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentID: json['studentID'],
      studentNumber: json['studentNumber'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'],
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate']) 
          : DateTime.now(),
      contactNumber: json['contactNumber'],
      email: json['email'],
      address: json['address'],
      studentType: json['studentType'] ?? 'New',
      status: json['status'],
      dateCreated: json['dateCreated'] != null 
          ? DateTime.parse(json['dateCreated']) 
          : null,
    );
  }

  String get fullName => '$firstName $lastName';
  String get fullNameWithMiddle => '$firstName ${middleName ?? ''} $lastName'.trim();
}

class StudentDocumentModel {
  int? documentID;
  int studentID;
  String documentType;
  String filePath;
  bool isApproved;
  DateTime uploadedDate;

  StudentDocumentModel({
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

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentModel(
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
}