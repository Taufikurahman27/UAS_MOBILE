import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:sleepys/pages/data_user/namepage.dart';
import 'package:sleepys/pages/data_user/genderpage.dart';
import 'package:sleepys/pages/data_user/workpage.dart';
import 'package:sleepys/pages/data_user/datepicker.dart';
import 'package:sleepys/pages/data_user/weightpage.dart';
import 'package:sleepys/pages/data_user/heightselection.dart';
import 'package:sleepys/pages/home.dart';
import 'package:sleepys/authentication/singup.dart';
import 'package:http/http.dart' as http;
import '../widgets/signupprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class LoginPages extends StatelessWidget {
  LoginPages({Key? key}) : super(key: key);

  bool isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void showCustomSnackBar(BuildContext context, String message) {
    final screenSize = MediaQuery.of(context).size;

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015,
          horizontal: screenSize.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF2D2C4E),
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: screenSize.width * 0.05,
            ),
            SizedBox(width: screenSize.width * 0.03),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.035,
                ),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02,
        horizontal: screenSize.width * 0.04,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _login(BuildContext context) async {
    final signupForm = Provider.of<SignupFormProvider>(context, listen: false);
    final email = signupForm.email1;
    final password = signupForm.password1;

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, "Email dan password harus diisi");
      return;
    }

    if (!isValidEmail(email)) {
      showCustomSnackBar(context, "Format email tidak valid");
      return;
    }

    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final loginUrl = Uri.parse('http://10.0.2.2:8000/login/');
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];

        // Simpan token ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        // Ambil profil user
        await _getUserProfile(context, token);
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['detail'];

        showCustomSnackBar(context, errorMessage);
      }
    } catch (e) {
      showCustomSnackBar(context, "Terjadi kesalahan. Silakan coba lagi.");
    } finally {
      // Tutup loading indicator
      Navigator.of(context).pop();
    }
  }

  Future<void> _getUserProfile(BuildContext context, String token) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/user-profile/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final name = responseData['name'];
        final gender = responseData['gender']?.toString();
        final work = responseData['work'];
        final dateOfBirth = responseData['date_of_birth'];
        final height = (responseData['height'] as num).toDouble();
        final weight = (responseData['weight'] as num).toDouble();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name ?? '');
        if (gender != null) {
          await prefs.setString('gender', gender == '0' ? 'female' : 'male');
        } else {
          await prefs.setString('gender', '');
        }

        await prefs.setString('work', work ?? '');
        await prefs.setString('date_of_birth', dateOfBirth ?? '');
        await prefs.setDouble('height', height);
        await prefs.setDouble('weight', weight);

        showCustomSnackBar(context, "Login berhasil");

        // Cek status profil yang sudah disimpan
        checkProfileCompletion(context, prefs.getString('email') ?? '');
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['detail'];

        showCustomSnackBar(context, errorMessage);
      }
    } catch (e) {
      showCustomSnackBar(
          context, "Terjadi kesalahan saat mengambil data profil.");
    }
  }

  Future<void> checkProfileCompletion(
      BuildContext context, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final gender = prefs.getString('gender');
    final work = prefs.getString('work') ?? '';
    final dateOfBirth = prefs.getString('date_of_birth') ?? '';
    final height = prefs.getDouble('height') ?? 0;
    final weight = prefs.getDouble('weight') ?? 0;

    print('Name: $name');
    print('Gender: $gender');
    print('Work: $work');
    print('Date of Birth: $dateOfBirth');
    print('Height: $height');
    print('Weight: $weight');

    if (name.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Namepage(email: email)),
      );
    } else if (gender == null || gender.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Genderpage(name: name, email: email),
        ),
      );
    } else if (work.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Workpage(name: name, email: email, gender: gender),
        ),
      );
    } else if (dateOfBirth.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Datepicker(name: name, email: email, gender: gender, work: work),
        ),
      );
    } else if (weight == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Weightpage(
            name: name,
            email: email,
            gender: gender,
            work: work,
            date_of_birth: dateOfBirth,
            height: height.toInt(),
            userEmail: email,
          ),
        ),
      );
    } else if (height == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HeightSelection(
            name: name,
            email: email,
            gender: gender,
            work: work,
            date_of_birth: dateOfBirth,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userEmail: email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupForm = Provider.of<SignupFormProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Allow the widget to resize when the keyboard appears
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
                          height: screenSize.width * 0.35,
                          width: screenSize.width * 0.35,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Masuk menggunakan akun yang \nsudah kamu daftarkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        Container(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.035),
                                child: Image.asset(
                                  'assets/images/email.png',
                                  height: screenSize.width * 0.06,
                                  width: screenSize.width * 0.06,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            onChanged: (value) {
                              signupForm.updateEmail1(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.email1,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.email1.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Container(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.035),
                                child: Image.asset(
                                  'assets/images/lock.png',
                                  height: screenSize.width * 0.06,
                                  width: screenSize.width * 0.06,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            onChanged: (value) {
                              signupForm.updatePassword1(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.password1,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.password1.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return ForgotPasswordBottomSheet();
                                },
                              );
                            },
                            child: Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: Color(0xFF00D0C0),
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.15),
                        ElevatedButton(
                          onPressed: () {
                            _login(context);
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
                              color: Colors.white,
                              fontSize: screenSize.width * 0.045,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Belum memiliki akun? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Daftar sekarang',
                                  style: TextStyle(
                                    color: Color(0xFF00D0C0),
                                    fontFamily: 'Urbanist',
                                    fontSize: screenSize.width * 0.04,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    }),
                            ],
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
      ),
    );
  }
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  @override
  _ForgotPasswordBottomSheetState createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  bool isOtpSent = false;
  bool isOtpVerified = false;

  String? emailError;
  String? otpError;
  String? passwordError;

  Future<void> requestOtp() async {
    setState(() {
      emailError = null;
    });

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email tidak boleh kosong';
      });
      return;
    }

    final email = emailController.text;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/request-otp/?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        isOtpSent = true;
        this.email = email;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        emailError = 'Email tidak terdaftar';
      });
    } else {
      setState(() {
        emailError = 'Terjadi kesalahan, coba lagi nanti.';
      });
    }
  }

  Future<void> verifyOtp() async {
    setState(() {
      otpError = null;
    });

    if (otpController.text.isEmpty) {
      setState(() {
        otpError = 'OTP tidak boleh kosong';
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/verify-otp/')
        .replace(queryParameters: {
      'email': email!,
      'otp': otpController.text,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        isOtpVerified = true;
      });
    } else if (response.statusCode == 400) {
      setState(() {
        otpError = 'Kode OTP salah atau sudah kedaluwarsa';
      });
    } else {
      setState(() {
        otpError = 'Terjadi kesalahan, coba lagi nanti.';
      });
    }
  }

  Future<void> resetPassword() async {
    final url = Uri.parse('http://10.0.2.2:8000/reset-password/')
        .replace(queryParameters: {
      'email': email!,
      'new_password': passwordController.text,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Display success alert
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "Success",
          text: "Password berhasil direset!",
          confirmButtonText: "OK",
          onConfirm: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.of(context).pop(); // Close the bottom sheet
          },
        ),
      );
    } else {
      print('Failed to reset password. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        height:
            MediaQuery.of(context).viewInsets.bottom + (isOtpSent ? 400 : 350),
        decoration: const BoxDecoration(
          color: Color(0xFF272E49),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.1,
              height: 4,
              color: const Color(0xFF009090),
            ),
            const SizedBox(height: 10),
            Text(
              'Lupa Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.06,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _getInstructionText(),
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: screenWidth * 0.04,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth * 0.05),
            if (!isOtpSent) ...[
              if (emailError != null) buildErrorText(emailError!, screenWidth),
              buildEmailInput(screenWidth),
              SizedBox(height: screenWidth * 0.03),
              buildSendOtpButton(screenWidth),
            ] else if (isOtpSent && !isOtpVerified) ...[
              if (otpError != null) buildErrorText(otpError!, screenWidth),
              buildOtpInput(screenWidth),
              SizedBox(height: screenWidth * 0.03),
              buildVerifyOtpButton(screenWidth),
            ] else if (isOtpVerified) ...[
              if (passwordError != null)
                buildErrorText(passwordError!, screenWidth),
              buildNewPasswordInput(screenWidth),
              SizedBox(height: screenWidth * 0.03),
              buildResetPasswordButton(screenWidth),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildErrorText(String errorText, double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      margin: EdgeInsets.only(bottom: 8.0),
      child: Text(
        errorText,
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Urbanist',
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  String _getInstructionText() {
    if (!isOtpSent) {
      return 'Kode OTP akan dikirim melalui email yang kamu gunakan untuk mendaftar.';
    } else if (isOtpSent && !isOtpVerified) {
      return 'Masukkan kode OTP yang telah kami kirim ke email Anda untuk verifikasi.';
    } else if (isOtpVerified) {
      return 'Masukkan password baru Anda untuk mereset password.';
    } else {
      return 'Error: Status tidak dikenali';
    }
  }

  Widget buildEmailInput(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Urbanist',
            fontSize: screenWidth * 0.04,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(screenWidth * 0.035),
            child: Image.asset('assets/images/email1.png'),
            height: screenWidth * 0.08,
            width: screenWidth * 0.08,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF333333),
          fontFamily: 'Urbanist',
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget buildSendOtpButton(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: ElevatedButton(
        onPressed: requestOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009090),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'Kirim',
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Colors.white,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  Widget buildOtpInput(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: TextField(
        controller: otpController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'OTP',
          hintStyle: TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Urbanist',
            fontSize: screenWidth * 0.04,
          ),
          prefixIcon: Icon(Icons.lock, color: Color(0xFF333333)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF333333),
          fontFamily: 'Urbanist',
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget buildVerifyOtpButton(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: ElevatedButton(
        onPressed: verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009090),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'Verifikasi',
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Colors.white,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  Widget buildNewPasswordInput(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password Baru',
          hintStyle: TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Urbanist',
            fontSize: screenWidth * 0.04,
          ),
          prefixIcon: Icon(Icons.lock, color: Color(0xFF333333)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF333333),
          fontFamily: 'Urbanist',
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget buildResetPasswordButton(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.85,
      child: ElevatedButton(
        onPressed: resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009090),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'Reset Password',
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Colors.white,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }
}
