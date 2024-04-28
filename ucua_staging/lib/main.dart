import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucua_staging/features/app/splash_screen.dart';
import 'package:ucua_staging/features/user_auth/screens/pages/homePage.dart';
import 'package:ucua_staging/features/user_auth/screens/pages/loginPage.dart';
import 'package:ucua_staging/features/user_auth/screens/pages/signUpPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //must put this
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UCUA Safety Reporting System',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUp(),
        '/home': (context) => HomePage(),
        //'/profile':(context) => UserProfilePage();
        
      },
    );
  }
}