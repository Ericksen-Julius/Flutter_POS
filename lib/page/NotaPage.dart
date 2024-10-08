// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/page/DashboardPage.dart';

class NotaPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> dataBarang;
  final String admin;
  final String userName;
  final double discount;
  final DateTime invoiceDate;

  const NotaPage(
      {super.key,
      required this.data,
      required this.dataBarang,
      required this.admin,
      required this.userName,
      required this.discount,
      required this.invoiceDate});

  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  String initials = "";
  int kurs = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kurs = sp.getInt('kursLocal') ?? 0;

    List<String> nameParts = widget.userName.split(" ");

    if (nameParts.length == 1) {
      initials = nameParts[0][0];
    } else if (nameParts.length > 1) {
      initials = nameParts[0][0] + nameParts[1][0];
    }

    initials = initials.toUpperCase();
    // print(initials);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCF3EC), // Light orange-like color
              Color(0xFFFFFFFF), // White color
            ],
            stops: [0.0004, 0.405], // Adjust the stops for a smooth transition
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Invoice #${widget.data['nota_code']}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: "Plus Jakarta Sans Bold",
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(initials),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Plus Jakarta Sans Bold",
                          ),
                        ),
                        Text(widget.data["no_hp"]),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invoice Date",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Plus Jakarta Sans Regular",
                          ),
                        ),
                        Text(
                          "${widget.invoiceDate.day} ${_getMonth(widget.invoiceDate.month)}, ${widget.invoiceDate.year}",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Plus Jakarta Sans Regular",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Plus Jakarta Sans Regular",
                          ),
                        ),
                        Text(
                          widget.admin,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Plus Jakarta Sans Regular",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                // Item List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.dataBarang.length,
                    itemBuilder: (context, index) {
                      // Build the ListTile for each item
                      final item = widget.dataBarang[index];
                      return ListTile(
                        // leading: Icon(item['icon'], color: item['iconColor']),
                        title: Text(item['nama']),
                        subtitle: Text(
                            "${item['count']} x ${formatNumber2(double.parse(item['berat']) * kurs)}"),
                        trailing: Text(
                          formatNumber2(
                              (double.parse(item['berat']) * item['count'] * kurs)
                                  .toDouble()),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Plus Jakarta Sans Bold",
                              fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                // Total Summary
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal"),
                          Text(formatNumber2(widget.data['nominal'] /
                              ((100 - widget.discount) / 100))),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount"),
                          Text("${widget.discount}%"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatNumber(widget.data['nominal']),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavbar()));
                      },
                      child: Text("Back To Dashboard"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Send invoice action
                      },
                      child: Text("Send invoice"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  String formatNumber(int harga) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(harga);
  }

  String formatNumber2(double harga) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(harga);
  }
}
