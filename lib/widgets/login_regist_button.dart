import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginRegistButton extends StatelessWidget {
  const LoginRegistButton(
      {super.key, required this.buttonText, required this.onTap});
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Color(0xFFB3D8A8)),
                backgroundColor: WidgetStatePropertyAll(Color(0xffE9762B))),
            onPressed: onTap,
            child: Text(
              buttonText,
              style: GoogleFonts.roboto(color: Colors.white),
            )),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
