import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/navbar.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Center(
              child: const Text(
                "UCUA",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 60),
          _buildEmployeeCard("Employee"), // Inserting the Employee Card
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(String employeeName) {
    return Column(
      children: [
        Container(
          width: double.infinity, // To make the card take full width
          height: 150, // Adjust the height as needed
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeeName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Add spacing between texts
                  Text(
                    "Syed Naufal",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5), // Add spacing between texts
                  Text(
                    "B23CS0070",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile_picture.png'), // Change to your image path
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20), // Add spacing between rounded boxes and square rounded boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the boxes horizontally
          children: [
            _buildSquareRoundedBox("UCUA Action"), // Inserting the first square rounded box
            SizedBox(width: 20), // Add spacing between the square rounded boxes
            _buildSquareRoundedBox("UCUA Condition"), // Inserting the second square rounded box
          ],
        ),
        SizedBox(height: 20), // Add spacing between square rounded boxes and rectangle rounded box
        _buildRectangleRoundedBox("List of Reporting Action"), // Inserting the rectangle rounded box
        SizedBox(height: 20), // Add spacing between rectangle rounded boxes
        _buildRectangleRoundedBox("List of Reporting Condition"), // Inserting the second rectangle rounded box
      ],
    );
  }

  Widget _buildSquareRoundedBox(String description) {
    return GestureDetector(
      onTap: () {
        if (description == "UCUA Action") {
          // Navigate to UCUA Action page
          Navigator.pushNamed(context, "/view_action_form");
        } else if (description == "UCUA Condition") {
          // Navigate to UCUA Condition page
          Navigator.pushNamed(context, "/view_condition_form");
        }
        // Add more conditions for other descriptions if needed
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 40, color: Colors.black), // Description icon
            SizedBox(height: 10), // Add spacing between icon and text
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectangleRoundedBox(String text) {
    return GestureDetector(
      onTap: () {
        if (text == "List of Reporting Action") {
          // Navigate to List of Reporting Action page
          Navigator.pushNamed(context, "/view_action_form_list");
        } else if (text == "List of Reporting Condition") {
          // Navigate to List of Reporting Condition page
          Navigator.pushNamed(context, "/view_condition_form_list");
        }
        // Add more conditions for other texts if needed
      },
      child: Container(
        width: 300,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
