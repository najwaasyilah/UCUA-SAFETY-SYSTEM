import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucua_staging/features/app/splash_screen.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/action_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/statusAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/updateAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/condition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/statusCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/updateCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/homeAdmin.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/homeEmp.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/homeSafeDept.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/loginPage.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/signUpPage.dart';
//import 'package:ucua_staging/features/user_profile/view_profile_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //must put this
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UCUA Safety Reporting System',
      routes: {
        '/': (context) => const SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUp(),
        //'/view_profile' : (context) => const ViewProfilePage(),
        '/employeeProfile': (context) => const empProfile(),
        '/safeDeptProfile': (context) => const safeDeptProfile(),
        '/adminProfile': (context) => const AdminProfile(),
        '/empHome': (context) => const empHomePage(),
        '/adminHome': (context) => const AdminHomePage(),
        '/safetyHome': (context) => const SafetyDeptHomePage(),

        //forms

        '/view_condition_form': (context) => const ConditionFormPage(),
        '/view_action_form': (context) => const ActionForm(),
        '/view_action_status': (context) => const ActionStatusPage(
              name: 'John Doe',
              status: 'Approved',
              remarks: 'Completed successfully',
              designation: 'Manager',
            ),
        '/view_condition_status': (context) => ConditionStatusPage(
              name: 'Jane Smith',
              designation: 'Supervisor',
              date: DateTime.now(),
              status: 'Pending',
              remarks: 'Awaiting further review',
            ),
        '/view_action_form_list': (context) => const ListActionPage(),
        '/view_condition_form_list': (context) => const ListConditionPage(),
        '/update_action_form': (context) => const UpdateActionForm(
              name: '',
              designation: '',
            ),
        '/update_condition_form': (context) => const UpdateConditionForm(
              name: '',
              designation: '',
            ),
      },
    );
  }
}
