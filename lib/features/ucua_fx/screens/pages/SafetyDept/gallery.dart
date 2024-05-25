import 'package:flutter/material.dart';

class galleryPage extends StatelessWidget {
  const galleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white), // Make back button white
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 columns in the grid
        children: List.generate(6, (index) {
          // Generate 6 template photos
          return Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Photo ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB functionality here
        },
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
