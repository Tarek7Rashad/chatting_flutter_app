// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_flutter_app/Screens/SignUp.dart';
import 'package:chat_flutter_app/Screens/chatingScreen.dart';
import 'package:chat_flutter_app/Widgets/CustomButtonWidget.dart';
import 'package:chat_flutter_app/Widgets/CustomTextFormFieldWidget.dart';
import 'package:chat_flutter_app/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'loginPage';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      Image.asset(
                        'assets/images/logo-removebg-preview.png',
                        width: 120,
                        height: 120,
                      ),
                      const Text(
                        'Chating',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextFormFieldWidget(
                        controller: emailEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "email Is Required Field";
                          } else {
                            // log(value);
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        hintText: "Email",
                        labelText: "Email",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormFieldWidget(
                        controller: passwordEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Password Is Required Field";
                          } else {
                            // log(value);
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        hintText: "Password",
                        labelText: "Password",
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButtonWidget(
                        text: "Login",
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await userLogin();

                              // showSnackBar(context, 'Succesfully Operation.');
                              Navigator.pushNamed(context, ChattingScreen.id,
                                  arguments: email);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                                showSnackBar(
                                    context, 'Email Or Password Invalid');
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(context,
                                    'Wrong password provided for that user.');
                              }
                            } catch (e) {
                              log(e.toString());
                              showSnackBar(context, 'Error');
                            }

                            isLoading = false;
                            setState(() {});
                          }
                          emailEditingController.clear();
                          passwordEditingController.clear();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have An Account",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(SignUpScreen.id);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Color(0xfff7f7f7), fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userLogin() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    log(userCredential.user!.email.toString());
    log(userCredential.user!.displayName.toString());
  }
}
