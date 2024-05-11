import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Aiman Haiqal'),
            accountEmail: const Text('aiman020404@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/pfp.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person), // Profile icon
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/employeeProfile");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
