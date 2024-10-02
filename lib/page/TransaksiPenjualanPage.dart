// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyek_pos/component/ProductCardTransaksi.dart';
import 'package:proyek_pos/component/TambahCustomerModal.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CartItemModel.dart';
import 'package:proyek_pos/page/CariCustomerPage.dart';
import 'package:proyek_pos/page/CheckoutPage.dart';
import 'package:proyek_pos/page/TambahProdukPage.dart';

import 'package:http/http.dart' as http;

class TransaksiPenjualanPage extends StatefulWidget {
  const TransaksiPenjualanPage({super.key});

  @override
  State<TransaksiPenjualanPage> createState() => TransaksiPenjualanPageState();
}

class TransaksiPenjualanPageState extends State<TransaksiPenjualanPage> {
  bool itemClicked = false;
  int? itemPrice;
  int? count;
  final TextEditingController _namaCustomerController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _totalHargaController = TextEditingController();
  final TextEditingController _totalHargaItemsController =
      TextEditingController();

  List<CartItem> _cart = [];
  bool _isSwitched = false;
  var kurs = 0;
  int total = 0;
  int totalHarga = 0;
  String? chooseItem;

  void _updateValues(bool clicked, int price, int count, String barcodeID) {
    setState(() {
      itemClicked = clicked;
      itemPrice = price;
      count = count;
      chooseItem = barcodeID;

      _jumlahController.text = count.toString();
      if (itemClicked == true) {
        _totalHargaItemsController.text = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(count * (itemPrice ?? 0));
        _jumlahController.text = count.toString();
      }
      // Simulate re-running init logic
      // print("Values updated: clicked = $itemClicked, price = $itemPrice");
    });
  }

  Future<void> _deleteItem(String productCode) async {
    String? cartJson = sp.getString('cartJson');
    List<CartItem> items = [];
    List<dynamic> cartList = jsonDecode(cartJson ?? '[]');

    items = cartList.map((item) => CartItem.fromJson(item)).toList();

    items.removeWhere((item) => item.produk.barcodeID == productCode);

    String updatedCartJson =
        jsonEncode(items.map((item) => item.toJson()).toList());
    await sp.setString('cartJson', updatedCartJson);
    setState(() {
      _cart = items;
      total = CartItem.calculateTotalPrice(_cart, kurs);

      String formattedTotal = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(total);
      _totalHargaController.text = formattedTotal;
    });
  }

  @override
  void initState() {
    // sp.remove('cartJson');

    // TODO: implement initState
    super.initState();
    // sp.remove('kursLocal');
    String? cart = sp.getString('cartJson');
    print(cart);
    List<dynamic> temporary = jsonDecode(cart ?? '[]');
    _cart = temporary.map((item) => CartItem.fromJson(item)).toList();
    fetchKurs();
    _jumlahController.addListener(() {
      _updateTotalPriceBasedOnBarcode();
    });

    _namaCustomerController.text = sp.getString('customer_nama') ?? '';
  }

  Future<void> _updateTotalPriceBasedOnBarcode() async {
    if (_jumlahController.text.isNotEmpty) {
      try {
        int jumlah = int.parse(_jumlahController.text);
        CartItem? foundItem;

        // Mencari item dalam cart berdasarkan barcode
        for (CartItem item in _cart) {
          if (item.produk.barcodeID == chooseItem) {
            foundItem = item;
            break; // Keluar dari loop jika item ditemukan
          }
        }

        if (foundItem != null) {
          foundItem.count = jumlah;
          print(itemPrice);
          print(foundItem.count);
          int totalHarga = itemPrice! * jumlah;
          setState(() {
            _totalHargaItemsController.text = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(totalHarga);
          });

          String updatedCartJson =
              jsonEncode(_cart.map((item) => item.toJson()).toList());
          await sp.setString('cartJson', updatedCartJson);
          total = CartItem.calculateTotalPrice(_cart, kurs);
          String formattedTotal = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(total);
          _totalHargaController.text = formattedTotal;

          // print('cek cart');
          // print(sp.getString('cartJson'));
        } else {
          _totalHargaItemsController.text = '';
        }
      } catch (e) {
        _totalHargaItemsController.text = '';
      }
    } else {
      _totalHargaItemsController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: ,
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Transaksi Penjualan',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(75, 16, 16, 1),
            fontFamily: 'Plus Jakarta Sans Bold',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, // ini juga isi sendiri
              icon: Icon(Icons.settings))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCF3EC), // #FCF3EC
              Color(0xFFFFFFFF), // #FFFFFF
            ],
            stops: [0.0004, 0.405],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Tambah Transaksi Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(75, 16, 16, 1),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Customer',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(75, 16, 16, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _namaCustomerController,
                          style: TextStyle(color: Color(0xFFE59A69)),
                          decoration: InputDecoration(
                            hintText: "Nama Customer",
                            enabled: false,
                            hintStyle: TextStyle(color: Color(0xFFE59A69)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE59A69)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE59A69)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFFEEEE2),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            // Aksi ketika tombol ditekan
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CariCustomerPage()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFE59A69),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Pilih',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextButton(
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
                                return TambahCustomerModal(); // Panggil komponen tanpa parameter
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFE59A69),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFDAC9B6),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Barang',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(75, 16, 16, 1),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aksi ketika tombol ditekan
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TambahProdukPage()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFFFE4C5),
                          padding: EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Tambah Produk',
                          style: TextStyle(
                            color: Color(0XFFBB6A37),
                            fontFamily: 'Plus Jakarta Sans Bold',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ProductCardTransaksi(
                          imagePath: _cart[index].produk.foto ?? '',
                          productName: _cart[index].produk.nama ?? '',
                          productCode: _cart[index].produk.barcodeID ?? '',
                          price: formatNumber(
                              int.parse(_cart[index].produk.berat ?? '0'),
                              kurs),
                          count: _cart[index].count,
                          onValueChange: _updateValues,
                          onItemDelete: _deleteItem,
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFDAC9B6),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Jumlah',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans Bold',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Total harga',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans Bold',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _jumlahController,
                          enabled: itemClicked ? true : false,
                          style: TextStyle(color: Color(0xFF667085)),
                          decoration: InputDecoration(
                            // hintText: "",
                            hintStyle: TextStyle(color: Color(0xFFD0D5DD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFF9FAFB),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _totalHargaItemsController,
                          style: TextStyle(color: Color(0xFF667085)),
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            // hintText: "Nama Customer",
                            enabled: false,
                            hintStyle: TextStyle(color: Color(0xFFD0D5DD)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            filled:
                                true, // tanda TextField ada background color
                            fillColor: Color(0xFFF9FAFB),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diskon',
                        style: TextStyle(
                          color: Color(0xFF4B1010),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                        ),
                      ),
                      Switch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  summaryComponent(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      //footer
      bottomNavigationBar: Container(
        color: Color(0xFFFFEBDE),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_totalHargaController.text}\n',
                    style: TextStyle(
                      fontSize: 18, // Gaya untuk "Selamat datang di"
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3765FF),
                      fontFamily: 'Plus Jakarta Sans Bold',
                    ),
                  ),
                  TextSpan(
                    text: 'Subtotal',
                    style: TextStyle(
                      fontSize: 16, // Gaya untuk "Point Of Sales"
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2727),
                      fontFamily: 'Plus Jakarta Sans Bold',
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (_cart.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Keranjang masih kosong'),
                  ));
                } else if (_namaCustomerController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Nama customer harus diisi'),
                  ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckOutPage(totalHarga: total),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFE19767),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Proses Pembayaran',
                style: TextStyle(
                  color: Color(0xFFFEFDF8),
                  fontFamily: 'Plus Jakarta Sans Bold',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container summaryComponent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2.0,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                color: Color(0xFF4B1010),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans Bold',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_cart[index].produk.nama!} (${_cart[index].count})',
                        style: TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formatNumber(
                            int.parse(_cart[index].produk.berat!), kurs),
                        style: TextStyle(
                          color: Color(0xFF3E3E3E),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total(IDR)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    _totalHargaController.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatNumber(int berat, int kurs) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(berat * kurs);
  }

  Future<void> fetchKurs() async {
    // print("Mulai fetchKurs...");

    kurs = sp.getInt('kursLocal') ?? 0;
    total = CartItem.calculateTotalPrice(_cart, kurs);
    print(_cart);
    String formattedTotal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(total);
    _totalHargaController.text = formattedTotal;
    // print(kurs);
    const url = "http://10.0.2.2:8082/proyek_pos/kurs";
    try {
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final body = response.body;
      final json = jsonDecode(body);
      print("Status kode response: ${response.statusCode}");
      setState(() {
        kurs = int.parse(json['data'][0]['KURS']);
        sp.setInt('kursLocal', kurs);
        total = CartItem.calculateTotalPrice(_cart, kurs);

        // Format and print total price
        String formattedTotal = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(total);
        _totalHargaController.text = formattedTotal;
        // print(kurs);
      });
    } catch (e) {
      print("Error dalam request ke server: $e");
      if (e is SocketException) {
        print('Tidak dapat terhubung ke server.');
      }
    }
  }
}
