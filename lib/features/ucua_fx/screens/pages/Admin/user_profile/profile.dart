import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class adminViewProfile extends StatefulWidget {
  const adminViewProfile({Key? key});

  @override
  State<adminViewProfile> createState() => _adminViewProfileState();
}

class _adminViewProfileState extends State<adminViewProfile> {
  late User? currentUser;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _staffIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneNoController.text = userData['phoneNo'] ?? '';
          _staffIDController.text = userData['staffID'] ?? '';
          _emailController.text = userData['email'] ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Add validation checks here
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _phoneNoController.text.isEmpty ||
          _staffIDController.text.isEmpty ||
          _emailController.text.isEmpty) {
        throw 'Please fill in all fields.';
      }

      if (currentUser != null) {
        // Get updated data from text controllers
        String firstName = _firstNameController.text;
        String lastName = _lastNameController.text;
        String phoneNo = _phoneNoController.text;
        String staffID = _staffIDController.text;
        String email = _emailController.text;

        // Update user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNo': phoneNo,
          'staffID': staffID,
          'email': email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        // Navigate back to adminViewProfile() page
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          textAlign: TextAlign.center, // Center the text
        ),
        centerTitle: true, // Center the title horizontally
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.account_circle, size: 100, color: Color.fromARGB(255, 33, 82, 243)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        // Add your edit functionality here
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Color.fromARGB(255, 248, 244, 244),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _firstNameController,
                hintText: "First Name",
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _lastNameController,
                hintText: "Last Name",
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _phoneNoController,
                hintText: "Phone Number",
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _staffIDController,
                hintText: "Staff ID",
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
              ),
              
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 33, 82, 243),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNoController.dispose();
    _staffIDController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
