import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucua_user_profile/providers/user_profile_provider.dart';
import 'package:ucua_user_profile/screens/user_profile_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProfileProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UCUA User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserProfileScreen(),
    );
  }
}
