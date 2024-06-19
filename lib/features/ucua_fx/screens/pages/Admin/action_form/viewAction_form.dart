import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';

class adminViewUAForm extends StatefulWidget {
  final String docId;

  const adminViewUAForm({super.key, required this.docId});

  @override
  State<adminViewUAForm> createState() => _adminViewUAFormState();
}

class _adminViewUAFormState extends State<adminViewUAForm> {

  final TextEditingController _remarkController = TextEditingController();

  Map<String, dynamic>? formData;
  List<String> actionImages = [];
  List<Map<String, dynamic>> followUps = [];
  List<String> _imageUrls = [];
  List<File?> _actionImages = [null, null];

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
        });
        if (formData!['imageUrls'] != null) {
          _imageUrls = List<String>.from(formData!['imageUrls'] ?? []);
        }
        if (formData!['status'] == null) {
          await FirebaseFirestore.instance.collection('uaform').doc(widget.docId).update({'status': 'Pending'});
          setState(() {
            _status = 'Pending';
          });
        } else {
          setState(() {
            _status = formData!['status'];
          });
        }
        fetchFollowUps();
      }
    } catch (e) {
      print('Error fetching form data: $e');
    }
  }

  Future<void> fetchImages(List<dynamic> urls) async {
    List<String> fetchedUrls = [];
    for (String url in urls) {
      try {
        String downloadUrl = await FirebaseStorage.instance.ref(url).getDownloadURL();
        fetchedUrls.add(downloadUrl);
      } catch (e) {
        print('Error fetching image: $e');
      }
    }
    setState(() {
      actionImages = fetchedUrls;
    });
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

  Future<void> _handleAction(String action) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      String userName = userSnapshot['firstName'] ?? 'Unknown User';
      String userRole = userSnapshot['role'] ?? 'Unknown Role';

      List<String> uploadedImageUrls = [];

      for (var file in _actionImages) {
        if (file != null) {
          String fileName = 'followup_${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference ref = FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = ref.putFile(file);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedImageUrls.add(downloadUrl);
        }
      }

      Map<String, dynamic> followUpData = {
        'remark': _remarkController.text,
        'status': action,
        'imageUrls': uploadedImageUrls,
        'timestamp': Timestamp.now(),
        'userName': userName, 
        'userRole': userRole,
      };

      await FirebaseFirestore.instance
          .collection('uaform')
          .doc(widget.docId)
          .collection('uafollowup')
          .add(followUpData);

      String message = _constructMessage(action, widget.docId, userName);
        print('Notification Message: $message');

        DocumentSnapshot formSnapshot = await FirebaseFirestore.instance
            .collection('uaform')
            .doc(widget.docId)
            .get();

        String reporterDesignation = formSnapshot['reporterDesignation'] ?? 'Unknown';

        Map<String, dynamic> notificationData = {
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
            'department': userRole,
            'formType': 'uaform',
            'formId': widget.docId,
            'sdNotiStatus': 'unread',
            'adminNotiStatus': 'unread',
        };

        if (reporterDesignation == 'Employee') {
            notificationData['empNotiStatus'] = 'unread';
        }

        await FirebaseFirestore.instance.collection('uaform').doc(widget.docId).collection('notifications').add(notificationData);

      await FirebaseFirestore.instance.collection('uaform').doc(widget.docId).update({
        'status': action == 'Approve' ? 'Approved' : action == 'Reject' ? 'Rejected' : 'Pending',
        'approvalName': userName,
        'approvalDesignation': userRole,
      });

      setState(() {
        _status = action == 'Approve' ? 'Approved' : action == 'Reject' ? 'Rejected' : 'Pending';
        approvalName = userName;
        approvalDesignation = userRole;
      });

      showToast(message: "The form is $action");
      fetchFormData();
      fetchFollowUps();

      setState(() {
        followUps.add(followUpData);
        _remarkController.clear();
        _actionImages = [null, null];
      });
    } catch (e) {
      print('Error saving follow-up: $e');
    }
  }

  String _constructMessage(String action, String docId, String userName) {
    if (action == 'Approve') {
      return '[$docId] $userName has approved the UA Form';
    } else if (action == 'Reject') {
      return '[$docId] $userName has rejected the UA Form';
    } else if (action == 'Save') {
      return '[$docId] $userName has updated the UA Form';
    } else {
      return '[$docId] $userName has performed an action on the UA Form';
    }
  }

  String _getStatus(String action) {
    if (action.toLowerCase() == 'approve' || action.toLowerCase() == 'approved') {
      return 'Approved';
    } else if (action.toLowerCase() == 'reject' || action.toLowerCase() == 'rejected') {
      return 'Rejected';
    } else {
      return 'Pending';
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

  Future<void> getImageGallery(int index, List<File?> imageList) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        imageList[index] = File(pickedFile.path);
      } else {
        print("No Image Picked!");
      }
    });
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
                      Text('\t\tNAME         : ${approvalName ?? ''}'),
                      Text('\t\tDESIGNATION  : ${approvalDesignation ?? ''}'),
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
                    const SizedBox(height: 20.0),
                    const Text('Remark:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _remarkController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Remark',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Upload Action Taken Picture:', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => getImageGallery(0, _actionImages),
                            child: Container(
                              height: 150,
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _actionImages[0] != null
                                  ? Image.file(
                                      _actionImages[0]!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 40.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () => getImageGallery(1, _actionImages),
                            child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _actionImages[1] != null
                                  ? Image.file(
                                      _actionImages[1]!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 40.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => _handleAction('Save'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromRGBO(255, 255, 255, 1), 
                            backgroundColor: const Color.fromARGB(255, 63, 63, 62),
                          ),
                          child: const Text('Save'),

                        ),
                        ElevatedButton(
                          onPressed: () => _handleAction('Approve'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, 
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Approve'),
                        ),
                        ElevatedButton(
                          onPressed: () => _handleAction('Reject'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, 
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
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