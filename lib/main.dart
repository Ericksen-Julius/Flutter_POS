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
import 'package:proyek_pos/page/MasterCustomerPage.dart';
import 'package:proyek_pos/page/NotaPage.dart';
import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:proyek_pos/page/Profile.dart';
import 'package:proyek_pos/page/Riwayat.dart';
import 'package:proyek_pos/page/SplashScreen.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

late SharedPreferences sp;
Timer? _timer;

void startSynchronization() {
  _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
    await synchronizeAddCustomers();
    await synchronizeAddCustomers();
    await synchronizeProduk();
    await synchronizeKurs();
    await synchronizeNota();
    await synchronizeEditCustomers();
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
    List<Map<String, dynamic>> barangDibeli = [];
    barangDibeli.add({'nama': "Test", 'count': 3, 'berat': "3"});
    Map<String, dynamic> notaData = {
      "no_hp": "87736473", // perlu
      "nota_code": "NR^%@%%@", //perlu
      "nominal": 20000, //perlu
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/riwayat',
      routes: {
        '/': (context) => BottomNavbar(),
        '/splash': (context) => SplashScreenPage(),
        '/onboarding': (context) => Onboardingpage(),
        '/dashboard': (context) => Dashboardpage(),
        '/login': (context) => LoginPage(),
        '/riwayat': (context) => Riwayat(),
        '/profile': (context) => Profile(),
        '/masterCustomer': (context) => MasterCustomerPage(),
        '/transaksipenjualan': (context) => TransaksiPenjualanPage(),
        '/cariCustomer': (context) => CariCustomerPage(),
        '/cekNota': (context) => NotaPage(
              data: notaData,
              dataBarang: barangDibeli,
              admin: "Erick",
              userName: "SEN",
              discount: 20,
              invoiceDate: DateTime.now(),
            ),
      },
      // title: 'POS UBS',
      // // theme: new ThemeData(scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1)),
      // theme:
      //     ThemeData(scaffoldBackgroundColor: Color.fromRGBO(255, 235, 222, 1)),
      // home: LoginPage(),
    );
  }

  // void fetchData() async {
  //   try {
  //     // print("Mulai request ke server...");
  //     const url = "http://10.0.2.2:8082/proyek_pos/barang";
  //     final uri = Uri.parse(url);
  //     final response = await http.get(
  //       uri,
  //     );
  //     final body = response.body;
  //     final json = jsonDecode(body);
  //     // print("Status kode response: ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       sp.setString('produksLocal', jsonEncode(json['data'] ?? []));
  //       // print(filteredProduk);
  //     } else {
  //       print('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print("Error dalam request ke server: $e");
  //     if (e is SocketException) {
  //       print('Tidak dapat terhubung ke server.');
  //     }
  //   }
  // }
}
