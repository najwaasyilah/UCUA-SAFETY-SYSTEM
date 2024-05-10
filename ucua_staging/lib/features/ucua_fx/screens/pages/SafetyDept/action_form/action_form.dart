import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActionForm extends StatefulWidget {
  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  // Controllers
  final TextEditingController _violaterNameController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();

  // Variable to store selected date
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _violaterNameController.dispose();
    _staffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
  }

  // Submit form data to Firestore
  Future<void> _submitForm() async {
    try {
      await FirebaseFirestore.instance.collection('actions').add({
        'violaterName': _violaterNameController.text,
        'staffId': _staffIdController.text,
        'icPassport': _icPassportController.text,
        'date': _selectedDate.toIso8601String(),
      });
      _resetForm();
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Reset form
  void _resetForm() {
    _violaterNameController.clear();
    _staffIdController.clear();
    _icPassportController.clear();
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Action Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Violater Name:'),
            TextField(controller: _violaterNameController),
            SizedBox(height: 20.0),
            Text('Staff Id:'),
            TextField(controller: _staffIdController),
            SizedBox(height: 20.0),
            Text('IC/Passport:'),
            TextField(controller: _icPassportController),
            SizedBox(height: 20.0),
            Text('Date:'),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('$_selectedDate'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
                ElevatedButton(onPressed: _resetForm, child: Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
