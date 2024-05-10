import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Unsafe Action Forms')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('actions').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['violaterName'] ?? 'No Name'),
                subtitle: Text('Staff ID: ${data['staffId'] ?? 'Unknown'}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    document.reference.delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
