import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ucua_staging/global_common/toast.dart';

class ActionFormSD extends StatefulWidget {
  const ActionFormSD({super.key});

  @override
  _ActionFormSDState createState() => _ActionFormSDState();
}

class _ActionFormSDState extends State<ActionFormSD> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _offenseCodeController = TextEditingController();
  final TextEditingController _icActionController = TextEditingController();
  final TextEditingController _violatorNameController = TextEditingController();
  final TextEditingController _violatorStaffIdController =
      TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _locationController.dispose();
    _offenseCodeController.dispose();
    _icActionController.dispose();
    _violatorNameController.dispose();
    _violatorStaffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
  }

  void _submitForm(String staffID) async {
    String location = _locationController.text;
    String offenseCode = _offenseCodeController.text;
    String ica = _icActionController.text;
    String violatorName = _violatorNameController.text;
    String violatorStaffId = _violatorStaffIdController.text;
    String icPassport = _icPassportController.text;
    String date = _selectedDate.toIso8601String();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String staffID = await _getStaffIDFromUID(uid);

    try {
      await firestore.collection('actions').add({
        'location': location,
        'offenseCode': offenseCode,
        'ica': ica,
        'violatorName': violatorName,
        'violatorStaffId': violatorStaffId,
        'icPassport': icPassport,
        'date': date,
        'staffID': staffID,
      });
      showToast(message: "Form Submitted Successfully!");
    } catch (e) {
      print('Error saving form data: $e');
    }

    _resetForm();
  }

  void _resetForm() {
    _locationController.clear();
    _offenseCodeController.clear();
    _icActionController.clear();
    _violatorNameController.clear();
    _violatorStaffIdController.clear();
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

  Future<String> _getStaffIDFromUID(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        return userData?['staffID'] ?? '';
      }
      return 'User Not Found';
    } catch (e) {
      print('Error getting staffID: $e');
      return 'No user with staff ID';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unsafe Action Form'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.white,
            elevation: 12.0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Action Form',
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildTextField('Location', _locationController),
                    const SizedBox(height: 15.0),
                    _buildTextField('Offense Code', _offenseCodeController),
                    const SizedBox(height: 15.0),
                    _buildTextField('Corrective Action', _icActionController),
                    const SizedBox(height: 15.0),
                    _buildTextField('Violator Name', _violatorNameController),
                    const SizedBox(height: 15.0),
                    _buildTextField('Staff ID', _violatorStaffIdController),
                    const SizedBox(height: 15.0),
                    _buildTextField('IC/Passport', _icPassportController),
                    const SizedBox(height: 15.0),
                    const Text('Date:', style: TextStyle(fontSize: 16.0)),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Text(
                          _selectedDate.toLocal().toString().split(' ')[0]),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () => _submitForm(
                              FirebaseAuth.instance.currentUser?.uid ?? ''),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text('Submit'),
                        ),
                        ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontSize: 16.0)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $label',
          ),
        ),
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: ActionFormSD()));
}
