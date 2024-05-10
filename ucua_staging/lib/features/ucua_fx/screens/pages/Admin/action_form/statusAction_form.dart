import 'package:flutter/material.dart';

class ActionStatusPage extends StatelessWidget {
  final String name;
  final String designation;
  final DateTime? date;
  final String status;
  final String remarks;

  const ActionStatusPage({super.key, 
    required this.name,
    required this.designation,
    this.date,
    required this.status,
    required this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Approve':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.yellow;
        break;
      case 'Reject':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name:', name),
            _buildInfoRow('Designation:', designation),
            _buildInfoRow('Date:', date?.toString() ?? ''),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  status,
                  style: TextStyle(fontSize: 16.0, color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildInfoRow('Remarks:', remarks),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
