import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actions List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ActionsListPage(),
    );
  }
}

class ActionsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Actions'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('actions').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data['location'] ?? 'No Location'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Offence: ${data['offence'] ?? 'No Offence Code'}'),
                        Text(
                            'Action: ${data['action'] ?? 'No Immediate Corrective Action'}'),
                        Text(
                            'Violater: ${data['violater'] ?? 'No Violater Name'}'),
                        Text('Staff ID: ${data['staffId'] ?? 'No Staff ID'}'),
                        Text('IC/Passport: ${data['ic'] ?? 'No IC/Passport'}'),
                        Text('Date: ${data['date'] ?? 'No Date'}'),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
