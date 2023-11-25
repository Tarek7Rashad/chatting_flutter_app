// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_flutter_app/Screens/LoginScreen.dart';
import 'package:chat_flutter_app/Widgets/CustomButtonWidget.dart';
import 'package:chat_flutter_app/Widgets/CustomTextFormFieldWidget.dart';
import 'package:chat_flutter_app/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});
  static final String id = "signUpPage";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  String? email;
  String? password;
  String? confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController =
      TextEditingController();
  TextEditingController secondNameEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormFieldWidget(
                        controller: firstNameEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "This Is Required Field";
                          } else {
                            // log(value);
                          }
                          return null;
                        },
                        obscureText: false,
                        hintText: "First Name",
                        labelText: "First Name",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormFieldWidget(
                        controller: secondNameEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "This Is Required Field";
                          } else {
                            // log(value);
                          }
                          return null;
                        },
                        obscureText: false,
                        hintText: "Last Name",
                        labelText: "Last Name",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormFieldWidget(
                        controller: emailEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Email Is Required Field";
                          } else if (value.isNotEmpty &&
                              !value.contains("@gmail.com")) {
                            return "Enter Valid Email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        obscureText: false,
                        hintText: "Email",
                        labelText: "Email",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormFieldWidget(
                        controller: passwordEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Password Must Contains Upper&Lower Letter And Numbers And (@-_\$ /)";
                          } else if (value.isNotEmpty && value.length <= 6) {
                            return "Password Is Too Weak";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (password != confirmPassword) {
                            password = value;
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        hintText: "Password",
                        labelText: "Password",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormFieldWidget(
                        controller: confirmPasswordEditingController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return " This Is Required Field ";
                          } else if (value.isNotEmpty &&
                              confirmPasswordEditingController.text !=
                                  passwordEditingController.text) {
                            return "Password Dosen't Match ";
                          } else {
                            log(value.toString());
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (confirmPassword == password) {
                            confirmPassword = value;
                          } else {
                            return null;
                          }
                        },
                        // validate: () {},
                        obscureText: true,
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButtonWidget(
                          onPressed: () async {
                            // FirebaseAuth auth = FirebaseAuth.instance;
                            if (formKey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await userSignUp();
                                // showSnackBar(
                                //     context, 'email has created succesfully.');
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  showSnackBar(context,
                                      'The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {
                                  showSnackBar(context,
                                      'The account already exists for that email.');
                                }
                              } catch (e) {
                                showSnackBar(context, '$e');
                              }
                              isLoading = false;
                              setState(() {});
                            } else {}
                            // catch (e) {

                            // print(e);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content:
                            //         Text('there was an error , please try again'),
                            //   ),
                            // );
                            // }
                            // auth.confirmPasswordReset(code: code, newPassword: newPassword)
                          },
                          text: "Sign Up"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Have An Account",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.id);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Color(0xfff7f7f7), fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(
                        flex: 3,
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

  Future<void> userSignUp() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    log(userCredential.user!.email.toString());
    log(userCredential.user!.displayName.toString());
  }
}
