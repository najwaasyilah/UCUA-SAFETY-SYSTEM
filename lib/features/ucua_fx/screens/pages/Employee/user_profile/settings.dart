import 'package:flutter/material.dart';

class empSettingsPage extends StatelessWidget {
  const empSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle first button tap
                print('First button tapped');
              },
              child: Container(
                width: 300,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(bottom: 20), // Add margin between the boxes
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 82, 243),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'First Button',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle second button tap
                print('Second button tapped');
              },
              child: Container(
                width: 300,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 81, 76, 76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Second Button',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
