// lib/screens/dashboard/my_subjects_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/page_header.dart';
import 'package:onlineenrollment/services/api_service.dart';

class MySubjectsPage extends StatefulWidget {
  const MySubjectsPage({super.key});

  @override
  State<MySubjectsPage> createState() => _MySubjectsPageState();
}

class _MySubjectsPageState extends State<MySubjectsPage> {
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _currentEnrollment;

  @override
  void initState() {
    super.initState();
    _loadEnrollmentAndSubjects();
  }

  Future<void> _loadEnrollmentAndSubjects() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final studentId = await ApiService.getStudentId();
      if (studentId == null) {
        setState(() {
          _error = 'Student not found. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final enrollmentResponse = await ApiService.getEnrollmentsByStudent(
        studentId,
      );

      if (enrollmentResponse['status'] == 200 &&
          enrollmentResponse['data'] != null &&
          enrollmentResponse['data'].isNotEmpty) {
        _currentEnrollment = enrollmentResponse['data'].first;

        final course = _currentEnrollment!['course'];
        final yearLevel = _currentEnrollment!['yearLevel'];
        final semester = _currentEnrollment!['semester'];

        final subjectsResponse = await ApiService.getSubjects(
          course: course,
          yearLevel: yearLevel,
          semester: semester,
        );

        if (subjectsResponse['status'] == 200 &&
            subjectsResponse['data'] != null) {
          setState(() {
            _subjects = List<Map<String, dynamic>>.from(
              subjectsResponse['data'],
            );
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = subjectsResponse['message'] ?? 'Failed to load subjects';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'No enrollment found. Please enroll first.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String _getYearLevelText(int? yearLevel) {
    switch (yearLevel) {
      case 1:
        return '1st Year';
      case 2:
        return '2nd Year';
      case 3:
        return '3rd Year';
      case 4:
        return '4th Year';
      default:
        return '${yearLevel ?? 1}th Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageHeader(showBackButton: true),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_error!, style: GoogleFonts.roboto(fontSize: 14)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadEnrollmentAndSubjects,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2901B7),
                          ),
                          child: const Text('RETRY'),
                        ),
                        if (_error ==
                            'No enrollment found. Please enroll first.')
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/enroll-old',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('ENROLL NOW'),
                            ),
                          ),
                      ],
                    ),
                  )
                : _subjects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No subjects found',
                          style: GoogleFonts.montserrat(fontSize: 18),
                        ),
                        if (_currentEnrollment != null)
                          Text(
                            '${_currentEnrollment!['course']} - ${_getYearLevelText(_currentEnrollment!['yearLevel'])} - ${_currentEnrollment!['semester']}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2901B7), Color(0xFF4A2FBD)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentEnrollment?['course'] ?? 'No Course',
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_getYearLevelText(_currentEnrollment?['yearLevel'])} - ${_currentEnrollment?['semester'] ?? ''}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_subjects.length} Subjects',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'My Subjects',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _subjects.length,
                          itemBuilder: (context, index) {
                            final subject = _subjects[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF2901B7,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        subject['SubjectCode']?.substring(
                                              0,
                                              2,
                                            ) ??
                                            '??',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2901B7),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subject['SubjectCode'] ?? '',
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subject['SubjectName'] ?? '',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
