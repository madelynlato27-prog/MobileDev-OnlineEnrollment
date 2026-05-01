import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';
import 'package:onlineenrollment/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? studentData;
  final bool isLoading;

  const ProfilePage({super.key, this.studentData, this.isLoading = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _studentData;
  bool _isLoading = true;
  bool _isEditing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    if (widget.studentData != null) {
      setState(() {
        _studentData = widget.studentData;
        _isLoading = widget.isLoading;
        _initControllers();
      });
    } else {
      try {
        final studentId = await ApiService.getStudentId();
        if (studentId != null) {
          final response = await ApiService.getStudent(studentId);
          if (response['status'] == 200 && response['data'] != null) {
            setState(() {
              _studentData = response['data'];
              _isLoading = false;
              _initControllers();
            });
          } else {
            setState(() => _isLoading = false);
          }
        } else {
          setState(() => _isLoading = false);
        }
      } catch (e) {
        print('Error loading student data: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  void _initControllers() {
    _firstNameController = TextEditingController(
      text: _studentData?['firstName'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: _studentData?['lastName'] ?? '',
    );
    _middleNameController = TextEditingController(
      text: _studentData?['middleName'] ?? '',
    );
    _contactController = TextEditingController(
      text: _studentData?['contactNumber'] ?? '',
    );
    _emailController = TextEditingController(
      text: _studentData?['email'] ?? '',
    );
    _addressController = TextEditingController(
      text: _studentData?['address'] ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      final updateData = {
        "studentID": _studentData?['studentID'],
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "middleName": _middleNameController.text.trim().isEmpty
            ? null
            : _middleNameController.text.trim(),
        "contactNumber": _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        "email": _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        "address": _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
      };

      final response = await ApiService.updateStudent(updateData);

      if (response['status'] == 200) {
        setState(() {
          _studentData?['firstName'] = _firstNameController.text.trim();
          _studentData?['lastName'] = _lastNameController.text.trim();
          _studentData?['middleName'] = _middleNameController.text.trim();
          _studentData?['contactNumber'] = _contactController.text.trim();
          _studentData?['email'] = _emailController.text.trim();
          _studentData?['address'] = _addressController.text.trim();
          _isEditing = false;
        });
        _showSnackBar('Profile updated successfully!');
      } else {
        _showSnackBar(response['message'] ?? 'Update failed', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageHeader(showBackButton: true),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _studentData == null
                ? const Center(child: Text('No student data available'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Profile Header Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2901B7), Color(0xFF4A2FBD)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Color(0xFF2901B7),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Name and ID
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_studentData?['firstName'] ?? ''} ${_studentData?['lastName'] ?? ''}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${_studentData?['studentID'] ?? 'N/A'}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _studentData?['email'] ?? 'No email',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            _studentData?['status'] ==
                                                'Approved'
                                            ? Colors.green
                                            : (_studentData?['status'] ==
                                                      'Pending'
                                                  ? Colors.orange
                                                  : Colors.red),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _studentData?['status'] ?? 'Pending',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Edit/Save Button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_isEditing) {
                                    _saveChanges();
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                icon: Icon(
                                  _isEditing ? Icons.save : Icons.edit,
                                ),
                                label: Text(
                                  _isEditing ? 'SAVE CHANGES' : 'EDIT PROFILE',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isEditing
                                      ? Colors.green
                                      : const Color(0xFF2901B7),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            if (_isEditing) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                      _initControllers(); // Reset to original data
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text('CANCEL'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Personal Information
                        _buildSection('Personal Information', [
                          _buildField(
                            'First Name',
                            _firstNameController,
                            enabled: _isEditing,
                          ),
                          _buildField(
                            'Last Name',
                            _lastNameController,
                            enabled: _isEditing,
                          ),
                          _buildField(
                            'Middle Name',
                            _middleNameController,
                            enabled: _isEditing,
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Contact Information
                        _buildSection('Contact Information', [
                          _buildField(
                            'Contact Number',
                            _contactController,
                            enabled: _isEditing,
                          ),
                          _buildField(
                            'Email Address',
                            _emailController,
                            enabled: _isEditing,
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Address
                        _buildSection('Address', [
                          _buildField(
                            'Complete Address',
                            _addressController,
                            enabled: _isEditing,
                            maxLines: 3,
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Account Information
                        _buildSection('Account Information', [
                          _buildReadOnlyField(
                            'Student Type',
                            _studentData?['studentType'] ?? 'N/A',
                          ),
                          _buildReadOnlyField(
                            'Student Number',
                            _studentData?['studentNumber'] ?? 'N/A',
                          ),
                        ]),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2901B7).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2901B7),
              ),
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool enabled = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          enabled
              ? TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    controller.text.isEmpty ? 'Not provided' : controller.text,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: controller.text.isEmpty
                          ? Colors.grey[500]
                          : Colors.black87,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
