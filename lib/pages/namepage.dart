import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/genderpage.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';

class Namepage extends StatefulWidget {
  final String email;

  Namepage({Key? key, required this.email}) : super(key: key);

  @override
  _NamepageState createState() => _NamepageState();
}

class _NamepageState extends State<Namepage> {
  final TextEditingController _controller = TextEditingController();
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

  Future<void> saveName(BuildContext context, String name, String email) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-name/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Name saved successfully: ${jsonDecode(response.body)}');
        Provider.of<UserData>(context, listen: false).setName(name); // Update Global State
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Genderpage(name: name, email: email),
          ),
        );
      } else {
        print('Failed to save name: ${response.body}');
        throw Exception('Failed to save name');
      }
    } catch (error) {
      print('Error: $error');

      var box = Hive.box('userBox');
      print('Saving data to Hive: {name: $name, email: $email}');
      await box.put('userData', {'name': name, 'email': email});

      Provider.of<UserData>(context, listen: false).setName(name); // Update Global State

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Genderpage(name: name, email: email),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save name. Data saved locally.')),
      );
    }
  }

  Future<void> syncData() async {
    var box = Hive.box('userBox');
    var userData = box.get('userData');

    if (userData != null) {
      print('Attempting to sync data: $userData');
      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8000/save-name/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(userData),
        );

        if (response.statusCode == 200) {
          print('Name synced successfully: ${jsonDecode(response.body)}');
          await box.delete('userData');
          print('Hive Data after deletion: ${box.get('userData')}');
        } else {
          print('Failed to sync data: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang di Sleepy Panda!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Kita kenalan dulu yuk! Siapa nama \nkamu?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.35),
                    child: Container(
                      width: deviceWidth * 0.8,
                      height: deviceWidth * 0.15,
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          String name = _controller.text;
                          saveName(context, name, widget.email);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF272E49),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize: subtitleFontSize,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: subtitleFontSize,
                        ),
                      ),
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
