import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShiftLine extends StatelessWidget {
  const ShiftLine({
    super.key,
    required this.questionText,
    required this.clickText,
    required this.screen,
  });
  final String questionText;
  final String clickText;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return screen;
                },
              ),
            );
          },
          child: Text(
            clickText,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
