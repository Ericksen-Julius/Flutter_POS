// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';

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
    return FutureBuilder<ImageProvider>(
      future: _loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for image to load
          return Center(
            child: Container(
              width: double.infinity,
              height: 130,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, show the default image
          return Image.asset(
            'assets/default_image.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 130.0,
          );
        } else if (snapshot.hasData) {
          // If the image is loaded successfully, display it
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image(
              image: snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 130.0,
            ),
          );
        } else {
          // Fallback in case none of the above states apply
          return Container(); // Return an empty container
        }
      },
    );
  }

  Future<ImageProvider> _loadImage(String url) async {
    // Create a completer to handle the async loading
    final completer = Completer<ImageProvider>();

    // Create a NetworkImage
    final networkImage = NetworkImage(url);

    // Add a listener for the image loading
    final imageStream = networkImage.resolve(ImageConfiguration());

    // Listen to the stream
    imageStream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool sync) {
          // If image is loaded successfully, complete the future with the image
          completer.complete(networkImage);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          // If there is an error, complete with a default asset image
          completer.complete(AssetImage('assets/default_image.jpg'));
        },
      ),
    );

    // Return the future from the completer
    return completer.future.timeout(Duration(seconds: 5), onTimeout: () {
      // If it times out, return the default asset image
      return AssetImage('assets/default_image.jpg');
    });
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

    // print(sp.getString('cartJson'));
  }
}
