import 'package:chat_flutter_app/Screens/LoginScreen.dart';
import 'package:chat_flutter_app/Screens/SignUp.dart';
import 'package:chat_flutter_app/Screens/chatingScreen.dart';
import 'package:chat_flutter_app/firebase_options.dart';
import 'package:chat_flutter_app/shared/components/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      routes: {
        SignUpScreen.id: (context) => SignUpScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ChattingScreen.id: (context) => const ChattingScreen(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
      ),
    );
  }
}
