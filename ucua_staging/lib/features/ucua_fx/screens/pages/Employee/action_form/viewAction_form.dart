// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class ViewActionForm extends StatefulWidget {
  final String docId;

  const ViewActionForm({super.key, required this.docId});

  @override
  State<ViewActionForm> createState() => _ViewActionFormState();
}

class _ViewActionFormState extends State<ViewActionForm> {
  final TextEditingController _violaterNameController = TextEditingController();
  final TextEditingController _violatorStaffIdController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _selectedLocation = 'ICT Department';
  List<String> locations = ['ICT Department','OASIS','Advisor Office','Break Bulk Terminal', 'HR Department', 'Train Track','Safety Department'];

  String _selectedOffenceCode = 'Not Fasting';
  List<String> offenceCode = ['Not Fasting', 'Sleep During Work', 'Eat During Work','Not Wearing Safety Ves'];

  String _selectedICA = 'Stop Work'; 
  List<String> icActions = ['Stop Work', 'Verbal Warning'];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot formDoc = await FirebaseFirestore.instance.collection('uaform').doc(widget.docId).get();
    
    setState(() {
      _violaterNameController.text = formDoc['violaterName'];
      _violatorStaffIdController.text = formDoc['violatorStaffId'];
      _icPassportController.text = formDoc['icPassport'];
      _selectedDate = DateTime.parse(formDoc['date']);
      _selectedLocation = formDoc['location'];
      _selectedICA = formDoc['ica'];
      _selectedOffenceCode = formDoc['offenceCode'];
    });
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Action Form'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Violater Name: ${_violaterNameController.text}'),
            Text('Violator Staff ID: ${_violatorStaffIdController.text}'),
            Text('IC/Passport: ${_icPassportController.text}'),
            Text('Date: $_selectedDate'),
            // Display other fetched data fields here
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          
          title: const Text('Unsafe Action Form'),
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
                          '1. U-SEE',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 151, 46, 170)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Location:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _selectedLocation,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Offence Code:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _selectedOffenceCode,
                      ),
                      const SizedBox(height: 30.0),
                      Center(
                        child: Text(
                          '2. U-ACT',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 151, 46, 170)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Suggest Immediate Corrective Action:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _selectedICA,
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
                      FormContainerWidget(
                        hintText: _violaterNameController.text,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Staff ID:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _violatorStaffIdController.text,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'IC/Passport:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _icPassportController.text,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Date:', 
                        style: TextStyle(fontSize: 16.0),
                      ),
                      FormContainerWidget(
                        hintText: '$_selectedDate',
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 30.0),
                      Center(
                        child: Text(
                          '3. FOLLOW-UP & STATUS',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 151, 46, 170)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'APPROVED BY (SAFETY DEPARTMENT OFFICER)',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4.0),
                      Text('\t\tNAME         : '),
                      Text('\t\tDESIGNATION  : '),
                      Text('\t\tDATE         : '),
                      Text('\t\tSTATUS       : '),
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
