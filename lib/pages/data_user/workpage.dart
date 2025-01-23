import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'datepicker.dart';
import '../../helper/note_card.dart';

class Workpage extends StatelessWidget {
  final String email;
  final String name;
  final String gender;

  const Workpage(
      {super.key,
      required this.name,
      required this.gender,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Workpages(name: name, gender: gender, email: email),
    );
  }
}

class Workpages extends StatefulWidget {
  final String name;
  final String gender;
  final String email;

  const Workpages(
      {super.key,
      required this.name,
      required this.gender,
      required this.email});

  @override
  _WorkpagesState createState() => _WorkpagesState();
}

class _WorkpagesState extends State<Workpages> {
  String? selectedWork;
  final List<String> occupations = [
    'Accountant',
    'Doctor',
    'Engineer',
    'Lawyer',
    'Manager',
    'Nurse',
    'Sales Representative',
    'Salesperson',
    'Scientist',
    'Software Engineer',
    'Teacher'
  ];

  Future<void> saveWork(String work) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-work/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': widget.name,
          'email': widget.email,
          'gender': widget.gender, // Send gender as string
          'work': work,
        }),
      );

      if (response.statusCode == 200) {
        print('Work saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save work: ${response.body}');
        throw Exception('Failed to save work');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void onOccupationSelected(String work) {
    saveWork(work).then((_) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Datepicker(
                name: widget.name,
                email: widget.email,
                gender: widget.gender,
                work: work),
          ),
        );
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF20223F),
        ),
        backgroundColor: Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleepy Panda ingin mengenalmu!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Apa Pekerjaan anda sekarang?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: deviceWidth * 0.03),
              NoteCard(
                text:
                    'Pilih pekerjaan Anda dari daftar di bawah ini. Jika pekerjaan Anda tidak ada di daftar, pilih yang paling mendekati.',
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.35),
                    child: Container(
                      width: deviceWidth * 0.8,
                      height: deviceWidth * 0.15,
                      padding:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Color(0xFF272E49),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedWork,
                          hint: Text(
                            'Pilih Pekerjaan',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: subtitleFontSize,
                            ),
                          ),
                          dropdownColor: Color(0xFF272E49),
                          items: occupations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: subtitleFontSize,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedWork = newValue;
                              if (selectedWork != null) {
                                onOccupationSelected(selectedWork!);
                              }
                            });
                          },
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
