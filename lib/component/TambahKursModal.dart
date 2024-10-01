import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for formatting the date
import 'package:proyek_pos/helper/KursSynchronize.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assuming you're using shared_preferences

class TambahKursModal extends StatefulWidget {
  const TambahKursModal({super.key});

  @override
  State<TambahKursModal> createState() => TambahKursModalState();
}

class TambahKursModalState extends State<TambahKursModal> {
  // Inisialisasi controller untuk input kurs
  final TextEditingController _inputKursController = TextEditingController();
  late SharedPreferences sp;

  @override
  void dispose() {
    // Dispose controller when not in use
    _inputKursController.dispose();
    super.dispose();
  }

  // Fetch shared preferences instance
  Future<void> _initPreferences() async {
    sp = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
     String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());


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
              'Tambah Kurs Hari Ini',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans Bold',
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C1D20),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _inputKursController,
              icon: Icons.money,
              label: 'Kurs (dalam angka)',
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logic for adding kurs
                  if (_inputKursController.text.isEmpty) {
                    // Show alert if kurs is empty
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Failed",
                            style: TextStyle(color: Colors.red),
                          ),
                          content: Text("Kurs harus diisi!"),
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
                  } else {
                    // Proceed with saving kurs
                    _inputKurs(todayDate, _inputKursController.text, context);
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
    required TextInputType inputType,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Color(0xFF667085)),
      keyboardType: inputType,
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

  Future<void> _inputKurs(
  String date,
  String kurs,
  BuildContext context,
) async {
  const url = "http://10.0.2.2:8082/proyek_pos/kurs"; // Your API endpoint
  final uri = Uri.parse(url);

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'tanggal': date, // Today's date
        'kurs': kurs, // Input kurs
      }),
    );

    final body = jsonDecode(response.body);
    print(body);
    
    if (response.statusCode == 200 && body['success']) {
      // Show success message
      Navigator.pop(context); // Close the modal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kurs added successfully!')),
      );
    } else {
      // Handle failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Failed", style: TextStyle(color: Colors.red)),
            content: Text("Failed to add kurs!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Handle any exceptions
    print('Error during API request: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error", style: TextStyle(color: Colors.red)),
          content: Text("An error occurred while adding kurs!"),
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


// ini belum paham wkwkwk
//   Future<void> _inputKurs(
//   String date,
//   String kurs,
//   BuildContext context,
// ) async {
//   // Change kursLocal to dynamic to handle different types
//   dynamic kursLocal = sp.get('kursLocal'); 
//   List<dynamic> kursList = [];

//   // Check if kursLocal is an int or String
//   if (kursLocal is String) {
//     // Parse existing kurs data from shared preferences
//     kursList = jsonDecode(kursLocal);
//   } else if (kursLocal is int) {
//     // If kursLocal is an int, you might want to handle this case.
//     // Here we can assume it's not valid and return or log an error.
//     print("kursLocal is an int: $kursLocal. Expected a String.");
//     return; // or handle it according to your needs
//   } else {
//     // If kursLocal is null or of an unexpected type, initialize an empty list
//     kursList = [];
//   }

//   // Check if kurs for today's date already exists
//   bool kursExists = kursList.any((item) => item['tanggal'] == date);

//   if (!kursExists) {
//     // Add new kurs entry
//     kursList.add({
//       'tanggal': date,
//       'kurs': kurs,
//     });

//     // Save the updated list back to shared preferences
//     String updatedKursLocal = jsonEncode(kursList);
//     await sp.setString('kursLocal', updatedKursLocal);

//     // Close modal and show success message
//     Navigator.pop(context);
//   } else {
//     // If kurs already exists for today's date, show an alert
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "Failed",
//             style: TextStyle(color: Colors.red),
//           ),
//           content: Text("Kurs untuk hari ini sudah ada!"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("OK"),
//             )
//           ],
//         );
//       },
//     );
//   }
  // synchronizeAddKurs(); // Call to synchronize kurs data

  // // Optionally, handle success/failure of the database insert operation
  // Navigator.pop(context);
// }

}
