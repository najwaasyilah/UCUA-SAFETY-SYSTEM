import 'package:flutter/material.dart';

class adminAboutUsPage extends StatelessWidget {
  const adminAboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                color: Colors.blueGrey[50], // Change the color here
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What is UCUA?',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'UCUA stands for Unsafe Condition Unsafe Action. It is an initiative designed to enhance workplace safety by identifying, reporting, and addressing unsafe conditions and actions. UCUA is a proactive approach aimed at preventing accidents and incidents before they occur, ensuring a safer environment for all employees.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                color: Colors.blueGrey[50], // Change the color here
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why is UCUA Important?',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'UCUA, which stands for Unsafe Condition Unsafe Action, is critically important because it proactively identifies and addresses potential hazards in the workplace before they lead to accidents or injuries. By fostering a culture of safety and accountability among employees, UCUA not only ensures compliance with safety regulations but also enhances productivity and morale. This approach not only reduces costs associated with accidents but also underscores the organizations commitment to maintaining a safe and supportive environment where employees can thrive.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Developed by Bit Buddies 2024',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
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
