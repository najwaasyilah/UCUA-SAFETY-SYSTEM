import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ucua_staging/global_common/toast.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool isChangingPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    setState(() {
      isChangingPassword = true;
    });

    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmNewPassword = _confirmNewPasswordController.text;

    if (newPassword != confirmNewPassword) {
      showToast(message: "New passwords do not match");
      setState(() {
        isChangingPassword = false;
      });
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        showToast(message: "Password changed successfully");
        Navigator.pushNamed(context, "/employeeProfile");
      } else {
        showToast(message: "User not logged in");
      }
    } catch (e) {
      showToast(message: "Error changing password: $e");
    }

    setState(() {
      isChangingPassword = false;
    });
  }

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
              controller: _currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmNewPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isChangingPassword ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(isChangingPassword ? 'Changing Password...' : 'Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
