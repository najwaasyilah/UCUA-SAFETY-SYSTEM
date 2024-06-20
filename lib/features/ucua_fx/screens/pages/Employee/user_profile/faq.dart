import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EmpFAQPage(),
  ));
}

class EmpFAQPage extends StatelessWidget {
  const EmpFAQPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: FAQList(),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({Key? key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FAQCategory(
          categoryName: 'Account Management',
          faqs: [
            FAQItem(
              question: 'How can I reset my password?',
              answer:
                  'To reset your password, go to the Profile page and select "Change Password". Enter the old password and then enter the new password.',
            ),
            FAQItem(
              question: 'How can I update my profile?',
              answer:
                  'To update your profile, go to the Profile page and click on "Edit Profile". Make the necessary changes and save.',
            ),
          ],
        ),
        FAQCategory(
          categoryName: 'Feedback and Notifications',
          faqs: [
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
          ],
        ),
        FAQCategory(
          categoryName: 'Reporting',
          faqs: [
            FAQItem(
              question: 'How do I file a report?',
              answer:
                  'To file a report, on the homepage choose between Unsafe Action or Unsafe Condition report and tap on it. Fill in the form with your details.',
            ),
            FAQItem(
              question: 'How do I view all reports?',
              answer:
                  'To view all reports that have been made, on the homepage scroll down and you will find two lists of reports.',
            ),
          ],
        ),
        FAQCategory(
          categoryName: 'Security and Privacy',
          faqs: [
            FAQItem(
              question: 'How is my data secured within the app?',
              answer:
                  'We use industry-standard encryption and security protocols to protect your data. For more details, refer to our privacy policy in the "Settings" section.',
            ),
          ],
        ),
      ],
    );
  }
}

class FAQCategory extends StatelessWidget {
  final String categoryName;
  final List<FAQItem> faqs;

  const FAQCategory({
    required this.categoryName,
    required this.faqs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 33, 82, 243), // Your specified color
            ),
          ),
        ),
        Column(
          children: faqs.map((faq) => FAQItemWidget(faq: faq)).toList(),
        ),
      ],
    );
  }
}

class FAQItemWidget extends StatefulWidget {
  final FAQItem faq;

  const FAQItemWidget({Key? key, required this.faq}) : super(key: key);

  @override
  _FAQItemWidgetState createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.faq.question),
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
            child: Text(widget.faq.answer),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
