// lib/screens/enrollment/newstudent/newstudent_personal_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';
import 'package:onlineenrollment/services/api_service.dart';
import 'newstudent_enrollment_info.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String? selectedGender;
  bool _isLoading = false;

  final List<String> genders = ['Male', 'Female'];

  String _formatDateForApi(String dateString) {
    if (dateString.isEmpty) return '';
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final month = parts[0].padLeft(2, '0');
      final day = parts[1].padLeft(2, '0');
      final year = parts[2];
      return '$year-$month-$day';
    }
    return dateString;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveToApi() async {
    setState(() => _isLoading = true);

    try {
      final studentData = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "middleName": middleInitialController.text.trim().isEmpty
            ? ""
            : middleInitialController.text.trim(),
        "gender": selectedGender,
        "birthDate": _formatDateForApi(birthdateController.text),
        "contactNumber": contactController.text.trim().isEmpty
            ? ""
            : contactController.text.trim(),
        "email": emailController.text.trim().isEmpty
            ? ""
            : emailController.text.trim(),
        "address": addressController.text.trim().isEmpty
            ? ""
            : addressController.text.trim(),
        "studentType": "New",
        "status": "Pending",
      };

      final response = await ApiService.createStudent(studentData);

      print('📥 API Response: $response');

      if (response['status'] == 200 || response['status'] == 201) {
        final studentId = response['data']['studentID'];
        final studentNumber =
            response['data']['studentNumber'] ?? ''; // ← Auto-generated!
        final firstName =
            response['data']['firstName'] ?? firstNameController.text.trim();
        final lastName =
            response['data']['lastName'] ?? lastNameController.text.trim();

        print('✅ Student Created! ID: $studentId, Number: $studentNumber');

        _showSnackBar('Personal information saved!');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnrollmentInfoPage(
              studentId: studentId,
              studentNumber: studentNumber,
              studentName: '$firstName $lastName',
            ),
          ),
        );
      } else {
        _showSnackBar(response['message'] ?? 'Failed to save', isError: true);
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('Connection error: $e', isError: true);
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _step(1, 'Personal', true),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _step(2, 'Enrollment', false),
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
                    const SizedBox(height: 30),
                    _buildSectionCard(
                      title: 'PERSONAL INFORMATION',
                      icon: Icons.person,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                firstNameController,
                                'First Name *',
                                Icons.person,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                lastNameController,
                                'Last Name *',
                                Icons.person,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          middleInitialController,
                          'Middle Name',
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                ageController,
                                'Age *',
                                Icons.numbers,
                                keyboardType: TextInputType.number,
                                enabled: false,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                selectedGender,
                                'Gender *',
                                Icons.people,
                                genders,
                                (v) => setState(() => selectedGender = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildDateField(
                          birthdateController,
                          'Birthdate *',
                          Icons.cake,
                        ),
                        const SizedBox(height: 15),
                        _buildPhoneField(
                          contactController,
                          'Contact Number *',
                          Icons.phone,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          emailController,
                          'Email Address *',
                          Icons.email,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          addressController,
                          'Complete Address *',
                          Icons.location_on,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey.shade50 : null,
      ),
      validator: (value) {
        if (label.contains('*') && (value == null || value.isEmpty))
          return 'Required';
        if (label.contains('Email') && value != null && value.isNotEmpty) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Enter a valid email';
          }
        }
        return null;
      },
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
        hintText: '09xxxxxxxxx',
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length != 11)
          return 'Contact number must be exactly 11 digits';
        if (!RegExp(r'^09\d{9}$').hasMatch(value))
          return 'Must start with 09 and contain 11 digits';
        return null;
      },
    );
  }

  Widget _buildDropdownField(
    String? value,
    String label,
    IconData icon,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'MM/DD/YYYY',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xFF2901B7)),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                final month = picked.month.toString().padLeft(2, '0');
                final day = picked.day.toString().padLeft(2, '0');
                final year = picked.year;
                controller.text = '$month/$day/$year';
                final age = DateTime.now().difference(picked).inDays ~/ 365;
                ageController.text = age.toString();
              });
            }
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        return null;
      },
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
            fontSize: 10,
            color: active ? const Color(0xFF2901B7) : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
