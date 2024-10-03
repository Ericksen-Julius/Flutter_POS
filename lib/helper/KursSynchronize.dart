import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_pos/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUnsentKursLocally(Map<String, dynamic> kurs) async {
  // String? unsentKursJson = sp.getString('unsentKurs');
  // unsentKursList.add(kurs);
  debugPrint("check");
  debugPrint(kurs.toString());
  await sp.setString('unsentKurs', jsonEncode(kurs));
}

Future<void> synchronizeKurs() async {
  const url = "http://10.0.2.2:8082/proyek_pos/kurs";
  final uri = Uri.parse(url);

  // Get unsent kurs data from local storage
  String? unsentKursJson = sp.getString('unsentKurs');
  if (unsentKursJson == null) {
    return;
  }

  // debugPrint(unsentKursJson);
  Map<String, dynamic> unsentKursList = jsonDecode(unsentKursJson);
  // debugPrint(unsentKursList['tanggal']);

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode(unsentKursList),
    );

    final body = jsonDecode(response.body);
    // print(body);
  } catch (e) {
  }
}
