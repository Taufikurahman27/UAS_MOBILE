import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String text;

  const NoteCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double textFontSize = deviceWidth * 0.035;
    final double iconSize = deviceWidth * 0.045;

    return Card(
      color: Color(0xFF272E49),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(deviceWidth * 0.03),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: iconSize,
            ),
            SizedBox(width: deviceWidth * 0.02),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: textFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
