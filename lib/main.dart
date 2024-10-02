// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:proyek_pos/helper/CustomerSynchronize.dart';
import 'package:proyek_pos/helper/KursSynchronize.dart';
import 'package:proyek_pos/helper/NotaSynchronize.dart';
import 'package:proyek_pos/helper/ProdukSynchronize.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/page/CariCustomerPage.dart';
import 'package:proyek_pos/page/CheckoutPage.dart';
// import 'package:proyek_pos/page/CheckoutPage.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:proyek_pos/page/Loginpage.dart';
import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:proyek_pos/page/Profile.dart';
import 'package:proyek_pos/page/Riwayat.dart';
import 'package:proyek_pos/page/SplashScreen.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

late SharedPreferences sp;
Timer? _timer;

void startSynchronization() {
  _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
    await synchronizeAddCustomers();
    await synchronizeDeleteCustomers();
    await synchronizeProduk();
    await synchronizeKurs();
    await synchronizeNota();
  });
}

// Fungsi untuk menghentikan sinkronisasi
void stopSynchronization() {
  _timer?.cancel();
}

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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    startSynchronization(); // Memulai sinkronisasi saat aplikasi diinisialisasi
  }

  @override
  void dispose() {
    stopSynchronization(); // Menghentikan sinkronisasi saat aplikasi dihentikan
    super.dispose();
  }

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
        '/cariCustomer': (context) => CariCustomerPage(),
        '/checkout': (context) => CheckOutPage(
              totalHarga: 20000,
            ),
      },
      // title: 'POS UBS',
      // // theme: new ThemeData(scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1)),
      // theme:
      //     ThemeData(scaffoldBackgroundColor: Color.fromRGBO(255, 235, 222, 1)),
      // home: LoginPage(),
    );
  }
}
