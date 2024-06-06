import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/profile.dart';
import 'package:badges/badges.dart' as badges;

class empProfile extends StatefulWidget {
  const empProfile({super.key});

  @override
  State<empProfile> createState() => _empProfileState();
}

class _empProfileState extends State<empProfile> {
  int _selectedIndex = 0;
  String? userName;
  String? userEmail;
  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fetchUnreadNotificationsCount();
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    try {
      int unreadCount = 0;

      QuerySnapshot ucformSnapshot = await FirebaseFirestore.instance.collection('ucform').get();
      for (QueryDocumentSnapshot ucformDoc in ucformSnapshot.docs) {
        QuerySnapshot notificationSnapshot = await ucformDoc.reference
            .collection('notifications')
            .where('empNotiStatus', isEqualTo: 'unread')
            .get();

        unreadCount += notificationSnapshot.size;
      }

      QuerySnapshot uaformSnapshot = await FirebaseFirestore.instance.collection('uaform').get();
      for (QueryDocumentSnapshot uaformDoc in uaformSnapshot.docs) {
        QuerySnapshot notificationSnapshot = await uaformDoc.reference
            .collection('notifications')
            .where('empNotiStatus', isEqualTo: 'unread')
            .get();

        unreadCount += notificationSnapshot.size;
      }

      setState(() {
        _unreadNotifications = unreadCount;
      });
    } catch (e) {
      print('Error fetching unread notifications count: $e');
    }
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          userName = userData['firstName'] ?? 'No Name';
          userEmail = userData['email'] ?? 'No Email';
          profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Upload image to Firebase Storage
          String fileName = '${user.uid}.jpg';
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_pictures/$fileName');
          UploadTask uploadTask = storageRef.putFile(File(pickedFile.path));
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profileImageUrl': downloadUrl});

          setState(() {
            profileImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile picture updated successfully')),
          );
        }
      } catch (e) {
        print('Error uploading profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Error uploading profile picture. Please try again later.')),
        );
      }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const AssetImage('assets/profile_picture.png')
                      as ImageProvider,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userName ?? 'Loading...',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userEmail ?? 'Loading...',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const employeeViewProfile()),
                );
              },
              child: Container(
                width: 150, // Set the desired width here
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: 10), // Adjust the vertical padding here
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 82, 243),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Add some space between the buttons
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
              child: Container(
                width: 300, // Set the desired width here
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15), // Adjust the padding here
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 81, 76, 76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock, color: Colors.white),
                        SizedBox(
                            width:
                                10), // Add some space between the icon and text
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Increase the text size
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white), // Add arrow icon
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/empViewProfile');
              },
              child: Container(
                width: 300, // Set the desired width here
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15), // Adjust the padding here
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 81, 76, 76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: Colors.white),
                        SizedBox(
                            width:
                                10), // Add some space between the icon and text
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Increase the text size
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white), // Add arrow icon
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                width: 300, // Set the desired width here
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15), // Adjust the padding here
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 81, 76, 76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(
                            width:
                                10), // Add some space between the icon and text
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Increase the text size
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white), // Add arrow icon
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Align FAB to center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, "/empHome"); // Add your FAB functionality here
        },
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        child: const Icon(
          Icons.home,
          size: 30, // Change the size of the FAB icon
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey, // Change the selected item color
        unselectedItemColor: const Color.fromARGB(
            255, 33, 82, 243), // Change the unselected item color
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(
                '$_unreadNotifications',
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(Icons.notifications),
              showBadge: _unreadNotifications > 0,
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(
              context, "/empNoty"); // Navigate without back button
          break;
        case 1:
          Navigator.pushNamed(context, "/employeeProfile");
          break;
      }
    });
  }
}
