// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NetworkImageWithLoading extends StatelessWidget {
  final String imageUrl;

  const NetworkImageWithLoading({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: _loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for image to load
          return Center(
            child: Container(
              width: double.infinity,
              height: 100, // Set the height as per your requirement
              padding: EdgeInsets.all(10.0), // Add padding
              alignment: Alignment.center, // Center the loading indicator
              child: CircularProgressIndicator(), // Default size
            ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, show the default image
          return Container(
            height: 100, // Maintain consistent height
            padding: EdgeInsets.all(10.0), // Add padding
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/default_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // If the image is loaded successfully, display it
          return Container(
            height: 100, // Maintain consistent height
            padding: EdgeInsets.all(10.0), // Add padding
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image(
                image: snapshot.data!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        } else {
          // Fallback in case none of the above states apply
          return Container(); // Return an empty container
        }
      },
    );
  }

  Future<ImageProvider> _loadImage(String url) async {
    // Create a completer to handle the async loading
    final completer = Completer<ImageProvider>();

    // Create a NetworkImage
    final networkImage = NetworkImage(url);

    // Add a listener for the image loading
    final imageStream = networkImage.resolve(ImageConfiguration());

    // Listen to the stream
    imageStream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool sync) {
          // If image is loaded successfully, complete the future with the image
          completer.complete(networkImage);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          // If there is an error, complete with a default asset image
          completer.complete(AssetImage('assets/default_image.jpg'));
        },
      ),
    );

    // Return the future from the completer
    return completer.future.timeout(Duration(seconds: 5), onTimeout: () {
      // If it times out, return the default asset image
      return AssetImage('assets/default_image.jpg');
    });
  }
}

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
          padding: const EdgeInsets.only(
              left: 10.0, right: 20, top: 10.0, bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                  flex: 5, child: NetworkImageWithLoading(imageUrl: imagePath)),
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
