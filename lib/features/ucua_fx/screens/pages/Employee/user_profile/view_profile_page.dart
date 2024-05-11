import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class empProfile extends StatefulWidget {
  const empProfile({Key? key});

  @override
  State<empProfile> createState() => _empProfileState();
}

class _empProfileState extends State<empProfile> {
  int _selectedIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(currentUser!.uid).get();

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
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNo': phoneNo,
          'staffID': staffID,
          'email': email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
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
        automaticallyImplyLeading: false, // Remove back icon
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.account_circle, size: 100, color: Colors.blue),
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
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey, // Change the selected item color
        unselectedItemColor: Color.fromARGB(255, 33, 82, 243), // Change the unselected item color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(context, "/empHome", (route) => false); // Navigate without back button
          break;
        case 1:
          Navigator.pushNamed(context, "/employeeProfile");
          break;
      }
    });
  }
}
