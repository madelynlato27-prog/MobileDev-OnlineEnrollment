import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'payment_page.dart';
import '../widgets/page_header.dart'; // Add this if you want consistent header

class DocumentPage extends StatefulWidget {
  final String studentName;
  final String studentId;
  final String enrollmentId;

  const DocumentPage({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.enrollmentId,
  });

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final ImagePicker _picker = ImagePicker();
  
  List<Map<String, dynamic>> documents = [
    {'name': 'Birth Certificate', 'required': true, 'uploaded': false, 'bytes': null, 'uploadDate': null},
    {'name': 'Report Card / Form 138', 'required': true, 'uploaded': false, 'bytes': null, 'uploadDate': null},
    {'name': 'Good Moral Certificate', 'required': true, 'uploaded': false, 'bytes': null, 'uploadDate': null},
    {'name': 'Transfer Credentials (for transferees)', 'required': false, 'uploaded': false, 'bytes': null, 'uploadDate': null},
    {'name': '2x2 ID Picture', 'required': true, 'uploaded': false, 'bytes': null, 'uploadDate': null},
    {'name': '1x1 ID Picture', 'required': true, 'uploaded': false, 'bytes': null, 'uploadDate': null},
  ];

  // Get current date and time
  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.month}/${now.day}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // Format file size
  String _getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Pick image with validation
  Future<void> _pickImage(int index) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_camera, color: Colors.blue),
                ),
                title: const Text('Take a Photo'),
                subtitle: const Text('Use camera to capture document'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );
                    if (photo != null) {
                      final bytes = await photo.readAsBytes();
                      final fileSize = await photo.length();
                      setState(() {
                        documents[index]['bytes'] = bytes;
                        documents[index]['uploaded'] = true;
                        documents[index]['uploadDate'] = _getCurrentDateTime();
                        documents[index]['fileSize'] = fileSize;
                      });
                      _showSnackBar(
                        '${documents[index]['name']} uploaded successfully',
                        isError: false,
                      );
                    }
                  } catch (e) {
                    _showSnackBar('Error taking photo: $e', isError: true);
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select from existing photos'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                      maxWidth: 1920,
                      maxHeight: 1080,
                    );
                    if (image != null) {
                      final bytes = await image.readAsBytes();
                      final fileSize = await image.length();
                      setState(() {
                        documents[index]['bytes'] = bytes;
                        documents[index]['uploaded'] = true;
                        documents[index]['uploadDate'] = _getCurrentDateTime();
                        documents[index]['fileSize'] = fileSize;
                      });
                      _showSnackBar(
                        '${documents[index]['name']} uploaded successfully',
                        isError: false,
                      );
                    }
                  } catch (e) {
                    _showSnackBar('Error picking image: $e', isError: true);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // View image with better UI
  void _viewImage(Uint8List imageBytes, String documentName) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              documentName,
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.white, size: 50),
                          SizedBox(height: 10),
                          Text('Failed to load image', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Delete Document'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ${documents[index]['name']}?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                documents[index]['bytes'] = null;
                documents[index]['uploaded'] = false;
                documents[index]['uploadDate'] = null;
                documents[index]['fileSize'] = null;
              });
              Navigator.pop(context);
              _showSnackBar('${documents[index]['name']} deleted', isError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadedCount = documents.where((doc) => doc['uploaded'] == true).length;
    final requiredCount = documents.where((doc) => doc['required'] == true).length;
    final uploadedRequiredCount = documents
        .where((doc) => doc['required'] == true && doc['uploaded'] == true)
        .length;
    
    final allRequiredUploaded = uploadedRequiredCount == requiredCount;

    return Scaffold(
      body: Column(
        children: [
          // Consistent header with PageHeader
          const PageHeader(
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator
                  Row(
                    children: [
                      _buildStep(1, 'Information', true),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: const Color(0xFF2901B7),
                        ),
                      ),
                      _buildStep(2, 'Documents', true),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: allRequiredUploaded 
                              ? const Color(0xFF2901B7) 
                              : Colors.grey.shade300,
                        ),
                      ),
                      _buildStep(3, 'Payment', false),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF2901B7).withOpacity(0.05),
                          const Color(0xFF4A2FBD).withOpacity(0.02),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2901B7).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.upload_file,
                            size: 50,
                            color: Color(0xFF2901B7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Step 2: Upload Documents',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2901B7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Student: ${widget.studentName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'ID: ${widget.studentId}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        
                        // Progress indicator for required documents
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Required Documents Progress',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$uploadedRequiredCount/$requiredCount',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: uploadedRequiredCount / requiredCount,
                                  backgroundColor: Colors.grey.shade200,
                                  color: const Color(0xFF2901B7),
                                  minHeight: 8,
                                ),
                              ),
                              if (allRequiredUploaded)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'All required documents uploaded!',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Documents List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DOCUMENTS ($uploadedCount/${documents.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2901B7),
                        ),
                      ),
                      if (uploadedCount > 0)
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete All Documents'),
                                content: const Text('Are you sure you want to delete all uploaded documents?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('CANCEL'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        for (var i = 0; i < documents.length; i++) {
                                          documents[i]['bytes'] = null;
                                          documents[i]['uploaded'] = false;
                                          documents[i]['uploadDate'] = null;
                                          documents[i]['fileSize'] = null;
                                        }
                                      });
                                      Navigator.pop(context);
                                      _showSnackBar('All documents deleted', isError: false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('DELETE ALL'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_sweep, size: 18),
                          label: const Text('Delete All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 15),

                  // Document List
                  ...documents.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> doc = entry.value;
                    return _buildDocumentTile(doc, index);
                  }),

                  const SizedBox(height: 30),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: allRequiredUploaded
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    studentName: widget.studentName,
                                    studentId: widget.studentId,
                                    enrollmentId: widget.enrollmentId,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2901B7),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        allRequiredUploaded ? 'PROCEED TO PAYMENT →' : 'UPLOAD ALL REQUIRED DOCUMENTS',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
        ],
      ),
    );
  }

  Widget _buildDocumentTile(Map<String, dynamic> doc, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2901B7).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2901B7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.description,
                    size: 20,
                    color: const Color(0xFF2901B7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doc['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2901B7),
                    ),
                  ),
                ),
                if (doc['required'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Required',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Image Preview or Upload Area
          if (doc['uploaded'] && doc['bytes'] != null)
            GestureDetector(
              onTap: () => _viewImage(doc['bytes'], doc['name']),
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.memory(
                      doc['bytes'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tap_and_play, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Tap to view',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () => _pickImage(index),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 50,
                      color: const Color(0xFF2901B7).withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to upload ${doc['name']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supported formats: JPG, PNG',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (doc['uploaded'] && doc['uploadDate'] != null)
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        'Uploaded: ${doc['uploadDate']}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      if (doc['fileSize'] != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.storage, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          _getFileSize(doc['fileSize']),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (doc['uploaded'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              'Uploaded',
                              style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    
                    Row(
                      children: [
                        if (doc['uploaded'] && doc['bytes'] != null) ...[
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(index),
                            tooltip: 'Delete',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _viewImage(doc['bytes'], doc['name']),
                            icon: const Icon(Icons.visibility, size: 16),
                            label: const Text('View'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2901B7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ] else
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(index),
                            icon: const Icon(Icons.cloud_upload, size: 16),
                            label: const Text('Upload'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2901B7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
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
            border: !isActive ? Border.all(color: Colors.grey.shade300) : null,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
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
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF2901B7) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}