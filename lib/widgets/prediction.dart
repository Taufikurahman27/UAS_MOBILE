import 'package:flutter/material.dart';
import 'package:sleepys/pages/home.dart';

class NormalPage extends StatelessWidget {
  final String email;

  NormalPage({required this.email, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: screenSize.height * 0.05),
                    Text(
                      'Profil Tidur Kamu',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.045),
                    Container(
                      padding: EdgeInsets.all(screenSize.width * 0.05),
                      decoration: BoxDecoration(
                        color: Color(0xFF272E49),
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.025),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baik.png',
                                height: screenSize.width * 0.05,
                                width: screenSize.width * 0.05,
                              ),
                              SizedBox(width: screenSize.width * 0.025),
                              Text(
                                'Baik',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.0125),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.075),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'Selamat, kamu memiliki profil tidur yang ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.0375,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'baik',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: screenSize.width * 0.0375,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: screenSize.width * 0.0375,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.0125),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.075),
                            child: Text(
                              'Kamu dapat tidur dengan nyenyak dan tanpa atau dengan sedikit gangguan.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.0375,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.0125),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.075),
                            child: Text(
                              'Durasi tidur kamu memadai dan berkualitas. Profil tidur baik mengindikasikan kesehatan fisik dan mental yang stabil.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.0375,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.025),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width * 0.075),
                            child: Text(
                              'Saran untuk kamu,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width * 0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.0125),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.width * 0.0375),
                            child: Column(
                              children: [
                                InfoBaik(
                                    text:
                                        'Tetap jaga rutinitas tidur yang konsisten.',
                                    screenSize: screenSize),
                                InfoBaik(
                                    text:
                                        'Memastikan lingkungan tidur mu nyaman, gelap, sejuk, dan tenang.',
                                    screenSize: screenSize),
                                InfoBaik(
                                    text:
                                        'Hindari penggunaan smartphone atau komputer di tempat tidur.',
                                    screenSize: screenSize),
                                InfoBaik(
                                    text:
                                        'Lakukan aktivitas fisik/olahraga secara teratur.',
                                    screenSize: screenSize),
                                InfoBaik(
                                    text:
                                        'Mengatur pola makan yang tepat, hindari makan besar sebelum tidur.',
                                    screenSize: screenSize),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05625),
                    Center(
                      child: Container(
                        height: screenSize.height * 0.0625,
                        width: screenSize.width * 0.875,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage(
                                      userEmail: email,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF009090),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.width * 0.075),
                            ),
                          ),
                          child: Text(
                            'Kembali ke Jurnal Tidur',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0375),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoBaik extends StatelessWidget {
  final String text;
  final Size screenSize;

  InfoBaik({required this.text, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.00625),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: screenSize.width * 0.05,
            height: screenSize.width * 0.05,
          ),
          SizedBox(width: screenSize.width * 0.025),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.width * 0.0375,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SleepApneaPage extends StatelessWidget {
  final String email;

  SleepApneaPage({required this.email, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenSize.height * 0.05),
              Text(
                'Profil Tidur Kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.045),
              Container(
                padding: EdgeInsets.all(screenSize.width * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xFF272E49),
                  borderRadius: BorderRadius.circular(screenSize.width * 0.025),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/gangguan.png',
                          height: screenSize.width * 0.05,
                          width: screenSize.width * 0.05,
                        ),
                        SizedBox(width: screenSize.width * 0.025),
                        RichText(
                          text: TextSpan(
                            text: 'Potensi gangguan: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.040,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                            children: [
                              TextSpan(
                                text: 'Sleep Apnea',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.040,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: RichText(
                        text: TextSpan(
                          text: 'Kamu berpotensi memiliki gangguan: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.0375,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sleep apnea',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.0375,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Sleep apnea merupakan salah satu kondisi serius terhadap masalah tidur.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.0375,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Segera konsultasikan dengan dokter atau ahli tidur agar kamu mendapatkan bantuan profesional.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.0375,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Saran untuk kamu,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.0375),
                      child: Column(
                        children: [
                          InfoApnea(
                            text:
                                'Segera konsultasikan dengan dokter untuk diagnosis yang tepat.',
                            screenSize: screenSize,
                          ),
                          InfoApnea(
                            text:
                                'Hindari alkohol, dan merokok, serta mempertimbangkan untuk tidur dalam posisi yang lebih baik, seperti tidur miring.',
                            screenSize: screenSize,
                          ),
                          InfoApnea(
                            text:
                                'Lakukan olahraga secara teratur, dan menjaga pola makan yang seimbang.',
                            screenSize: screenSize,
                          ),
                          InfoApnea(
                            text:
                                'Terus lakukan evaluasi dan pemantauan berkala dengan dokter atau ahli tidur untuk memastikan perubahan gaya hidup.',
                            screenSize: screenSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.05625),
              Center(
                child: Container(
                  height: screenSize.height * 0.0625,
                  width: screenSize.width * 0.875,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage(userEmail: email)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.075),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Jurnal Tidur',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.045,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.0375),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoApnea extends StatelessWidget {
  final String text;
  final Size screenSize;

  InfoApnea({required this.text, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.00625),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: screenSize.width * 0.05,
            height: screenSize.width * 0.05,
          ),
          SizedBox(width: screenSize.width * 0.025),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.width * 0.0375,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsomniaPage extends StatelessWidget {
  final String email;

  InsomniaPage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenSize.height * 0.05),
              Text(
                'Profil Tidur Kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.045),
              Container(
                padding: EdgeInsets.all(screenSize.width * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xFF272E49),
                  borderRadius: BorderRadius.circular(screenSize.width * 0.025),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/gangguan.png',
                          height: screenSize.width * 0.05,
                          width: screenSize.width * 0.05,
                        ),
                        SizedBox(width: screenSize.width * 0.025),
                        RichText(
                          text: TextSpan(
                            text: 'Potensi gangguan: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.040,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                            children: [
                              TextSpan(
                                text: 'Insomnia',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.040,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: RichText(
                        text: TextSpan(
                          text: 'Kamu berpotensi memiliki gangguan: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.0375,
                          ),
                          children: [
                            TextSpan(
                              text: 'Insomnia',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.0375,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Insomnia merupakan gangguan tidur yang melibatkan kesulitan tidur atau sering terbangun di tengah malam.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.0375,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Segera konsultasikan dengan dokter atau ahli tidur agar kamu mendapatkan bantuan profesional.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.0375,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.075),
                      child: Text(
                        'Saran untuk kamu,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.0125),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.0375),
                      child: Column(
                        children: [
                          InfoInsomnia(
                            text:
                                'Mengatur rutinitas tidur yang konsisten. Menerapkan jadwal tidur yang tepat, dan hindari tidur siang yang berlebihan.',
                            screenSize: screenSize,
                          ),
                          InfoInsomnia(
                            text:
                                'Menghindari kafein, alkohol, dan makanan berat beberapa jam sebelum tidur.',
                            screenSize: screenSize,
                          ),
                          InfoInsomnia(
                            text:
                                'Melakukan aktivitas yang menenangkan seperti membaca buku, atau meditasi.',
                            screenSize: screenSize,
                          ),
                          InfoInsomnia(
                            text:
                                'Jika berlanjut, lakukan konsultasi dengan dokter untuk mencari penyebab dan pengobatan yang sesuai.',
                            screenSize: screenSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.05625),
              Center(
                child: Container(
                  height: screenSize.height * 0.0625,
                  width: screenSize.width * 0.875,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                              userEmail: email), // Gunakan parameter email
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.075),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Jurnal Tidur',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.045,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.0375),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoInsomnia extends StatelessWidget {
  final String text;
  final Size screenSize;

  InfoInsomnia({required this.text, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.00625),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: screenSize.width * 0.05,
            height: screenSize.width * 0.05,
          ),
          SizedBox(width: screenSize.width * 0.025),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.width * 0.0375,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
