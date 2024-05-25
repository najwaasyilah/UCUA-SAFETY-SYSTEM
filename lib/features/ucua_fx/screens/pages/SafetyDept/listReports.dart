import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/action_form/listAllUAForm.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/Admin/condition_form/listAllUCForm.dart';

class safeDeptListOfReports extends StatelessWidget {
  const safeDeptListOfReports({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List of Reports",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 33, 82, 243),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 450,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => adminListAllUAForm(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 33, 82, 243),
                    foregroundColor: Colors.white,
                    elevation: 5, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list, size: 32),
                      SizedBox(width: 10),
                      Text(
                        'List of UA Form',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios, size: 32),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 450,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => adminListAllUCForm(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 33, 82, 243),
                    foregroundColor: Colors.white,
                    elevation: 5, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list, size: 32),
                      SizedBox(width: 10),
                      Text(
                        'List of UC Form',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios, size: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
