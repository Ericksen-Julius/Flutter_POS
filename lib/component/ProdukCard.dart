// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CartItemModel.dart';
import 'package:proyek_pos/model/ProdukModel.dart';
import 'package:proyek_pos/page/TransaksiPenjualanPage.dart';

class NetworkImageWithLoading extends StatelessWidget {
  final String imageUrl;

  const NetworkImageWithLoading({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity, // Adjust size as needed
            height: 130.0,
            errorBuilder: (context, error, stackTrace) {
              // Menampilkan gambar default jika gagal memuat
              return Image.asset(
                'assets/default_image.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100.0,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProdukCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final int berat;
  final String kategori;
  final String barcodeID;
  final int kurs;

  const ProdukCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.berat,
    required this.kategori,
    required this.barcodeID,
    required this.kurs,
  });

  @override
  Widget build(BuildContext context) {
    String formattedHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(berat * kurs);
    return GestureDetector(
      onTap: () {
        _loadCartItem();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransaksiPenjualanPage(),
          ),
        );
      },
      child: Container(
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
            NetworkImageWithLoading(
              imageUrl: imagePath, // Ganti dengan imagePath yang sesuai
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

    print(sp.getString('cartJson'));
  }
}
