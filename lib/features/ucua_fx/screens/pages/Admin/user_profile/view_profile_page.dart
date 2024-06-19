import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/profile.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/change_password_page.dart';
import 'package:badges/badges.dart' as badges;

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  int _selectedIndex = 1;
  String? adminName;
  String? adminEmail;
  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    fetchAdminData();
    _fetchUnreadNotificationsCount();
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    try {
      int unreadCount = 0;

      QuerySnapshot ucformSnapshot = await FirebaseFirestore.instance.collection('ucform').get();
      for (QueryDocumentSnapshot ucformDoc in ucformSnapshot.docs) {
        QuerySnapshot notificationSnapshot = await ucformDoc.reference
            .collection('notifications')
            .where('adminNotiStatus', isEqualTo: 'unread')
            .get();

        unreadCount += notificationSnapshot.size;
      }

      QuerySnapshot uaformSnapshot = await FirebaseFirestore.instance.collection('uaform').get();
      for (QueryDocumentSnapshot uaformDoc in uaformSnapshot.docs) {
        QuerySnapshot notificationSnapshot = await uaformDoc.reference
            .collection('notifications')
            .where('adminNotiStatus', isEqualTo: 'unread')
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

  Future<void> fetchAdminData() async {
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
          adminName = userData['firstName'] ?? 'No Name';
          adminEmail = userData['email'] ?? 'No Email';
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
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : const AssetImage('assets/profile_picture.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(255, 33, 82, 243),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                adminName ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                adminEmail ?? 'Loading...',
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
                        builder: (context) => const adminViewProfile()),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
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
                  Navigator.pushNamed(context, '/adminFaqPage');
                },
                child: Container(
                  width: 300,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 81, 76, 76),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.question_mark, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'FAQ',
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
                  Navigator.pushNamed(context, '/adminAboutUs');
                },
                child: Container(
                  width: 300,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 81, 76, 76),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pageview, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'About Us',
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
                  Navigator.pushNamed(context, '/adminFeedback');
                },
                child: Container(
                  width: 300,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 81, 76, 76),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.feedback, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Feedback',
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/adminHome");
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
                style: const TextStyle(color: Colors.white),
              ),
              child: const Icon(Icons.notifications),
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
          Navigator.pushNamed(context, "/adminNoty");
          break;
        case 1:
          Navigator.pushNamed(context, "/adminProfile");
          break;
      }
    });
  }
}
