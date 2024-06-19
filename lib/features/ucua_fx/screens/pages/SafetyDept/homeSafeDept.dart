import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/gallery.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/listReports.dart';
import 'package:badges/badges.dart' as badges;

class SafetyDeptHomePage extends StatefulWidget {
  const SafetyDeptHomePage({super.key});

  @override
  State<SafetyDeptHomePage> createState() => _SafetyDeptHomePageState();
}

class _SafetyDeptHomePageState extends State<SafetyDeptHomePage> {
  int _selectedIndex = 0;
  String? safeDeptName;
  String? staffID;
  String? profileImageUrl;

  int _unreadNotifications = 0;

  int reportedCount = 0;
  int pendingCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchSafeDeptData();
    _fetchFormStatistics();
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
          profileImageUrl =
              doc['profileImageUrl']; 
        });
      }
    } catch (e) {
      print('Error fetching safety department data: $e');
    }
  }

  Future<void> _fetchFormStatistics() async {
    try {
      QuerySnapshot ucformSnapshot = await FirebaseFirestore.instance.collection('ucform').get();
      QuerySnapshot uaformSnapshot = await FirebaseFirestore.instance.collection('uaform').get();

      int totalForms = ucformSnapshot.size + uaformSnapshot.size;
      int pending = 0;
      int approved = 0;
      int rejected = 0;

      void processDocument(QueryDocumentSnapshot doc, String collectionName) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          if (data.containsKey('status')) {
            switch (data['status']) {
              case 'Pending':
                pending++;
                break;
              case 'Approved':
                approved++;
                break;
              case 'Rejected':
                rejected++;
                break;
              default:
                print('Unknown status in $collectionName: ${data['status']}');
            }
          } else {
            print('No status field in $collectionName document: ${doc.id}');
          }
        } else {
          print('Null data in $collectionName document: ${doc.id}');
        }
      }

      // Count statuses in ucform collection
      for (var doc in ucformSnapshot.docs) {
        processDocument(doc, 'ucform');
      }

      for (var doc in uaformSnapshot.docs) {
        processDocument(doc, 'uaform');
      }

      setState(() {
        reportedCount = totalForms;
        pendingCount = pending;
        approvedCount = approved;
        rejectedCount = rejected;
      });
    } catch (e) {
      print('Error fetching form statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "UCUA",
            style: TextStyle(
              fontSize: 30,
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
              _buildSafeDeptCard(safeDeptName!, staffID!, profileImageUrl),
            if (safeDeptName == null || staffID == null)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, "/safetyHome"); // Add your FAB functionality here
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
        selectedItemColor:  const Color.fromRGBO(158, 158, 158, 1),
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

  Widget _buildSafeDeptCard(
      String safeDeptName, String staffID, String? profileImageUrl) {
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
              CircleAvatar(
                radius: 45,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage('assets/profile_picture.png') as ImageProvider,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 35.0), // Increased the left padding
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Form statistics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = (constraints.maxWidth - 80) / 4; // Adjusted box width to ensure no overflow
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.description_rounded,
                  iconColor: const Color.fromARGB(255, 33, 82, 243),
                  label: 'Reported',
                  text: '$reportedCount',
                  onTap: () {
                    // Add navigation or functionality for Chart 1
                  },
                  width: boxWidth,
                  height: 90, // Adjusted height to better fit the screen
                  iconSize: 30, // Adjusted icon size
                ),
                const SizedBox(width: 20),
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.pending_actions_rounded,
                  iconColor: Colors.orange,
                  label: 'Pending',
                  text: '$pendingCount',
                  onTap: () {
                    // Add navigation or functionality for Chart 2
                  },
                  width: boxWidth,
                  height: 90, // Adjusted height to better fit the screen
                  iconSize: 30, // Adjusted icon size
                ),
                const SizedBox(width: 20),
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  label: 'Approved',
                  text: '$approvedCount',
                  onTap: () {
                    // Add navigation or functionality for Chart 3
                  },
                  width: boxWidth,
                  height: 90, // Adjusted height to better fit the screen
                  iconSize: 30, // Adjusted icon size
                ),
                const SizedBox(width: 20),
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                  label: 'Rejected',
                  text: '$rejectedCount',
                  onTap: () {
                    // Add navigation or functionality for Chart 4
                  },
                  width: boxWidth,
                  height: 90, // Adjusted height to better fit the screen
                  iconSize: 30, // Adjusted icon size
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 35.0), // Increased the left padding
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
        LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = (constraints.maxWidth - 50) / 2; // Adjusted box width to ensure no overflow
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.description,
                  iconColor: const Color.fromARGB(255, 194, 63, 216),
                  label: '',
                  text: 'Unsafe Action',
                  onTap: () {
                    Navigator.pushNamed(context, "/sdUAForm");
                  },
                  width: boxWidth,
                  height: 140, // Adjusted height to better fit the screen
                  iconSize: 55, // Adjusted icon size
                ),
                const SizedBox(width: 20),
                _buildSquareRoundedBoxWithLabel(
                  icon: Icons.description,
                  iconColor: const Color.fromARGB(255, 194, 63, 216),
                  label: '',
                  text: 'Unsafe Condition',
                  onTap: () {
                    Navigator.pushNamed(context, "/sdUCForm");
                  },
                  width: boxWidth,
                  height: 140, // Adjusted height to better fit the screen
                  iconSize: 55, // Adjusted icon size
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 35.0), // Increased the left padding
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
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = constraints.maxWidth - 40; // Adjusted button width to ensure no overflow
            return Column(
              children: [
                _buildRectangleRoundedBox(
                  "Unsafe Actions",
                  icon: Icons.list,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const safeDeptListUAForm()),
                    );
                  },
                  width: buttonWidth,
                  height: 70, // Adjusted height to better fit the screen
                ),
                const SizedBox(height: 10), // Added spacing
                _buildRectangleRoundedBox(
                  "Unsafe Conditions",
                  icon: Icons.list,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const safeDeptListUCForm()),
                    );
                  },
                  width: buttonWidth,
                  height: 70, // Adjusted height to better fit the screen
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 30), 
        const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 35.0), 
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              "Tools Management",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              _buildSquareRoundedBoxWithLabel(
                icon: Icons.photo_rounded,
                iconColor: const Color.fromARGB(255, 29, 112, 180),
                label: 'Gallery',
                text: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const galleryPage(),
                    ),
                  );
                },
                width: 80,
                height: 100,
              ),
              const SizedBox(width: 20),
              _buildSquareRoundedBoxWithLabel(
                icon: Icons.library_books,
                iconColor: const Color.fromARGB(255, 22, 111, 22),
                label: 'Reports',
                text: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const safeDeptListOfReports(),
                    ),
                  );
                },
                width: 80,
                height: 100,
              ),
            ],
          ),
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
    double width = 80,
    double height = 100,
    double iconSize = 35, // Default icon size
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
    required String text,
    required Color iconColor,
    VoidCallback? onTap,
    double width = 80,
    double height = 100,
    double iconSize = 35, // Default icon size
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 5), // Adjust padding to make space for text
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
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectangleRoundedBox(String text,
      {IconData? icon, VoidCallback? onTap, double? width, double? height}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 370, // Use passed width or default
        height: height ?? 70, // Use passed height or default
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
          Navigator.pushNamed(
              context, "/safeDeptNoty"); // Navigate to notifications
          break;
        case 1:
          Navigator.pushNamed(context, "/safeDeptProfile");
          break;
      }
    });
  }
}
