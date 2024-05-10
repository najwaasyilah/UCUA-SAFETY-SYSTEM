import 'package:flutter/material.dart';

class ConditionStatusPage extends StatelessWidget {
  final String name;
  final String designation;
  final DateTime? date;
  final String status;
  final String remarks;

  ConditionStatusPage({
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
        title: Text('Condition Status'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name:', name),
            _buildInfoRow('Designation:', designation),
            _buildInfoRow('Date:', date?.toString() ?? ''),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  status,
                  style: TextStyle(fontSize: 16.0, color: statusColor),
                ),
              ],
            ),
            SizedBox(height: 20.0),
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
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            content,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
