// ignore_for_file: prefer_const_constructors, use_super_parameters
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/condition_form/viewCondition_form.dart';

class empListUCForm extends StatefulWidget {
  const empListUCForm({super.key});

  @override
  State<empListUCForm> createState() => _empListUCFormState();
}

class _empListUCFormState extends State<empListUCForm> {
  String? currentUserStaffID;

  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUserStaffID();
  }

  Future<void> getCurrentUserStaffID() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final staffID = userDoc.get('staffID');
      setState(() {
        currentUserStaffID = staffID;
      });
    }
  }

  Future<void> deleteImages(String docId) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance.collection('ucform').doc(docId).get();
      if (documentSnapshot.exists) {
        if (documentSnapshot.data()!.containsKey('imageURLs')) {
          final imageURLs = List<String>.from(documentSnapshot.get('imageURLs') ?? []);
          final storage = FirebaseStorage.instance;

          for (final url in imageURLs) {
            try {
              print('Attempting to delete image from URL: $url');
              await storage.refFromURL(url).delete();
              print('Successfully deleted image: $url');
            } catch (e) {
              print('Error deleting image at $url: $e');
            }
          }
        } else {
          print('No imageURLs field found in document with ID: $docId');
        }
      } else {
        print('Document with ID $docId does not exist');
      }
    } catch (e) {
      print('Error fetching document for deletion with ID $docId: $e');
    }
  }

  Future<void> deleteConditionForm(String docId) async {
    try {
        DocumentReference mainDocRef = FirebaseFirestore.instance.collection('ucform').doc(docId);
        await deleteImages(docId);

        Future<void> deleteSubcollection(CollectionReference collectionRef) async {
            QuerySnapshot snapshot;
            do {
                snapshot = await collectionRef.limit(10).get();
                for (DocumentSnapshot doc in snapshot.docs) {
                    await doc.reference.delete();
                }
            } while (snapshot.size == 10);
        }

        await deleteSubcollection(mainDocRef.collection('ucfollowup'));
        await deleteSubcollection(mainDocRef.collection('notifications'));
        await mainDocRef.delete();

        print('Successfully deleted main document and its subcollections: $docId');
    } catch (e) {
        print('Error deleting form: $e');
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Color.fromARGB(255, 212, 192, 6);
      default:
        return Colors.grey; 
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("List of Unsafe Condition Forms"),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 33, 82, 243),
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
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unsafe Condition Report',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 33, 82, 243),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Form ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim().toUpperCase();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: (searchQuery.isEmpty)
                        ? FirebaseFirestore.instance.collection('ucform').where('staffID', isEqualTo: currentUserStaffID).orderBy('date', descending: true).snapshots()
                        : FirebaseFirestore.instance.collection('ucform')
                          .where('staffID', isEqualTo: currentUserStaffID)
                          .where('ucformid', isGreaterThanOrEqualTo: searchQuery)
                          .where('ucformid', isLessThanOrEqualTo: '$searchQuery\uf8ff')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No forms found', style: TextStyle(fontSize: 18, color: Colors.black54)));
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!.docs.map((document) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Form ID: ${document['ucformid']}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243),),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Date Created: ${document['date']}',
                                    style: TextStyle(fontSize: 16, color: Colors.black54),
                                  ),
                                  SizedBox(height: 5),
                                  if ((document.data() as Map<String, dynamic>).containsKey('status'))
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(document['status']),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'Status: ${document['status']}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => empViewUCForm(docId: document.id),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        ),
                                        child: Text(
                                          'View',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          deleteConditionForm(document.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}