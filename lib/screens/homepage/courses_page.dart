import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(title: Text('Course 1: Introduction')),
          ListTile(title: Text('Course 2: Intermediate')),
          ListTile(title: Text('Course 3: Advanced')),
        ],
      ),
    );
  }
}
