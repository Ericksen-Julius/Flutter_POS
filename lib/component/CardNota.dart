// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardNota extends StatelessWidget {
  final String noDok;
  final String noHp;
  final String tanggal;
  final String userInput;

  const CardNota({
    super.key,
    required this.noDok,
    required this.noHp,
    required this.tanggal,
    required this.userInput,
  });

  String formatTanggal(String tanggal) {
    try {
      DateTime parsedDate = DateTime.parse(tanggal); // Try parsing input in standard format like YYYY-MM-DD
      return DateFormat('dd-MMM-yy').format(parsedDate).toUpperCase(); // Format and return the date
    } catch (e) {
      // If parsing fails (like with '08-OCT-24'), return the original string
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // First shadow
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Second shadow
            blurRadius: 3.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 20,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noDok,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF344054),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No HP: $noHp',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans Regular',
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF1D2939),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        formatTanggal(tanggal),
                        // tanggal,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFE19767),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'User Input: $userInput',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Divider placed here
            Divider(
              color: Colors.grey[400], // Color of the line
              thickness: 2.0, // Thickness of the line
            ),
          ],
        ),
      ),
    );
  }
}
