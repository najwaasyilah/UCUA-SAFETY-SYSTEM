import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';

class empViewUAForm extends StatefulWidget {
  final String docId;

  const empViewUAForm({super.key, required this.docId});


  @override
  State<empViewUAForm> createState() => _empViewUAFormState();
}

class _empViewUAFormState extends State<empViewUAForm> {

  Map<String, dynamic>? formData;
  List<String> actionImages = [];
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
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('uaform').doc(widget.docId).get();
      if (doc.exists) {
        setState(() {
          formData = doc.data() as Map<String, dynamic>;
          _status = formData!['status'] ?? 'Pending'; 
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
          .collection('uaform')
          .doc(widget.docId)
          .collection('uafollowup')
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
        return const Color.fromARGB(255, 216, 195, 7);
    }
  }

  Widget _buildFollowUpUpdate() {
    followUps.sort((a, b) {
      Timestamp timestampA = a['timestamp'];
      Timestamp timestampB = b['timestamp'];
      return timestampB.compareTo(timestampA);
    });

    return SingleChildScrollView(
      child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.security, color: Color.fromARGB(255, 33, 82, 243)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                update['userRole'] ?? 'Unknown Role',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (update['timestamp'] as Timestamp).toDate().toString(),
                                style: TextStyle(color: const Color.fromARGB(255, 107, 107, 107), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(update['remark']),
                    SizedBox(height: 8),
                    if (update['imageUrls'] != null && update['imageUrls'].length > 0)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: update['imageUrls'].map<Widget>((url) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.network(
                                url,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (formData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unsafe Action Form')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Unsafe Action Form')),
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        '1. U-SEE',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 151, 46, 170),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Location:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['location']),
                    const SizedBox(height: 20.0),
                    const Text('Offence Code:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['offenceCode']),
                    const SizedBox(height: 20.0),
                    const Text('Action Pictures:', style: TextStyle(fontSize: 16.0)),
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
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
                                ),
                              );
                            }).toList(),
                          )
                        : const Text('No images available'),
                    const SizedBox(height: 30.0),
                    const Center(
                      child: Text(
                        '2. U-ACT',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 151, 46, 170),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Suggest Immediate Corrective Action:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['ica']),
                    const SizedBox(height: 20.0),
                    const Text('Name:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['violaterName']),
                    const SizedBox(height: 20.0),
                    const Text('Staff ID:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['violatorStaffId']),
                    const SizedBox(height: 20.0),
                    const Text('IC/Passport:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    FormContainerWidget(hintText: formData!['icPassport']),
                    const SizedBox(height: 20.0),
                    const Text('Date:', style: TextStyle(fontSize: 16.0)),
                    FormContainerWidget(hintText: formData!['date']),
                    const SizedBox(height: 20.0),
                    const Text('Violator Work Card:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    _imageUrls.length >= 3
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(_imageUrls[2], fit: BoxFit.cover, width: 1000.0),
                            ),
                          )
                        : const Text('No images available or not enough images'),
                    const SizedBox(height: 30.0),
                    const Center(
                      child: Text(
                        '3. FOLLOW-UP & STATUS',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 151, 46, 170),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('REPORTER INFORMATION', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4.0),
                    Text('\t\tNAME         : ${formData!['reporterName']}'),
                    Text('\t\tDESIGNATION  : ${formData!['reporterDesignation']}'),
                    Text('\t\tDATE         : ${formData!['date']}'),
                    const SizedBox(height: 20.0),
                    const Text('CHECKED BY (SAFETY DEPARTMENT OFFICER)', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4.0),
                    if (_status != 'Pending') ...[
                      Text('\t\tNAME         : ${formData!['approvalName']}'),
                      Text('\t\tDESIGNATION  : ${formData!['approvalDesignation']}'),
                      Text('\t\tDATE         : ${DateTime.now().toString().substring(0, 10)}'),
                    ],
                    Row(
                      children: [
                        const Text('\t\tSTATUS       : '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    _buildFollowUpUpdate(), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}