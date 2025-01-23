import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sleepys/widgets/note_card.dart';
import 'dart:convert';
import 'package:sleepys/widgets/sleeppage.dart';

class HeartRatePage extends StatefulWidget {
  final String email;
  HeartRatePage({required this.email, Key? key}) : super(key: key);

  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  TextEditingController _heartRateController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _heartRateController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _heartRateController.removeListener(_updateButtonState);
    _heartRateController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _heartRateController.text.isNotEmpty;
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
        builder: (context) => SleepPage(email: widget.email),
      ),
    );
  }

  Future<void> _saveHeartRate() async {
    int heartRate = int.tryParse(_heartRateController.text) ?? 0;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-heart-rate/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'heartRate': heartRate,
        }),
      );

      if (response.statusCode == 200) {
        print('Heart rate saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save heart rate: ${response.body}');
        throw Exception('Failed to save heart rate');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _saveAndNavigate() {
    _saveHeartRate().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontSizeTitle = screenWidth * 0.06;
    double fontSizeSubtitle = screenWidth * 0.045;
    double fontSizeButton = screenWidth * 0.04;

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
            SizedBox(height: verticalPadding),
            Text(
              'Saya ingin tau tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: fontSizeTitle,
              ),
            ),
            SizedBox(height: verticalPadding * 0.5),
            Text(
              'Berapa detak jantungmu hari ini?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: fontSizeSubtitle,
                color: Colors.white,
              ),
            ),
            NoteCard(
                text:
                    'Letakkan jari telunjuk dan jari tengah di area nadi pergelangan tangan atau sisi leher, lalu hitung denyut selama 15 detik. Kalikan jumlah denyut dengan empat untuk mendapatkan detak jantungmu.'),
            SizedBox(height: verticalPadding),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heartRateController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Detak jantung',
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
                      onPressed: () => _decrement(_heartRateController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_heartRateController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _saveAndNavigate : null,
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      textStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: fontSizeButton,
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
