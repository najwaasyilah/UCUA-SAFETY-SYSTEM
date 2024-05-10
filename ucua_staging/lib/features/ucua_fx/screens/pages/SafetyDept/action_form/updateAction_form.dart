import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActionStatusPage extends StatelessWidget {
  final String documentId;

  ActionStatusPage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Action Status')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('actions')
            .doc(documentId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found for this document.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Violater Name:', data?['violaterName'] ?? 'N/A'),
                _buildInfoRow('Staff ID:', data?['staffId'] ?? 'N/A'),
                _buildInfoRow('IC/Passport:', data?['icPassport'] ?? 'N/A'),
                _buildInfoRow('Date:', data?['date'] ?? 'N/A'),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper function to build a detailed information row
  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16.0)),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(content, style: TextStyle(fontSize: 16.0)),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
