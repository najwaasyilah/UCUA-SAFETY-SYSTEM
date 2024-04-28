import 'package:flutter/material.dart';
import 'package:ucua_staging/features/user_profile/update_profile_page.dart';
import 'package:ucua_staging/features/user_profile/change_password_page.dart';

class ViewProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              //backgroundImage: AssetImage('assets/profile_image.png'), // Change the image path
              child: Icon(Icons.account_circle, size: 100, color: Colors.blue), // Add this line for pfp icon
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Set text color to black
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 18, color: Colors.black), // Set text color to black
            ),
            SizedBox(height: 10),
            Text(
              'Safety Department',
              style: TextStyle(fontSize: 18, color: Colors.black), // Set text color to black
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set button background color to blue
              ),
              child: Text(
                'Update Profile',
                style: TextStyle(color: Colors.white), // Set button text color to white
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set button background color to blue
              ),
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.white), // Set button text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
