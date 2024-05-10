import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              var action = snapshot.data!.docs[index];
              return ListTile(
                title: Text(action['location']),
                subtitle: Text(action['offence']),
              );
            },
          );
        },
      ),
    );
  }
}
