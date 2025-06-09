import 'package:flutter/material.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_registeration_screen.dart';
import 'package:mediscan/screens/user_interface/user_registeration_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimarybgColor,
      appBar: AppBar(
        backgroundColor: kPrimarybgColor,
        title: const Text('Choose Account Type'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Register As",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ChoiceButton(
              screen: UserRegisterationScreen(),
              icon: Icons.person,
              title: 'Normal User',
            ),
            const SizedBox(height: 20),
            ChoiceButton(
              screen: PharmacyRegisterScreen(),
              icon: Icons.local_pharmacy,
              title: 'pharmacy',
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.title,
    required this.icon,
    required this.screen,
  });
  final String title;
  final IconData icon;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
