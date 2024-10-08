// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/component/CardMenu.dart';
import 'package:proyek_pos/component/CardProduk.dart';
import 'package:proyek_pos/component/ProdukCard.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/ProdukModel.dart';
import 'package:proyek_pos/page/TambahKursPage.dart';
import 'package:proyek_pos/page/MasterCustomerPage.dart';
import 'package:proyek_pos/page/MasterProdukPage.dart';
// import 'package:proyek_pos/page/OnBoardingPage.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchKurs();
  }

  final List<Widget> _menuPages = [
    TransaksiPenjualanPage(),
    MasterProdukPage(),
    MasterCustomerPage(),
    TambahKursPage(),
  ];
  List<Produk> produk = [];
  List<Produk> filteredProduk = [];
  var kurs = 0;
  final List<String> carouselImages = [
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png'
  ];

  final List<String> menuImages = [
    'assets/transaksi.png',
    'assets/stokbarang.png',
    'assets/customer.png',
    'assets/kurs.png'
  ];

  final List<String> menuLabels = [
    'Transaksi Baru',
    'Stok Barang',
    'Customer',
    'Kurs'
  ];

  final List<Map<String, String>> products = [
    {
      'imagePath': 'assets/ProductImage.png',
      'label': 'UBS Gold Gelang Emas',
      'harga': 'Rp.5.240.000'
    },
    {
      'imagePath': 'assets/ProductImage.png',
      'label': 'UBS Gold Gelang Emas',
      'harga': 'Rp.5.240.000'
    },
    {
      'imagePath': 'assets/ProductImage.png',
      'label': 'UBS Gold Gelang Emas',
      'harga': 'Rp.5.240.000'
    },
    {
      'imagePath': 'assets/ProductImage.png',
      'label': 'UBS Gold Gelang Emas',
      'harga': 'Rp.5.240.000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'UBS',
                style: TextStyle(
                    color: Color.fromRGBO(75, 16, 16, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Plus Jakarta Sans Bold'),
              ),
              TextSpan(
                text: 'POS',
                style: TextStyle(
                    color: Color.fromRGBO(40, 45, 48, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Plus Jakarta Sans Bold'),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {}, // ini isi sendiri nanti
        ),
        actions: [
          IconButton(
              onPressed: () {}, // ini juga isi sendiri
              icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xFFFCF3EC),
                  Color(0xFFFFFFFF),
                ])),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    viewportFraction: 1.0,
                  ),
                  items: carouselImages.map((imagePath) {
                    return Container(
                      child: Center(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selamat datang di MiniPOS UBS, aplikasi untuk menunjang transaksi penjualan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Menu Utama',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Plus Jakarta Sans Bold',
                    color: Color.fromRGBO(75, 16, 16, 1),
                  ),
                ),
                SizedBox(height: 8.0),
                // Adding a horizontal line (divider) under "Menu Utama"
                Divider(
                  color: Color.fromRGBO(75, 16, 16, 1), // Color of the line
                  thickness: 2.0, // Thickness of the line
                  indent: 20.0, // Left padding
                  endIndent: 20.0, // Right padding
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(menuImages.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the specific page for this card
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _menuPages[index]),
                        );
                      },
                      child: CardMenu(
                        imagePath: menuImages[index],
                        label: menuLabels[index],
                        page: _menuPages[
                            index], // Make sure _menuPages contains the correct pages
                      ),
                    );
                  }),
                ),

                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Katalog Produk',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Plus Jakarta Sans Bold',
                        ),
                      ),
                      Text(
                        'Lihat Semua',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Plus Jakarta Sans Bold',
                            color: Color.fromRGBO(5, 34, 131, 1)),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 15.0, // Horizontal space between items
                  runSpacing: 15.0, // Vertical space between rows
                  children: List.generate(produk.length, (index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.45, // Adjust the width for 2 items per row
                      child: ProdukCard(
                        imagePath:
                            'http://10.0.2.2:8082/proyek_pos/uploads/${produk[index].foto}',
                        label: produk[index].nama!,
                        berat: int.parse(produk[index].berat!),
                        kurs: kurs,
                        kategori: produk[index].kategori!,
                        barcodeID: produk[index].barcodeID!,
                      ),
                    );
                  }),
                ),
                // SizedBox(
                //   height: 300,
                //   child: GridView.builder(
                //     itemCount: products.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2, // 2 columns
                //       crossAxisSpacing: 8.0, // Space between columns
                //       mainAxisSpacing: 8.0, // Space between rows
                //       childAspectRatio: 1.0, // Aspect ratio of each grid item
                //     ),
                //     itemBuilder: (context, index) {
                //       return CardProduk(
                //         imagePath: products[index]['imagePath']!,
                //         label: products[index]['label']!,
                //         harga: products[index]['harga']!,
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchData() async {
    // print("Mulai fetchData...");

    String? produksLocal = sp.getString('produksLocal');
    // print(produksLocal);
    try {
      // print("Coba decode local data...");
      List<dynamic> produkListLocal = jsonDecode(produksLocal ?? '[]');
      setState(() {
        produk = produkListLocal
            .map((item) => Produk.fromJson(item))
            .take(4)
            .toList();
      });
      // print("Local data berhasil dimuat.");
    } catch (e) {
      print('Error decoding JSON local: $e');
    }

    try {
      // print("Mulai request ke server...");
      const url = "http://10.0.2.2:8082/proyek_pos/barang";
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final body = response.body;
      final json = jsonDecode(body);
      // print("Status kode response: ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          produk = (json['data'] as List)
              .map((item) => Produk.fromJson(item))
              .take(4)
              .toList();
          // filteredProduk = produk;
          sp.setString('produksLocal', jsonEncode(json['data'] ?? []));
          // print(filteredProduk);
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error dalam request ke server: $e");
      if (e is SocketException) {
        print('Tidak dapat terhubung ke server.');
      }
    }
  }

  Future<void> fetchKurs() async {
    // print("Mulai fetchKurs...");

    kurs = sp.getInt('kursLocal') ?? 0;
    // print(kurs);
    // print(kurs);
    const url = "http://10.0.2.2:8082/proyek_pos/kurs";
    try {
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final body = response.body;
      final json = jsonDecode(body);
      // print("Status kode response: ${response.statusCode}");
      setState(() {
        kurs = int.parse(json['data'][0]['KURS']);
        sp.setInt('kursLocal', kurs);
        // print(kurs);
      });
    } catch (e) {
      print("Error dalam request ke server: $e");
      if (e is SocketException) {
        print('Tidak dapat terhubung ke server.');
      }
    }
  }
}
