// lib/screens/enrollment/document_page.dart
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'payment_page.dart';
import '../widgets/page_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/services/api_service.dart';

class DocumentPage extends StatefulWidget {
  final String studentId;
  final String enrollmentId;
  final String studentName;

  const DocumentPage({
    super.key,
    required this.studentId,
    required this.enrollmentId,
    required this.studentName,
  });

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> documents = [
    {
      'name': 'Birth Certificate',
      'required': true,
      'uploaded': false,
      'imageBytes': null,
      'uploadDate': null,
      'isUploading': false,
    },
    {
      'name': 'Report Card',
      'required': true,
      'uploaded': false,
      'imageBytes': null,
      'uploadDate': null,
      'isUploading': false,
    },
    {
      'name': 'Good Moral Certificate',
      'required': true,
      'uploaded': false,
      'imageBytes': null,
      'uploadDate': null,
      'isUploading': false,
    },
    {
      'name': 'Transfer Credentials',
      'required': false,
      'uploaded': false,
      'imageBytes': null,
      'uploadDate': null,
      'isUploading': false,
    },
    {
      'name': '2x2 ID Picture',
      'required': true,
      'uploaded': false,
      'imageBytes': null,
      'uploadDate': null,
      'isUploading': false,
    },
  ];

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.month}/${now.day}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickImage(int index) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Take Photo"),
              onTap: () async {
                Navigator.pop(context);
                final photo = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) await _showPreviewAndConfirm(index, photo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) await _showPreviewAndConfirm(index, image);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPreviewAndConfirm(int index, XFile file) async {
    final bytes = await file.readAsBytes();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.image, color: const Color(0xFF2901B7)),
            const SizedBox(width: 10),
            Text(
              'Preview: ${documents[index]['name']}',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 300, // ✅ Fixed width instead of double.infinity
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(bytes, height: 200, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Is this the correct picture?',
                style: GoogleFonts.roboto(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Click CONFIRM to upload, or REPLACE to choose another.',
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'REPLACE',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2901B7),
            ),
            child: const Text('CONFIRM & UPLOAD'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _uploadDocument(index, file, bytes);
    } else {
      _pickImage(index);
    }
  }

  Future<void> _uploadDocument(int index, XFile file, Uint8List bytes) async {
    setState(() {
      documents[index]['isUploading'] = true;
    });

    try {
      final response = await ApiService.uploadDocument(
        studentId: widget.studentId,
        enrollmentId: widget.enrollmentId,
        documentName: documents[index]['name'],
        fileBytes: bytes,
      );

      if (response['status'] == 200) {
        setState(() {
          documents[index]['uploaded'] = true;
          documents[index]['imageBytes'] = bytes;
          documents[index]['uploadDate'] = _getCurrentDateTime();
          documents[index]['isUploading'] = false;
        });
        _showSnackBar('${documents[index]['name']} uploaded successfully');
      } else {
        setState(() {
          documents[index]['isUploading'] = false;
        });
        _showSnackBar('Upload failed: ${response['message']}', isError: true);
      }
    } catch (e) {
      setState(() {
        documents[index]['isUploading'] = false;
      });
      _showSnackBar('Upload error: $e', isError: true);
    }
  }

  void _showImagePreview(int index) {
    final imageBytes = documents[index]['imageBytes'];
    if (imageBytes == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 350, // ✅ Fixed width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                documents[index]['name'],
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2901B7),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  imageBytes,
                  height: 250, // ✅ Fixed height
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      _pickImage(index);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Replace'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  void _proceedToPayment() {
    final requiredDocs = documents
        .where((d) => d['required'] == true && d['uploaded'] == true)
        .length;
    final requiredCount = documents.where((d) => d['required'] == true).length;

    if (requiredDocs < requiredCount) {
      _showSnackBar('Please upload all required documents', isError: true);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          studentId: widget.studentId,
          enrollmentId: widget.enrollmentId,
          studentName: widget.studentName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadedCount = documents
        .where((d) => d['required'] && d['uploaded'])
        .length;
    final requiredCount = documents.where((d) => d['required']).length;
    final allRequiredUploaded = uploadedCount == requiredCount;

    return Scaffold(
      body: Column(
        children: [
          const PageHeader(showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      _step(2, 'Enrollment', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(3, 'Documents', true),
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
                  _buildDocumentsCard(),
                  const SizedBox(height: 20),
                  _buildProgressCard(
                    uploadedCount,
                    requiredCount,
                    allRequiredUploaded,
                  ),
                  const SizedBox(height: 30),
                  _buildNextButton(allRequiredUploaded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard() {
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
                  child: const Icon(
                    Icons.upload_file,
                    color: Color(0xFF2901B7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'REQUIRED DOCUMENTS',
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
              children: [
                for (int i = 0; i < documents.length; i++)
                  _buildDocumentRow(i, documents[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(int index, Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: doc['uploaded'] ? () => _showImagePreview(index) : null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: doc['uploaded'] && doc['imageBytes'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        doc['imageBytes'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.cloud_upload,
                      color: Colors.orange,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc['uploaded']
                      ? "Uploaded on ${doc['uploadDate']}"
                      : "${doc['required'] ? 'Required' : 'Optional'} - Tap to upload",
                  style: GoogleFonts.roboto(fontSize: 11),
                ),
              ],
            ),
          ),
          doc['isUploading']
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : doc['uploaded']
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blue,
                        size: 20,
                      ),
                      onPressed: () => _showImagePreview(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () => _pickImage(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2901B7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(70, 35),
                  ),
                  child: const Text(
                    "Upload",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    int uploadedCount,
    int requiredCount,
    bool allRequiredUploaded,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress:',
                style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
              ),
              Text(
                '$uploadedCount/$requiredCount documents uploaded',
                style: GoogleFonts.roboto(
                  color: allRequiredUploaded ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: uploadedCount / requiredCount,
            backgroundColor: Colors.grey.shade300,
            color: allRequiredUploaded ? Colors.green : const Color(0xFF2901B7),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(bool allRequiredUploaded) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _proceedToPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: allRequiredUploaded
              ? const Color(0xFF2901B7)
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          allRequiredUploaded
              ? 'PROCEED TO PAYMENT'
              : 'UPLOAD REQUIRED DOCUMENTS',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
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
            fontSize: 11,
            color: active ? const Color(0xFF2901B7) : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
