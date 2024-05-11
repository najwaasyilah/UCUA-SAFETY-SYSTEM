// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/viewAction_form.dart';

class ListActionPage extends StatefulWidget {
  const ListActionPage({Key? key}) : super(key: key);

  @override
  State<ListActionPage> createState() => _ListActionPageState();
}

class _ListActionPageState extends State<ListActionPage> {
  String? currentUserStaffID;

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

  void deleteActionForm(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('uaform').doc(docId).delete();
    } catch (e) {
      print('Error deleting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Unsafe Action Forms"),
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
                        'LIST OF UNSAFE ACTION REPORT',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 199, 26, 230),
                        ),
                      ),
                      SizedBox(height: 20),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('uaform')
                            .where('staffID', isEqualTo: currentUserStaffID)
                            .orderBy('date', descending: true)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (DocumentSnapshot document in snapshot.data!.docs)
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //'Title: ${document['title']}',
                                        'Unsafe Action Form',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Date Created: ${document['date']}',
                                        style: TextStyle(fontSize: 16),
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
                                                  builder: (context) => ViewActionForm(docId: document.id),
                                                ),
                                              );
                                            },
                                            child: Text('View'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              deleteActionForm(document.id);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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
      ),
    );
  }
}
