import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  _AdminUserManagementScreenState createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color mainColor = const Color.fromARGB(255, 33, 82, 243);

  void _addUser(Map<String, dynamic> user) {
    _firestore.collection('users').add(user);
  }

  void _updateUser(String userId, Map<String, dynamic> user) {
    _firestore.collection('users').doc(userId).update(user);
  }

  void _deleteUser(String userId) {
    _firestore.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
              String firstName = user['firstName'] ?? 'No Name';
              String staffID = user['staffID'] ?? 'No ID';
              String email = user['email'] ?? 'No Email';
              String role = user['role'] ?? 'No Role';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(firstName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Staff ID: $staffID'),
                      Text('Email: $email'),
                      Text('Role: $role'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: mainColor),
                        onPressed: () {
                          _showUserForm(context, userId: doc.id, user: user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade800),
                        onPressed: () {
                          _deleteUser(doc.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserForm(context);
        },
        backgroundColor: mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserForm(BuildContext context,
      {String? userId, Map<String, dynamic>? user}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: user?['firstName']);
    final TextEditingController emailController =
        TextEditingController(text: user?['email']);
    final TextEditingController roleController =
        TextEditingController(text: user?['role']);
    final TextEditingController staffIDController =
        TextEditingController(text: user?['staffID']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a role';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: staffIDController,
                  decoration: const InputDecoration(labelText: 'Staff ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a staff ID';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Map<String, dynamic> newUser = {
                    'firstName': nameController.text,
                    'email': emailController.text,
                    'role': roleController.text,
                    'staffID': staffIDController.text,
                  };
                  if (userId == null) {
                    _addUser(newUser);
                  } else {
                    _updateUser(userId, newUser);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save', style: TextStyle(color: mainColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: mainColor)),
            ),
          ],
        );
      },
    );
  }
}
