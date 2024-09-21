// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/ProductCardTransaksi.dart';

class TransaksiPenjualanPage extends StatefulWidget {
  const TransaksiPenjualanPage({super.key});

  @override
  State<TransaksiPenjualanPage> createState() => TransaksiPenjualanPageState();
}

class TransaksiPenjualanPageState extends State<TransaksiPenjualanPage> {
  final TextEditingController _namaCustomerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: ,
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Transaksi Penjualan',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(75, 16, 16, 1),
            fontFamily: 'Plus Jakarta Sans Bold',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, // ini juga isi sendiri
              icon: Icon(Icons.settings))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCF3EC), // #FCF3EC
              Color(0xFFFFFFFF), // #FFFFFF
            ],
            stops: [0.0004, 0.405],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Tambah Transaksi Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(75, 16, 16, 1),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Customer',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(75, 16, 16, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _namaCustomerController,
                          style: TextStyle(color: Color(0xFFE59A69)),
                          decoration: InputDecoration(
                            hintText: "Nama Customer",
                            hintStyle: TextStyle(color: Color(0xFFE59A69)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE59A69)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE59A69)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFFEEEE2),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            // Aksi ketika tombol ditekan
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFE59A69),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Pilih',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            // Aksi ketika tombol ditekan
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFE59A69),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFDAC9B6),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Barang',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(75, 16, 16, 1),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aksi ketika tombol ditekan
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFFFE4C5),
                          padding: EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Tambah Produk',
                          style: TextStyle(
                            color: Color(0XFFBB6A37),
                            fontFamily: 'Plus Jakarta Sans Bold',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ProductCardTransaksi(
                            imagePath: 'assets/card_image.png',
                            productName: 'LM Gift Classic',
                            productCode: 'HB202323232323',
                            price: 'Rp 194.700'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
