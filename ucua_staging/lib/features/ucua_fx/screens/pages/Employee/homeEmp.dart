import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/navbar.dart';


class empHomePage extends StatefulWidget {
  const empHomePage({super.key});

  @override
  State<empHomePage> createState() => _empHomePageState();
}

class _empHomePageState extends State<empHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Employee Homepage"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Welcome to Employee Homepage",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text("Sign Out"),
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
      // Handle the error as needed, e.g., show a snackbar or toast with the error message.
    }
  }

}