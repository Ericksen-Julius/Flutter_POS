import 'package:flutter/material.dart';
import 'package:proyek_pos/component/ProdukBody.dart';

class MasterProdukPage extends StatefulWidget {
  const MasterProdukPage({super.key});

  @override
  State<MasterProdukPage> createState() => _MasterProdukPageState();
}

class _MasterProdukPageState extends State<MasterProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Master Produk',
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
              icon: Icon(Icons.person_add_alt_1_rounded))
        ],
      ),
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
          child: ProdukBody(), // Panggil komponen baru di sini
        ),
      ),
    );
  }
}