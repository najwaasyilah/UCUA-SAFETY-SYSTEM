import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewActionForm extends StatelessWidget {
  final String documentId;

  const ViewActionForm({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Action Form')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('actions')
            .doc(documentId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found for this document.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Violater Name:', data['violaterName'] ?? 'N/A'),
                _buildInfoRow('Staff Id:', data['staffId'] ?? 'N/A'),
                _buildInfoRow('IC/Passport:', data['icPassport'] ?? 'N/A'),
                _buildInfoRow('Date:', data['date'] ?? 'N/A'),
                _buildInfoRow('Status:', data['status'] ?? 'N/A'),
                _buildInfoRow('Remarks:', data['remarks'] ?? 'N/A'),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(content, style: const TextStyle(fontSize: 16.0)),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
