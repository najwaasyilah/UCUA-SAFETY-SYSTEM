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
            accountEmail: const Text('aimanhaiqal@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/ucua-logo.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('User Profile'),
            //onTap: () {
            //Navigator.pushNamed(context, "/login");
          //},
        ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Unsafe Condition'),
            onTap: () => print('Unsafe Condition Form tapped'),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Unsafe Action'),
            onTap: () => print('Unsafe Action Form tapped'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
            Navigator.pushNamed(context, "/login");
          },
        ),


        ],
      ),
    );
  }
}
