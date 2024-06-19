import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucua_staging/features/app/splash_screen.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/action_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/listAllUAForm.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/condition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/listAllUCForm.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/gallery.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/homeAdmin.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/listReports.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/notifications.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/aboutUs.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/faq.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/feedback.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/action_form/action_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/condition_form/condition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/homeEmp.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/notifications.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/aboutUs.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/faq.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/feedback.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Employee/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/action_form/action_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/action_form/listAction_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/action_form/listAllUAForm.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/condition_form/condition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/condition_form/listAllUCForm.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/condition_form/listCondition_form.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/gallery.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/homeSafeDept.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/listReports.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/aboutUs.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/faq.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/feedback.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/user_profile/view_profile_page.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/notifications.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/loginPage.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/signUpPage.dart';
import 'package:ucua_staging/ucuaNotify.dart';
//import 'ucuaNotify.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //must put this
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await NotificationService().initialize(); 

  NotificationService notificationService = NotificationService();
  await notificationService.initialize(); 
  
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
        '/safeDeptProfile': (context) => const SafeDeptProfile(),
        '/adminProfile': (context) => const AdminProfile(),
        '/empHome': (context) => const empHomePage(),
        '/adminHome': (context) => const AdminHomePage(),
        '/safetyHome': (context) => const SafetyDeptHomePage(),
        

        //admin
        '/adminUCForm': (context) => const adminUCForm(),
        '/adminUCFormList': (context) => const adminListUCForm(),
        '/adminUAForm': (context) => const adminUAForm(),
        '/adminUAFormList': (context) => const adminListUAForm(),
        '/adminListtAllUAForms': (context) => const adminListAllUAForm(),
        '/adminListtAllUForms': (context) => const adminListAllUCForm(),
        '/adminListReports': (context) => const adminListOfReports(),
        '/adminGallery': (context) => const adminGalleryPage(),
        '/adminFeedback': (context) => const AdminFeedbackFormPage(),
        '/adminAboutUs': (context) => const adminAboutUsPage(),
        '/adminFaqPage' : (context) => const adminFAQPage(),
        

        //safetyDept
        '/sdUCForm': (context) => const safeDeptUCForm(),
        '/sdUCFormList': (context) => const safeDeptListUCForm(),
        '/sdUAForm': (context) => const safeDeptUAForm(),
        '/sdUAFormList': (context) => const safeDeptListUAForm(),
        '/sdListtAllUAForms': (context) => const safeDeptListAllUAForm(),
        '/sdListtAllUForms': (context) => const safeDeptListAllUCForm(),
        '/sdListReports': (context) => const safeDeptListOfReports(),
        '/sdGallery': (context) => const safeDeptGalleryPage(),
        '/safetyDeptFeedback': (context) => const safeDeptFeedbackFormPage(),
        '/safeDeptAboutUs': (context) => const safeDeptAboutUsPage(),
        '/safeDeptFaqPage' : (context) => const safeDeptFAQPage(),
        

        //employee
        '/empUCForm': (context) => const empUCForm(),
        '/empUCFormList': (context) => const empListUCForm(),
        '/empUAForm': (context) => const empUAForm(),
        '/empUAFormList': (context) => const empListUAForm(),
        '/empFeedback': (context) => const empFeedbackFormPage(),
        '/empAboutUs': (context) => const empAboutUsPage(),
        '/empFaqPage' : (context) => const empFAQPage(),

        //View notification page
        '/empNoty': (context) => const empNotyPage(),
        '/adminNoty': (context) => const adminNotyPage(),
        '/safeDeptNoty': (context) => const SafeDeptNotyPage(),
        
      },
    );
  }
}
