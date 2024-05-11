// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';

class ConditionFormPage extends StatefulWidget {
  const ConditionFormPage({super.key});

  @override
  State<ConditionFormPage> createState() => _ConditionFormPageState();
}

class _ConditionFormPageState extends State<ConditionFormPage> {
  final TextEditingController _conditionDetailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _selectedLocation = 'ICT Department';
  List<String> locations = ['ICT Department', 'HR Department', 'Train Track','Safety Department'];

  @override
  void dispose() {
    _conditionDetailsController.dispose();
    super.dispose();
  }

  void _submitForm(String staffID) async {
    String location = _selectedLocation;
    String conditionDetails = _conditionDetailsController.text;
    String date = _selectedDate.toString();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String staffID = await getStaffIDFromUID(uid); 

    try {
      await firestore.collection('ucform').add({
        'location': location,
        'conditionDetails': conditionDetails,
        'date': date,
        'staffID': staffID, 
      });
      print('UC Form data saved successfully!');
      showToast(message: "Form data saved successfully!");
    } catch (e) {
      print('Error saving form data: $e');
    }

    _resetForm();
  }

  Future<String> getStaffIDFromUID(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          return userData['staffID'] ?? ''; 
        } else {
          return '';
        }
      } else {
        return ''; 
      }
    } catch (e) {
      print('Error getting staffID: $e');
      return '';
    }
  }


  void _resetForm() {
    _conditionDetailsController.clear();

    setState(() {
      _selectedDate = DateTime.timestamp();
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unsafe Condition Form'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          color: Colors.grey.withOpacity(.35),
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
                      offset: Offset(0,3), 
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
                          '1. U-SEE, U-ACT',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 151, 46, 170)),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select Location',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Condition Details:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _conditionDetailsController,
                        maxLines: null, // Allow multiline input
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Condition Details',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: "Fill in your condition details");
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
                            onPressed: () {
                              String staffID = FirebaseAuth.instance.currentUser?.uid ?? '';
                              _submitForm(staffID);
                            },
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
