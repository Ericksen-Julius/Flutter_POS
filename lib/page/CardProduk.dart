// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CardProduk extends StatelessWidget {
  final String imagePath;
  final String label;
  final String harga;
  const CardProduk(
      {super.key,
      required this.imagePath,
      required this.label,
      required this.harga});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(252, 243, 236, 1),
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 100.0, // Adjust size as needed
                height: 100.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        // Text below the image
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        SizedBox(height: 4.0),
        // Text below the image
        Text(
          harga,
          style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Plus Jakarta Sans',
              color: Color.fromRGBO(226, 62, 95, 1)),
        ),
      ],
    );
  }
}
