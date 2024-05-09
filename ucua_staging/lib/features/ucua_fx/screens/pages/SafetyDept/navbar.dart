import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc('email').get();
    return snapshot.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final userData = snapshot.data ?? {};
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userData['name'] ?? 'No Name'),
                accountEmail: Text(userData['email'] ?? 'No Email'),
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
                  Navigator.pushNamed(context, "/adminProfile");
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
      },
    );
  }
}
