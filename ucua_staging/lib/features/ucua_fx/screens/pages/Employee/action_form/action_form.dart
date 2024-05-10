import 'package:flutter/material.dart';

class ActionForm extends StatefulWidget {
  const ActionForm({super.key});

  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  // Controller for text input fields
  final TextEditingController _violaterNameController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();

  // Variable to store selected date
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    // Dispose text editing controllers when widget is disposed
    _violaterNameController.dispose();
    _staffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
    // Get form data
    String violaterName = _violaterNameController.text;
    String staffId = _staffIdController.text;
    String icPassport = _icPassportController.text;

    // Handle form submission (e.g., print or send data)
    print('Violater Name: $violaterName');
    print('Staff Id: $staffId');
    print('IC/Passport: $icPassport');
    print('Date: $_selectedDate');
  
    // Reset form after submission
    _resetForm();
  }

  // Function to handle form reset
  void _resetForm() {
    // Clear text input fields
    _violaterNameController.clear();
    _staffIdController.clear();
    _icPassportController.clear();

    // Reset selected date
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  // Function to show date picker
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Action Form'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location:',
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for location
              const SizedBox(height: 20.0),
              const Text(
                'Offence Code:', // Changed from 'Condition Details'
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for offence code
              const SizedBox(height: 20.0),
              const Text(
                'Immediate Corrective Action:', // New dropdown button for immediate corrective action
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for immediate corrective action
              const SizedBox(height: 20.0),
              const Text(
                'Violater Name:', // New text input for violater name
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for violater name
              TextField(
                controller: _violaterNameController,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Staff Id:', // New text input for staff id
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for staff id
              TextField(
                controller: _staffIdController,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'IC/Passport:', // New text input for IC/passport
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for IC/passport
              TextField(
                controller: _icPassportController,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Date:', // New text input for date
                style: TextStyle(fontSize: 16.0),
              ),
              // Date picker for date
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _selectedDate != null ? '$_selectedDate' : 'Select Date',
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ActionForm(),
  ));
}
