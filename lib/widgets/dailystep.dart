import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/widgets/heartrate.dart';

class Dailystep extends StatefulWidget {
  final String email;
  Dailystep({required this.email, Key? key}) : super(key: key);

  @override
  _DailystepState createState() => _DailystepState();
}

class _DailystepState extends State<Dailystep> {
  TextEditingController _stepsController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _stepsController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _stepsController.removeListener(_updateButtonState);
    _stepsController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _stepsController.text.isNotEmpty;
    });
  }

  void _increment(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 0;
      controller.text = (currentValue + 1).toString();
    });
  }

  void _decrement(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 0;
      if (currentValue > 0) {
        controller.text = (currentValue - 1).toString();
      }
    });
  }

  void _navigateToSleepPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeartRatePage(email: widget.email),
      ),
    );
  }

  Future<void> _saveDailySteps() async {
    int dailySteps = int.tryParse(_stepsController.text) ?? 0;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-daily-steps/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'dailySteps': dailySteps,
        }),
      );

      if (response.statusCode == 200) {
        print('Daily steps saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save daily steps: ${response.body}');
        throw Exception('Failed to save daily steps');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _saveAndNavigate() {
    _saveDailySteps().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the width and height of the screen
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define adaptive font sizes based on screen width
    double fontSizeTitle = screenWidth * 0.06;
    double fontSizeSubtitle = screenWidth * 0.045;
    double fontSizeButton = screenWidth * 0.04;

    // Define adaptive padding and spacing
    double verticalPadding = screenHeight * 0.02;
    double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFF20223F),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: verticalPadding), // Adjusted spacing
            Text(
              'Saya ingin tau tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: fontSizeTitle, // Adjusted font size
              ),
            ),
            SizedBox(height: verticalPadding * 0.5), // Adjusted spacing
            Text(
              'Berapa jumlah langkah hari ini?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: fontSizeSubtitle, // Adjusted font size
                color: Colors.white,
              ),
            ),
            SizedBox(height: verticalPadding), // Adjusted spacing
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stepsController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Jumlah langkah',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _decrement(_stepsController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_stepsController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: screenHeight * 0.07, // Adjusted button height
                  width: screenWidth * 0.8, // Adjusted button width
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _saveAndNavigate : null,
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090), // Button color
                      textStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: fontSizeButton, // Adjusted font size
                      ),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
