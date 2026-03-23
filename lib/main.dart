import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:onlineenrollment/screens/auth/splash.dart';
import 'package:onlineenrollment/screens/homepage/contact_page.dart';
import 'package:onlineenrollment/screens/homepage/courses_page.dart';
import 'package:onlineenrollment/screens/auth/dashboard_page.dart';
import 'package:onlineenrollment/screens/homepage/home_page.dart';
import 'package:onlineenrollment/screens/auth/login_page.dart';
import 'package:onlineenrollment/screens/homepage/about_page.dart';
import 'package:onlineenrollment/screens/auth/welcome_page.dart';
import 'package:onlineenrollment/screens/enrollment/enrollment_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Enrollment System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        
        textTheme: GoogleFonts.robotoTextTheme(), 
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/contact': (context) => const ContactPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/about': (context) => const AboutPage(),
        '/courses': (context) => CoursesPage(),
        '/enroll': (context) => const EnrollmentFormPage(),

      },
    );
  }
}