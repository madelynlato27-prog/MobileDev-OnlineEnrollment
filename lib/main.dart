import 'package:flutter/material.dart';
import 'package:onlineenrollment/screens/homepage/contact_page.dart';
import 'package:onlineenrollment/screens/homepage/courses_page.dart';
import 'package:onlineenrollment/screens/auth/dashboard_page.dart';
import 'package:onlineenrollment/screens/homepage/home_page.dart';
import 'package:onlineenrollment/screens/auth/login_page.dart' ;
import 'package:onlineenrollment/screens/auth/register_page.dart';




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
      ),
      home: const HomePage(),
      routes: {
         '/home': (context) => const HomePage(),
        '/contact': (context) => const ContactPage(),
        '/courses': (context) => const CoursesPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
    

      },
    );
  }
}
