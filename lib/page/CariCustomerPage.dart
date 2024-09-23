// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:proyek_pos/component/CustomerProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:proyek_pos/model/CustomerModel.dart';

class CariCustomerPage extends StatefulWidget {
  const CariCustomerPage({super.key});

  @override
  State<CariCustomerPage> createState() => CariCustomerPageState();
}

class CariCustomerPageState extends State<CariCustomerPage> {
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
        // elevation: ,
        backgroundColor: Color.fromRGBO(254, 253, 248, 1),
        title: Text(
          'Cari Customer',
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
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomerProfile(
                        nama: filteredCustomers[index].nama!,
                        noHp: filteredCustomers[index].noHp!,
                        kota: filteredCustomers[index].kota!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchData() async {
    const url = "http://10.0.2.2:8082/proyek_pos/customer";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
    );
    final body = response.body;
    final json = jsonDecode(body);
    // print(json['data']);
    setState(() {
      customers = (json['data'] as List)
          .map((item) => Customer.fromJson(item))
          .toList();
      filteredCustomers = customers;
      // print(customers);
    });
  }
}
