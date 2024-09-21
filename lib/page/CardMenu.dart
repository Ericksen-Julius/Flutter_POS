// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  final String imagePath;
  final String label;
  const CardMenu({super.key, required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0), // Padding around the circle
          child: CircleAvatar(
            radius:
                40.0, // Adjust the radius to make the circle larger or smaller
            backgroundColor: Color.fromRGBO(
                252, 243, 236, 1), // Background color of the circle
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding inside the circle
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit
                      .cover, // Adjust the fit to make the image cover the circle
                  width: 50.0, // Adjust width and height to size the image
                  height: 50.0,
                ),
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
      ],
    );
  }
}
