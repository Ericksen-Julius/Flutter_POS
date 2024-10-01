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

    Map<String, dynamic> kursData = {
      'tanggal': date, // Today's date
      'kurs': kurs, // Input kurs
    };

    await saveUnsentKursLocally(kursData);
    await synchronizeKurs();
    print(kursData);

    // try {
    //   final response = await http.post(
    //     uri,
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: json.encode(kursData), // Send kurs data
    //   );

    //   final body = jsonDecode(response.body);
    //   print(body);

    //   if (response.statusCode == 200 && body['success']) {
    //     // Show success message
    //     Navigator.pop(context); // Close the modal
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Kurs added successfully!')),
    //     );
    //   } else {
    //     // Handle failure
    //     await saveUnsentKursLocally(kursData); // Save kurs data locally
    //     _showAlertDialog(context, "Failed", "Failed to add kurs!"); // Show error dialog
    //   }
    // } catch (e) {
    //   await saveUnsentKursLocally(kursData); // Save kurs data locally on exception
    //   print('Error during API request: $e');
    //   _showAlertDialog(context, "Error", "An error occurred while adding kurs!"); // Show error dialog
    // }

    // // Optional: Call synchronizeKurs if needed
    // await synchronizeKurs();
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Colors.red)),
          content: Text(message),
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

}
