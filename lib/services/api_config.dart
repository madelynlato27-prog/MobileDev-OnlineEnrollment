// lib/services/api_config.dart
class ApiConfig {
  // Change this to your API URL
  static const String baseUrl = 'http://192.168.1.8:5080';
  //static const String baseUrl = 'http://172.20.10.4:5080';
  static const String apiUrl = '$baseUrl/api';

  // AUTH ENDPOINTS
  static const String login = '$apiUrl/auth/login';
  static const String createStudentLogin = '$apiUrl/auth/create-student';
  static const String createStaffLogin = '$apiUrl/auth/create-staff';

  // STUDENT ENDPOINTS
  static const String createStudent = '$apiUrl/Student';
  static const String updateStudent = '$apiUrl/Student';
  static const String getStudent = '$apiUrl/Student';
  static const String getStudentLogin =
      '$apiUrl/student/login'; // NEW: Get approved username/password
  static const String getAllStudents = '$apiUrl/Student/AllStudents';
  static const String uploadDocument = '$apiUrl/Student/documents';
  static const String getDocuments = '$apiUrl/Student/documents';

  // ENROLLMENT ENDPOINTS
  static const String createEnrollment = '$apiUrl/Enrollment';
  static const String getAllEnrollments = '$apiUrl/Enrollment';
  static const String getPendingEnrollments = '$apiUrl/Enrollment/pending';
  static const String getEnrollmentsByStudent =
      '$apiUrl/Enrollment/student'; // GET: Course, YearLevel, Semester, SchoolYear, Status
  static const String approveEnrollment = '$apiUrl/Enrollment';
  static const String rejectEnrollment = '$apiUrl/Enrollment';
  static const String completeEnrollment = '$apiUrl/Enrollment';

  // PAYMENT ENDPOINTS
  static const String createPayment = '$apiUrl/Payment';
  static const String getAllPayments = '$apiUrl/Payment';
  static const String getPendingPayments = '$apiUrl/Payment/pending';
  static const String getPaymentsByEnrollment =
      '$apiUrl/Payment/enrollment'; // GET: Payments by enrollment ID
  static const String getPaymentById = '$apiUrl/Payment';
  static const String approvePayment = '$apiUrl/Payment';
  static const String rejectPayment = '$apiUrl/Payment';

  // NOTIFICATION ENDPOINTS
  static const String createNotification = '$apiUrl/Notification';
  static const String getNotifications =
      '$apiUrl/Notification'; // GET: /{studentID} - For tracking account
  static const String markNotificationRead = '$apiUrl/Notification/read';

  // GRADES ENDPOINTS
  static const String addGrade = '$apiUrl/Grades';
  static const String updateGrade = '$apiUrl/Grades';
  static const String getGradesByStudent =
      '$apiUrl/Grades/student'; // GET: /{studentID} - Returns SubjectName, SchoolYear, Semester, Grade, Remarks
  static const String getGradeById = '$apiUrl/Grades';

  // VALIDATION ENDPOINTS
  static const String validateStudent =
      '$apiUrl/Validation'; // GET: /{studentID} - Check if student can enroll

  // STUDENT DOCUMENT ENDPOINTS
  static const String insertStudentDocument =
      '$apiUrl/StudentDocument/InsertStudentDocument';
  static const String getAllDocuments = '$apiUrl/StudentDocument/AllDocuments';
}
