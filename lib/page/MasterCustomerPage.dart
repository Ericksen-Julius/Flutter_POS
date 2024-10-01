// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/CustomerProfile.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/component/MasterCustomerProfile.dart';
import 'package:proyek_pos/component/TambahCustomerModal.dart';
import 'package:proyek_pos/main.dart';
import 'dart:convert';

import 'package:proyek_pos/model/CustomerModel.dart';

class MasterCustomerPage extends StatefulWidget {
  const MasterCustomerPage({super.key});

  @override
  State<MasterCustomerPage> createState() => MasterCustomerPageState();
}

class MasterCustomerPageState extends State<MasterCustomerPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = customers.where((cust) {
        final nameMatches = cust.nama!.toLowerCase().contains(query);
        final phoneMatches = cust.noHp!.contains(query);
        final cityMatches = cust.kota!.toLowerCase().contains(query);
        return nameMatches || phoneMatches || cityMatches;
      }).toList();
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromRGBO(254, 253, 248, 1),
      title: Text(
        'Master Customer',
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
              builder: (context) => TambahCustomerModal(),
            );
          },
          icon: Icon(Icons.person_add_alt_1_rounded),
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Color(0xFF667085)),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFE19767),
                ),
                hintText: 'Cari Customer',
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
            SizedBox(height: 20), // Adds some space between search and list
            Expanded(
              child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: MasterCustomerProfile(
                      nama: filteredCustomers[index].nama!,
                      noHp: filteredCustomers[index].noHp!,
                      alamat: filteredCustomers[index].alamat!,
                      kota: filteredCustomers[index].kota!,
                      onDelete: fetchData,
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


  // void fetchData() async {
  //   const url = "http://10.0.2.2:8082/proyek_pos/customer";
  //   final uri = Uri.parse(url);
  //   final response = await http.get(
  //     uri,
  //   );
  //   final body = response.body;
  //   final json = jsonDecode(body);
  //   // print(json['data']);
  //   setState(() {
  //     customers = (json['data'] as List)
  //         .map((item) => Customer.fromJson(item))
  //         .toList();
  //     filteredCustomers = customers;
  //     // print(customers);
  //   });
  // }

  Future<void> fetchData() async {
    // print("Mulai fetchData...");

    String? customerLocal = sp.getString('customersLocal');
    try {
      // print("Coba decode local data...");
      List<dynamic> customerListLocal = jsonDecode(customerLocal ?? '[]');
      setState(() {
        customers =
            customerListLocal.map((item) => Customer.fromJson(item)).toList();
        filteredCustomers = customers;
      });
      // print("Local data berhasil dimuat.");
    } catch (e) {
      print('Error decoding JSON local: $e');
    }

    try {
      // print("Mulai request ke server...");
      const url = "http://10.0.2.2:8082/proyek_pos/customer";
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      // print("Status kode response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        // print("Data dari server: $json");

        if (mounted) {
          setState(() {
            customers = (json['data'] as List)
                .map((item) => Customer.fromJson(item))
                .toList();
            filteredCustomers = customers;
            sp.setString('customersLocal', jsonEncode(json['data'] ?? []));
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
