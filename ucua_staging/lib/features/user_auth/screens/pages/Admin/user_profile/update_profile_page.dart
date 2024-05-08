import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:ucua_staging/features/user_auth/screens/pages/Admin/user_profile/view_profile_page.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement update profile logic
                Navigator.pushNamed(context, "/view_profile");// Navigate back to View Profile page
              },
              style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set button background color to blue
              ),
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
