// lib/screens/enrollment/newstudent/newstudent_enrollment_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/services/api_service.dart';
import '../../widgets/page_header.dart';
import '../document_page.dart';
import 'dart:convert';

class EnrollmentInfoPage extends StatefulWidget {
  final int studentId;
  final String studentNumber;
  final String studentName;

  const EnrollmentInfoPage({
    super.key,
    required this.studentId,
    required this.studentNumber,
    required this.studentName,
  });

  @override
  State<EnrollmentInfoPage> createState() => _EnrollmentInfoPageState();
}

class _EnrollmentInfoPageState extends State<EnrollmentInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController studentNoController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  String? selectedCourse;
  String? selectedYearLevel;
  String? selectedSemester;
  String? schoolYear;

  bool _isLoading = false;

  final List<String> yearLevels = ['1', '2', '3', '4'];
  final List<String> semesters = ['1st Semester', '2nd Semester'];
  final List<String> courses = [
    'BS Computer Science',
    'BS Information Technology',
    'BS Hospitality Management',
    'BS Business Administration',
    'BS Accountancy',
  ];

  @override
  void initState() {
    super.initState();
    studentNoController.text = widget.studentNumber;
    studentIdController.text = widget.studentId.toString();
    _generateSchoolYear();
    _autoSelectSemester();
  }

  void _generateSchoolYear() {
    int currentYear = DateTime.now().year;
    int nextYear = currentYear + 1;
    schoolYear = '$currentYear-$nextYear';
  }

  void _autoSelectSemester() {
    int currentMonth = DateTime.now().month;
    if (currentMonth >= 8 || currentMonth == 1) {
      selectedSemester = '1st Semester';
    } else {
      selectedSemester = '2nd Semester';
    }
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

  Future<void> _saveToApi() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    if (selectedCourse == null || selectedCourse!.isEmpty) {
      _showSnackBar('Please select a course', isError: true);
      return;
    }

    if (selectedYearLevel == null || selectedYearLevel!.isEmpty) {
      _showSnackBar('Please select year level', isError: true);
      return;
    }

    if (selectedSemester == null || selectedSemester!.isEmpty) {
      _showSnackBar('Please select semester', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final int yearLevelInt = int.parse(selectedYearLevel!);

      final enrollmentData = {
        'StudentID': widget.studentId,
        'Course': selectedCourse!.trim(),
        'YearLevel': yearLevelInt,
        'SchoolYear': schoolYear,
        'Semester': selectedSemester,
        'EnrollmentStatus': 'Pending', // ✅ REQUIRED BY API!
      };

      print('📤 Sending: $enrollmentData');

      final response = await ApiService.createEnrollment(enrollmentData);

      print('📥 Response: $response');

      if (response['status'] == 200) {
        int enrollmentId = response['data']['enrollmentID'];

        _showSnackBar('Enrollment successful!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentPage(
              studentId: widget.studentId.toString(),
              enrollmentId: enrollmentId.toString(),
              studentName: widget.studentName,
            ),
          ),
        );
      } else {
        _showSnackBar('Failed: ${response['message']}', isError: true);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error: $e');
      _showSnackBar('Error: ${e.toString()}', isError: true);
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _step(1, 'Personal', false),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _step(2, 'Enrollment', true),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _step(3, 'Documents', false),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _step(4, 'Payment', false),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildSectionCard(
                      title: 'ENROLLMENT INFORMATION',
                      icon: Icons.school,
                      children: [
                        _buildReadOnlyField(
                          label: 'Student No.',
                          value: widget.studentNumber,
                        ),
                        const SizedBox(height: 12),
                        _buildReadOnlyField(
                          label: 'Student ID',
                          value: studentIdController.text,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Course *',
                          value: selectedCourse,
                          items: courses,
                          onChanged: (value) =>
                              setState(() => selectedCourse = value),
                        ),
                        const SizedBox(height: 12),
                        _buildYearLevelDropdown(),
                        const SizedBox(height: 12),
                        _buildReadOnlyField(
                          label: 'School Year',
                          value: schoolYear ?? '',
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Semester *',
                          value: selectedSemester,
                          items: semesters,
                          onChanged: (value) =>
                              setState(() => selectedSemester = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveToApi,
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
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'NEXT',
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
          ),
        ],
      ),
    );
  }

  Widget _buildYearLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year Level *',
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedYearLevel,
          hint: const Text('Select year level (1, 2, 3, 4)'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: yearLevels.map((year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(year, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYearLevel = value;
            });
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2901B7).withOpacity(0.05),
                  const Color(0xFF4A2FBD).withOpacity(0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2901B7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF2901B7), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2901B7),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value.isEmpty ? 'Not provided' : value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: value.isEmpty ? Colors.grey[500] : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text('Select $label'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _step(int num, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active
              ? const Color(0xFF2901B7)
              : Colors.grey.shade400,
          child: Text(
            '$num',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? const Color(0xFF2901B7) : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    studentNoController.dispose();
    studentIdController.dispose();
    super.dispose();
  }
}
