import 'package:flutter/material.dart';
import '../home.dart';
import '../../widgets/alarmscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SleepPage extends StatefulWidget {
  final String email;

  SleepPage({required this.email});

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int? selectedWakeUpHour;
  int? selectedSleepMinute;

  bool isHourSelected = false;
  bool isMinuteSelected = false;

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.notification.request();
    }
  }

  Future<void> showPermissionAlert() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Izin Notifikasi Diperlukan'),
            content: Text('Aplikasi ini membutuhkan izin notifikasi.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await requestNotificationPermission();
                },
                child: Text('Izinkan'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    showPermissionAlert();
  }

  Future<void> saveSleepData() async {
    final sleepTime = DateTime.now();
    final wakeTime = DateTime(
      sleepTime.year,
      sleepTime.month,
      sleepTime.day,
      selectedWakeUpHour ?? 0,
      selectedSleepMinute ?? 0,
    );

    final url = Uri.parse('http://10.0.2.2:8000/save-sleep-record/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': widget.email,
        'sleep_time': sleepTime.toIso8601String(),
        'wake_time': wakeTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print('Sleep data saved successfully');
    } else {
      print('Failed to save sleep data: ${response.body}');
    }
  }

  List<Widget> generateMinutes(Size screenSize) {
    return List<Widget>.generate(60, (int index) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (selectedSleepMinute == index)
            Container(
              width: screenSize.width * 0.15,
              height: screenSize.height * 0.07,
              decoration: BoxDecoration(
                color: Color(0xFFF0F2FF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(screenSize.width * 0.025),
              ),
            ),
          Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: screenSize.width * 0.1,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> generateHours(Size screenSize) {
    return List<Widget>.generate(24, (int index) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (selectedWakeUpHour == index)
            Container(
              width: screenSize.width * 0.15,
              height: screenSize.height * 0.07,
              decoration: BoxDecoration(
                color: Color(0xFFF0F2FF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(screenSize.width * 0.025),
              ),
            ),
          Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: screenSize.width * 0.1,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize
                .height, // Mengatur tinggi minimum agar sesuai dengan layar
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF272E49),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenSize.width * 0.05),
                topRight: Radius.circular(screenSize.width * 0.05),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Pilih waktu bangun tidur mu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.06,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenSize.height * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.25,
                        width: screenSize.width * 0.25,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: screenSize.height * 0.085,
                          perspective: 0.001,
                          diameterRatio: 9.0,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedWakeUpHour = index;
                              isHourSelected = true;
                            });
                          },
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: generateHours(screenSize),
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                            fontSize: screenSize.width * 0.1,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.25,
                        width: screenSize.width * 0.25,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: screenSize.height * 0.085,
                          perspective: 0.001,
                          diameterRatio: 9.0,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedSleepMinute = index;
                              isMinuteSelected = true;
                            });
                          },
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: generateMinutes(screenSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.056),
                    child: RichText(
                      text: TextSpan(
                          text: 'Waktu tidur ideal yang cukup adalah \nselama ',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                              color: Colors.white),
                          children: [
                            TextSpan(
                                text: '8 jam',
                                style: TextStyle(
                                    fontFamily: 'Urbanist', color: Colors.red))
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.1),
                    child: Container(
                      height: screenSize.height * 0.0625,
                      width: screenSize.width * 0.875,
                      child: ElevatedButton(
                        onPressed: isHourSelected && isMinuteSelected
                            ? () {
                                saveSleepData();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AlarmScreen(
                                      wakeUpTime:
                                          '${selectedWakeUpHour.toString().padLeft(2, '0')}:${selectedSleepMinute.toString().padLeft(2, '0')}',
                                      email: widget.email,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Text(
                          'Tidur sekarang',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00A8B5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenSize.width * 0.075),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  userEmail: widget.email,
                                )),
                      );
                    },
                    child: Text(
                      'Nanti saja',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.045),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
