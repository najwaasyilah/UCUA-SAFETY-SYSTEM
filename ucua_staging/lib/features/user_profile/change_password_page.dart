import 'package:flutter/material.dart';
import 'package:ucua_staging/features/user_profile/view_profile_page.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement change password logic
                Navigator.pushNamed(context, "/view_profile");// Navigate back to View Profile page
              },
              style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set button background color to blue
              ),
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
