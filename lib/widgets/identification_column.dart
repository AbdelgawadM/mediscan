import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentificationColumn extends StatelessWidget {
  const IdentificationColumn({super.key, required this.columnTitle});
  final String columnTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Image.asset('assets/logos/logo light.jpg', height: 100, width: 100),
        const SizedBox(height: 60),
        Text(
          columnTitle,
          style: GoogleFonts.roboto(
            color: const Color(0xff74AAA0),
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
