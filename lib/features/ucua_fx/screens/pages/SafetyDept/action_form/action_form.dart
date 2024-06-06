// ignore_for_file: avoid_print, prefer_const_constructors
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class safeDeptUAForm extends StatefulWidget {
  const safeDeptUAForm({super.key});

  @override
  State<safeDeptUAForm> createState() => _safeDeptUAFormState();
}

class _safeDeptUAFormState extends State<safeDeptUAForm> {

  List<File?> _images = [null,null,null];
  final picker = ImagePicker();

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
  void dispose() {
    _violaterNameController.dispose();
    _violatorStaffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getReporterInfo(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting user info: $e');
      return {};
    }
  }

  void _submitForm(String staffID) async {
    String location = _selectedLocation;
    String offenceCode = _selectedOffenceCode;
    String ica = _selectedICA;
    String violaterName = _violaterNameController.text;
    String violatorStaffId = _violatorStaffIdController.text;
    String icPassport = _icPassportController.text;
    String date = _selectedDate.toString();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    Map<String, dynamic> userInfo = await getReporterInfo(uid);
    String reporterName = '${userInfo['firstName']} ${userInfo['lastName']}';
    String reporterDesignation = userInfo['role'] ?? '';
  
    QuerySnapshot querySnapshot = await firestore.collection('uaform').orderBy('uaformid', descending: true).limit(1).get();
    String lastId = 'UAFORM00';
    if (querySnapshot.docs.isNotEmpty) {
      lastId = querySnapshot.docs.first['uaformid'];
    }

    int lastIdNumber = int.parse(lastId.replaceAll('UAFORM', ''));
    String newIdNumber = (lastIdNumber + 1).toString().padLeft(2, '0');
    String uaformid = 'UAFORM$newIdNumber';

    List<String> imageUrls = [];

    try {
      for (int i = 0; i < _images.length; i++) {
        if (_images[i] != null) {
          final taskSnapshot = await firebase_storage.FirebaseStorage.instance
              .ref('uaform/$uaformid/image$i.jpg')
              .putFile(_images[i]!);
          final url = await taskSnapshot.ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      await firestore.collection('uaform').doc(uaformid).set({
        'uaformid': uaformid,
        'location': location,
        'offenceCode': offenceCode,
        'ica': ica,
        'violaterName': violaterName,
        'violatorStaffId': violatorStaffId,
        'icPassport': icPassport,
        'date': date,
        'staffID': staffID,
        'reporterName': reporterName,
        'reporterDesignation': reporterDesignation,
        'imageUrls': imageUrls,
      });

      await firestore.collection('uaform').doc(uaformid).collection('notifications').add({
        'message': '[$uaformid] $reporterName has submitted a new UA Form',
        'timestamp': FieldValue.serverTimestamp(),
        'department': reporterDesignation,
        'formType': 'uaform',
        'formId': uaformid,
        'sdNotiStatus': 'unread',
        'adminNotiStatus': 'unread',
      });

      print('Unsafe Action Form sent successfully!');
      showToast(message: "Unsafe Action Form sent successfully!");
    } catch (e) {
      print('Error saving form data: $e');
    }

    _resetForm();
  }

  Future getImageGallery(int index) async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        if (index < _images.length) {
          _images[index] = File(pickedFile.path);
        } else {
          _images.add(File(pickedFile.path));
        }
      } else {
        print("No Image Picked!");
      }
    });
  }

  void _resetForm() {
    _violaterNameController.clear();
    _violatorStaffIdController.clear();
    _icPassportController.clear();

    setState(() {
      _images = [null, null,null];
      //_actionTakenImageUrls.clear();
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

  Future<String> getStaffIDFromUID(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          return userData['staffID'] ?? ''; 
        } else {
          return 'User Not Exist';
        }
      } else {
        return 'User not exist'; 
      }
    } catch (e) {
      print('Error getting staffID: $e');
      return 'No user with staff ID';
    }
  }

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
                        'Offence Code:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedOffenceCode,
                        items: offenceCode.map((String code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedOffenceCode = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select Offence Code',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Upload Action Picture:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => getImageGallery(0),
                            child: Container(
                              width: 150, // Adjusted width here
                              height: 150,
                              margin: EdgeInsets.only(right: 8.0), // Added margin here
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _images.isNotEmpty && _images[0] != null // Modified condition here
                                ? Image.file(_images[0]!, fit: BoxFit.cover)
                                : Center(
                                    child: Icon(Icons.add_a_photo, color: Colors.grey[800], size: 50),
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => getImageGallery(1),
                            child: Container(
                              width: 150, // Adjusted width here
                              height: 150,
                              margin: EdgeInsets.only(left: 8.0), // Added margin here
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _images.length > 1 && _images[1] != null // Modified condition here
                                ? Image.file(_images[1]!, fit: BoxFit.cover)
                                : Center(
                                    child: Icon(Icons.add_a_photo, color: Colors.grey[800], size: 50),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
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
                      DropdownButtonFormField<String>(
                        value: _selectedICA,
                        items: icActions.map((String icas) {
                          return DropdownMenuItem<String>(
                            value: icas,
                            child: Text(icas),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedICA = newValue!;
                          });
                        },
                        decoration: InputDecoration(
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
                        controller: _violaterNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Violator Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: "Fill in violator name!");
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
                        controller: _violatorStaffIdController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Staff ID',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: "Fill in Staff ID!");
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'IC/Passport',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showToast(message: "Fill in IC/Passport!");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Date:', 
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_selectedDate.toString().split(' ')[0]),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Violator Work Card:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => getImageGallery(2),
                            child: Container(
                              width: 150,
                              height: 150,
                              margin: EdgeInsets.only(right: 8.0), 
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _images.length > 2 && _images[2] != null 
                                ? Image.file(_images[2]!, fit: BoxFit.cover)
                                : Center(
                                    child: Icon(Icons.add_a_photo, color: Colors.grey[800], size: 50),
                                  ),
                            ),
                          ),
                        ],
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
                            onPressed: () async {
                              //String staffID = FirebaseAuth.instance.currentUser?.uid ?? '';
                              String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                              String staffID = await getStaffIDFromUID(uid);
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: safeDeptUAForm(),
  ));
}