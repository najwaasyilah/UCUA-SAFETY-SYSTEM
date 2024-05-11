import 'package:flutter/material.dart';

class UpdateActionForm extends StatefulWidget {
  final String name;
  final String designation;
  final DateTime? date;

  const UpdateActionForm({
    super.key,
    required this.name,
    required this.designation,
    this.date,
  });

  @override
  _UpdateActionFormState createState() => _UpdateActionFormState();
}

class _UpdateActionFormState extends State<UpdateActionForm> {
  String _selectedStatus = 'Pending'; // Default status
  String _remarks = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status of Action Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name:', widget.name),
            _buildInfoRow('Designation:', widget.designation),
            _buildInfoRow('Date:', widget.date?.toString() ?? ''),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items: <String>['Approve', 'Pending', 'Reject']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Remarks:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            TextFormField(
              maxLines: 5, // Increase box size
              onChanged: (value) {
                setState(() {
                  _remarks = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Remarks',
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  child: const Text('Submit'),
                ),
              ],
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
