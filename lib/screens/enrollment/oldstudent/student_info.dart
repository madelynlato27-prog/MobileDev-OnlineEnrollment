import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import '../../widgets/page_header.dart';
import 'package:onlineenrollment/screens/enrollment/oldstudent/student_enrollment_info.dart';

class StudentInfoPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentInfoPage({super.key, required this.studentData});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController middleNameController;
  late TextEditingController contactController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(
      text: widget.studentData['firstName'] ?? '',
    );
    lastNameController = TextEditingController(
      text: widget.studentData['lastName'] ?? '',
    );
    middleNameController = TextEditingController(
      text: widget.studentData['middleName'] ?? '',
    );
    contactController = TextEditingController(
      text: widget.studentData['contactNumber'] ?? '',
    );
    emailController = TextEditingController(
      text: widget.studentData['email'] ?? '',
    );
    addressController = TextEditingController(
      text: widget.studentData['address'] ?? '',
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
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

  Future<void> _saveAndProceed() async {
    setState(() => _isLoading = true);

    try {
      final updateData = {
        "StudentID": widget.studentData['studentID'],
        "FirstName": firstNameController.text.trim(),
        "LastName": lastNameController.text.trim(),
        "MiddleName": middleNameController.text.trim().isEmpty
            ? ""
            : middleNameController.text.trim(),
        "Gender": widget.studentData['gender'] ?? "",
        "BirthDate":
            widget.studentData['birthDate'] ?? DateTime.now().toIso8601String(),
        "ContactNumber": contactController.text.trim().isEmpty
            ? ""
            : contactController.text.trim(),
        "Email": emailController.text.trim().isEmpty
            ? ""
            : emailController.text.trim(),
        "Address": addressController.text.trim().isEmpty
            ? ""
            : addressController.text.trim(),
        "StudentType": widget.studentData['studentType'] ?? "Old",
        "Status": widget.studentData['status'] ?? "Approved",
      };

      final response = await ApiService.updateStudent(updateData);

      if (response['status'] == 200) {
        _showSnackBar('Information saved!');

        widget.studentData['firstName'] = firstNameController.text.trim();
        widget.studentData['lastName'] = lastNameController.text.trim();
        widget.studentData['middleName'] = middleNameController.text.trim();
        widget.studentData['contactNumber'] = contactController.text.trim();
        widget.studentData['email'] = emailController.text.trim();
        widget.studentData['address'] = addressController.text.trim();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudentEnrollmentPage(studentData: widget.studentData),
          ),
        );
      } else {
        _showSnackBar('Failed to save: ${response['message']}', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
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
                  // Step Indicator
                  Row(
                    children: [
                      _step(1, 'Verify', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(2, 'Student Info', true),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(3, 'Enrollment', false),
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
                        // ✅ Blue Gradient Header
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
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'PERSONAL INFORMATION',
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
                          child: Column(
                            children: [
                              _buildTextField(
                                firstNameController,
                                'First Name',
                                Icons.person,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                lastNameController,
                                'Last Name',
                                Icons.person,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                middleNameController,
                                'Middle Name',
                                Icons.person_outline,
                              ),
                              const SizedBox(height: 12),
                              _buildPhoneField(
                                contactController,
                                'Contact Number',
                                Icons.phone,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                emailController,
                                'Email Address',
                                Icons.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                addressController,
                                'Address',
                                Icons.location_on,
                                maxLines: 2,
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
                      onPressed: _isLoading ? null : _saveAndProceed,
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
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SAVE & PROCEED →',
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
      ),
    );
  }

  Widget _buildPhoneField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 11,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
        counterText: '',
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
