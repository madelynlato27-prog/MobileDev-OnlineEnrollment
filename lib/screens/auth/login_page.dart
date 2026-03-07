import 'package:flutter/material.dart';
import 'package:onlineenrollment/service/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 3, 156),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ACLC COLLEGE OF MANDAUE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Enrollment System',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  // login api invoke
                  await studentLogin(context, username, password);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter username and password'),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 36, 3, 156),
                foregroundColor: Colors.white,
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> studentLogin(
    BuildContext context,
    String username,
    String password,
  ) async {
    try {
      final service = AuthService();

      final response = await service.login(
        username: username,
        password: password,
      );

      debugPrint('response: ${response.message}');
      if (!context.mounted) return;
      if (response.status == 200) {
        // use pushAndRemoveUntil
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Server error')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }
}
