import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../pages/weightpage.dart';
import '../widgets/note_card.dart';

class HeightSelection extends StatelessWidget {
  final String name;
  final String email;
  final String gender;
  final String work;
  final String date_of_birth;

  const HeightSelection({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
    required this.date_of_birth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeightSelectionPage(
        name: name,
        email: email,
        gender: gender,
        work: work,
        date_of_birth: date_of_birth,
      ),
    );
  }
}

class HeightSelectionPage extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final String work;
  final String date_of_birth;

  const HeightSelectionPage({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
    required this.date_of_birth,
  });

  @override
  _HeightSelectionPageState createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  FixedExtentScrollController _controller = FixedExtentScrollController();
  int selectedItem = 0;
  Timer? _timer;
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.map(
        (List<ConnectivityResult> results) => results.firstWhere(
            (result) => result != ConnectivityResult.none,
            orElse: () => ConnectivityResult.none));

    // Listen for changes in connectivity
    _connectivityStream.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // If connectivity is restored, sync data
        syncData();
      }
    });

    // Sync any unsent data at the start
    syncData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> saveHeight(int height) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-height/'), // Update URL as needed
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'name': widget.name,
          'gender': int.parse(widget.gender),
          'work': widget.work,
          'date_of_birth': widget.date_of_birth,
          'height': height,
        }),
      );

      if (response.statusCode == 200) {
        print('Height saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save height: ${response.body}');
        throw Exception('Failed to save height');
      }
    } catch (error) {
      print('Error: $error');

      // Save the height data to Hive for later sync
      var box = Hive.box('userBox');
      print(
          'Saving height data to Hive: {name: ${widget.name}, email: ${widget.email}, gender: ${widget.gender}, work: ${widget.work}, date_of_birth: ${widget.date_of_birth}, height: $height}');
      await box.put('heightData', {
        'name': widget.name,
        'email': widget.email,
        'gender': widget.gender,
        'work': widget.work,
        'date_of_birth': widget.date_of_birth,
        'height': height,
      });
    }
  }

  Future<void> syncData() async {
    var box = Hive.box('userBox');
    var heightData = box.get('heightData');

    if (heightData != null) {
      print('Attempting to sync height data: $heightData');
      try {
        final response = await http.put(
          Uri.parse(
              'http://10.0.2.2:8000/save-height/'), // Update URL as needed
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(heightData),
        );

        if (response.statusCode == 200) {
          print('Height synced successfully: ${jsonDecode(response.body)}');
          // Remove the data from Hive after successful sync
          await box.delete('heightData');
          print(
              'Hive Data after deletion: ${box.get('heightData')}'); // Debugging statement to check if Hive is empty
        } else {
          print('Failed to sync height data: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void _onItemChanged(int index) {
    setState(() {
      selectedItem = index + 100;
    });
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 1), () {
      saveHeight(selectedItem).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Weightpage(
              name: widget.name,
              email: widget.email,
              gender: widget.gender,
              work: widget.work,
              date_of_birth: widget.date_of_birth,
              height: selectedItem,
              userEmail: widget.email,
            ),
          ),
        );
      }).catchError((error) {
        print('Error: $error');
      });
    });
  }

  void printHiveData() {
    var box = Hive.box('userBox');
    print('Hive Data: ${box.get('heightData')}');
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.045;
    final double pickerItemHeight = deviceWidth * 0.15;
    final double pickerContainerWidth = deviceWidth * 0.25;
    final double paddingHorizontal = deviceWidth * 0.05;

    // Sync any unsent data when this page is built
    printHiveData();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selanjutnya,',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  Text(
                    'Berapa tinggi badan mu?',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  NoteCard(
                    text:
                        'Lakukan Scrolling untuk menentukan Tinggi Badan kamu!',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onPanEnd: (details) {
                          _resetTimer();
                        },
                        child: Container(
                          height: pickerItemHeight,
                          width: pickerContainerWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF272E49),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            controller: _controller,
                            itemExtent: pickerItemHeight,
                            physics: const FixedExtentScrollPhysics(),
                            overAndUnderCenterOpacity: 0.5,
                            onSelectedItemChanged: _onItemChanged,
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    '${index + 100}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: subtitleFontSize * 1.5,
                                    ),
                                  ),
                                );
                              },
                              childCount:
                                  200, // This gives a range from 100 cm to 299 cm
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.02),
                      Text(
                        'Cm',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: subtitleFontSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: deviceWidth * 0.08),
          ],
        ),
      ),
    );
  }
}
