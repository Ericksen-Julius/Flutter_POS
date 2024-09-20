// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proyek_pos/page/Loginpage.dart';
import 'package:proyek_pos/style/colors.dart';

class Onboardingpage extends StatefulWidget {
  const Onboardingpage({super.key});

  @override
  State<Onboardingpage> createState() => _OnboardingpageState();
}

class _OnboardingpageState extends State<Onboardingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/onBoardingBackground.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/ubs_logo.png',
                      width: 100,
                      height: 100,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Selamat datang di\n',
                            style: TextStyle(
                              fontSize: 36, // Gaya untuk "Selamat datang di"
                              fontWeight: FontWeight.bold,
                              color: primary,
                              fontFamily: 'Plus Jakarta Sans Bold',
                            ),
                          ),
                          TextSpan(
                            text: 'Point Of Sales',
                            style: TextStyle(
                              fontSize: 36, // Gaya untuk "Point Of Sales"
                              fontWeight: FontWeight.bold,
                              color: primary,
                              fontFamily: 'Plus Jakarta Sans Bold',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Aplikasi manajemen penjualan produk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: primary,
                        fontFamily: 'Plus Jakarta Sans Regular',
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Aksi ketika tombol ditekan
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(254, 253, 248, 1),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
