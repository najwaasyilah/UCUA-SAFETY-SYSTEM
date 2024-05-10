import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateActionForm extends StatefulWidget {
  final String documentId;

  UpdateActionForm({required this.documentId});

  @override
  _UpdateActionFormState createState() => _UpdateActionFormState();
}

class _UpdateActionFormState extends State<UpdateActionForm> {
  String _selectedStatus = 'Pending';
  String _remarks = '';
  Map<String, dynamic>? _initialData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data for the form based on document ID
  Future<void> _fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('actions')
        .doc(widget.documentId)
        .get();
    setState(() {
      _initialData = doc.data() as Map<String, dynamic>?;
      _selectedStatus = _initialData?['status'] ?? 'Pending';
      _remarks = _initialData?['remarks'] ?? '';
    });
  }

  // Update Firestore document with new data
  Future<void> _updateForm() async {
    await FirebaseFirestore.instance
        .collection('actions')
        .doc(widget.documentId)
        .update({
      'status': _selectedStatus,
      'remarks': _remarks,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Update Action Form')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Violater Name:', _initialData?['violaterName'] ?? 'N/A'),
            _buildInfoRow('Staff Id:', _initialData?['staffId'] ?? 'N/A'),
            _buildInfoRow('IC/Passport:', _initialData?['icPassport'] ?? 'N/A'),
            Row(
              children: [
                Text('Status:', style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 10.0),
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
            Text('Remarks:', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 5.0),
            TextFormField(
              maxLines: 5,
              initialValue: _remarks,
              onChanged: (value) {
                _remarks = value;
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Back')),
                SizedBox(width: 20.0),
                ElevatedButton(onPressed: _updateForm, child: Text('Submit')),
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
