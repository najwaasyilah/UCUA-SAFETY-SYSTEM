import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucua_staging/features/user_auth/firebase_auth_implemantation/firebase_auth_services.dart';
import 'package:ucua_staging/features/user_auth/screens/pages/loginPage.dart';
import 'package:ucua_staging/features/user_auth/screens/widgets/form_container_widget.dart';
import 'package:ucua_staging/global_common/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _staffIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose(){
    _staffIDController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Text(
                "Sign Up",
                style: TextStyle(fontSize:28, fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _staffIDController,
                hintText: "Staff ID",
                isPasswordField: false,
              ),
              const SizedBox(
                height:10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height:10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(
                height:30,
              ),
              GestureDetector(
                onTap:
                  _signUp,
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()));
                
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 33, 82, 243),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: isSigningUp ? const CircularProgressIndicator(
                      color: Colors.white,) :
                      const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height:20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromARGB(255, 33, 82, 243),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
      
    );
  }

  /*void _signUp() async{
    String staffID = _staffIDController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if(user != null){
      print("User is successfully created");
      Navigator.pushNamed(context,"/home");
    }
    else{
      print("Some error happened!");
    }
  }*/

  void _signUp() async {

    setState(() {
      isSigningUp = true;
    });

    String staffID = _staffIDController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happend");
    }
  }


}