import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/gallery.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/listReports.dart';

class SafetyDeptHomePage extends StatefulWidget {
  const SafetyDeptHomePage({super.key});

  @override
  State<SafetyDeptHomePage> createState() => _SafetyDeptHomePageState();
}

class _SafetyDeptHomePageState extends State<SafetyDeptHomePage> {
  int _selectedIndex = 0;
  String? safeDeptName;
  String? staffID;

  @override
  void initState() {
    super.initState();
    _fetchSafeDeptData();
  }

  Future<void> _fetchSafeDeptData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          safeDeptName = doc['firstName'] ?? 'No Name';
          staffID = doc['staffID'] ?? 'No ID';
        });
      }
    } catch (e) {
      print('Error fetching safety department data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 136.0), // Adjust the left padding as needed
          child: Text(
            "UCUA",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (safeDeptName != null && staffID != null)
              _buildSafeDeptCard(safeDeptName!, staffID!), // Inserting the Safety Department Card
            if (safeDeptName == null || staffID == null)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/safetyHome"); // Add your FAB functionality here
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
        selectedItemColor: const Color.fromRGBO(158, 158, 158, 1), // Set selected item color
        unselectedItemColor: const Color.fromRGBO(158, 158, 158, 1), // Set unselected item color
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

  Widget _buildSafeDeptCard(String safeDeptName, String staffID) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 10, 62, 232),
                Color.fromARGB(255, 75, 126, 215),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Safety Department",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      safeDeptName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      staffID,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0), // Increased the left padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Form statistics", // New text header
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.description_rounded,
              iconColor: const Color.fromARGB(255, 33, 82, 243), // Set the icon color for "Submitted"
              label: 'Reported',
              text: '5',
              onTap: () {
                // Add navigation or functionality for Chart 1
              },
              width: 80,
              height: 100,
              iconSize: 35,
            ),
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.pending_actions_rounded,
              iconColor: Colors.orange, // Set the icon color for "Pending"
              label: 'Pending',
              text: '2',
              onTap: () {
                // Add navigation or functionality for Chart 2
              },
              width: 80,
              height: 100,
              iconSize: 35,
            ),
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green, // Set the icon color for "Approved"
              label: 'Approved',
              text: '2',
              onTap: () {
                // Add navigation or functionality for Chart 3
              },
              width: 80,
              height: 100,
              iconSize: 35,
            ),
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.cancel,
              iconColor: Colors.red, // Set the icon color for "Rejected"
              label: 'Rejected',
              text: '1',
              onTap: () {
                // Add navigation or functionality for Chart 4
              },
              width: 80,
              height: 100,
              iconSize: 35,
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0), // Increased the left padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Make a report",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // Adjusted height here
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.description,
              iconColor: const Color.fromARGB(255, 194, 63, 216), // Set the icon color for "Unsafe Action"
              label: '',
              text: 'Unsafe Action',
              onTap: () {
                Navigator.pushNamed(context, "/sdUAForm");
              },
              width: 150, // Increased width for better spacing
              height: 150, // Increased height for better spacing
              iconSize: 60, // Increased icon size
            ),
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.description,
              iconColor: const Color.fromARGB(255, 194, 63, 216), // Set the icon color for "Unsafe Condition"
              label: '',
              text: 'Unsafe Condition',
              onTap: () {
                Navigator.pushNamed(context, "/sdUCForm");
              },
              width: 150, // Increased width for better spacing
              height: 150, // Increased height for better spacing
              iconSize: 60, // Increased icon size
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0), // Increased the left padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "List of reports",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildRectangleRoundedBox(
          "Unsafe Actions",
          icon: Icons.list,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const safeDeptListUAForm()),
            );
          },
        ),
        const SizedBox(height: 10), // Added spacing
        _buildRectangleRoundedBox(
          "Unsafe Conditions",
          icon: Icons.list,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const safeDeptListUCForm()),
            );
          },
        ),
        const SizedBox(height: 30), // Added spacing for the new text header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0), // Increased the left padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Tools",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.photo_rounded,
              iconColor: const Color.fromARGB(255, 29, 112, 180), // Set the icon color for "Gallery"
              label: 'Gallery',
              text: '',
              onTap: () {
                Navigator.push(
                   context,
                    MaterialPageRoute(
                   builder: (context) => const galleryPage(),
               ),
                  );// Add navigation for "Gallery" here
              },
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 20),
            _buildSquareRoundedBoxWithLabel(
              icon: Icons.library_books,
              iconColor: const Color.fromARGB(255, 22, 111, 22), // Set the icon color for "Reports"
              label: 'Reports',
              text: '',
              onTap: () {
                 Navigator.push(
                  context,
                   MaterialPageRoute(
                   builder: (context) => const safeDeptListOfReports(), // Remove 'const' keyword here
    ),
  );
              },
              width: 80,
              height: 80,
            ),
          ],
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }

  Widget _buildSquareRoundedBoxWithLabel({
    required IconData icon,
    required String label,
    required String text, // New text parameter
    required Color iconColor, // Add iconColor parameter
    VoidCallback? onTap,
    double width = 150,
    double height = 150,
    double iconSize = 40, // Default icon size
  }) {
    return Column(
      children: [
        _buildSquareRoundedBox(
          icon: icon,
          text: text, // Pass the text parameter
          iconColor: iconColor, // Pass the iconColor parameter
          onTap: onTap,
          width: width,
          height: height,
          iconSize: iconSize, // Set icon size
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareRoundedBox({
    required IconData icon,
    required String text, // New text parameter
    required Color iconColor, // Add iconColor parameter
    VoidCallback? onTap,
    double width = 150,
    double height = 150,
    double iconSize = 40, // Default icon size
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5), // Adjust padding to make space for text
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize, // Use the passed icon size
              color: iconColor, // Use the passed icon color
            ),
            const SizedBox(height: 5), // Spacing between icon and text
            Text(
              text,
              textAlign: TextAlign.center, // Center align the text
              style: const TextStyle(
                fontSize: 14, // Adjust the font size as needed
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectangleRoundedBox(String text, {IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370, // Increased width
        height: 70, // Added height to increase size
        padding: const EdgeInsets.all(20), // Increased padding for a larger box
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 33, 82, 243),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, // Increased font size for better visibility
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, "/login");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, "/safeDeptNoty"); // Navigate to notifications
          break;
        case 1:
          Navigator.pushNamed(context, "/safeDeptProfile");
          break;
      }
    });
  }
}
