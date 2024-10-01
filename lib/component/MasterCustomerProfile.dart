import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CustomerModel.dart';
import 'package:proyek_pos/page/MasterCustomerPage.dart';

class MasterCustomerProfile extends StatefulWidget {
  final String nama;
  final String noHp;
  final String alamat;
  final String kota;
  final Function onDelete;

  const MasterCustomerProfile(
      {super.key, required this.nama, required this.noHp, required this.alamat, required this.kota, required this.onDelete});

  @override
  State<MasterCustomerProfile> createState() => _MasterCustomerProfileState();
}

class _MasterCustomerProfileState extends State<MasterCustomerProfile> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // First shadow
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Second shadow
            blurRadius: 3.0,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 20, top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.account_circle, // Icon for account
                      size: 100, // Icon size
                      color: Colors.black, // Icon color
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF344054),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.noHp,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans Regular',
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF1D2939),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.kota,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFE19767),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFE19767), // Background color
                      shape: BoxShape.rectangle, // Box shape
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Divider placed here
            Divider(
              color: Colors.grey[400], // Color of the line
              thickness: 2.0, // Thickness of the line
              // height: 20.0,
            ),
            // Row for text on the left and text with icon on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements between
              children: [
                Text(
                  '${widget.kota}, Indonesia',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete, 
                        color: Colors.red,
                      ),
                      SizedBox(width: 4), 
                      Text(
                        'Delete Customer',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Plus Jakarta Sans Bold',
                            color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    deleteCustomer(widget.noHp, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // ini get fetchdata offline + online
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

  Future<void> deleteCustomer(String noHp, BuildContext context) async {
  final trimmedNoHp = noHp.trim();
  final url = "http://10.0.2.2:8082/proyek_pos/customer";
  final uri = Uri.parse(url);

  try {
    final response = await http.delete(
      uri,
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode({'no_hp': trimmedNoHp}),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success']) {
      await fetchData(); 

      bool? dialogResult = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Customer deleted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Close dialog and return true
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      if (dialogResult == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MasterCustomerPage()),
        );
      }
    } else {
      print('Failed to delete customer: ${response.statusCode}');
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}
}




