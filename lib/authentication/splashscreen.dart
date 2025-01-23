import 'package:flutter/material.dart';
import 'package:sleepys/authentication/loginpage.dart';
import 'dart:async';
import 'package:sleepys/authentication/singup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScreenOpsi()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/sleepypanda.png',
                height: screenSize.width * 0.4,
                width: screenSize.width * 0.4,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Sleepy Panda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.1,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Urbanist',
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenOpsi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1D42),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 15, horizontal: screenSize.width * 0.1),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/sleepypanda.png',
                        height: screenSize.width * 0.4,
                        width: screenSize.width * 0.4,
                      ),
                      Text(
                        'Sleepy Panda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.1,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Urbanist',
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.2),
                        child: Text(
                          'Mulai dengan masuk atau \nmendaftar untuk melihat analisa tidur mu.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPages()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009090),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize:
                              Size(double.infinity, screenSize.height * 0.06),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize:
                              Size(double.infinity, screenSize.height * 0.06),
                        ),
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.045,
                            color: const Color(0xFF009090),
                          ),
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
    );
  }
}
