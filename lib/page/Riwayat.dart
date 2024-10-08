// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:proyek_pos/component/CardNota.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CartItemModel.dart';
import 'package:proyek_pos/model/NotaModel.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/page/NotaPage.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  final TextEditingController _searchController = TextEditingController();

  List<NotaModel> notas = [];
  List<NotaModel> filteredNotas = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filterNotas);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterNotas);
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredNotas = notas.where((nota) {
        final notaCodeMatches = nota.noDok!.toLowerCase().contains(query);
        final phoneMatches =
            nota.noHp!.contains(query); // Example, adapt as needed
        return notaCodeMatches ||
            phoneMatches; // Modify based on your search criteria
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavbar()));
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Cari Nota',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(75, 16, 16, 1),
            fontFamily: 'Plus Jakarta Sans Bold',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Container(
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Color(0xFF667085)),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFE19767),
                ),
                hintText: 'Cari Nota',
                hintStyle: TextStyle(
                  color: Color(0xFFE19767),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFFE19767)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Color(0xFFE19767)),
                ),
                filled: true,
                fillColor: Color(0xFFFEFCFB),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotas.length,
                itemBuilder: (context, index) {
                  final nota = filteredNotas[index];
                  print("nota di riwayat");
                  print(nota.toString());
                  return 
                  GestureDetector(
                    onTap: () {
                      Map<String, dynamic> notaData = {
                            "no_hp": nota.noHp, // PERLU
                            "nota_code": nota.noDok, // PERLU 
                            "nominal": int.parse(nota.nominal!), // PERLU

                          };

                          List<Map<String, dynamic>> barangDibeli = [];
                            nota.barang!.forEach((item) {

                              barangDibeli.add({
                                'nama': item.nama,
                                'barcode':item.barcode,
                                'count': int.parse(item.count!),
                                'berat': (int.parse(item.harga.toString())/int.parse(item.kurs.toString())).toString(),
                              });
                            });
                    // print('Card pressed: ${nota.no_dok}');
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotaPage(
                          data: notaData,

          

                          dataBarang: barangDibeli,
                          // List<Map<String, dynamic>> barangBody = [];
                          //   items.forEach((item) {
                          //     barangBody.add({'barcode': item.produk.barcodeID, 'count': item.count});
                          //   });
                          //   List<Map<String, dynamic>> barangDibeli = [];
                          //   items.forEach((item) {
                          //     barangDibeli.add({
                          //       'nama': item.produk.nama,
                          //       'count': item.count,
                          //       'berat': item.produk.berat
                          //     });
                          //   });

                          admin: nota.userName!, // ini harus ambil dari userInput di nota A
                          userName: nota.customerName!, // ini ambil dari no hp di nota A trs join ke customer
                          discount: nota.discount.toDouble(), // diambil dari nota C
                          invoiceDate: formatTanggal(nota.tanggal!.toString()) ?? DateTime.now(), // ini dari nota A
                        ),
                      ),
                    );
                  },
                    child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CardNota(
                        noDok: nota.noDok ?? '',
                          noHp: nota.noHp ?? '',
                          tanggal: nota.tanggal?.toString() ?? '',
                          userInput: nota.userName?.toString() ?? '',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  
  DateTime? formatTanggal(String tanggal) {
  try {
    // Create a DateFormat for the input format
    DateFormat format = DateFormat("dd-MMM-yy");
    // Parse the string into a DateTime object
    DateTime parsedDate = format.parse(tanggal);
    print("Parsed Date: $parsedDate"); // Prints the DateTime object
    return parsedDate; // Return the parsed DateTime object
  } catch (e) {
    print("Error parsing date: $e");
    return null; // Return null in case of error
  }
}

  Future<void> fetchData() async {
    String? notaLocal = sp.getString('fetchNota');
    print(notaLocal);
    try {
      List<dynamic> notaListLocal = jsonDecode(notaLocal ?? '[]');
      setState(() {
        notas = notaListLocal.map((item) => NotaModel.fromJson(item)).toList();
        filteredNotas = notas;
        // Print filteredNotas to check the values when using local data
        // print("Offline data (filteredNotas):");
        // filteredNotas.forEach((nota) {
        //   print('Nota Code: ${nota.no_dok}, Phone: ${nota.no_hp}');
        // });
      });
    } catch (e) {
      print('Error decoding JSON local: $e');
    }

    try {
      // print("online");
      const url = "http://10.0.2.2:8082/proyek_pos/nota";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);

        if (mounted) {
          setState(() {
            notas = (json['data'] as List)
                .map((item) => NotaModel.fromJson(item))
                .toList();
            filteredNotas = notas;
            filteredNotas.forEach((nota) {
          print('Nota Code: ${nota.noDok}, Phone: ${nota.noHp}');
        });
            sp.setString('fetchNota', jsonEncode(json['data'] ?? []));
          });
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error dalam request ke server: $e");
      if (e is SocketException) {
        print('Tidak dapat terhubung ke server.');
      }
    }
  }
}
