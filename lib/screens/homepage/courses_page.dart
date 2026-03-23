import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({super.key});

  final List<Map<String, String>> courses = [
    {
      'title': 'BS Computer Science',
      'description': 'Learn programming, algorithms, and software development',
      'years': '4 years'
    },
    {
      'title': 'BS Information Technology',
      'description': 'Focus on network administration and IT infrastructure',
      'years': '4 years'
    },
    {
      'title': 'BS Hospitality Management',
      'description': 'Management, hotel business, and restaurant, and resort industry',
      'years': '4 years'
    },
    {
      'title': 'BS Accountancy',
      'description': 'Financial accounting and auditing',
      'years': '4 years'
    },
  
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bachelor\'s Degree Courses'),
        backgroundColor: const Color.fromARGB(255, 36, 3, 156),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courses[index]['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 31, 4, 150),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    courses[index]['description']!,
                    style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.orange),
                      const SizedBox(width: 5),
                      Text(
                        courses[index]['years']!,
                        style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}