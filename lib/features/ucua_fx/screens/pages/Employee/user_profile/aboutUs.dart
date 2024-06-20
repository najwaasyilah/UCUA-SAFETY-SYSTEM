import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class empAboutUsPage extends StatelessWidget {
  const empAboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 33, 82, 243),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white, // Color of the selected tab's text
            unselectedLabelColor: Colors.white, // Color of the unselected tab's text
            indicatorColor: Colors.white, // Color of the indicator
            tabs: [
              Tab(text: 'About UCUA'),
              Tab(text: 'Developers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // About UCUA Tab
            buildTabContent(
              context,
              title: 'Unsafe Condition Unsafe Action',
              description: 'UCUA is an advanced online complaint management system specifically designed for heavy industry companies to efficiently process, distribute, and complete report forms related to unsafe activities and hazardous conditions. By leveraging this comprehensive platform, organizations can streamline their safety protocols, ensure timely responses to potential risks, and enhance overall workplace safety by systematically addressing and mitigating unsafe practices and environments.',
              imageUrl: "https://img.freepik.com/free-vector/teamwork-concept-landing-page_23-2148240859.jpg?t=st=1718897291~exp=1718900891~hmac=7ed63f329b657162fb00db92e4fb53505b20e1259c5bab87211247f18aec23cc&w=1380",
            ),
            // Developers Tab
            buildTabContent(
              context,
              title: 'Developers',
              description: 'Meet our talented team of developers BIT BUDDIES who brought this project to life.',
              imageUrl: "https://img.freepik.com/free-vector/illustration-concept-with-business-people_23-2148452992.jpg?t=st=1718899317~exp=1718902917~hmac=dfd0cd06c523a297e88db0c57f6a5a17c5ccd49ea19c8f0335451cff388838d5&w=2000",
              additionalContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  DeveloperContactSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(BuildContext context, {required String title, required String description, required String imageUrl, Widget? additionalContent}) {
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 187, 222, 251), // Background color
          height: double.infinity,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: 350,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 250,
          left: 16,
          right: 16,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.info_rounded,
                          size: 50,
                          color: Color.fromARGB(255, 33, 82, 243),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (additionalContent != null) additionalContent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DeveloperContactSection extends StatelessWidget {
  const DeveloperContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildContactCard('Aiman Haiqal', 'assets/aiman.jpeg', 'Back-End Programmer'),
        _buildContactCard('Hafiy Daniel', 'assets/hafiy.jpeg', 'Front-End Programmer'),
        _buildContactCard('Syed Naufal', 'assets/naufal.jpeg', 'Front-End Programmer'),
        _buildContactCard('Musab Ahmad', 'assets/musab.jpg', 'Back-End Programmer'),
        _buildContactCard('Najwa Asyilah', 'assets/najwa.jpeg', 'Front-End Programmer'),
      ],
    );
  }

  Widget _buildContactCard(String name, String imagePath, String role) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Color.fromARGB(255, 255, 255, 255), // Change this to your desired card color
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust padding to resize the box
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 39, // Adjust the radius to resize the profile photo
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Make the font bold
                    color: Color.fromARGB(255, 33, 82, 243), // Adjust text color if necessary
                  ),
                ), // Adjust the font size
                const SizedBox(height: 4.0),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0), // Adjust text color if necessary
                  ),
                ), // Adjust the font size
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: empAboutUsPage(),
  ));
}
