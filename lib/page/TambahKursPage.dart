import 'package:flutter/material.dart';
import 'package:proyek_pos/component/KursBody.dart';
import 'package:proyek_pos/component/TambahKursModal.dart';

class TambahKursPage extends StatefulWidget {
  const TambahKursPage({super.key});

  @override
  State<TambahKursPage> createState() => _TambahKursPageState();
}

class _TambahKursPageState extends State<TambahKursPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Master Kurs',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(75, 16, 16, 1),
            fontFamily: 'Plus Jakarta Sans Bold',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => TambahKursModal(),
            );
          },
          icon: Icon(Icons.add_circle_outline),
        ),
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
          child: KursBody(), // Panggil komponen baru di sini
        ),
      ),
    );
  }
}