// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';

class ActionForm extends StatefulWidget {
  const ActionForm({Key? key}) : super(key: key);

  @override
  _ActionFormState createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {

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

  List<XFile> _imageFiles = [];
  

  @override
  void dispose() {
    _violaterNameController.dispose();
    _violatorStaffIdController.dispose();
    _icPassportController.dispose();
    super.dispose();
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
    //String imageUrl = await uploadImageToStorage(_imageFile!);

    /*List<XFile> _imageFiles = [];
    for (XFile imageFile in _imageFiles) {
      String imageUrl = await uploadImageToStorage(imageFile);
      imageUrls.add(imageUrl);
    }*/

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String staffID = await getStaffIDFromUID(uid); 


    try {
      await firestore.collection('uaform').add({
        'location': location,
        'offenceCode': offenceCode,
        'ica': ica,
        'violaterName': violaterName,
        'violatorStaffId': violatorStaffId,
        'icPassport': icPassport,
        'date': date,
        'staffID': staffID, 
        //'imageUrls': imageUrls,
      });
      showToast(message: "Unsafe Action Form Submitted Successfully!");
    } catch (e) {
      print('Error saving form data: $e');
    }

    _resetForm();
  }

  void _resetForm() {
    _violaterNameController.clear();
    _violatorStaffIdController.clear();
    _icPassportController.clear();

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

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFiles.add(image);
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
                      FormContainerWidget(
                        //controller: _offenceCodeController,
                        hintText: "Upload Evidence",
                        isPasswordField: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //return 'Choose your location';
                            showToast(message: "Upload Your Evidence");
                          }
                          return null;
                        },
                      ),
                      /*Row(
                        children: [
                          ElevatedButton(
                            //onPressed: _getImage,
                            child: const Text('Upload Picture'),
                          ),
                          if (_imageFile != null)
                            Image.file(File(_imageFile!.path)),
                        ],
                      ),*/
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
                      FormContainerWidget(
                        controller: _violaterNameController,
                        hintText: "Violator Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //return 'Choose your location';
                            showToast(message: "Fill in Your Name");
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
                      FormContainerWidget(
                        controller: _violatorStaffIdController,
                        hintText: "Staff ID",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //return 'Choose your location';
                            showToast(message: "Choose your location");
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
                      FormContainerWidget(
                        controller: _icPassportController,
                        hintText: "IC/Passport",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //return 'Choose your location';
                            showToast(message: "Fill in your IC/Passport");
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: ActionForm(),
  ));
}
