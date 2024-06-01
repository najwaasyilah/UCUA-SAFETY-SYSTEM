import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  _AdminUserManagementScreenState createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color mainColor = const Color.fromARGB(255, 33, 82, 243);

  void _addUser(Map<String, dynamic> user, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user['email'],
        password: password,
      );
      user['uid'] = userCredential.user!.uid;
      _firestore.collection('users').doc(userCredential.user!.uid).set(user);
    } catch (e) {
      print("Error adding user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding user: $e')),
      );
    }
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
              String lastName = user['lastName'] ?? 'No Last Name';
              String staffID = user['staffID'] ?? 'No ID';
              String email = user['email'] ?? 'No Email';
              String role = user['role'] ?? 'No Role';
              String phone = user['phone'] ?? 'No Phone';
              String? profileImageUrl = user['profileImageUrl'];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/default_profile_picture.png')
                            as ImageProvider,
                  ),
                  title: Text('$firstName $lastName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Staff ID: $staffID'),
                      Text('Email: $email'),
                      Text('Phone: $phone'),
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
    final TextEditingController lastNameController =
        TextEditingController(text: user?['lastName']);
    final TextEditingController emailController =
        TextEditingController(text: user?['email']);
    final TextEditingController roleController =
        TextEditingController(text: user?['role']);
    final TextEditingController staffIDController =
        TextEditingController(text: user?['staffID']);
    final TextEditingController phoneController =
        TextEditingController(text: user?['phone']);
    final TextEditingController profileImageUrlController =
        TextEditingController(text: user?['profileImageUrl']);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a last name';
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
                  if (user == null)
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
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
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: profileImageUrlController,
                    decoration:
                        const InputDecoration(labelText: 'Profile Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a profile image URL';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Map<String, dynamic> newUser = {
                    'firstName': nameController.text,
                    'lastName': lastNameController.text,
                    'email': emailController.text,
                    'role': roleController.text,
                    'staffID': staffIDController.text,
                    'phone': phoneController.text,
                    'profileImageUrl': profileImageUrlController.text,
                  };
                  if (userId == null) {
                    _addUser(newUser, passwordController.text);
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
