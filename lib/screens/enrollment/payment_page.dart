// lib/screens/enrollment/payment_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/page_header.dart';
import 'package:onlineenrollment/services/api_service.dart';

class PaymentPage extends StatefulWidget {
  final String studentId;
  final String enrollmentId;
  final String studentName;

  const PaymentPage({
    super.key,
    required this.studentId,
    required this.enrollmentId,
    required this.studentName,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;
  bool isProcessing = false;

  final List<PaymentOption> paymentOptions = [
    PaymentOption(
      title: 'GCash',
      icon: Icons.phone_android,
      color: const Color(0xFF00B4D8),
      description: 'Pay via GCash',
    ),
    PaymentOption(
      title: 'Credit/Debit Card',
      icon: Icons.credit_card,
      color: const Color(0xFFF39C12),
      description: 'Visa / Mastercard',
    ),
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enrollment Submitted!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text(
              'Student ID: ${widget.studentId}',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Your enrollment has been successfully submitted.'),
            const SizedBox(height: 8),
            Text(
              'Check email for updates.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome',
                (route) => false,
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == null) {
      _showError("Please select payment method");
      return;
    }

    setState(() => isProcessing = true);

    try {
      final response = await ApiService.createPayment(
        int.parse(widget.enrollmentId),
        5000.00,
      );
      print('Payment Response: $response');

      if (response['status'] == 200) {
        _showSuccess();
      } else {
        _showError('Payment failed: ${response['message']}');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => isProcessing = false);
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
                      _step(3, 'Documents', false),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      _step(4, 'Payment', true),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Select Payment Method",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2901B7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Amount to Pay: ₱5,000.00 (Downpayment)",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...paymentOptions.map((option) {
                    bool selected = selectedPaymentMethod == option.title;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedPaymentMethod = option.title),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: selected ? Colors.green.shade50 : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(option.icon, color: option.color, size: 30),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    option.description,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                            if (!selected)
                              Radio<String>(
                                value: option.title,
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) => setState(
                                  () => selectedPaymentMethod = value,
                                ),
                                activeColor: Colors.green,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2901B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "SUBMIT ENROLLMENT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your enrollment will be processed after payment confirmation",
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
            fontSize: 11,
            color: active ? const Color(0xFF2901B7) : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class PaymentOption {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  PaymentOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}
