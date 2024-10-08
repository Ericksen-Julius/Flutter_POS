// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:proyek_pos/style/colors.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    sp.remove('fetchNota');

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) =>
                Onboardingpage()), // Ganti HomePage dengan halaman utama Anda
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 235, 222, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Column(
            children: [
              Image.asset(
                'assets/splash_screen.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 10),
              Text(
                'Point Of Sales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primary,
                  fontFamily: 'Poltawski Nowy',
                ),
              ),
            ],
          ),

          // Logo UBS di footer
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Image.asset(
              'assets/ubs_logo.png',
              width: 100,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
