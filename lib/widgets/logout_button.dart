import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:sleepys/authentication/loginpage.dart';

class LogoutButton extends StatelessWidget {
  final Size screenSize;

  LogoutButton({required this.screenSize});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Hapus token dari SharedPreferences
    await prefs.remove('token');

    // Panggil endpoint logout di server
    final url = Uri.parse(
        'http://10.0.2.2:8000/logout/'); // Ganti dengan URL yang sesuai
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Navigate to Login Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPages()),
      (Route<dynamic> route) => false,
    );
  }

  void _confirmLogout(BuildContext context) async {
    final ArtDialogResponse result = await ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        title: "Are you sure?",
        text: "Do you really want to logout?",
        confirmButtonText: "Logout",
        cancelButtonText: "Cancel",
        type: ArtSweetAlertType.warning,
        showCancelBtn: true,
      ),
    );

    // Check the result and if confirmed, proceed with the logout
    if (result.isTapConfirmButton) {
      _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.05,
      width: screenSize.width * 0.8,
      child: ElevatedButton(
        onPressed: () => _confirmLogout(context),
        child: Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Color(0xFF009090),
            fontSize: screenSize.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenSize.width * 0.025),
          ),
        ),
      ),
    );
  }
}
