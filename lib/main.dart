import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:onlineenrollment/screens/auth/splash.dart';
import 'package:onlineenrollment/screens/homepage/contact_page.dart';
import 'package:onlineenrollment/screens/homepage/courses_page.dart';
import 'package:onlineenrollment/screens/auth/dashboard_page.dart';
import 'package:onlineenrollment/screens/auth/login_page.dart';
import 'package:onlineenrollment/screens/homepage/about_page.dart';
import 'package:onlineenrollment/screens/auth/welcome_page.dart';
import 'package:onlineenrollment/screens/enrollment/newstudent_enrollmentform.dart';
import 'package:onlineenrollment/screens/enrollment/oldstudent_enrollmentform.dart';


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
  '/login': (context) => const LoginPage(),
  '/dashboard': (context) => const DashboardPage(),
  '/about': (context) => const AboutPage(),
  '/courses': (context) =>  CoursesPage(),
  '/contact': (context) => const ContactPage(),
  '/enroll': (context) => const NewstudentEnrollmentform(),
    '/enroll-old': (context) => const OldstudentEnrollmentform(),


      },
    );
  }
}