import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/widgets/dailystep.dart';

class Bloodpressure extends StatefulWidget {
  final String email;
  Bloodpressure({required this.email, Key? key}) : super(key: key);

  @override
  _BloodpressureState createState() => _BloodpressureState();
}

class _BloodpressureState extends State<Bloodpressure> {
  TextEditingController _upperPressureController = TextEditingController();
  TextEditingController _lowerPressureController = TextEditingController();
  bool _isButtonEnabled = false; // Flag to check if button should be enabled

  @override
  void initState() {
    super.initState();
    _upperPressureController.addListener(_updateButtonState);
    _lowerPressureController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _upperPressureController.removeListener(_updateButtonState);
    _lowerPressureController.removeListener(_updateButtonState);
    _upperPressureController.dispose();
    _lowerPressureController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _upperPressureController.text.isNotEmpty &&
          _lowerPressureController.text.isNotEmpty;
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
        builder: (context) => Dailystep(
          email: widget.email,
        ),
      ),
    );
  }

  Future<void> _saveBloodPressure() async {
    int upperPressure = int.tryParse(_upperPressureController.text) ?? 0;
    int lowerPressure = int.tryParse(_lowerPressureController.text) ?? 0;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-blood-pressure/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'upperPressure': upperPressure,
          'lowerPressure': lowerPressure,
        }),
      );

      if (response.statusCode == 200) {
        print(
            'Blood pressure saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save blood pressure: ${response.body}');
        throw Exception('Failed to save blood pressure');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _saveAndNavigate() {
    _saveBloodPressure().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _skipAndNavigate() {
    _navigateToSleepPage();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05; // 5% of screen width as padding

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFF20223F),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Add top spacing
            Text(
              'Saya ingin tahu tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: screenWidth * 0.06, // Scalable font size
              ),
            ),
            SizedBox(
                height: screenHeight * 0.01), // Add spacing between the texts
            Text(
              'Berapa tekanan darah kamu seminggu terakhir?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: screenWidth * 0.045, // Scalable font size
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: screenHeight * 0.03), // Add spacing before input fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _upperPressureController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Tekanan darah atas',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: screenWidth * 0.04, // Scalable hint text
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: screenWidth * 0.045, // Scalable text size
                    ),
                  ),
                ),
                SizedBox(
                    width: screenWidth *
                        0.02), // Add spacing between field and buttons
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _decrement(_upperPressureController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_upperPressureController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                height:
                    screenHeight * 0.02), // Add spacing between input fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lowerPressureController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Tekanan darah bawah',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: screenWidth * 0.04, // Scalable hint text
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: screenWidth * 0.045, // Scalable text size
                    ),
                  ),
                ),
                SizedBox(
                    width: screenWidth *
                        0.02), // Add spacing between field and buttons
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _decrement(_lowerPressureController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_lowerPressureController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.15),
            Center(
              child: Container(
                width: screenWidth * 0.8, // Button width is 80% of screen width
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _saveAndNavigate : null,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: screenWidth * 0.045, // Scalable text size
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF009090), // Button color
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Add spacing at the bottom
          ],
        ),
      ),
    );
  }
}
