import 'dart:convert';

import 'package:proyek_pos/main.dart';
import 'package:http/http.dart' as http;

Future<void> saveUnsentNotaLocally(Map<String, dynamic> nota) async {
  String? unsentNotaJson = sp.getString('unsentNota');
  List<dynamic> unsentNotaList = jsonDecode(unsentNotaJson ?? '[]');
  unsentNotaList.add(nota);
  await sp.setString('unsentNota', jsonEncode(unsentNotaList));
}

Future<void> synchronizeNota() async {
  // print('cek');
  // print(sp.getString('unsentNota'));
  const url = "http://10.0.2.2:8082/proyek_pos/nota";
  final uri = Uri.parse(url);

  // Get unsent nota data from local storage
  String? unsentNotaJson = sp.getString('unsentNota');
  if (unsentNotaJson == null) {
    return;
  }
  List<dynamic> unsentNotaList = jsonDecode(unsentNotaJson);

  for (var nota in List.from(unsentNotaList)) {
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(nota),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success']) {
        // Remove successfully sent nota from the local storage
        unsentNotaList.remove(nota);
        await sp.setString('unsentNota', jsonEncode(unsentNotaList));
      } else {
        break; // Stop if there's an issue with the server response
      }
    } catch (e) {
      break; // Stop if there's an error
    }
  }
}
