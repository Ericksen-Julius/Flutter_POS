// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations

// import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  Future<void> _sendWhatsApp() async {
    try {
      // Format nomor telepon
      String phoneNumber =
          widget.data["no_hp"].replaceAll(RegExp(r'[^\d]'), '');

// Check if the phone number starts with '0'
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.replaceFirst('0', '62');
      } else if (!phoneNumber.startsWith('62')) {
        phoneNumber = '62$phoneNumber';
      }

      // print(phoneNumber);
      // return;

      // Membuat string untuk isi invoice
      String invoiceContent = """
*Invoice #${widget.data['nota_code']}*

Customer: ${widget.userName}
Phone: ${widget.data["no_hp"]}

Date: ${widget.invoiceDate.day} ${_getMonth(widget.invoiceDate.month)}, ${widget.invoiceDate.year}
User: ${widget.admin}

*Items:*
${widget.dataBarang.map((item) => "${item['nama']}\n${item['count']} x ${formatNumber(int.parse(item['berat']) * kurs)} = ${formatNumber((int.parse(item['berat']) * item['count'] * kurs).toInt())}").join("\n")}

Subtotal: ${formatNumber2(widget.data['nominal'] / ((100 - widget.discount) / 100))}
Discount: ${widget.discount}%
*Total: ${formatNumber(widget.data['nominal'])}*

Thank you for your business!
    """;

      // Encode pesan untuk URL
      final encodedMessage = Uri.encodeComponent(invoiceContent);

      // Buat URL WhatsApp dengan nomor tujuan dan pesan
      final whatsappUrl =
          Uri.parse("https://wa.me/628970423008?text=$encodedMessage");

      if (!await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch WhatsApp';
      }
      // Generate the PDF content

      // Open WhatsApp and prompt to send the PDF
      // await Share.shareXFiles(
      //   [XFile(file.path)], // List of XFiles to share
      //   text: 'Here is your invoice!', // Message text
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending invoice: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> sendPdfWithTwilio(String phoneNumber, String pdfPath) async {
  //   final url =
  //       'https://api.twilio.com/2010-04-01/Accounts/YOUR_ACCOUNT_SID/Messages.json';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization':
  //           'Basic ${base64Encode(utf8.encode('YOUR_ACCOUNT_SID:YOUR_AUTH_TOKEN'))}',
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //     body: {
  //       'From': 'whatsapp:+628970423008', // Your Twilio WhatsApp number
  //       'To': 'whatsapp:$phoneNumber',
  //       'MediaUrl':
  //           'URL_TO_YOUR_PDF', // This needs to be a public URL to the PDF
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print('PDF sent successfully');
  //   } else {
  //     print('Failed to send PDF: ${response.body}');
  //   }
  // }

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
                            "${item['count']} x ${formatNumber(int.parse(item['berat']) * kurs)}"),
                        trailing: Text(
                          formatNumber(
                              (int.parse(item['berat']) * item['count'] * kurs)
                                  .toInt()),
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
                                builder: (context) => Dashboardpage()));
                      },
                      child: Text("Back To Dashboard"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Send invoice action
                        _sendWhatsApp();
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

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Invoice #${widget.data['nota_code']}",
                style: pw.TextStyle(fontSize: 16, color: PdfColors.grey),
              ),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Container(
                    width: 40,
                    height: 40,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Center(
                      child: pw.Text(initials,
                          style: pw.TextStyle(color: PdfColors.black)),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        widget.userName,
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(widget.data["no_hp"]),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice Date"),
                      pw.Text(
                          "${widget.invoiceDate.day} ${_getMonth(widget.invoiceDate.month)}, ${widget.invoiceDate.year}"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("User"),
                      pw.Text(widget.admin),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              // Item List
              pw.ListView.builder(
                itemCount: widget.dataBarang.length,
                itemBuilder: (context, index) {
                  final item = widget.dataBarang[index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item['nama']),
                      pw.Text(
                          "${item['count']} x ${formatNumber(int.parse(item['berat']) * kurs)}"),
                    ],
                  );
                },
              ),
              pw.Divider(),
              // Total Summary
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Subtotal"),
                      pw.Text(formatNumber2(widget.data['nominal'] /
                          ((100 - widget.discount) / 100))),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Discount"),
                      pw.Text("${widget.discount}%"),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Total",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(formatNumber(widget.data['nominal']),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("Thank you for your business!"),
            ],
          );
        },
      ),
    );

    return await pdf.save();
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
