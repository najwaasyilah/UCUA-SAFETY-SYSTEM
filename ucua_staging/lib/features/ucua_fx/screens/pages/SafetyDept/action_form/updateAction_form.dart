import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateActionPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> action;

  const UpdateActionPage({Key? key, required this.docId, required this.action})
      : super(key: key);

  @override
  _UpdateActionPageState createState() => _UpdateActionPageState();
}

class _UpdateActionPageState extends State<UpdateActionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _offenceController;

  @override
  void initState() {
    super.initState();
    _locationController =
        TextEditingController(text: widget.action['location']);
    _offenceController = TextEditingController(text: widget.action['offence']);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _offenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Action'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _offenceController,
              decoration: InputDecoration(labelText: 'Offence'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an offence';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('actions')
                      .doc(widget.docId)
                      .update({
                        'location': _locationController.text,
                        'offence': _offenceController.text,
                      })
                      .then((value) => Navigator.pop(context))
                      .catchError(
                          (error) => print("Failed to update action: $error"));
                }
              },
              child: Text('Update Action'),
            ),
          ],
        ),
      ),
    );
  }
}
