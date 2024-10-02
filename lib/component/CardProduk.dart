// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
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
            child: Container(
              width: 100.0,
              height: 100.0,
              padding: EdgeInsets.all(5.0), // Add padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
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
          ),
        ),
        // ClipRRect(
        //       borderRadius: BorderRadius.circular(16.0),
        //       child: Image.asset(
        //         imagePath,
        //         fit: BoxFit.cover,
        //         width: 100.0, // Adjust size as needed
        //         height: 100.0,
        //       ),
        //     ),
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
