import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import '../pages/workpage.dart';

class Genderpage extends StatefulWidget {
  final String name;
  final String email;

  const Genderpage({super.key, required this.name, required this.email});

  @override
  _GenderpageState createState() => _GenderpageState();
}

class _GenderpageState extends State<Genderpage> {
  Color borderColor1 = Colors.transparent;
  Color borderColor2 = Colors.transparent;
  late Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> resultList) {
      if (resultList.isNotEmpty &&
          resultList.first != ConnectivityResult.none) {
        syncData();
      }
    });

    syncData();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onTap(int index) async {
    String gender = index == 1 ? "0" : "1";

    // Save gender to the server
    await saveGender(context, widget.name, widget.email, gender);

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

    // Navigate to the next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Workpage(name: widget.name, email: widget.email, gender: gender),
      ),
    );
  }

  Future<void> saveGender(BuildContext context, String name, String email, String gender) async {
    try {
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
        Provider.of<UserData>(context, listen: false).setGender(gender); // Update global state
      } else {
        print('Failed to save gender: ${response.body}');
        throw Exception('Failed to save gender');
      }
    } catch (error) {
      print('Error: $error');

      // Save data locally using Hive if there's an error
      var box = Hive.box('userBox');
      await box.put('genderData', {'name': name, 'email': email, 'gender': gender});

      Provider.of<UserData>(context, listen: false).setGender(gender); // Update global state

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save gender. Data saved locally.')),
      );
    }
  }

  Future<void> syncData() async {
    var box = Hive.box('userBox');
    var genderData = box.get('genderData');

    if (genderData != null) {
      print('Attempting to sync gender data: $genderData');
      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8000/save-gender/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(genderData),
        );

        if (response.statusCode == 200) {
          print('Gender synced successfully: ${jsonDecode(response.body)}');
          await box.delete('genderData');
        } else {
          print('Failed to sync gender data: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
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
                                  child: Image.asset('assets/images/person2.png'),
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
                                  child: Image.asset('assets/images/person1.png'),
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
