import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement change password logic
                Navigator.pushNamed(context, "/safeDeptProfile");// Navigate back to View Profile page
              },
              style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 33, 82, 243)), // Set button background color to blue
              ),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
