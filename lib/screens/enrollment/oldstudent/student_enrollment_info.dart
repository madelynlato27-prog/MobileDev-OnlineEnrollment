// lib/screens/enrollment/oldstudent/student_enrollment.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/services/api_service.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';
import 'package:onlineenrollment/screens/enrollment/payment_page.dart';

class StudentEnrollmentPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentEnrollmentPage({super.key, required this.studentData});

  @override
  State<StudentEnrollmentPage> createState() => _StudentEnrollmentPageState();
}

class _StudentEnrollmentPageState extends State<StudentEnrollmentPage> {
  final TextEditingController schoolYearController = TextEditingController();
  String? selectedCourse; // Auto gikan sa current enrollment
  String? selectedYearLevel;
  String? selectedSemester;
  bool _isLoading = true;
  bool _hasExistingEnrollment = false;

  final List<String> yearLevels = ['1', '2', '3', '4'];
  final List<String> semesters = ['1st Semester', '2nd Semester'];

  @override
  void initState() {
    super.initState();
    _loadCurrentEnrollment();
    _autoGenerateSchoolYear();
    _autoSelectSemester();
  }

  Future<void> _loadCurrentEnrollment() async {
    setState(() => _isLoading = true);

    try {
      final studentId = widget.studentData['studentID'];
      final response = await ApiService.getEnrollmentsByStudent(studentId);

      if (response['status'] == 200 &&
          response['data'] != null &&
          response['data'].isNotEmpty) {
        // Kuhaon ang pinaka-una nga enrollment (latest)
        final currentEnrollment = response['data'].first;

        setState(() {
          selectedCourse =
              currentEnrollment['course']; // ✅ Auto gikan sa database
          _hasExistingEnrollment = true;
          _isLoading = false;
        });

        print('✅ Current Course Loaded: $selectedCourse');
      } else {
        setState(() {
          _hasExistingEnrollment = false;
          _isLoading = false;
        });
        _showSnackBar(
          'No existing enrollment found. Please contact registrar.',
          isError: true,
        );
      }
    } catch (e) {
      print('❌ Error loading enrollment: $e');
      setState(() {
        _isLoading = false;
        _hasExistingEnrollment = false;
      });
    }
  }

  void _autoGenerateSchoolYear() {
    int currentYear = DateTime.now().year;
    int nextYear = currentYear + 1;
    schoolYearController.text = '$currentYear-$nextYear';
  }

  void _autoSelectSemester() {
    int currentMonth = DateTime.now().month;
    selectedSemester = (currentMonth >= 8 || currentMonth == 1)
        ? '1st Semester'
        : '2nd Semester';
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createEnrollment() async {
    if (selectedYearLevel == null) {
      _showSnackBar('Please select year level', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final enrollmentData = {
        'StudentID': widget.studentData['studentID'],
        'Course': selectedCourse, // ✅ Auto gikan sa database, dili maka-pili
        'YearLevel': int.parse(selectedYearLevel!),
        'SchoolYear': schoolYearController.text,
        'Semester': selectedSemester,
        'EnrollmentStatus': 'Pending',
      };

      print('📤 Enrollment Data: $enrollmentData');

      final response = await ApiService.createEnrollment(enrollmentData);

      print('📥 Response: $response');

      if (response['status'] == 200) {
        final enrollmentId = response['data']['enrollmentID'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              studentId: widget.studentData['studentID'].toString(),
              enrollmentId: enrollmentId.toString(),
              studentName:
                  '${widget.studentData['firstName']} ${widget.studentData['lastName']}',
            ),
          ),
        );
      } else {
        _showSnackBar(
          'Enrollment failed: ${response['message']}',
          isError: true,
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error: $e');
      _showSnackBar('Error: $e', isError: true);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageHeader(showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _step(1, 'Verify', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(2, 'Student Info', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(3, 'Enrollment', true),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(4, 'Payment', false),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF2901B7)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Student: ${widget.studentData['firstName']} ${widget.studentData['lastName']}',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2901B7), Color(0xFF4A2FBD)],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.school, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'ENROLLMENT INFORMATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    // ✅ Course - READ ONLY (dili maka-pili, auto gikan sa database)
                                    TextFormField(
                                      initialValue:
                                          selectedCourse ?? 'Loading...',
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText: 'Course *',
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    // ✅ Year Level - Pwede maka-pili
                                    DropdownButtonFormField<String>(
                                      value: selectedYearLevel,
                                      decoration: const InputDecoration(
                                        labelText: 'Year Level *',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: yearLevels
                                          .map(
                                            (y) => DropdownMenuItem(
                                              value: y,
                                              child: Text(y),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => selectedYearLevel = v),
                                    ),
                                    const SizedBox(height: 15),

                                    // ✅ School Year - Auto (read-only)
                                    TextFormField(
                                      controller: schoolYearController,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText: 'School Year',
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    // ✅ Semester - Pwede maka-pili
                                    DropdownButtonFormField<String>(
                                      value: selectedSemester,
                                      decoration: const InputDecoration(
                                        labelText: 'Semester *',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: semesters
                                          .map(
                                            (s) => DropdownMenuItem(
                                              value: s,
                                              child: Text(s),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => selectedSemester = v),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createEnrollment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasExistingEnrollment
                            ? const Color(0xFF2901B7)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'PROCEED TO PAYMENT →',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(int num, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2901B7) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF2901B7) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
