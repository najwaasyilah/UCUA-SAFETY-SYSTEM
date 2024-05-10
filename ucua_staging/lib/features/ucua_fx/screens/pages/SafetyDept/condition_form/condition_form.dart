import 'package:flutter/material.dart';
import 'package:ucua_staging/features/ucua_fx/screens/pages/SafetyDept/homeSafeDept.dart';

void main() {
  runApp(ConditionFormPage());
}

class ConditionFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsafe Condition Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/safetyHome': (context) => const SafetyDeptHomePage(), // Define named route for employee homepage
      },
      home: LocationOffenceForm(),
    );
  }
}

class LocationOffenceForm extends StatefulWidget {
  @override
  _LocationOffenceFormState createState() => _LocationOffenceFormState();
}

class _LocationOffenceFormState extends State<LocationOffenceForm> {
  String selectedLocation = 'Location 1'; // Default value for Location dropdown
  TextEditingController conditionDetailsController = TextEditingController(); // Controller for the condition details text field

  List<String> locations = ['Location 1', 'Location 2', 'Location 3']; // List of locations
  
  @override
  void dispose() {
    conditionDetailsController.dispose(); // Dispose the text controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsafe Condition Form'),
        leading: IconButton( // Add leading IconButton for back navigation
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the current route to navigate back
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location:',
              style: TextStyle(fontSize: 16.0),
            ),
            DropdownButton<String>(
              value: selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  selectedLocation = newValue!;
                });
              },
              items: locations.map<DropdownMenuItem<String>>((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Condition Details:', // Changed from 'Offence Code'
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0), // Add border radius for box-style container
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0), // Add padding for text input
              child: TextField(
                controller: conditionDetailsController, // Assign the controller to the text field
                onChanged: (newValue) {
                  // No need to setState as the controller will automatically update the value
                },
                maxLines: null, // Set maxLines to null for a multi-line text box
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  hintText: 'Enter Condition Details', // Changed from 'Enter Offence Code'
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle resetting the form
                    setState(() {
                      selectedLocation = 'Location 1'; // Reset location to default
                      conditionDetailsController.text = ''; // Clear condition details using the controller
                    });
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                    // You can access selectedLocation and selectedConditionDetails here
                    print('Location: $selectedLocation, Condition Details: ${conditionDetailsController.text}');
                    // Navigate to the employee homepage after form submission
                    Navigator.pushReplacementNamed(context, "/empHome");
                  },
                  child: Text('Submit'),
                ),
                IconButton( // Back button IconButton
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop the current route to navigate back
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
