import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'document_page.dart';
import '../widgets/page_header.dart';

class EnrollmentFormPage extends StatefulWidget {
  const EnrollmentFormPage({super.key});

  @override
  State<EnrollmentFormPage> createState() => _EnrollmentFormPageState();
}

class _EnrollmentFormPageState extends State<EnrollmentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController enrollmentIdController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController schoolYearController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String? selectedGender;
  String? selectedCourse;
  String? selectedYearLevel;
  String? selectedSemester;

  final List<String> genders = ['Male', 'Female'];
  final List<String> yearLevels = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
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
  // Auto-generate Enrollment ID
  enrollmentIdController.text = 'EN-${DateTime.now().year}-${DateTime.now().millisecond}';
  
  // Auto-generate School Year
  _autoGenerateSchoolYear();
  
  // Auto-select current semester
  _autoSelectSemester();
}

void _autoGenerateSchoolYear() {
  int currentYear = DateTime.now().year;
  int nextYear = currentYear + 1;
  
  // School year format: "2024-2025"
  schoolYearController.text = '$currentYear-$nextYear';
}

void _autoSelectSemester() {
  int currentMonth = DateTime.now().month;
  
  // 1st Semester: August to January (months 8,9,10,11,12,1)
  // 2nd Semester: February to July (months 2,3,4,5,6,7)
  if (currentMonth >= 8 || currentMonth == 1) {
    selectedSemester = '1st Semester';
  } else {
    selectedSemester = '2nd Semester';
  }
}
  @override
  void dispose() {
    enrollmentIdController.dispose();
    studentIdController.dispose();
    schoolYearController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    middleInitialController.dispose();
    ageController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with Logo and School Name
          const PageHeader(
            showBackButton: true,
          ),
          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Indicator
                    Row(
                      children: [
                        _buildStep(1, 'Info', true),
                        Expanded(child: Container(height: 2, color: const Color(0xFF2901B7))),
                        _buildStep(2, 'Docs', false),
                        Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                        _buildStep(3, 'Payment', false),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // ENROLLMENT INFORMATION CARD
                    _buildSectionCard(
                      title: 'ENROLLMENT INFORMATION',
                      icon: Icons.school,
                      children: [
                        _buildReadOnlyField(
                          controller: enrollmentIdController,
                          label: 'Enrollment ID',
                          icon: Icons.confirmation_number,
                        ),
                        const SizedBox(height: 15),
                        _buildDropdownField(
                          value: selectedCourse,
                          label: 'Course *',
                          icon: Icons.school,
                          items: courses,
                          onChanged: (value) => setState(() => selectedCourse = value),
                        ),
                        const SizedBox(height: 15),
                        _buildDropdownField(
                          value: selectedYearLevel,
                          label: 'Year Level *',
                          icon: Icons.grade,
                          items: yearLevels,
                          onChanged: (value) => setState(() => selectedYearLevel = value),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildReadOnlyField(
                                controller: schoolYearController,
                                label: 'School Year',
                                icon: Icons.calendar_today,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                value: selectedSemester,
                                label: 'Semester *',
                                icon: Icons.calendar_month,
                                items: semesters,
                                onChanged: (value) => setState(() => selectedSemester = value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // PERSONAL INFORMATION CARD
                    _buildSectionCard(
                      title: 'PERSONAL INFORMATION',
                      icon: Icons.person,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: firstNameController,
                                label: 'First Name *',
                                icon: Icons.person,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: lastNameController,
                                label: 'Last Name *',
                                icon: Icons.person,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: middleInitialController,
                          label: 'Middle Name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: ageController,
                                label: 'Age *',
                                icon: Icons.numbers,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                value: selectedGender,
                                label: 'Gender *',
                                icon: Icons.people,
                                items: genders,
                                onChanged: (value) => setState(() => selectedGender = value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildDateField(
                          controller: birthdateController,
                          label: 'Birthdate *',
                          icon: Icons.cake,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: contactController,
                          label: 'Contact Number *',
                          hint: '09xxxxxxxxx',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email Address *',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!value.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: addressController,
                          label: 'Complete Address *',
                          icon: Icons.location_on,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DocumentPage(
                                  studentName: '${firstNameController.text} ${lastNameController.text}',
                                  studentId: studentIdController.text,
                                  enrollmentId: enrollmentIdController.text,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2901B7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'NEXT → DOCUMENTS',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Card Widget
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(fontSize: 14),
        hintText: hint,
        hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2901B7), width: 2),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7), size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: validator ?? (label.contains('*') ? (value) => value!.isEmpty ? 'Required' : null : null),
    );
  }

  // Read-only Field Widget
  Widget _buildReadOnlyField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7), size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  // Dropdown Field Widget
  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2901B7), width: 2),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7), size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.roboto(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  // Date Field Widget
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2901B7), width: 2),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2901B7), size: 20),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: const Color(0xFF2901B7), size: 18),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                controller.text = '${picked.month}/${picked.day}/${picked.year}';
              });
            }
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (value) => value!.isEmpty ? 'Required' : null,
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
            border: !isActive ? Border.all(color: Colors.grey.shade300) : null,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: GoogleFonts.montserrat(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: isActive ? const Color(0xFF2901B7) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}