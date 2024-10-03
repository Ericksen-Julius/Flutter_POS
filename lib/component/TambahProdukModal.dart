// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:proyek_pos/helper/ProdukSynchronize.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/ProdukModel.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:proyek_pos/page/MasterProdukPage.dart';

class TambahProdukModal extends StatefulWidget {
  const TambahProdukModal({super.key});

  @override
  State<TambahProdukModal> createState() => _TambahProdukModalState();
}

class _TambahProdukModalState extends State<TambahProdukModal> {
  final TextEditingController _inputNamaProdukController =
      TextEditingController();
  final TextEditingController _inputBeratController = TextEditingController();
  final picker = ImagePicker();
  bool isSubmitting = false;
  File? _selectedImage;

  List<String> dropdownValue = ['LM', 'GD'];
  List<String> dropdownText = ['Logam Mulia', 'Perhiasan'];
  String? _selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputBeratController.text = '80';
    _inputNamaProdukController.text = 'Emas Uhuy';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: isSubmitting // Tampilkan loader jika isLoading true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tambah Produk',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5C1D20),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _inputNamaProdukController,
                    icon: Icons.shopping_bag,
                    label: 'Produk',
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _inputBeratController,
                    icon: Icons.label,
                    label: 'Berat',
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    // value: selectedValue,
                    decoration: InputDecoration(
                      labelText: "Pilih kategori",
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
                    items: dropdownText.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(color: Color(0xFF667085))),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    },
                    dropdownColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _selectedImage == null
                          ? Text('No image selected.')
                          : Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic untuk tambah customer
                        if (_inputNamaProdukController.text.isEmpty ||
                            _inputBeratController.text.isEmpty ||
                            _selectedItem == null ||
                            _selectedImage == null) {
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
                          _submitForm();
                          // Logic untuk tambah customer
                          // _inputCustomer(
                          //   _inputBarcodeController.text,
                          //   _inputNoHpController.text,
                          //   _inputAlamatController.text,
                          //   _inputKotaController.text,
                          //   context,
                          // );
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
          label == 'Berat' ? TextInputType.number : TextInputType.text,
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        debugPrint("huy ${_selectedImage!.path}");
      });
    }
  }

  String generateBarcode(String type) {
    // Validate barcode type
    if (type != 'LM' && type != 'GD') {
      throw Exception('Invalid barcode type.');
    }

    String year = DateTime.now().year.toString().substring(2);

    String randomNumber = List.generate(
            10,
            (index) =>
                (index == 0) ? Random().nextInt(9) + 1 : Random().nextInt(10))
        .join('');

    // Format barcode
    String barcode = type + year + randomNumber;

    return barcode;
  }

  Future<void> _submitForm() async {
    setState(() {
      isSubmitting = true;
    });

    // Getting the index of the selected category
    int index = dropdownText.indexOf(_selectedItem!);

    String barcode = generateBarcode(dropdownValue[index]);
    // print(barcode);
    // return;
    // Create the request data
    Map<String, String> requestData = {
      'barcode_id': barcode,
      'nama': _inputNamaProdukController.text,
      'berat': _inputBeratController.text,
      'kategori': dropdownValue[index],
    };

    // Add image if selected
    final mimeTypeData = lookupMimeType(_selectedImage!.path)?.split('/');
    if (_selectedImage != null) {
      if (mimeTypeData != null && mimeTypeData.length == 2) {
        requestData['foto'] =
            _selectedImage!.path; // Store the image path for offline
      }
    }
    // print(requestData);
    // Navigator.pop(context);
    // return;
    String? produksLocal = sp.getString('produksLocal');
    try {
      // print("Coba decode local data...");
      List<dynamic> produkListLocal = jsonDecode(produksLocal ?? '[]');
      List<Produk> products = [];
      products = produkListLocal.map((item) => Produk.fromJson(item)).toList();
      products.add(Produk(
          barcodeID: barcode,
          nama: _inputNamaProdukController.text,
          berat: _inputBeratController.text,
          kategori: dropdownValue[index],
          foto: _selectedImage!.path));
      sp.setString('produksLocal', jsonEncode(products));

      // print("Local data berhasil dimuat.");
    } catch (e) {
      print('Error decoding JSON local: $e');
    }

    try {
      Navigator.pop(context);

      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboardpage()));
      });

      await saveUnsentProdukLocally(requestData);
      await synchronizeProduk();

      // Checking if the response is successful
      // if (response.statusCode == 200 && jsonResponse['success'] == true) {
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Center(
      //           child: Text(
      //             "Success",
      //             style: TextStyle(color: Colors.green),
      //           ),
      //         ),
      //         content: Text("Produk has been added successfully."),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //               Navigator.of(context).pop(true);
      //             },
      //             child: Text("OK"),
      //           ),
      //         ],
      //       );
      //     },
      //   );

      //   // Optionally, you can clear local data after successful submission
      //   await sp.remove('unsentProduk');
      // } else {
      //   // Handle unsuccessful response
      //   await saveUnsentProdukLocally(requestData);
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text(
      //           "Failed",
      //           style: TextStyle(color: Colors.red),
      //         ),
      //         content: Text(
      //             jsonResponse['message'] ?? 'Sorry, there was some trouble.'),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             child: Text("OK"),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
    } catch (e) {
      // Save data locally in case of an error
      await saveUnsentProdukLocally(requestData);
      // setState(() {
      //   isSubmitting = false; // Reset loading state on error
      // });
    }
  }

  // void _submitForm() {
  //     // Handle form submission
  //     print('Name: ${_nameController.text}');
  //     print('Category ID: $_selectedCategoryId');
  //     print('Description: ${_descController.text}');
  //     print('Price: ${_priceController.text}');
  //     print('Image: $_selectedImage');
  //     // Add your API call or further processing here
  //   }
}
