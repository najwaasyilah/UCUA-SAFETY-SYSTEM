import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/navbar.dart';


class SafetyDeptHomePage extends StatefulWidget {
  const SafetyDeptHomePage({super.key});

  @override
  State<SafetyDeptHomePage> createState() => _SafetyDeptHomePageState();
}

class _SafetyDeptHomePageState extends State<SafetyDeptHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Safety Department Homepage"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Welcome to Safety Department Homepage",
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