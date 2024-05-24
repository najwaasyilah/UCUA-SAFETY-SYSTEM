import 'package:flutter/material.dart';

class empNotyPage extends StatefulWidget {
  const empNotyPage({Key? key}) : super(key: key);

  @override
  _empNotyPageState createState() => _empNotyPageState();
}

class _empNotyPageState extends State<empNotyPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'No Notifications for Employee',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/empHome"); // Updated to employee home
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
          Navigator.pushNamed(context, "/empNotyPage"); // Updated to employee notifications page
          break;
        case 1:
          Navigator.pushNamed(context, "/employeeProfile"); // Updated to employee profile page
          break;
      }
    });
  }
}
