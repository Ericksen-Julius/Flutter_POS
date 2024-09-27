// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/component/CustomAppBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/helper/NotaSynchronize.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CartItemModel.dart';
import 'package:proyek_pos/page/DashboardPage.dart';

class CheckOutPage extends StatefulWidget {
  final int totalHarga;
  const CheckOutPage({super.key, required this.totalHarga});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<bool> isSelected = [];
  int charge = 10000;
  int totalBiaya = 0;
  int totalBayar = 0;
  int kembali = 0;
  List<dynamic> jenisBayar = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalBiaya = widget.totalHarga + charge;
    totalBayar = totalBiaya;
    kembali = totalBayar - totalBiaya;
    fetchJenisBayar();
  }

  void _toggleMetodePembayaran(int index) {
    setState(() {
      if (!isSelected[index]) {
        for (int i = 0; i < isSelected.length; i++) {
          isSelected[i] = i == index ? true : false;
        }
      } else {
        isSelected[index] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Pilih Pembayaran'),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCF3EC),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0004, 0.405],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rowPembayaran('Total Harga', formatNumber(widget.totalHarga)),
              SizedBox(height: 5),
              rowPembayaran('Charge', formatNumber(charge)),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: Color(0xFF3E3E3E),
              ),
              SizedBox(height: 10),
              rowPembayaran('Total Biaya', formatNumber(totalBiaya)),
              SizedBox(height: 5),
              rowPembayaran('Total Bayar', formatNumber(totalBayar)),
              SizedBox(height: 5),
              rowPembayaran('Kembali', formatNumber(kembali)),
              SizedBox(height: 10),
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans Bold',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4B1010),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 10.0, // Jarak horizontal antar tombol
                  runSpacing: 10.0, // Jarak vertikal antar baris tombol
                  children: List.generate(
                    jenisBayar.length, // jumlah total metode pembayaran
                    (index) {
                      String label = jenisBayar[index]['JENIS_BAYAR'];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 3 -
                            20, // Lebar tombol agar 3 per baris
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _toggleMetodePembayaran(index);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[index]
                                ? Color(0xFFE19767)
                                : Colors.white,
                            padding: EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: isSelected[index]
                                    ? Colors.transparent
                                    : Color(0xFF515151),
                              ),
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected[index]
                                  ? Colors.white
                                  : Color(0xFF515151),
                              fontFamily: 'Plus Jakarta Sans Regular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _inputNota(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE59A69),
            padding: EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Bayar',
            style: TextStyle(
              color: Color(0xFFFEFDF8),
              fontFamily: 'Plus Jakarta Sans Bold',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Row rowPembayaran(String label, String harga) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans Bold',
            color: Color(0xFF3E3E3E),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          harga,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans Bold',
            color: label == 'Kembali' ? Color(0xFFEB2020) : Color(0xFF3E3E3E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String formatNumber(int harga) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(harga);
  }

  void fetchJenisBayar() async {
    String? jenisBayarLocal = sp.getString('jenisBayarLocal');

    try {
      // print(jenisBayarLocalList[0]['KODE']);
      setState(() {
        jenisBayar = jsonDecode(jenisBayarLocal ?? '[]');
        isSelected = List.generate(jenisBayar.length, (index) => false);
      });
    } catch (e) {
      print('Error decoding JSON local: $e');
    }
    try {
      const url = "http://10.0.2.2:8082/proyek_pos/jenisbayar";
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final body = response.body;
      final json = jsonDecode(body);
      // print(json['data'][0]['KURS']);
      setState(() {
        jenisBayar = json['data'];
        sp.setString('jenisBayarLocal', jsonEncode(jenisBayar));
        isSelected = List.generate(jenisBayar.length, (index) => false);
        print(sp.getString('jenisBayarLocal'));
        // print(kurs);
      });
    } catch (e) {
      print("Error dalam request ke server: $e");
    }
  }

  int findFirstTrueIndex(List<bool> isSelected) {
    return isSelected.indexOf(true);
  }

  // Future<void> _inputNota(
  //   BuildContext context,
  // ) async {
  //   String noHp = sp.getString('customer_noHp')!;
  //   Map<String, dynamic> user = jsonDecode(sp.getString('admin')!);
  //   String? cartJson = sp.getString('cartJson');
  //   List<CartItem> items = [];
  //   List<dynamic> cartList = jsonDecode(cartJson ?? '[]');

  //   items = cartList.map((item) => CartItem.fromJson(item)).toList();
  //   int firstTrueIndex = findFirstTrueIndex(isSelected);
  //   if (firstTrueIndex == -1) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Failed",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           content: Text("Silahkan pilih metode pembayaran terlebih dahulu"),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("OK"),
  //             )
  //           ],
  //         );
  //       },
  //     );
  //     return;
  //   } else {
  //     // print(jenisBayar[firstTrueIndex]['KODE']);
  //   }
  //   // print(widget.totalHarga);

  //   // print(items[0].count);
  //   // print(user['USER_ID']);
  //   // print(noHp);
  //   List<Map<String, dynamic>> barangBody = [];
  //   items.forEach((item) {
  //     barangBody.add({'barcode': item.produk.barcodeID, 'count': item.count});
  //   });
  //   print(barangBody);
  //   const url = "http://10.0.2.2:8082/proyek_pos/nota";
  //   final uri = Uri.parse(url);
  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Content-type': 'application/json',
  //     },
  //     body: json.encode({
  //       "no_hp": noHp,
  //       "user_input": user['USER_ID'],
  //       "barang": barangBody,
  //       "kode_bayar": jenisBayar[firstTrueIndex]['KODE'],
  //       "nominal": widget.totalHarga
  //     }),
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     final body = response.body;
  //     final jsonBody = jsonDecode(body);
  //     if (jsonBody['success']) {
  //       sp.remove('cartJson');
  //       sp.remove('customer_noHp');
  //       sp.remove('customer_nama');

  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => Dashboardpage()));
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text(
  //               "Failed",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //             content: Text(jsonBody['message'] ??
  //                 'Maaf ada kesalahan,mohon tunggu sebentar'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("OK"),
  //               )
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Failed",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           content: Text('Maaf ada kesalahan,mohon tunggu sebentar'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("OK"),
  //             )
  //           ],
  //         );
  //       },
  //     );
  //     return;
  //   }
  // }
  Future<void> _inputNota(BuildContext context) async {
    String noHp = sp.getString('customer_noHp')!;
    // print(noHp);
    // return;

    Map<String, dynamic> user = jsonDecode(sp.getString('admin')!);
    String? cartJson = sp.getString('cartJson');
    List<CartItem> items = [];
    List<dynamic> cartList = jsonDecode(cartJson ?? '[]');

    items = cartList.map((item) => CartItem.fromJson(item)).toList();
    int firstTrueIndex = findFirstTrueIndex(isSelected);
    if (firstTrueIndex == -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Failed",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("Silahkan pilih metode pembayaran terlebih dahulu"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
      return;
    }

    List<Map<String, dynamic>> barangBody = [];
    items.forEach((item) {
      barangBody.add({'barcode': item.produk.barcodeID, 'count': item.count});
    });

    Map<String, dynamic> notaData = {
      "no_hp": noHp,
      "user_input": user['USER_ID'],
      "barang": barangBody,
      "kode_bayar": jenisBayar[firstTrueIndex]['KODE'],
      "nominal": widget.totalHarga,
    };
    print('test');
    print(notaData);
    sp.remove('cartJson');
    sp.remove('customer_noHp');
    sp.remove('customer_nama');

    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboardpage()));
    });
    await saveUnsentNotaLocally(notaData);
    await synchronizeNota();

    // const url = "http://10.0.2.2:8082/proyek_pos/nota";
    // final uri = Uri.parse(url);
    // try {
    //   final response = await http.post(
    //     uri,
    //     headers: {'Content-type': 'application/json'},
    //     body: json.encode(notaData),
    //   );

    //   if (response.statusCode == 200) {
    //     final body = jsonDecode(response.body);
    //     if (!body['success']) {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             title: Text(
    //               "Failed",
    //               style: TextStyle(color: Colors.red),
    //             ),
    //             content: Text(body['message'] ??
    //                 'Maaf ada kesalahan, mohon tunggu sebentar'),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: Text("OK"),
    //               )
    //             ],
    //           );
    //         },
    //       );
    //     }
    //   } else {
    //     // Save locally if not successful
    //     await saveUnsentNotaLocally(notaData);
    //   }
    // } catch (e) {
    //   // Save locally in case of any exception
    //   await saveUnsentNotaLocally(notaData);
    // }
  }
}
