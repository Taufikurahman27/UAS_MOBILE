import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/widgets/prediction.dart';

class SleepProfile extends StatelessWidget {
  final String email;

  SleepProfile({required this.email, Key? key}) : super(key: key);

  Future<void> getPrediction(BuildContext context) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/predict');

      // Kirim POST request dengan email dalam body
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prediction = data['prediction'];

        // Navigasi berdasarkan hasil prediksi
        if (prediction == 'Normal') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NormalPage(email: email)));
        } else if (prediction == 'Sleep Apnea') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SleepApneaPage(email: email)));
        } else if (prediction == 'Insomnia') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsomniaPage(email: email)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unknown prediction result')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get prediction from API')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F), // Set background color to dark blue
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.10;
          double fontSize = constraints.maxWidth * 0.05;
          double buttonHeight = constraints.maxHeight * 0.07;
          double buttonWidth = constraints.maxWidth * 0.9;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sebelum melanjutkan..',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  InfoItem(
                    text:
                        'Sleepy Panda bertujuan untuk memberikan edukasi dan informasi. Sleepy Panda berusaha untuk memberikan pemahaman lebih tentang pola tidur kamu. Tetapi, Sleepy Panda bukanlah alat diagnostik atau pengganti konsultasi dengan dokter.',
                  ),
                  InfoItem(
                    text:
                        'Profil tidur yang disediakan oleh Sleepy Panda berdasarkan data tidur yang kamu berikan, dan bertujuan untuk memberikan rekomendasi terkait pola tidur atau potensi kesehatan.',
                  ),
                  InfoItem(
                    text:
                        'Kami selalu menyarankan untuk berkonsultasi dengan dokter atau ahli tidur jika mengalami masalah tidur yang serius atau berkelanjutan.',
                  ),
                  InfoItem(
                    text: 'Hasil profil tidur dapat berubah seiring waktu.',
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          getPrediction(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00A99D), // Button color
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Ya, saya mengerti',
                          style: TextStyle(
                            fontSize: fontSize * 0.6,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String text;

  InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
