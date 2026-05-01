// lib/screens/enrollment/oldstudent/old_student_verify.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';
import 'package:onlineenrollment/services/api_service.dart';
import 'student_info.dart';

class OldStudentVerifyPage extends StatefulWidget {
  const OldStudentVerifyPage({super.key});

  @override
  State<OldStudentVerifyPage> createState() => _OldStudentVerifyPageState();
}

class _OldStudentVerifyPageState extends State<OldStudentVerifyPage> {
  final TextEditingController studentIdController = TextEditingController();
  bool _isLoading = false;
  int? loggedInStudentId;
  Map<String, dynamic>? fetchedStudentData;

  @override
  void initState() {
    super.initState();
    _getLoggedInStudentId();
  }

  Future<void> _getLoggedInStudentId() async {
    loggedInStudentId = await ApiService.getStudentId();
    print('🔐 LOGGED IN STUDENT ID: $loggedInStudentId');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _verifyStudent() async {
    final String enteredId = studentIdController.text.trim();

    if (enteredId.isEmpty) {
      _showSnackBar('Please enter your Student ID', isError: true);
      return;
    }

    final int? enteredIdInt = int.tryParse(enteredId);
    if (enteredIdInt == null) {
      _showSnackBar('Invalid Student ID. Numbers only.', isError: true);
      return;
    }

    if (loggedInStudentId == null) {
      _showSnackBar('Please login again', isError: true);
      return;
    }

    if (enteredIdInt != loggedInStudentId) {
      _showSnackBar(
        '❌ ERROR: You are logged in as Student ID $loggedInStudentId. '
        'You cannot enroll as Student ID $enteredIdInt!',
        isError: true,
      );
      studentIdController.clear();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.getStudent(enteredIdInt);

      print('Student response: $response');

      if (response['status'] == 200 && response['data'] != null) {
        fetchedStudentData = response['data'];
        _showSnackBar(
          '✅ Verified! Welcome ${response['data']['firstName']}',
          isError: false,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudentInfoPage(studentData: fetchedStudentData!),
          ),
        );
      } else {
        _showSnackBar('Student not found', isError: true);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
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
                      _buildStep(1, 'Verify', true),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: const Color(0xFF2901B7),
                        ),
                      ),
                      _buildStep(2, 'Student Info', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _buildStep(3, 'Enrollment', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _buildStep(4, 'Payment', false),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
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
                        const Icon(
                          Icons.verified_user,
                          size: 60,
                          color: Color(0xFF2901B7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Student Verification',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2901B7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your Student ID to continue',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (loggedInStudentId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'You are logged in as Student ID: $loggedInStudentId',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: studentIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Student ID',
                            hintText: 'Enter your Student ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.badge,
                              color: Color(0xFF2901B7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyStudent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2901B7),
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
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'VERIFY →',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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

  Widget _buildStep(int number, String label, bool isActive) {
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
              number.toString(),
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
