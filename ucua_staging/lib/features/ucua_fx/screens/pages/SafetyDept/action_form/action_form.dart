import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucua_staging/main.dart';

class ActionForm extends StatefulWidget {
  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  // Controller for text input fields
  final _violaterNameController = TextEditingController();
  final _staffIdController = TextEditingController();
  final _icPassportController = TextEditingController();

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
    if (_selectedDate != null) {
      print('Date: $_selectedDate');
    }

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
          title: Text('Action Form'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location:',
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for location
              SizedBox(height: 20.0),
              Text(
                'Offence Code:', // Changed from 'Condition Details'
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for offence code
              SizedBox(height: 20.0),
              Text(
                'Immediate Corrective Action:', // New dropdown button for immediate corrective action
                style: TextStyle(fontSize: 16.0),
              ),
              // Dropdown button for immediate corrective action
              SizedBox(height: 20.0),
              Text(
                'Violater Name:', // New text input for violater name
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for violater name
              TextField(
                controller: _violaterNameController,
              ),
              SizedBox(height: 20.0),
              Text(
                'Staff Id:', // New text input for staff id
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for staff id
              TextField(
                controller: _staffIdController,
              ),
              SizedBox(height: 20.0),
              Text(
                'IC/Passport:', // New text input for IC/passport
                style: TextStyle(fontSize: 16.0),
              ),
              // Text field for IC/passport
              TextField(
                controller: _icPassportController,
              ),
              SizedBox(height: 20.0),
              Text(
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
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      CollectionReference collRef =
                          FirebaseFirestore.instance.collection('actions');
                      collRef.add({
                        'violaterName': _violaterNameController.text,
                        'staffId': _staffIdController.text,
                        'icPassport': _icPassportController.text,
                      }).then((value) {
                        print("Data Added Successfully");
                      }).catchError((error) {
                        print("Failed to add data: $error");
                      });
                    },
                    child: const Text('Save'),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
