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
            onPressed: () {},
            icon: Icon(Icons.settings),
          )
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
            SizedBox(height: 20),
            // Expanded widget to allow the ListView.builder to take up available space
            Expanded(
              child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }

  void fetchData() async {
    const url = "http://10.0.2.2:8082/proyek_pos/customer";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

  if (mounted){
    setState(() {
      customers = (json['data'] as List)
          .map((item) => Customer.fromJson(item))
          .toList();
      filteredCustomers = customers;
    });
  }
  }
}
