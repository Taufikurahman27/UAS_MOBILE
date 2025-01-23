import 'package:flutter/material.dart';
import 'package:sleepys/pages/data_user/workpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Genderpage extends StatelessWidget {
  final String name;
  final String email;

  const Genderpage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Genderpages(name: name, email: email),
    );
  }
}

class Genderpages extends StatefulWidget {
  final String name;
  final String email;

  const Genderpages({super.key, required this.name, required this.email});

  @override
  _GenderpagesState createState() => _GenderpagesState();
}

class _GenderpagesState extends State<Genderpages> {
  Color borderColor1 = Colors.transparent;
  Color borderColor2 = Colors.transparent;

  void _onTap(int index) async {
    String gender = index == 1
        ? "0"
        : "1"; // Ubah gender menjadi "0" untuk female dan "1" untuk male
    await saveGender(widget.name, widget.email, gender);

    setState(() {
      if (index == 1) {
        borderColor1 = borderColor1 == Colors.transparent
            ? Color(0xFF009090)
            : Colors.transparent;
        borderColor2 = Colors.transparent;
      } else {
        borderColor2 = borderColor2 == Colors.transparent
            ? Color(0xFF009090)
            : Colors.transparent;
        borderColor1 = Colors.transparent;
      }
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Workpage(name: widget.name, email: widget.email, gender: gender),
      ),
    );
  }

  Future<void> saveGender(String name, String email, String gender) async {
    try {
      print(
          'Saving gender: $gender'); // Tambahkan logging untuk melihat nilai gender
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-gender/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'gender': gender,
        }),
      );

      if (response.statusCode == 200) {
        print('Gender saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save gender: ${response.body}');
        throw Exception('Failed to save gender');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.04;
    final double buttonHeight = deviceWidth * 0.13;
    final double paddingSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi ${widget.name}!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Pilih gender kamu, agar kami bisa mengenal kamu lebih baik.',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _onTap(1),
                          child: Container(
                            width: deviceWidth * 0.8,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFF272E49),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: borderColor1, width: 2),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(paddingSize),
                                  child:
                                      Image.asset('assets/images/person2.png'),
                                ),
                                Text(
                                  'Perempuan',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: deviceWidth * 0.05),
                        GestureDetector(
                          onTap: () => _onTap(2),
                          child: Container(
                            width: deviceWidth * 0.8,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFF272E49),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: borderColor2, width: 2),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(paddingSize),
                                  child:
                                      Image.asset('assets/images/person1.png'),
                                ),
                                Text(
                                  'Pria',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
