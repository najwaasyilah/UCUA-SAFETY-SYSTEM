// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class ViewConditionForm extends StatefulWidget {
  final String docId;

  const ViewConditionForm({super.key, required this.docId});

  @override
  State<ViewConditionForm> createState() => _ViewConditionFormState();
}

class _ViewConditionFormState extends State<ViewConditionForm> {
  final TextEditingController _conditionDetailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _selectedLocation = 'ICT Department';
  List<String> locations = ['ICT Department','OASIS','Advisor Office','Break Bulk Terminal', 'HR Department', 'Train Track','Safety Department'];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot formDoc = await FirebaseFirestore.instance.collection('ucform').doc(widget.docId).get();
    
    setState(() {
      _selectedDate = DateTime.parse(formDoc['date']);
      _selectedLocation = formDoc['location'];
      _conditionDetailsController.text = formDoc['conditionDetails'];
    });
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
                      FormContainerWidget(
                        hintText: _selectedLocation,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Condition Details:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: _conditionDetailsController.text,
                      ),
                      const Text(
                        'Date:', 
                        style: TextStyle(fontSize: 16.0),
                      ),
                      FormContainerWidget(
                        hintText: '$_selectedDate',
                      ),
                      const SizedBox(height: 30.0),
                      Center(
                        child: Text(
                          '2. FOLLOW-UP & STATUS',
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
