import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediscan/helper/AuthMethods.dart';
import 'package:mediscan/helper/custom_snack_bar.dart';
import 'package:mediscan/models/user_model.dart';
import 'package:mediscan/screens/user_interface/location_screen.dart';
import 'package:mediscan/screens/user_interface/user_registeration_screen.dart';
import 'package:mediscan/widgets/basic_text_form.dart';
import 'package:mediscan/widgets/identification_column.dart';
import 'package:mediscan/widgets/login_regist_button.dart';
import 'package:mediscan/widgets/shift_line.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email, password;
  bool loading = false;
  bool isHidden = false;

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
                  const IdentificationColumn(columnTitle: 'Login'),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BasicTextForm(
                          isHidden: false,
                          keyboardType: TextInputType.emailAddress,
                          onChange: (data) {
                            email = data;
                          },
                          customHint: 'enter your email',
                        ),
                        BasicTextForm(
                          suffixIcon: IconButton(
                            onPressed: () {
                              isHidden = !isHidden;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                          ),
                          isHidden: isHidden,
                          keyboardType: TextInputType.visiblePassword,
                          onChange: (data) {
                            password = data;
                          },
                          customHint: 'enter your password',
                        ),
                        LoginRegistButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                loading = true;
                                setState(() {});

                                final UserModel userModel = await Authmethods()
                                    .loginUser(email!, password!);

                                loading = false;
                                setState(() {});
                                customSnackBar(context, 'success login ');
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LocationScreen(
                                          userModel: userModel,
                                        );
                                      },
                                    ),
                                  );
                                });
                              } on FirebaseAuthException catch (error) {
                                if (error.code == 'wrongpassword') {
                                  customSnackBar(
                                    context,
                                    'ERROR_WRONG_PASSWORD',
                                  );
                                } else if (error.code == "user-not-found") {
                                  customSnackBar(context, 'user-not-found');
                                } else if (error.code == "invalid-email") {
                                  customSnackBar(context, 'invalid-email');
                                } else if (error.code == "too-many-requests") {
                                  customSnackBar(context, 'too-many-requests');
                                } else if (error.code ==
                                    "network-request-failed") {
                                  customSnackBar(
                                    context,
                                    'network-request-failed',
                                  );
                                }
                              }
                              loading = false;
                              setState(() {});
                            }
                          },
                          buttonText: 'Login',
                        ),
                        const ShiftLine(
                          questionText: 'dont have account ?',
                          clickText: 'Sign Up',
                          screen: UserRegisterationScreen(),
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

  Future<UserCredential> loginMethod() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    return credential;
  }
}
