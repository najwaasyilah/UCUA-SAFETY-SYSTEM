import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucua_user_profile/models/user_profile.dart';
import 'package:ucua_user_profile/providers/user_profile_provider.dart';
import 'package:ucua_user_profile/screens/change_password_screen.dart';
import 'package:ucua_user_profile/screens/update_profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userProfile = userProfileProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: userProfile.profilePicture.isNotEmpty
                  ? NetworkImage(userProfile.profilePicture)
                  : null,
              child: userProfile.profilePicture.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${userProfile.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${userProfile.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Department: ${userProfile.department}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()),
                );
              },
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()),
                );
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
