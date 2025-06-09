import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediscan/helper/AuthMethods.dart';
import 'package:mediscan/models/pharmacy_model.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_admin_screen.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_registeration_screen.dart';
import 'package:mediscan/widgets/basic_text_form.dart';
import 'package:mediscan/widgets/identification_column.dart';
import 'package:mediscan/widgets/login_regist_button.dart';
import 'package:mediscan/widgets/shift_line.dart';

class PharmacyLoginScreen extends StatefulWidget {
  const PharmacyLoginScreen({super.key});

  @override
  State<PharmacyLoginScreen> createState() => _PharmacyLoginScreenState();
}

class _PharmacyLoginScreenState extends State<PharmacyLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool isHidden = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      final uid = userCredential.user!.uid;
      final PharmacyModel pharmacyModel = await Authmethods().fetchPharmacyData(
        uid,
      );

      // Login success, navigate to dashboard or home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PharmacyAdminScreen(pharmacyModel: pharmacyModel),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = "An unknown error occurred";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  IdentificationColumn(columnTitle: 'Login'),
                  BasicTextForm(
                    customHint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    isHidden: false,
                    controller: emailController,
                  ),
                  BasicTextForm(
                    customHint: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isHidden: isHidden,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isHidden = !isHidden;
                        setState(() {});
                      },
                      icon: Icon(Icons.remove_red_eye, color: Colors.white),
                    ),
                  ),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : LoginRegistButton(
                        buttonText: 'Login',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                      ),
                  ShiftLine(
                    questionText: 'dont have account ?',
                    clickText: 'Sign Up Now',
                    screen: PharmacyRegisterScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
