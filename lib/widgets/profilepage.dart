import 'package:flutter/material.dart';
import 'package:sleepys/widgets/user_profile.dart';
import 'package:sleepys/widgets/logout_button.dart';
import 'package:sleepys/widgets/feedback.dart';

class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            CircleAvatar(
              radius: screenSize.width * 0.1,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: screenSize.width * 0.15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Divider(color: Colors.grey),
            Infoprofile(screenSize: screenSize),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.01,
                horizontal: screenSize.width * 0.05,
              ),
              child: Card(
                color: Color(0xFF272E49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenSize.width * 0.025),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        'assets/images/detil.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text(
                        'Detil profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Userprofile(email: email),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.15,
                      ),
                      child: Divider(color: Colors.grey, height: 0),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/terms.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        // Tambahkan aksi untuk "Terms & Conditions"
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.15,
                      ),
                      child: Divider(color: Colors.grey, height: 0),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/feedback.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            LogoutButton(screenSize: screenSize),
          ],
        ),
      ),
    );
  }
}

class Infoprofile extends StatelessWidget {
  final Size screenSize;

  Infoprofile({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
