import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2901B7),
              Color(0xFF4A2FBD),
              Color(0xFF6B4FCF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/1973802.webp',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.school,
                            size: 100,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // School Name
                  Text(
                    'ACLC',
                    style: GoogleFonts.montserrat(
                      fontSize: 39,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'COLLEGE OF',
                    style: GoogleFonts.montserrat(
                      fontSize: 39,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'MANDAUE',
                    style: GoogleFonts.montserrat(
                      fontSize: 39,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Welcome Text
                  Container(

                    child: Column(
                      children: [
                        Text(
                          'Welcome Students!',
                          style: GoogleFonts.roboto(
                            fontSize:25 ,
                            color: Colors.white70,
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Description Card
                  Container(
                 
                    child: Text(
                      'Enroll in your course online. Manage your enrollment easily and securely. Start your journey with us today!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Buttons
                  Column(
                    children: [
                      // Enroll Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/enroll');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2901B7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'ENROLL NOW',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2901B7),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Footer
                  Column(
                    children: [
                      const Divider(
                        color: Colors.white30,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'ACLC COLLEGE OF MANDAUE',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white60,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Empowering Minds, Building Futures',
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}