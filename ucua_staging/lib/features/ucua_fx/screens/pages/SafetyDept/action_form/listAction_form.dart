import 'package:flutter/material.dart';

class ListActionPage extends StatefulWidget {
  const ListActionPage({super.key});

  @override
  _ListActionPageState createState() => _ListActionPageState();
}

class _ListActionPageState extends State<ListActionPage> {
  List<SubmittedForm> submittedForms = []; // List to hold submitted form data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Unsafe Action Form'), // Updated title
      ),
      body: ListView.builder(
        itemCount: submittedForms.length,
        itemBuilder: (context, index) {
          // Determine the status color based on the approval status of the form
          Color statusColor;
          switch (submittedForms[index].status) {
            case FormStatus.approved:
              statusColor = Colors.green;
              break;
            case FormStatus.pending:
              statusColor = Colors.yellow;
              break;
            case FormStatus.rejected:
              statusColor = Colors.red;
              break;
          }

          return ListTile(
            leading: Container(
              width: 10, // Width of the status indicator
              color: statusColor, // Color representing the approval status
            ),
            title: Text(submittedForms[index].title),
            subtitle: Text(
                'ID: ${submittedForms[index].id} - ${submittedForms[index].dateCreated}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    // Implement functionality to view the form
                    // Navigate to the form details page or show a dialog with form details
                    // You can use submittedForms[index] to access the form data
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Implement functionality to delete form
                    setState(() {
                      submittedForms.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Enum for form approval status
enum FormStatus {
  approved,
  pending,
  rejected,
}

class SubmittedForm {
  final String title;
  final String id;
  final String dateCreated;
  final FormStatus status; // Status of the form

  SubmittedForm({
    required this.title,
    required this.id,
    required this.dateCreated,
    required this.status,
  });
}
