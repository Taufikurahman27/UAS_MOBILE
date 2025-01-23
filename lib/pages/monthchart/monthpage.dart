import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleepys/helper/card_sleepprofile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sleepys/pages/monthchart/monthbarchart.dart';
import 'package:sleepys/pages/monthchart/monthlinechart_sleeptime.dart';
import 'package:sleepys/pages/monthchart/monthlinechart_wakeuptime.dart';

class MonthPage extends StatefulWidget {
  final String email;

  MonthPage({required this.email});

  @override
  _MonthPageState createState() => _MonthPageState();
}

Future<Map<String, dynamic>> fetchMonthlyData(
    String email, String month, String year) async {
  // Constructing the URL with the required month and year parameters
  final url = Uri.parse(
      'http://10.0.2.2:8000/get-monthly-sleep-data/$email?month=$month&year=$year');

  final response = await http.get(url);

  print('Request URL: $url');
  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load sleep data: ${response.statusCode} - ${response.reasonPhrase}');
  }
}

class _MonthPageState extends State<MonthPage> {
  bool _isBackButtonPressed = false;
  bool _isNextButtonPressed = false;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  Map<String, dynamic> monthlyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      isLoading = true; // Set loading to true before fetching data
    });

    try {
      String month = startDate.month
          .toString()
          .padLeft(2, '0'); // Ensure month is two digits
      String year = startDate.year.toString();

      Map<String, dynamic> data =
          await fetchMonthlyData(widget.email, month, year);

      // Tambahkan log untuk mengecek isi data
      print("Fetched Data: $data");

      setState(() {
        monthlyData = data;
      });

      // Tambahkan log untuk mengecek hasil evaluasi kondisi
      if (monthlyData.containsKey('daily_sleep_durations')) {
        print(
            "daily_sleep_durations found: ${monthlyData['daily_sleep_durations']}");
        print(
            "Length of daily_sleep_durations: ${(monthlyData['daily_sleep_durations'] as List).length}");
        print(
            "All durations valid: ${(monthlyData['daily_sleep_durations'] as List).every((duration) => duration != null && duration > 0)}");
      } else {
        print("Key 'daily_sleep_durations' not found in monthlyData");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false; // Ensure loading is false after fetching
      });
    }
  }

  void _previousMonth() {
    setState(() {
      isLoading = true; // Set loading status to true
      monthlyData = {}; // Clear old data
      startDate = DateTime(startDate.year, startDate.month - 1, 1);
      _fetchData();
    });
  }

  void _nextMonth() {
    setState(() {
      isLoading = true; // Set loading status to true
      monthlyData = {}; // Clear old data
      startDate = DateTime(startDate.year, startDate.month + 1, 1);
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
    String year = DateFormat('yyyy').format(startDate);
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;
    final dateFormat = DateFormat('MMMM', 'id');

    // Generate sleep data
    final sleepData = (monthlyData.containsKey('weekly_sleep_durations') &&
            monthlyData['weekly_sleep_durations'] is List)
        ? List<double>.generate(
            4,
            (index) => (monthlyData['weekly_sleep_durations'][index] ?? 0.0)
                .toDouble())
        : List<double>.filled(4, 0.0);

    final sleepStartTimes =
        (monthlyData.containsKey('weekly_sleep_start_times') &&
                monthlyData['weekly_sleep_start_times'] is Map)
            ? List<double?>.generate(4, (index) {
                List<dynamic>? times =
                    monthlyData['weekly_sleep_start_times'][index.toString()];
                if (times != null && times.isNotEmpty) {
                  String time = times[0] as String;
                  double hours = double.parse(time.split(":")[0]);
                  double minutes = double.parse(time.split(":")[1]) / 60;
                  return hours + minutes;
                } else {
                  return null; // Return null if there's no data
                }
              })
            : List<double?>.filled(
                4, null); // Use List<double?> for nullable values

    final wakeUpTimes = (monthlyData.containsKey('weekly_wake_times') &&
            monthlyData['weekly_wake_times'] is Map)
        ? List<double?>.generate(4, (index) {
            List<dynamic>? times =
                monthlyData['weekly_wake_times'][index.toString()];
            if (times != null && times.isNotEmpty) {
              String time = times[0] as String;
              double hours = double.parse(time.split(":")[0]);
              double minutes = double.parse(time.split(":")[1]) / 60;
              return hours + minutes;
            } else {
              return null; // Return null if there's no data
            }
          })
        : List<double?>.filled(
            4, null); // Use List<double?> for nullable values

    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF20223F),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool hasFullMonthData = monthlyData.containsKey('daily_sleep_durations') &&
        monthlyData['daily_sleep_durations'] is List &&
        (monthlyData['daily_sleep_durations'] as List).length == 30 &&
        (monthlyData['daily_sleep_durations'] as List).every((duration) =>
            duration != null &&
            duration > 0); // Pastikan data lengkap dan valid

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MonthlySleepProfile(
                email: widget.email,
                hasSleepData: hasFullMonthData, // Only show if full month data
              ),
              SizedBox(height: 10),
              Text(
                year,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/back.png',
                      height: 35,
                      width: 35,
                      color: _isBackButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isBackButtonPressed = !_isBackButtonPressed;
                        _isNextButtonPressed =
                            false; // Reset other button state
                        _previousMonth();
                      });
                    },
                  ),
                  Text(
                    dateFormat.format(startDate),
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/next.png',
                      height: 35,
                      width: 35,
                      color: _isNextButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNextButtonPressed = !_isNextButtonPressed;
                        _isBackButtonPressed =
                            false; // Reset other button state
                        _nextMonth();
                      });
                    },
                  ),
                ],
              ),
              monthlyData.isNotEmpty
                  ? SleepEntryGrid(monthlyData: monthlyData)
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Belum ada catatan tidur untuk minggu ini.',
                        style: TextStyle(
                          fontSize: baseFontSize,
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 200, bottom: 20),
                child: Text(
                  'Durasi Tidur',
                  style: TextStyle(
                    fontSize: baseFontSize,
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthBarChart(
                          sleepData: sleepData,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Mulai Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthLineChart(
                          data: sleepStartTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Bangun Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthLineChart1(
                          data: wakeUpTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
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

class SleepEntry extends StatelessWidget {
  final String title;
  final String value;
  final String content;
  final String imageAsset;

  SleepEntry({
    required this.title,
    required this.value,
    required this.content,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    final double imageHeight = screenWidth * 0.06; // 6% of screen width
    final double imageWidth = screenWidth * 0.06; // 6% of screen width
    final double fontSizeContent = screenWidth * 0.035; // 3.5% of screen width
    final double fontSizeTitle = screenWidth * 0.03; // 3% of screen width
    final double fontSizeValue = screenWidth * 0.03; // 3% of screen width

    final double imageTop = screenWidth * 0.05; // 5% of screen width
    final double imageLeft = screenWidth * 0.025; // 2.5% of screen width
    final double contentLeft = screenWidth * 0.1; // 10% of screen width
    final double contentTop = screenWidth * 0.0125; // 1.25% of screen width
    final double titleTop = screenWidth * 0.05; // 5% of screen width
    final double valueTop = screenWidth * 0.0875; // 8.75% of screen width

    return Card(
      color: Color(0xFF272E49),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        child: Stack(
          children: [
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Image.asset(
                imageAsset,
                height: imageHeight,
                width: imageWidth,
              ),
            ),
            Positioned(
              left: contentLeft,
              top: contentTop,
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: fontSizeContent,
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: titleTop,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: valueTop,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: fontSizeValue,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepEntryGrid extends StatelessWidget {
  final Map<String, dynamic> monthlyData;

  SleepEntryGrid({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxItemWidth = constraints.maxWidth / 2 - 10;
        double itemHeight = maxItemWidth * 0.55;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxItemWidth,
                childAspectRatio: maxItemWidth / itemHeight,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Durasi tidur',
                      value: monthlyData['avg_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/clock.png',
                    );
                  case 1:
                    return SleepEntry(
                      content: 'Total',
                      title: 'Durasi tidur',
                      value: monthlyData['total_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/wakeup.png',
                    );
                  case 2:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Mulai tidur',
                      value: monthlyData['avg_sleep_time'] ?? 'N/A',
                      imageAsset: 'assets/images/bed.png',
                    );
                  case 3:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Bangun tidur',
                      value: monthlyData['avg_wake_time'] ?? 'N/A',
                      imageAsset: 'assets/images/sun.png',
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
