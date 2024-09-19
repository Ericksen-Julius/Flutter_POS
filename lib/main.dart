// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proyek_pos/page/Loginpage.dart';
import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:proyek_pos/page/SplashScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'POS UBS',
      // // theme: new ThemeData(scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1)),
      // theme:
      //     ThemeData(scaffoldBackgroundColor: Color.fromRGBO(255, 235, 222, 1)),
      home: LoginPage(),
    );
  }
}
