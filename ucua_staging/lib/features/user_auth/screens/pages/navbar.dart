import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);
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
            leading: const Icon(Icons.account_circle),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/view_profile");
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Unsafe Condition'),
            onTap: () => print('Unsafe Condition Form tapped'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Unsafe Action'),
            onTap: () => print('Unsafe Action Form tapped'),
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
}
