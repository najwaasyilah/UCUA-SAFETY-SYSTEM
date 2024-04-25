import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucua_user_profile/models/user_profile.dart';
import 'package:ucua_user_profile/providers/user_profile_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _departmentController;

  @override
  void initState() {
    super.initState();
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final userProfile = userProfileProvider.userProfile;

    _nameController = TextEditingController(text: userProfile.name);
    _emailController = TextEditingController(text: userProfile.email);
    _departmentController = TextEditingController(text: userProfile.department);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final userProfileProvider =
                    Provider.of<UserProfileProvider>(context, listen: false);
                final updatedProfile = UserProfile(
                  name: _nameController.text,
                  email: _emailController.text,
                  department: _departmentController.text,
                  profilePicture:
                      userProfileProvider.userProfile.profilePicture,
                );
                userProfileProvider.updateProfile(updatedProfile);
                Navigator.pop(context);
              },
              child: const Text('Update Profile'),
            ), //333
          ],
        ),
      ),
    );
  }
}
