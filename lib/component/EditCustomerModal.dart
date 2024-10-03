// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/helper/CustomerSynchronize.dart';
import 'package:proyek_pos/main.dart';
import 'dart:convert';

import 'package:proyek_pos/model/CustomerModel.dart';

class EditCustomerModal extends StatefulWidget {
  final String nama;
  final String noHp;
  final String alamat;
  final String kota;
  final Function(Customer) onEdit;
  const EditCustomerModal({super.key, required this.nama, required this.noHp, required this.alamat, required this.kota, required this.onEdit});

  @override
  State<EditCustomerModal> createState() => EditCustomerModalState();
}

class EditCustomerModalState extends State<EditCustomerModal> {
  // Inisialisasi controller di dalam widget
  final TextEditingController _editNamaController = TextEditingController();
  final TextEditingController _editNoHpController = TextEditingController();
  final TextEditingController _editAlamatController = TextEditingController();
  final TextEditingController _editKotaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editNamaController.text = widget.nama;
    _editNoHpController.text = widget.noHp;
    _editAlamatController.text = widget.alamat;
    _editKotaController.text = widget.kota;
  }

  
  @override
  void dispose() {
    // Jangan lupa dispose controller setelah selesai digunakan
    _editNamaController.dispose();
    _editNoHpController.dispose();
    _editAlamatController.dispose();
    _editKotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Customer',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans Bold',
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C1D20),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _editNamaController,
              icon: Icons.mail,
              label: 'Nama',
              enabled: true,
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _editNoHpController,
              icon: Icons.phone,
              label: 'No Handphone',
              enabled: false,
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _editAlamatController,
              icon: Icons.location_on,
              label: 'Alamat',
              enabled: true,
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _editKotaController,
              icon: Icons.location_city,
              label: 'Kota',
              enabled: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logic untuk tambah customer
                  if (_editNamaController.text.isEmpty ||
                      _editNoHpController.text.isEmpty ||
                      _editAlamatController.text.isEmpty ||
                      _editKotaController.text.isEmpty) {
                    // Show alert dialog if any field is empty
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Failed",
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text("Semua field harus diisi!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              )
                            ],
                          );
                        });
                  } else {
                    // Logic untuk tambah customer
                    _editCustomer(
                      _editNamaController.text,
                      _editNoHpController.text,
                      _editAlamatController.text,
                      _editKotaController.text,
                      context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE59A69),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFFFEFDF8),
                    fontFamily: 'Plus Jakarta Sans Bold',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label, required bool enabled,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Color(0xFF667085)),
      keyboardType:
          label == 'No Handphone' ? TextInputType.number : TextInputType.text,
          readOnly: !enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Color(0xFF667085),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFF667085),
        ),
        hintStyle: TextStyle(
          color: Color(0xFFD0D5DD),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xFFD0D5DD)),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[200],
      ),
    );
  }

  // Future<void> updateLocalStorage(List<Customer> customers) async {
  //   // Simpan daftar pelanggan yang diperbarui ke local storage
  //   // Misalnya, menggunakan SharedPreferences
  //   String customerList =
  //       jsonEncode(customers.map((user) => user.toJson()).toList());
  //   await sp.setString('temporaryAddCustomer', customerList);
  // }

Future<void> _editCustomer(
    String nama,
    String noHp, // noHp cannot be changed, used as identifier
    String alamat,
    String kota,
    BuildContext context,
  ) async {
    String? customersLocal = sp.getString('customersLocal');
    List<Customer> customers = [];

    // Check if customersLocal is available
    if (customersLocal != null) {
      List<dynamic> customerList = jsonDecode(customersLocal);
      customers = customerList.map((item) => Customer.fromJson(item)).toList();

      // Find the customer by noHp and update their details
      for (var customer in customers) {
        if (customer.noHp == noHp) {
          customer.nama = nama;
          customer.alamat = alamat;
          customer.kota = kota;
          break;
        }
      }

      // Update SharedPreferences with the modified list of customers
      String updatedCustomersLocal =
          jsonEncode(customers.map((user) => user.toJson()).toList());
      await sp.setString('customersLocal', updatedCustomersLocal);

      // Save unsent edited customer data locally for synchronization
      await saveUnsentEditCustomerLocally({
        'no_hp': noHp,
        'nama': nama,
        'alamat': alamat,
        'kota': kota,
      });

      // Call a function to synchronize the changes with the backend
      synchronizeEditCustomers();

       // Create a Customer object to pass back to the parent
      Customer updatedCustomer = Customer(
        nama: nama,
        noHp: noHp,
        alamat: alamat,
        kota: kota,
      );

      // Call the onEdit callback
      widget.onEdit(updatedCustomer);

      // Close the modal after successful update
      Navigator.pop(context);
    } else {
      // If no customers exist in local storage, show an error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("Customer not found!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }
  }
}
