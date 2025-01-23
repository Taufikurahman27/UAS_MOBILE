import 'package:flutter/material.dart';

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

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate feedback submission
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thank you for your feedback!')),
        );

        _emailController.clear();
        _feedbackController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double containerWidth =
        screenSize.width * 0.8; // Set a fixed width for alignment

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tambahkan Spacer atau SizedBox untuk memberikan jarak dari atas
              Spacer(
                  flex:
                      2), // Menggunakan flex untuk menyesuaikan ruang secara proporsional
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
                'How are we doing?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: screenSize.height * 0.005),
              Text(
                "We'd love to hear your thoughts",
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
              Spacer(
                  flex:
                      5), // Menambahkan spacer di bawah agar konten utama berada di tengah
            ],
          ),
        ),
      ),
    );
  }
}
