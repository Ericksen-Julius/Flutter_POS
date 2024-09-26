// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/ProdukCard.dart';
import 'package:proyek_pos/model/ProdukModel.dart';

class ProdukBody extends StatefulWidget {
  const ProdukBody({super.key});

  @override
  State<ProdukBody> createState() => _ProdukBodyState();
}

class _ProdukBodyState extends State<ProdukBody> {
  final TextEditingController _searchController = TextEditingController();
  List<bool> isSelected = [false, false, false]; // Assuming 3 filters

  List<Produk> produk = [];
  List<Produk> filteredProduk = [];
  var kurs = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchKurs();
    _searchController.addListener(_filterProduk);
    isSelected[0] = true;
  }

  void _filterProduk() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProduk = produk.where((prod) {
        final nameMatches = prod.nama!.toLowerCase().contains(query);
        final barcodeMatches = prod.barcodeID!.toLowerCase().contains(query);
        return nameMatches || barcodeMatches;
      }).toList();
    });
  }

  void _toggleFilter(int index) {
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

  void _resetFilters() {
    setState(() {
      isSelected = [false, false, false]; // Reset all filters
    });
  }

  int findFirstTrueIndex(List<bool> isSelected) {
    return isSelected.indexOf(true);
  }

  void _filterByCategory() {
    int firstTrueIndex = findFirstTrueIndex(isSelected);
    List<String> category = ['Semua', 'LM', 'Emas'];

    setState(() {
      if (firstTrueIndex != -1) {
        if (firstTrueIndex != 0) {
          filteredProduk = produk.where((prod) {
            // Gunakan perbandingan eksak
            return prod.kategori == category[firstTrueIndex];
          }).toList();
        } else {
          filteredProduk = produk;
        }
      }
    });

    Navigator.pop(context); // Close modal after applying the filter
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Color(0xFF667085)),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFE19767),
                  ),
                  hintText: 'Cari Produk',
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
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFFE19767), // Warna latar belakang
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
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          // Tambahkan StatefulBuilder di sini
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Container(
                              height: 175, // Adjust height as needed
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans Bold',
                                          fontSize: 18,
                                          color: Color(0xFF5C1D20),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _resetFilters();
                                          });
                                          setModalState(
                                              () {}); // Tambahkan ini untuk mereset warna di modal
                                        },
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            fontFamily:
                                                'Plus Jakarta Sans Bold',
                                            fontSize: 16,
                                            color: Color(0xFF006AFF),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(3, (index) {
                                      String label = [
                                        'Semua',
                                        'Logam Mulia',
                                        'Perhiasan'
                                      ][index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _toggleFilter(index);
                                            });
                                            setModalState(
                                                () {}); // Tambahkan ini untuk update state di modal
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isSelected[index]
                                                ? Color(0xFFE19767)
                                                : Colors.white,
                                            padding: EdgeInsets.all(12.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                                              fontFamily:
                                                  'Plus Jakarta Sans Regular',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _filterByCategory();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFBC5716),
                                        padding: EdgeInsets.all(12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Filter',
                                        style: TextStyle(
                                          color: Color(0xFFFEFDF8),
                                          fontFamily: 'Plus Jakarta Sans Bold',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFFFEFCFB),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              childAspectRatio: 0.85, // Adjust the height of each item
              mainAxisSpacing: 10, // Spacing between rows
              crossAxisSpacing: 10, // Spacing between columns
            ),
            itemCount: filteredProduk.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ProdukCard(
                  imagePath:
                      'http://10.0.2.2:8082/proyek_pos/uploads/${filteredProduk[index].foto}',
                  label: filteredProduk[index].nama!,
                  harga:
                      (int.parse(filteredProduk[index].berat!) * kurs).toString(),
                ),
              );
            },
          ),
          itemCount: filteredProduk.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ProdukCard(
                imagePath:
                    'http://10.0.2.2:8082/proyek_pos/uploads/${filteredProduk[index].foto}',
                label: filteredProduk[index].nama!,
                berat: int.parse(filteredProduk[index].berat!),
                kurs: kurs,
                kategori: filteredProduk[index].kategori!,
                barcodeID: filteredProduk[index].barcodeID!,
                // (int.parse(filteredProduk[index].berat!) * kurs).toString(),
              ),
            );
          },
        ),
      ],
    );
  }

  void fetchData() async {
    const url = "http://10.0.2.2:8082/proyek_pos/barang";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
    );
    final body = response.body;
    final json = jsonDecode(body);
    print(json['data'][0]['BERAT']);
    setState(() {
      produk =
          (json['data'] as List).map((item) => Produk.fromJson(item)).toList();
      filteredProduk = produk;
      // print(produk);
    });
  }

  void fetchKurs() async {
    const url = "http://10.0.2.2:8082/proyek_pos/kurs";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
    );
    final body = response.body;
    final json = jsonDecode(body);
    // print(json['data'][0]['KURS']);
    setState(() {
      kurs = int.parse(json['data'][0]['KURS']);
      // print(kurs);
    });
  }
}
