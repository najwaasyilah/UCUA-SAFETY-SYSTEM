import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:ucua_staging/features/user_profile/view_profile_page.dart';

class UpdateProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Department'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement update profile logic
                Navigator.pushNamed(context, "/view_profile");// Navigate back to View Profile page
              },
              style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set button background color to blue
              ),
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
