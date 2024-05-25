import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/change_password_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/profile.dart';

class empProfile extends StatefulWidget {
  const empProfile({super.key, Key});

  @override
  State<empProfile> createState() => _empProfileState();
}

class _empProfileState extends State<empProfile> {
  int _selectedIndex = 0;

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
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/profile_picture.png'), // Add your image asset path
            ),
            const SizedBox(height: 10),
            const Text(
              'Aiman Haiqal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'mnqarlz04@gmail.com',
              style: TextStyle(
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
                            //fontWeight: FontWeight.bold,
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
                // Add the functionality to handle logout
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
                            //fontWeight: FontWeight.bold,
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
                // Add the functionality to handle logout
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
                            //fontWeight: FontWeight.bold,
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
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
