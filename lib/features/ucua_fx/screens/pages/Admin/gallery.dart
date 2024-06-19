import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class adminGalleryPage extends StatefulWidget {
  const adminGalleryPage({super.key});

  @override
  State<adminGalleryPage> createState() => _adminGalleryPageState();
}

class _adminGalleryPageState extends State<adminGalleryPage> {
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    List<String> fetchedUrls = [];
    try {
      // Fetch from ucform collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('ucform').get();
      fetchedUrls.addAll(await _fetchUrlsFromSnapshot(snapshot));

      // Fetch from uaform collection
      QuerySnapshot uaSnapshot = await FirebaseFirestore.instance.collection('uaform').get();
      fetchedUrls.addAll(await _fetchUrlsFromSnapshot(uaSnapshot));
    } catch (e) {
      print('Error fetching image URLs: $e');
    } finally {
      setState(() {
        imageUrls = fetchedUrls;
        isLoading = false;
      });
    }
  }

  Future<List<String>> _fetchUrlsFromSnapshot(QuerySnapshot snapshot) async {
    List<String> urls = [];
    for (var doc in snapshot.docs) {
      List<dynamic> imageUrls = doc['imageUrls'] as List<dynamic>;
      for (String url in imageUrls) {
        try {
          String downloadUrl = url.contains('https') ? url : await FirebaseStorage.instance.ref().child(url).getDownloadURL();
          urls.add(downloadUrl);
        } catch (e) {
          print('Error fetching image URL for $url: $e');
        }
      }
    }
    return urls;
  }

  void showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black,
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : imageUrls.isEmpty
              ? const Center(child: Text('No images found.'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showFullScreenImage(context, imageUrls[index]),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                          child: Container(
                            color: Colors.grey[200],
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB functionality here
        },
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}