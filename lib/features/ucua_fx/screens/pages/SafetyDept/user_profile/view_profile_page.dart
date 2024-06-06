import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/profile.dart';
import 'package:badges/badges.dart' as badges;

class SafeDeptProfile extends StatefulWidget {
  const SafeDeptProfile({super.key});

  @override
  State<SafeDeptProfile> createState() => _SafeDeptProfileState();
}

class _SafeDeptProfileState extends State<SafeDeptProfile> {
  int _selectedIndex = 1;
  String? userName;
  String? userEmail;
  String? userProfileImageUrl;

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
            .where('sdNotiStatus', isEqualTo: 'unread')
            .get();

        unreadCount += notificationSnapshot.size;
      }

      QuerySnapshot uaformSnapshot = await FirebaseFirestore.instance.collection('uaform').get();
      for (QueryDocumentSnapshot uaformDoc in uaformSnapshot.docs) {
        QuerySnapshot notificationSnapshot = await uaformDoc.reference
            .collection('notifications')
            .where('sdNotiStatus', isEqualTo: 'unread')
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
          userProfileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          String fileName = '${user.uid}.jpg';
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(fileName);
          UploadTask uploadTask = storageRef.putFile(imageFile);

          TaskSnapshot storageSnapshot = await uploadTask;
          String downloadUrl = await storageSnapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'profileImageUrl': downloadUrl,
          });

          setState(() {
            userProfileImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        } catch (e) {
          print('Error uploading profile image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading profile image')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userProfileImageUrl != null
                      ? NetworkImage(userProfileImageUrl!)
                      : const AssetImage('assets/profile_picture.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _uploadProfileImage,
                  ),
                ),
              ],
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
                      builder: (context) => const SafeDeptViewProfile()),
                );
              },
              child: Container(
                width: 150,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
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
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
              child: Container(
                width: 300,
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        SizedBox(width: 10),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/safeDeptViewProfile');
              },
              child: Container(
                width: 300,
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        SizedBox(width: 10),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                width: 300,
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/safetyHome");
        },
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        child: const Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 33, 82, 243),
        unselectedItemColor: Colors.grey,
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
          Navigator.pushNamed(context, "/safeDeptNoty");
          break;
        case 1:
          Navigator.pushNamed(context, "/safeDeptProfile");
          break;
      }
    });
  }
}
