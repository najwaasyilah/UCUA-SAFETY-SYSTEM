import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateAction_form.dart'; // Ensure you have this page created for updating actions

class ActionsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Actions'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('actions').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var action = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(action['location']),
                subtitle: Text(action['offence']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateActionPage(docId: doc.id, action: action),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
