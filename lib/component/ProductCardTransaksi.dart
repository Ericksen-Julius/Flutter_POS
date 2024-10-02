// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';

class ProductCardTransaksi extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String productCode;
  final String price;
  final int count;
  final Function(bool, int, int, String) onValueChange;
  final Function(String) onItemDelete;
  // final VoidCallback onDelete;

  const ProductCardTransaksi(
      {super.key,
      required this.imagePath,
      required this.productName,
      required this.productCode,
      required this.price,
      required this.count,
      required this.onValueChange,
      required this.onItemDelete
      // required this.onDelete,
      });

  @override
  Widget build(BuildContext context) {
    String cleanedPrice = price.replaceAll(RegExp(r'[^\d]'), '');
    return GestureDetector(
      onTap: () {
        onValueChange(
            true, int.parse(cleanedPrice), count, productCode.toString());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Bayangan pertama
              blurRadius: 2.0,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Bayangan kedua
              blurRadius: 3.0,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  height: 100.0, // Maintain consistent height
                  padding: EdgeInsets.all(10.0), // Add padding
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16.0), // Rounded corners
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
                          child:
                              CircularProgressIndicator(), // Loading indicator
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
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Rata kiri untuk teks
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Plus Jakarta Sans Bold',
                        fontWeight: FontWeight.w700,
                        color: Color(0XFF344054),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      productCode,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans Regular',
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF1D2939),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Plus Jakarta Sans Bold',
                        fontWeight: FontWeight.w700,
                        color: Color(0XFF006AFF),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0XFFFF9A9A), // Warna latar belakang
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
                      onItemDelete(productCode);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0XFF851B1B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _deleteItem() async {
  //   String? cartJson = sp.getString('cartJson');
  //   List<CartItem> items = [];
  //   List<dynamic> cartList = jsonDecode(cartJson ?? '[]');
  //   items = cartList.map((item) => CartItem.fromJson(item)).toList();
  //   items.removeWhere((item) => item.produk.barcodeID == productCode);
  //   List<String> updatedCartJson =
  //       items.map((item) => jsonEncode(item.toJson())).toList();
  //   await sp.setString('cartJson', jsonEncode(updatedCartJson));
  //   onItemDelete();
  // }
}
