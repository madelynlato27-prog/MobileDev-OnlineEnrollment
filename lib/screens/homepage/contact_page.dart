import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              
              child: const Column(
                children: [
                  Icon(Icons.school, size: 50, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    'ACLC College of Mandaue',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enrollment System',
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PHONE NUMBERS', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 79, 73))),
                  SizedBox(height: 10),
                  Row(
                    children: [
                    Icon(Icons.phone, color: Colors.green), SizedBox(width: 10), Text('+63 (32) 123-4567')]),
                      SizedBox(height: 15),
                  Row(
                    children: [
                    Icon(Icons.phone, color: Colors.green), SizedBox(width: 10), Text('+63 (32) 765-4321')]),
                      SizedBox(height: 20),
                   Divider(height: 15),
                ],
              ),
            ),

             Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EMAIL ADDRESSES', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 79, 73))),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.red), SizedBox(width: 10), Text('info@aclc.edu.ph')]),
                      SizedBox(height: 15),
                  Row(
                    children: [Icon(Icons.email, color: Colors.red), SizedBox(width: 10), Text('admissions@aclc.edu.ph')]),
                      SizedBox(height: 20),
                  Divider(height: 30),
                ],
                  ),
            ),
                  
                   Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ADDRESS', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 79, 73))),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.orange), SizedBox(width: 10), Text('Mandaue City, Cebu')]),
                        SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.orange), SizedBox(width: 10), Text('6014 Philippines')]),
                        SizedBox(height: 20),
                  Divider(height: 30),
                ],
                  ),
                  ),

                     Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HOURS', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 79, 73))),
                  SizedBox(height: 10),
                  
                  // Hours Section
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.purple), SizedBox(width: 10), Text('Mon-Fri: 8:00 AM - 5:00 PM')]),
                        SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.purple), SizedBox(width: 10), Text('Saturday: 9:00 AM - 12:00 PM')]),
                        SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
 
  
}