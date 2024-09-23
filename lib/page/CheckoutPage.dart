// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/CustomAppBar.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<bool> isSelected = [false, false]; // Assuming 3 filters
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
              rowPembayaran('Total Harga', 'Rp. 194.700'),
              SizedBox(height: 5),
              rowPembayaran('Charge', 'Rp. 0'),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: Color(0xFF3E3E3E),
              ),
              SizedBox(height: 10),
              rowPembayaran('Total Biaya', 'Rp. 194.700'),
              SizedBox(height: 5),
              rowPembayaran('Total Bayar', 'Rp. 194.700'),
              SizedBox(height: 5),
              rowPembayaran('Kembali', 'Rp. 0'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    2,
                    (index) {
                      String label = ['Debit Card', 'Cash'][index];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
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
          onPressed: () {},
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
}
