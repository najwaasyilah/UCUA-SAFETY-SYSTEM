import 'package:flutter/material.dart';

class adminFAQPage extends StatelessWidget {
  const adminFAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: const FAQList(),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FAQItem(
          question: 'How can I reset my password?',
          answer:
              'To reset your password, go to the Profile page and select "Change Password". Enter the old password and then enter the new password',
        ),
        FAQItem(
          question: 'How can I update my profile?',
          answer:
              'To update your profile, go to the Profile page and click on "Edit Profile". Make the necessary changes and save.',
        ),
        FAQItem(
          question: 'How do I submit feedback?',
          answer:
              'To submit feedback, go to the Feedback page, fill in the form with your details and feedback, and click on the "Submit" button.',
        ),
        FAQItem(
          question: 'Where can I view my notifications?',
          answer:
              'To view your notifications, click on the bell icon on the bottom navigation bar. This will take you to the Notifications page.',
        ),
        FAQItem(
          question: 'How do I file a report?',
          answer:
              'To file a report, on homepage choose between Unsafe Action or Unsafe Condition report and tap on it. Fill in the form with your details',
        ),
        FAQItem(
          question: 'How do I view every reports?',
          answer:
              'To view every reports that has been make, on homepage scroll down and you will found two list of reports.',
        ),
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer, super.key});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.question),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.answer),
          ),
        ],
      ),
    );
  }
}
