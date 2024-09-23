// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetworkImageWithLoading extends StatelessWidget {
  final String imageUrl;

  const NetworkImageWithLoading({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity, // Adjust size as needed
            height: 130.0,
            errorBuilder: (context, error, stackTrace) {
              // Menampilkan gambar default jika gagal memuat
              return Image.asset(
                'assets/default_image.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100.0,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProdukCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String harga;

  const ProdukCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    String formattedHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(int.parse(harga));
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageWithLoading(
            imageUrl: imagePath, // Ganti dengan imagePath yang sesuai
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              formattedHarga,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(226, 62, 95, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
