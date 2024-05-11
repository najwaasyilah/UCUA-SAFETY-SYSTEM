import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ucua_staging/global_common/toast.dart';

class ActionForm extends StatefulWidget {
  const ActionForm({Key? key}) : super(key: key);

  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  final TextEditingController _violatorNameController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _selectedLocation = 'ICT Department';
  List<String> locations = [
    'ICT Department',
    'HR Department',
    'Train Track',
    'Safety Department',
  ];

  String _selectedOffenseCode = 'Not Fasting';
  List<String> offenseCodes = [
    'Not Fasting',
    'Sleeping During Work',
    'Eating During Work',
    'Not Wearing Safety Vest',
  ];

  String _selectedICA = 'Stop Work';
  List<String> icActions = ['Stop Work', 'Verbal Warning'];

  @override
  void dispose() {
    _violatorNameController.dispose();
    _staffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
  }

  // Function to initialize Firebase
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Function to handle form submission
  void _submitForm() async {
    // Get form data
    String location = _selectedLocation;
    String offenseCode = _selectedOffenseCode;
    String ica = _selectedICA;
    String violatorName = _violatorNameController.text;
    String staffId = _staffIdController.text;
    String icPassport = _icPassportController.text;
    String date = _selectedDate.toString();

    // Validate input
    if (violatorName.isEmpty || staffId.isEmpty || icPassport.isEmpty) {
      showToast(message: "Please fill out all fields.");
      return;
    }

    // Initialize Firebase
    await _initializeFirebase();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('actions').add({
        'location': location,
        'offenseCode': offenseCode,
        'ica': ica,
        'violatorName': violatorName,
        'staffId': staffId,
        'icPassport': icPassport,
        'date': date,
      });
      showToast(message: "Form data saved successfully!");
    } catch (e) {
      print('Error saving form data: $e');
      showToast(message: "Error saving form data.");
    }

    _resetForm();
  }

  void _resetForm() {
    _violatorNameController.clear();
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
        body: Container(
          color: Colors.grey.withOpacity(0.35),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Action Form',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 151, 46, 170),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Location:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        items: locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select Location',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Offense Code:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedOffenseCode,
                        items: offenseCodes.map((String code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedOffenseCode = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select Offense Code',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Suggest Immediate Corrective Action:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedICA,
                        items: icActions.map((String ica) {
                          return DropdownMenuItem<String>(
                            value: ica,
                            child: Text(ica),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedICA = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select Immediate Corrective Action',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Violator:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Violator Name:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _violatorNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Violator Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: 'Fill in the Violator\'s Name');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Staff ID:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _staffIdController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Staff ID',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: 'Fill in the Staff ID');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'IC/Passport:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _icPassportController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'IC/Passport',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: 'Fill in the IC/Passport');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Date:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
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
            ),
          ),
        ),
      ),
    );
  }
}
