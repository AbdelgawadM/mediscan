import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/helper/AuthMethods.dart';
import 'package:mediscan/helper/custom_snack_bar.dart';
import 'package:mediscan/models/user_model.dart';
import 'package:mediscan/screens/user_interface/location_screen.dart';
import 'package:mediscan/screens/user_interface/user_login_screen.dart';
import 'package:mediscan/widgets/basic_text_form.dart';
import 'package:mediscan/widgets/identification_column.dart';
import 'package:mediscan/widgets/login_regist_button.dart';
import 'package:mediscan/widgets/shift_line.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserRegisterationScreen extends StatefulWidget {
  const UserRegisterationScreen({super.key});

  @override
  State<UserRegisterationScreen> createState() =>
      _UserRegisterationScreenState();
}

class _UserRegisterationScreenState extends State<UserRegisterationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email, password1, password2, name, phoneNumber;

  bool loading = false;
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: kPrimaryColor,
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
                          isHidden: false,
                          keyboardType: TextInputType.name,
                          onChange: (data) {
                            name = data;
                          },
                          customHint: 'enter your name',
                        ),
                        BasicTextForm(
                          isHidden: false,
                          keyboardType: TextInputType.emailAddress,
                          onChange: (data) {
                            email = data;
                          },
                          customHint: 'enter your email',
                        ),
                        BasicTextForm(
                          isHidden: false,
                          keyboardType: TextInputType.phone,
                          onChange: (data) {
                            phoneNumber = data;
                          },
                          customHint: 'enter your phone',
                        ),
                        BasicTextForm(
                          isHidden: isHidden,
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
                          keyboardType: TextInputType.visiblePassword,
                          onChange: (data) {
                            password1 = data;
                          },
                          customHint: 'enter your password',
                        ),
                        BasicTextForm(
                          isHidden: isHidden,
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
                          keyboardType: TextInputType.visiblePassword,
                          onChange: (data) {
                            password2 = data;
                          },
                          customHint: 'confirm your password',
                        ),
                        LoginRegistButton(
                          buttonText: 'Sign Up',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (password1 == password2) {
                                try {
                                  loading = true;
                                  setState(() {});
                                  final UserCredential userCredential =
                                      await Authmethods().registerUser(
                                        email: email!,
                                        password: password1!,
                                        name: name!,
                                        phone: phoneNumber!,
                                      );
                                  final UserModel userModel =
                                      await Authmethods().fetchUserData(
                                        userCredential.user!.uid,
                                      );

                                  loading = false;
                                  setState(() {});
                                  customSnackBar(
                                    context,
                                    'you have registered succsssfully !',
                                  );

                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
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
                                    },
                                  );
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
                              } else {
                                customSnackBar(
                                  context,
                                  'Try to match Passwords',
                                );
                              }
                            }
                          },
                        ),
                        const ShiftLine(
                          questionText: 'already have account ?',
                          clickText: 'Login Now',
                          screen: UserLoginScreen(),
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
}
