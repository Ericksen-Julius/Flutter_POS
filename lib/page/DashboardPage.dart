import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proyek_pos/page/CardMenu.dart';
import 'package:proyek_pos/page/CardProduk.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {

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
    {'imagePath': 'assets/ProductImage.png', 'label': 'UBS Gold Gelang Emas', 'harga': 'Rp.5.240.000'},
    {'imagePath': 'assets/ProductImage.png', 'label': 'UBS Gold Gelang Emas', 'harga': 'Rp.5.240.000'},
    {'imagePath': 'assets/ProductImage.png', 'label': 'UBS Gold Gelang Emas', 'harga': 'Rp.5.240.000'},
    {'imagePath': 'assets/ProductImage.png', 'label': 'UBS Gold Gelang Emas', 'harga': 'Rp.5.240.000'},
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
                  fontFamily: 'Plus Jakarta Sans Bold' 
                ),
              ),
              TextSpan(
                text: 'POS', 
                style: TextStyle(
                  color: Color.fromRGBO(40, 45, 48, 1), 
                  fontWeight: FontWeight.bold, 
                  fontFamily: 'Plus Jakarta Sans Bold'
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {}, // ini isi sendiri nanti
        ),
        actions: [
          IconButton(onPressed: () {}, // ini juga isi sendiri
          icon: Icon(Icons.settings))],
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
                Text('Menu Utama',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Plus Jakarta Sans Bold',
                  color: Color.fromRGBO(75, 16, 16, 1), 
                ),),
                SizedBox(height: 8.0),
                // Adding a horizontal line (divider) under "Menu Utama"
                Divider(
                  color: Color.fromRGBO(75, 16, 16, 1),  // Color of the line
                  thickness: 2.0,     // Thickness of the line
                  indent: 20.0,       // Left padding
                  endIndent: 20.0,    // Right padding
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(menuImages.length, (index) {
                    return CardMenu(
                      imagePath: menuImages[index],
                      label: menuLabels[index],
                    );
                  }),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Katalog Produk',
                      style: TextStyle(
                              fontSize: 18.0, 
                              fontFamily: 'Plus Jakarta Sans Bold',
                            ),),
                            Text('Lihat Semua',
                      style: TextStyle(
                              fontSize: 14.0, 
                              fontFamily: 'Plus Jakarta Sans Bold',
                              color: Color.fromRGBO(5, 34, 131, 1)
                            ),),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8.0, // Horizontal space between items
                  runSpacing: 8.0, // Vertical space between rows
                  children: List.generate(products.length, (index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45, // Adjust the width for 2 items per row
                      child: CardProduk(
                        imagePath: products[index]['imagePath']!,
                        label: products[index]['label']!,
                        harga: products[index]['harga']!,
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
}
