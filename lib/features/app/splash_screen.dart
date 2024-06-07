import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.child});

  final LoginPage child;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  bool showWelcome = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showWelcome = false;
      });
    });

    // Navigate to the next screen after the splash animation completes
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 82, 243), // Blue gradient background color
      body: Center(
        child: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/ucua-logo.png'), // Path to your logo image
                    width: 200, // Set the desired width
                    height: 200, // Set the desired height
                  ),
                  /*SizedBox(height: 5), // Space between logo and spinner
                  SpinKitThreeBounce(
                    color: Colors.white, // Loading spinner color
                    size: 50.0,
                  ),*/
                ],
              )
            : showWelcome
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/ucua-logo.png'), // Path to your logo image
                        width: 200, // Set the desired width
                        height: 200, // Set the desired height
                      ),
                      SizedBox(height: 5), // Space between logo and text
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "UCUA Safety Reporting System",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Container(), // Empty container when not showing welcome message
      ),
    );
  }
}
