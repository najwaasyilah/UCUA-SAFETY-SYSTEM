// ignore_for_file: prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class empViewUCForm extends StatefulWidget {
  final String docId;

  const empViewUCForm({super.key, required this.docId});

  @override
  State<empViewUCForm> createState() => _empViewUCFormState();
}

class _empViewUCFormState extends State<empViewUCForm> {

  Map<String, dynamic>? formData;
  List<String> conditionImages = [];
  List<Map<String, dynamic>> followUps = [];
  List<String> _imageUrls = [];

  String _status = 'Pending';
  String? approvalName;
  String? approvalDesignation;

  @override
  void initState() {
    super.initState();
    fetchFormData();
  }

  Future<void> fetchFormData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('ucform').doc(widget.docId).get();
      if (doc.exists) {
        setState(() {
          formData = doc.data() as Map<String, dynamic>;
          _status = formData!['status'] ?? 'Pending'; // Fetch and update status
        });
        if (formData!['imageUrls'] != null) {
          _imageUrls = List<String>.from(formData!['imageUrls'] ?? []);
        }
        fetchFollowUps();
      }
    } catch (e) {
      print('Error fetching form data: $e');
    }
  }

  Future<void> fetchFollowUps() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('ucform')
          .doc(widget.docId)
          .collection('ucfollowup')
          .get();
      setState(() {
        followUps = query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching follow-up data: $e');
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
      default:
        return Color.fromARGB(255, 216, 195, 7);
    }
  }

  Widget _buildFollowUpUpdate() {
    followUps.sort((a, b) {
      Timestamp timestampA = a['timestamp'];
      Timestamp timestampB = b['timestamp'];
      return timestampB.compareTo(timestampA);
    });

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
            'Follow-Up Update',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 10),
          ...followUps.map((update) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Color.fromARGB(255, 33, 82, 243)),
                      SizedBox(width: 8),
                      Text(
                        update['userRole'] ?? 'Unknown Role', // Display the role
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        (update['timestamp'] as Timestamp).toDate().toString(),
                        style: TextStyle(color: const Color.fromARGB(255, 107, 107, 107), fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(update['remark']),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (update['imageUrls'] != null && update['imageUrls'].length > 0)
                        ...update['imageUrls'].map<Widget>((url) {
                          return Expanded(
                            child: Image.network(
                              url,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
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
                      offset: Offset(0, 3),
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
                        hintText: formData != null ? formData!['location'] : '',
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Condition Details:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      FormContainerWidget(
                        hintText: formData != null ? formData!['conditionDetails'] : '',
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Action Pictures:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4),
                      _imageUrls.isNotEmpty
                          ? CarouselSlider(
                              options: CarouselOptions(
                                height: 200.0,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.8,
                              ),
                              items: _imageUrls.sublist(0, _imageUrls.length < 3 ? _imageUrls.length : 2).map((url) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
                                  ),
                                );
                              }).toList(),
                            )
                          : Text('No images available'),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Date:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      FormContainerWidget(
                        hintText: formData != null ? formData!['date'] : '',
                      ),
                      const SizedBox(height: 30.0),
                      Center(
                        child: Text(
                          '2. FOLLOW-UP & STATUS',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 151, 46, 170)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text('REPORTER INFORMATION', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4.0),
                      Text('\t\tNAME         : ${formData != null ? formData!['reporterName'] : ''}'),
                      Text('\t\tDESIGNATION  : ${formData != null ? formData!['reporterDesignation'] : ''}'),
                      Text('\t\tDATE         : ${formData != null ? formData!['date'] : ''}'),
                      const SizedBox(height: 20.0),
                      const Text(
                        'CHECKED BY (SAFETY DEPARTMENT OFFICER)',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4.0),
                      if (_status != 'Pending') ...[
                        Text('\t\tNAME         : ${formData!['approvalName']}'),
                        Text('\t\tDESIGNATION  : ${formData!['approvalDesignation']}'),
                        Text('\t\tDATE         : ${DateTime.now().toString().substring(0, 10)}'),
                      ],
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text('\t\tSTATUS       : '),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _status,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildFollowUpUpdate(), 
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