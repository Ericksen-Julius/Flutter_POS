// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/helper/CustomerSynchronize.dart';
import 'package:proyek_pos/main.dart';
import 'dart:convert';

import 'package:proyek_pos/model/CustomerModel.dart';

class TambahCustomerModal extends StatefulWidget {
  const TambahCustomerModal({super.key});

  @override
  State<TambahCustomerModal> createState() => TambahCustomerModalState();
}

class TambahCustomerModalState extends State<TambahCustomerModal> {
  // Inisialisasi controller di dalam widget
  final TextEditingController _inputNamaController = TextEditingController();
  final TextEditingController _inputNoHpController = TextEditingController();
  final TextEditingController _inputAlamatController = TextEditingController();
  final TextEditingController _inputKotaController = TextEditingController();

  @override
  void dispose() {
    // Jangan lupa dispose controller setelah selesai digunakan
    _inputNamaController.dispose();
    _inputNoHpController.dispose();
    _inputAlamatController.dispose();
    _inputKotaController.dispose();
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
              'Tambah Customer',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans Bold',
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C1D20),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _inputNamaController,
              icon: Icons.mail,
              label: 'Nama',
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _inputNoHpController,
              icon: Icons.phone,
              label: 'No Handphone',
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _inputAlamatController,
              icon: Icons.location_on,
              label: 'Alamat',
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _inputKotaController,
              icon: Icons.location_city,
              label: 'Kota',
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logic untuk tambah customer
                  if (_inputNamaController.text.isEmpty ||
                      _inputNoHpController.text.isEmpty ||
                      _inputAlamatController.text.isEmpty ||
                      _inputKotaController.text.isEmpty) {
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
                    _inputCustomer(
                      _inputNamaController.text,
                      _inputNoHpController.text,
                      _inputAlamatController.text,
                      _inputKotaController.text,
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
                  'Tambah',
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
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Color(0xFF667085)),
      keyboardType:
          label == 'No Handphone' ? TextInputType.number : TextInputType.text,
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
        fillColor: Colors.white,
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

  Future<void> _inputCustomer(
    String nama,
    String noHp,
    String alamat,
    String kota,
    BuildContext context,
  ) async {
    // print(isChecked);
    // return;
    String? customersLocal = sp.getString('customersLocal');
    List<Customer> temporaryAddCustomer = [];

    // print(customersLocal);
    List<Customer> customers = [];
    // if (customersLocal != null) {
    List<dynamic> customerList = jsonDecode(customersLocal ?? '[]');
    customers = customerList.map((item) => Customer.fromJson(item)).toList();
    bool customerExist = customers.any((customer) => customer.noHp == noHp);
    if (!customerExist) {
      String? temp = sp.getString('temporaryAddCustomer');
      List<dynamic> temporaryAddCustomerList = jsonDecode(temp ?? '[]');
      temporaryAddCustomer = temporaryAddCustomerList
          .map((item) => Customer.fromJson(item))
          .toList();
      temporaryAddCustomer
          .add(Customer(noHp: noHp, nama: nama, alamat: alamat, kota: kota));
      sp.setString('temporaryAddCustomer', jsonEncode(temporaryAddCustomer));
      customers
          .add(Customer(noHp: noHp, nama: nama, alamat: alamat, kota: kota));
      String updatedCustomersLocal =
          jsonEncode(customers.map((user) => user.toJson()).toList());
      await sp.setString('customersLocal', updatedCustomersLocal);
      // print("Customer added to SharedPreferences");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Failed",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("Customer already exists!"),
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
      return;
    }
    // } else {
    //   customers
    //       .add(Customer(noHp: noHp, nama: nama, alamat: alamat, kota: kota));

    //   String updatedCustomersLocal =
    //       jsonEncode(customers.map((user) => user.toJson()).toList());
    //   await sp.setString('customersLocal', updatedCustomersLocal);
    //   // print("Local Storage initialized!");
    // }
    // print(sp.getString('customersLocal'));
    print(sp.getString('temporaryAddCustomer'));

    // return;
    synchronizeAddCustomers();
    Navigator.pop(context);
    // print(temporaryAddCustomer);
  }
}
