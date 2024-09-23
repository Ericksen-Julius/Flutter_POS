// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/ProductCardTransaksi.dart';
import 'package:proyek_pos/component/TambahCustomerModal.dart';
import 'package:proyek_pos/page/CariCustomerPage.dart';

class TransaksiPenjualanPage extends StatefulWidget {
  const TransaksiPenjualanPage({super.key});

  @override
  State<TransaksiPenjualanPage> createState() => TransaksiPenjualanPageState();
}

class TransaksiPenjualanPageState extends State<TransaksiPenjualanPage> {
  final TextEditingController _namaCustomerController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _totalHargaController = TextEditingController();
  bool _isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _totalHargaController.text = 'Rp. 194.700';
    _jumlahController.text = '1';
  }

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CariCustomerPage()));
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
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return TambahCustomerModal(); // Panggil komponen tanpa parameter
                              },
                            );
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
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFDAC9B6),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Jumlah',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans Bold',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Total harga',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans Bold',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _jumlahController,
                          enabled: false,
                          style: TextStyle(color: Color(0xFF667085)),
                          decoration: InputDecoration(
                            // hintText: "",
                            hintStyle: TextStyle(color: Color(0xFFD0D5DD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFF9FAFB),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _totalHargaController,
                          style: TextStyle(color: Color(0xFF667085)),
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            // hintText: "Nama Customer",
                            enabled: false,
                            hintStyle: TextStyle(color: Color(0xFFD0D5DD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFF9FAFB),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diskon',
                        style: TextStyle(
                          color: Color(0xFF4B1010),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                        ),
                      ),
                      Switch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  summaryComponent()
                ],
              ),
            ),
          ),
        ),
      ),
      //footer
      bottomNavigationBar: Container(
        color: Color(0xFFFFEBDE),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Rp. 194.700\n',
                    style: TextStyle(
                      fontSize: 18, // Gaya untuk "Selamat datang di"
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3765FF),
                      fontFamily: 'Plus Jakarta Sans Bold',
                    ),
                  ),
                  TextSpan(
                    text: 'Subtotal',
                    style: TextStyle(
                      fontSize: 16, // Gaya untuk "Point Of Sales"
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2727),
                      fontFamily: 'Plus Jakarta Sans Bold',
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Aksi ketika tombol ditekan
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFE19767),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Proses Pembayaran',
                style: TextStyle(
                  color: Color(0xFFFEFDF8),
                  fontFamily: 'Plus Jakarta Sans Bold',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container summaryComponent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2.0,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                color: Color(0xFF4B1010),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans Bold',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LM Gift Classic 0,1 gr',
                        style: TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Rp. 194.700',
                        style: TextStyle(
                          color: Color(0xFF3E3E3E),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total(IDR)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Rp. 200.000',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
