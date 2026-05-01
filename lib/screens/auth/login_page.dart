// lib/screens/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/services/api_service.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  int _loginAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to welcome page instead of popping to black screen
        Navigator.pushReplacementNamed(context, '/welcome');
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        body: Column(
          children: [
            PageHeader(
              showBackButton: true,
              onBackPressed: () {
                // Go to welcome page when back button is pressed
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Student Login',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2901B7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your credentials to continue',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 30),
                            
                            // Username Field
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2901B7)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Password Field
                            TextField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2901B7)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
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
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'LOGIN',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Info for students
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Contact your administrator if you don\'t have login credentials.',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (usernameController.text.isEmpty) {
      _showSnackBar('Please enter your username', isError: true);
      return;
    }
    
    if (passwordController.text.isEmpty) {
      _showSnackBar('Please enter your password', isError: true);
      return;
    }

    if (_loginAttempts >= 5) {
      _showSnackBar('Too many failed attempts. Please try again later.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    
    final username = usernameController.text.trim();
    final password = passwordController.text;
    
    try {
      final response = await ApiService.login(username, password);
      
      print('Login Response: ${response['status']} - ${response['message']}');

      if (!mounted) return;
      
      if (response['status'] == 200) {
        _loginAttempts = 0;
        _showSnackBar('Login successful!', isError: false);
        
        // Navigate to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() => _loginAttempts++);
        _showSnackBar(response['message'] ?? 'Invalid username or password', isError: true);
        passwordController.clear();
      }
    } catch (e) {
      print('Login error: $e');
      _showSnackBar('Connection error. Please check your internet.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 2 : 1),
      ),
    );
  }
}