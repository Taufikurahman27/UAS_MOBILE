import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final url = Uri.parse(
          'http://10.0.2.2:8000/submit-feedback/'); // Replace with your backend URL

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'feedback': _feedbackController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thank you for your feedback!')),
          );

          _emailController.clear();
          _feedbackController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to submit feedback. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double containerWidth = screenSize.width * 0.8;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              CircleAvatar(
                radius: screenSize.width * 0.08,
                backgroundColor: Color(0xFF272E49),
                child: Icon(
                  Icons.feedback,
                  color: Colors.blue.shade700,
                  size: screenSize.width * 0.1,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Beritahu Kami Jika Terjadi Bug!!..',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: screenSize.height * 0.005),
              Text(
                "Kami Akan Segara Memperbaikinya...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.035,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: containerWidth,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          hintText: 'Your email',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'Urbanist',
                          ),
                          filled: true,
                          fillColor: Color(0xFF272E49),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Container(
                      width: containerWidth,
                      child: TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.comment, color: Colors.white),
                          hintText: 'Write your comment here',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'Urbanist',
                          ),
                          filled: true,
                          fillColor: Color(0xFF272E49),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.015,
                          horizontal: screenSize.width * 0.25,
                        ),
                        backgroundColor: Color(0xFF00ADB5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: _isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
