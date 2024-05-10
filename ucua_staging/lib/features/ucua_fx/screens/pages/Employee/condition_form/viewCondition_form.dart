import 'package:flutter/material.dart';

class ViewConditionForm extends StatelessWidget {
  final String selectedLocation;
  final String selectedOffenceCode;
  final String selectedImmediateAction;
  final String violaterName;
  final String staffId;
  final String icPassport;
  final String date;

  const ViewConditionForm({super.key, 
    required this.selectedLocation,
    required this.selectedOffenceCode,
    required this.selectedImmediateAction,
    required this.violaterName,
    required this.staffId,
    required this.icPassport,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Condition Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Location:', selectedLocation),
            _buildInfoRow('Offence Code:', selectedOffenceCode),
            _buildInfoRow('Immediate Corrective Action:', selectedImmediateAction),
            _buildInfoRow('Violater Name:', violaterName),
            _buildInfoRow('Staff Id:', staffId),
            _buildInfoRow('IC/Passport:', icPassport),
            _buildInfoRow('Date:', date),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
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
