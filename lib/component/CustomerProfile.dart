// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

class CustomerProfile extends StatefulWidget {
  final String nama;
  final String noHp;
  final String kota;

  const CustomerProfile(
      {super.key, required this.nama, required this.noHp, required this.kota});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Bayangan pertama
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Bayangan kedua
            blurRadius: 3.0,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 20, top: 10.0, bottom: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 100,
                child: Icon(
                  Icons.account_circle, // Menggunakan ikon akun
                  size: 100, // Sesuaikan ukuran ikon
                  color: Colors.black, // Ganti dengan warna yang diinginkan
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Rata kiri untuk teks
                children: [
                  Text(
                    widget.nama,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0XFF344054),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.noHp,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans Regular',
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF1D2939),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.kota,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0XFFE19767),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFFE19767), // Warna latar belakang
                  shape: BoxShape.rectangle, // Bentuk kotak
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    _loadCustomerInfo();
                  },
                  icon: Icon(
                    Icons.touch_app,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCustomerInfo() async {
    sp.setString('customer_nama', widget.nama);
    sp.setString('customer_noHp', widget.noHp);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransaksiPenjualanPage(),
      ),
    );
    // Use the retrieved values as needed
  }
}
