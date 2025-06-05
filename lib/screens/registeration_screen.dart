import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediscan/helper/custom_snack_bar.dart';
import 'package:mediscan/screens/location_screen.dart';
import 'package:mediscan/screens/login_screen.dart';
import 'package:mediscan/widgets/basic_text_form.dart';
import 'package:mediscan/widgets/identification_column.dart';
import 'package:mediscan/widgets/login_regist_button.dart';
import 'package:mediscan/widgets/shift_line.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email, password;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const IdentificationColumn(columnTitle: 'Sign Up'),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BasicTextForm(
                          onChange: (data) {
                            email = data;
                          },
                          customHint: 'enter your email',
                        ),
                        BasicTextForm(
                          onChange: (data) {},
                          customHint: 'enter your phone',
                        ),
                        BasicTextForm(
                          onChange: (data) {
                            password = data;
                          },
                          customHint: 'enter your password',
                        ),
                        BasicTextForm(
                          onChange: (data) {},
                          customHint: 'renter your password',
                        ),
                        LoginRegistButton(
                          buttonText: 'Sign Up',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                loading = true;
                                setState(() {});
                                await registerMethod();
                                loading = false;
                                setState(() {});
                                customSnackBar(
                                  context,
                                  'you have registered succsssfully !',
                                );

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LocationScreen();
                                      },
                                    ),
                                  );
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  customSnackBar(context, 'password is weak');
                                } else if (e.code == 'email-already-in-use') {
                                  customSnackBar(
                                    context,
                                    'email-already-in-use',
                                  );
                                }
                              } catch (e) {
                                customSnackBar(context, e.toString());
                              }
                              loading = false;
                              setState(() {});
                            }
                          },
                        ),
                        const ShiftLine(
                          questionText: 'already have account ?',
                          clickText: 'Login Now',
                          screen: LoginScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerMethod() async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
