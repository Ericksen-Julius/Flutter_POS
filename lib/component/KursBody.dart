import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class KursBody extends StatefulWidget {
  const KursBody({super.key});

  @override
  State<KursBody> createState() => _KursBodyState();
}

class _KursBodyState extends State<KursBody> {
  List<dynamic> kursData = []; // List to hold data

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  void fetchData() async {
    try {
      // Simulate fetching local data from shared preferences
      // String? kursLocal = '{"data":[{"tanggal":"01-09-2024","kurs":"15,000"}, {"tanggal":"02-09-2024","kurs":"14,800"}]}';
      // List<dynamic> kursListLocal = jsonDecode(kursLocal)['data'];
      
      // setState(() {
      //   kursData = kursListLocal; // Set local data first
      // });

      // Now try fetching from server
      const url = "http://10.0.2.2:8082/proyek_pos/kurs";
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final body = response.body;
      final json = jsonDecode(body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          kursData = json['data'];
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (e is SocketException) {
        print('No internet connection.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return kursData.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical, // Allow vertical scrolling
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allow horizontal scrolling (if needed)
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Full screen width
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange, // Background color for header
                        ),
                        padding: const EdgeInsets.all(8.0), // Padding for the header
                        child: const Text(
                          'Tanggal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange, // Background color for header
                        ),
                        padding: const EdgeInsets.all(8.0), // Padding for the header
                        child: const Text(
                          'Kurs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: kursData
                      .map((item) => DataRow(cells: [
                            DataCell(Text(item['TANGGAL'])),
                            DataCell(Text(item['KURS'])),
                          ]))
                      .toList(),
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}