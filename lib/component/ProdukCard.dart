// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CartItemModel.dart';
import 'package:proyek_pos/model/ProdukModel.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

class ProdukCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final int berat;
  final String kategori;
  final String barcodeID;
  final int kurs;
  final bool? dashBoard;

  const ProdukCard(
      {super.key,
      required this.imagePath,
      required this.label,
      required this.berat,
      required this.kategori,
      required this.barcodeID,
      required this.kurs,
      this.dashBoard});

  @override
  Widget build(BuildContext context) {
    String formattedHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(berat * kurs);
    return GestureDetector(
      onTap: () {
        if (dashBoard == false) {
          _loadCartItem();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransaksiPenjualanPage(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 130.0, // Maintain consistent height
              padding: EdgeInsets.all(5.0), // Add padding
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(16.0), // Rounded corners
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Container(
                      width: double.infinity,
                      height: 100, // Set the height as per your requirement
                      padding: EdgeInsets.all(10.0), // Add padding
                      alignment:
                          Alignment.center, // Center the loading indicator
                      child: CircularProgressIndicator(), // Loading indicator
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100, // Maintain consistent height
                    padding: EdgeInsets.all(10.0), // Add padding
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/default_image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                formattedHarga,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(226, 62, 95, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCartItem() async {
    String? cart = sp.getString('cartJson');
    List<CartItem> items = [];

    List<dynamic> itemsList = jsonDecode(cart ?? '[]');

    items = itemsList.map((item) => CartItem.fromJson(item)).toList();

    int index = items.indexWhere((item) => item.produk.barcodeID == barcodeID);

    // kalo sudah ada di cart maka increment saja
    if (index != -1) {
      items[index].count += 1;
    } else {
      items.add(
        CartItem(
          produk: Produk(
            barcodeID: barcodeID,
            nama: label,
            berat: berat.toString(),
            kategori: kategori,
            foto: imagePath,
          ),
          count: 1,
        ),
      );
    }

    String updatedCartJson =
        jsonEncode(items.map((item) => item.toJson()).toList());

    await sp.setString('cartJson', updatedCartJson);

    // print(sp.getString('cartJson'));
  }
}
