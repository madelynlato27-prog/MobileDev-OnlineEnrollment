// lib/screens/enrollment/tracking_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/page_header.dart';

class TrackingPage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const TrackingPage({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  String _applicationStatus = 'Pending';
  List<Map<String, dynamic>> _trackingSteps = [];

  @override
  void initState() {
    super.initState();
    _loadTrackingStatus();
  }

  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  String _getCurrentFormattedTime() {
    final now = DateTime.now();
    return _formatTime(now);
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour12 = time.hour % 12;
    final hour = hour12 == 0 ? 12 : hour12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Simulate fetching status from database
  // In real app, this would come from API with actual timestamps
  void _loadTrackingStatus() {
    final currentDate = _getCurrentFormattedDate();
    final currentTime = _getCurrentFormattedTime();

    // Calculate dates for different steps
    final submittedDate = _getCurrentFormattedDate();
    final submittedTime = _getCurrentFormattedTime();

    // For demo: Document verification is 5 minutes after submission
    final verificationDateTime = DateTime.now().add(const Duration(minutes: 5));
    final verificationDate = _formatDate(verificationDateTime);
    final verificationTime = _formatTime(verificationDateTime);

    _trackingSteps = [
      {
        'title': 'Application Submitted',
        'description': 'Your enrollment application has been received',
        'status': 'completed',
        'date': submittedDate,
        'time': submittedTime,
        'timestamp': DateTime.now(),
      },
      {
        'title': 'Document Verification',
        'description': 'Admission office is reviewing your documents',
        'status': 'in-progress',
        'date': verificationDate,
        'time': verificationTime,
        'timestamp': verificationDateTime,
      },
      {
        'title': 'Payment Confirmation',
        'description': 'Awaiting payment confirmation',
        'status': 'pending',
        'date': null,
        'time': null,
        'timestamp': null,
      },
      {
        'title': 'Enrollment Confirmation',
        'description': 'Final approval and enrollment confirmation',
        'status': 'pending',
        'date': null,
        'time': null,
        'timestamp': null,
      },
    ];
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Date/Time Display
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2901B7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: const Color(0xFF2901B7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getCurrentFormattedDate(),
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2901B7),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: const Color(0xFF2901B7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getCurrentFormattedTime(),
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2901B7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Student Info Card
                  Container(
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
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.studentName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: ${widget.studentId}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Application Status:',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(_applicationStatus),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _applicationStatus,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tracking Progress Title
                  Text(
                    'Application Progress',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2901B7),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Last Updated Info
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Last updated: ${_getCurrentFormattedDate()} at ${_getCurrentFormattedTime()}',
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  // Timeline
                  ..._trackingSteps.map((step) => _buildTimelineItem(step)),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showContactDialog(context);
                      },
                      icon: const Icon(Icons.support_agent),
                      label: Text(
                        'Contact Admin',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2901B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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

  String _getExpectedCompletionDate() {
    final now = DateTime.now();
    // Add 3-5 business days (using 4 days for demo)
    final expectedDate = now.add(const Duration(days: 4));
    return _formatDate(expectedDate);
  }

  Widget _buildTimelineItem(Map<String, dynamic> step) {
    Color iconColor;
    IconData icon;
    String statusText;

    switch (step['status']) {
      case 'completed':
        iconColor = Colors.green;
        icon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case 'in-progress':
        iconColor = Colors.orange;
        icon = Icons.pending;
        statusText = 'In Progress';
        break;
      default:
        iconColor = Colors.grey;
        icon = Icons.circle_outlined;
        statusText = 'Pending';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Icon
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (step != _trackingSteps.last)
                Container(
                  width: 2,
                  height: 40,
                  color: iconColor.withOpacity(0.3),
                  margin: const EdgeInsets.only(top: 4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        step['title'],
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['description'],
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (step['date'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          step['date'],
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          step['time'],
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Add relative time indicator for completed/in-progress steps
                  if (step['timestamp'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _getRelativeTime(step['timestamp']),
                        style: GoogleFonts.roboto(
                          fontSize: 9,
                          color: iconColor,
                          fontStyle: FontStyle.italic,
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

  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: const Color(0xFF2901B7), size: 28),
            const SizedBox(width: 10),
            Text(
              'Contact Admin',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'For inquiries about your application, please contact:',
              style: GoogleFonts.roboto(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.email, size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(
                        'admissions@aclc.edu.ph',
                        style: GoogleFonts.roboto(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: Colors.green),
                      const SizedBox(width: 12),
                      Text(
                        '+63 (32) 123-4567',
                        style: GoogleFonts.roboto(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.orange),
                      const SizedBox(width: 12),
                      Text(
                        'Mon-Fri: 8:00 AM - 5:00 PM',
                        style: GoogleFonts.roboto(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.roboto(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
