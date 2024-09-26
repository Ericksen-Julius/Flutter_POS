// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/page/CheckoutPage.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:proyek_pos/page/Loginpage.dart';
import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:proyek_pos/page/Profile.dart';
import 'package:proyek_pos/page/Riwayat.dart';
import 'package:proyek_pos/page/SplashScreen.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

late SharedPreferences sp;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSharedPreferences();
  // await Firebase.initializeApp(
  //   name: "",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await initFCM();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // print(" FCMToken: $fcmToken");
  runApp(const MainApp());
}

Future<void> initializeSharedPreferences() async {
  try {
    sp = await SharedPreferences.getInstance();
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => BottomNavbar(),
        '/splash': (context) => SplashScreenPage(),
        '/onboarding': (context) => Onboardingpage(),
        '/dashboard': (context) => Dashboardpage(),
        '/login': (context) => LoginPage(),
        '/riwayat': (context) => Riwayat(),
        '/profile': (context) => Profile(),
        '/transaksipenjualan': (context) => TransaksiPenjualanPage(),
        // '/checkout': (context) => CheckOutPage(),
      },
      // title: 'POS UBS',
      // // theme: new ThemeData(scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1)),
      // theme:
      //     ThemeData(scaffoldBackgroundColor: Color.fromRGBO(255, 235, 222, 1)),
      // home: LoginPage(),
    );
  }
}
