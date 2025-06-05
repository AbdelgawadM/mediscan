import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicTextForm extends StatelessWidget {
  const BasicTextForm({
    super.key,
    required this.customHint,
    required this.onChange,
  });
  final String customHint;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'field is required';
            }
            return null;
          },
          onChanged: onChange,
          // keyboardType: ,
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.blueGrey, width: 4.0), // Custom color & width
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xffB3E2A7),
                    width: 4.0), // Custom color & width
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              filled: true,
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
              hintText: customHint,
              hintStyle: const TextStyle(color: Color(0xffffffff)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              fillColor: const Color(0xff2D8174)),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
