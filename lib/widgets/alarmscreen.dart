import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:sleepys/pages/home.dart';

class AlarmScreen extends StatefulWidget {
  final String wakeUpTime;
  final String email;

  AlarmScreen({required this.wakeUpTime, required this.email});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  String _currentTime = '';
  bool _isWakeUpTime = false;
  String _userName = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  double _dragOffset = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  Timer? _alarmTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 20.0, end: 0.0).animate(_controller);
    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.grey).animate(_controller);

    _initNotification();
    _updateTime();
    _fetchUserName(); // Fetch the user's name
  }

  @override
  void dispose() {
    _controller.dispose();
    _alarmTimer?.cancel();
    super.dispose();
  }

  void _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = _formatDateTime(DateTime.now());
        _checkWakeUpTime();
      });
    });
  }

  void _checkWakeUpTime() {
    if (_currentTime == widget.wakeUpTime && !_isWakeUpTime) {
      _isWakeUpTime = true;
      _startRepeatingAlarm();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _stopAlarm() {
    _alarmTimer?.cancel();
    flutterLocalNotificationsPlugin.cancelAll();
    print("Alarm stopped");
  }

  Future<void> _startRepeatingAlarm() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('alarm_channel', 'Alarm',
            channelDescription: 'Alarm Notification',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('alarm'));
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    _alarmTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await flutterLocalNotificationsPlugin.show(0, 'Waktu Bangun',
          'Ini saatnya untuk bangun!', platformChannelSpecifics,
          payload: 'alarm_payload');
    });
  }

  void _onSwipeUp() {
    if (_isWakeUpTime) {
      _stopAlarm();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
          userEmail: widget.email,
        ),
      ));
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/user/${widget.email}'));

      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        setState(() {
          _userName = user['name'];
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (_isWakeUpTime && details.primaryVelocity! < -1000) {
            _onSwipeUp();
          }
        },
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.030,
                    bottom: screenSize.height * 0.20,
                  ),
                  child: Text(
                    _userName.isNotEmpty
                        ? 'Selamat tidur, $_userName'
                        : 'Selamat tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.06,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Center(
                  child: Text(
                    _currentTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Waktu bangun: ${widget.wakeUpTime}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.045,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.10),
                  child: Image.asset('assets/images/line.png'),
                ),
                if (_isWakeUpTime)
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.20),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animation.value),
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: _colorAnimation.value,
                              size: screenSize.width * 0.08,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (_isWakeUpTime)
                  Center(
                    child: Text(
                      'Geser ke atas untuk bangun',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenSize.width * 0.035,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
