import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:proyek_pos/main.dart';
import 'package:http/http.dart' as http;

// Function to save unsent products locally
Future<void> saveUnsentProdukLocally(Map<String, dynamic> produk) async {
  String? unsentProdukJson = sp.getString('unsentProduk');
  List<dynamic> unsentProdukList = jsonDecode(unsentProdukJson ?? '[]');
  unsentProdukList.add(produk);
  await sp.setString('unsentProduk', jsonEncode(unsentProdukList));
}

// Function to synchronize unsent products
Future<void> synchronizeProduk() async {
  const url = "http://10.0.2.2:8082/proyek_pos/barang";
  final uri = Uri.parse(url);

  // Get unsent produk data from local storage
  String? unsentProdukJson = sp.getString('unsentProduk');
  if (unsentProdukJson == null) {
    return;
  }
  List<dynamic> unsentProdukList = jsonDecode(unsentProdukJson);

  for (var produk in List.from(unsentProdukList)) {
    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['nama'] = produk['nama']
        ..fields['berat'] = produk['berat']
        ..fields['kategori'] = produk['kategori']
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
        });

      // Adding the image file to the request if available
      if (produk['foto'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          produk['foto'],
          contentType:
              MediaType('image', 'jpeg'), // Adjust according to your image type
        ));
      }

      // Sending the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      // Check response status
      if (response.statusCode == 200 && jsonResponse['success']) {
        // Remove successfully sent produk from local storage
        unsentProdukList.remove(produk);
        await sp.setString('unsentProduk', jsonEncode(unsentProdukList));
      } else {
        break; // Stop if there's an issue with the server response
      }
    } catch (e) {
      break; // Stop if there's an error
    }
  }
}
