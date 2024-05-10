import 'package:flutter/material.dart';

class UpdateActionForm extends StatefulWidget {
  final String name;
  final String designation;
  final DateTime? date;

  UpdateActionForm({
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
        title: Text('Status of Action Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name:', widget.name),
            _buildInfoRow('Designation:', widget.designation),
            _buildInfoRow('Date:', widget.date?.toString() ?? ''),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
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
            SizedBox(height: 20.0),
            Text(
              'Remarks:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            TextFormField(
              maxLines: 5, // Increase box size
              onChanged: (value) {
                setState(() {
                  _remarks = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Remarks',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  child: Text('Submit'),
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