import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/update_profile_page.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              //backgroundImage: AssetImage('assets/profile_image.png'), // Change the image path
              child: Icon(Icons.account_circle,
                  size: 100, color: Colors.blue), // Add this line for pfp icon
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Set text color to black
            ),
            const SizedBox(height: 10),
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                  fontSize: 18, color: Colors.black), // Set text color to black
            ),
            const SizedBox(height: 10),
            const Text(
              'Safety Department',
              style: TextStyle(
                  fontSize: 18, color: Colors.black), // Set text color to black
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Set button background color to blue
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(
                    color: Colors.white), // Set button text color to white
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Set button background color to blue
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(
                    color: Colors.white), // Set button text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
