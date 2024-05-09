import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/firebase_auth_implemantation/firebase_auth_services.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/homeAdmin.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/homeEmp.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/homeSafeDept.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/forgotPassword.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/signUpPage.dart';
import 'package:ucua_staging/features/ucua_fx/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
              width: 180, // Adjust width as needed
              height: 180, // Adjust height as needed
              child: Image.asset('assets/ucua-logo.png'),
            ),
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _signIn();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 33, 82, 243),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 82, 243),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 82, 243),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Employee") {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  empHomePage(),
          ),
        );
        }
        else if (documentSnapshot.get('role') == "Safety Department") {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  SafetyDeptHomePage(),
          ),
        );
        }
        else if (documentSnapshot.get('role') == "Admin") {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  adminHomePage(),
          ),
        );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      //Navigator.pushNamed(context, "/home");
      route();
    } else {
      showToast(message: "Some error occurred");
    }
  }
}
