// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProductCardTransaksi extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String productCode;
  final String price;
  // final VoidCallback onDelete;

  const ProductCardTransaksi({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.productCode,
    required this.price,
    // required this.onDelete,
  });

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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Rata kiri untuk teks
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0XFF344054),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    productCode,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans Regular',
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF1D2939),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0XFF006AFF),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFFFF9A9A), // Warna latar belakang
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Color(0XFF851B1B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
