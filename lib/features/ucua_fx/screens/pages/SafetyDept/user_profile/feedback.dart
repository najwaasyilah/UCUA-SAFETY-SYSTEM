// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../global_common/toast.dart';

class safeDeptFeedbackFormPage extends StatefulWidget {
  const safeDeptFeedbackFormPage({super.key});

  @override
  _safeDeptFeedbackFormPageState createState() => _safeDeptFeedbackFormPageState();
}

class _safeDeptFeedbackFormPageState extends State<safeDeptFeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  String _rating = "";

  bool _isSubmitting = false;
  bool _showSuccessMessage = false;
  String? _submissionMessage;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        int feedbackNumber = 1;
        if (querySnapshot.docs.isNotEmpty) {
          String lastFeedbackId = querySnapshot.docs.first.id;
          feedbackNumber = int.parse(lastFeedbackId.replaceAll('FEEDBACK', '')) + 1;
        }
        String feedbackId = 'FEEDBACK${feedbackNumber.toString().padLeft(2, '0')}';

        await FirebaseFirestore.instance.collection('feedback').doc(feedbackId).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'feedback': _feedbackController.text,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _submissionMessage = 'Thank you for your feedback!';
          _isSubmitting = false;
          _showSuccessMessage = true;
        });

        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        _rating = "";

        showToast(message: _submissionMessage!);
      } catch (e) {
        setState(() {
          _submissionMessage = 'Failed to submit feedback. Please try again later.';
          _isSubmitting = false;
          _showSuccessMessage = true;
        });

        showToast(message: _submissionMessage!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: "https://img.freepik.com/free-vector/flat-design-feedback-concept_23-2148957875.jpg",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 200,
                    width: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _feedbackController,
                  label: 'Feedback',
                  icon: Icons.feedback,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "How was your experience with us?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: _buildRatingBar(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 200, 
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      icon: _isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Icon(Icons.send),
                      label: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildRatingBar() {
    final ratingLabels = ["Too bad", "Bad", "Average", "Happy", "Too happy"];
    final ratingColors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = ratingLabels[index];
            });
          },
          icon: Icon(
            index == 0
                ? FontAwesomeIcons.solidSadCry
                : index == 1
                    ? FontAwesomeIcons.solidFrown
                    : index == 2
                        ? FontAwesomeIcons.solidMeh
                        : index == 3
                            ? FontAwesomeIcons.solidSmile
                            : FontAwesomeIcons.solidLaughBeam,
            color: _rating == ratingLabels[index] ? ratingColors[index] : Colors.grey,
            size: 32,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        );
      }),
    );
  }
}
