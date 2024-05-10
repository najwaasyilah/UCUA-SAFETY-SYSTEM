import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/navbar.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Homepage"),
        backgroundColor: Colors.blue,
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue,
            child: const Text(
              "Welcome to Admin Homepage",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _signOut,
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, "/login");
    } catch (e) {
      print("Error signing out: $e");
      // Handle the error as needed, e.g., show a snackbar or toast with the error message.
    }
  }
}
