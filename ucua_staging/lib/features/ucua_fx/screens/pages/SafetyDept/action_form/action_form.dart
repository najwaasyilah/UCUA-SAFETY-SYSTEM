import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActionFormPage extends StatefulWidget {
  const ActionFormPage({super.key});

  @override
  _ActionFormPageState createState() => _ActionFormPageState();
}

class _ActionFormPageState extends State<ActionFormPage> {
  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _violaterNameController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Status dropdown default valuer
  String _status = "Pending";

  // DateTime variable to hold the selected date
  DateTime _selectedDate = DateTime.now();

  // Method to save data to Firestore
  Future<void> _saveActionForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Add the form data to Firestore
        await FirebaseFirestore.instance.collection('actions').add({
          'violaterName': _violaterNameController.text,
          'staffId': _staffIdController.text,
          'icPassport': _icPassportController.text,
          'date': _selectedDate.toIso8601String(),
          'status': _status,
          'remarks': _remarksController.text,
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action Form Saved Successfully!')),
        );

        // Clear form data
        _formKey.currentState?.reset();
        _status = "Pending";
        _selectedDate = DateTime.now();
      } catch (e) {
        // Display error message
        print('Error saving data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save the Action Form.')),
        );
      }
    }
  }

  // Method to select the date
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    // Update the selected date
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Action Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _violaterNameController,
                decoration: const InputDecoration(labelText: 'Violater Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _staffIdController,
                decoration: const InputDecoration(labelText: 'Staff Id'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Staff Id' : null,
              ),
              TextFormField(
                controller: _icPassportController,
                decoration: const InputDecoration(labelText: 'IC/Passport'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter IC/Passport' : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                items: ['Pending', 'Approved', 'Rejected']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
              ),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveActionForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
