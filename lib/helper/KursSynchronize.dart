// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:proyek_pos/model/KursModel.dart'; // Ensure you import your Kurs model
// import 'package:proyek_pos/main.dart'; // Ensure you import your SharedPreferences instance

// Future<void> updateKursLocalStorage(List<Kurs> kursList) async {
//   // Save the updated list of kurs to local storage
//   String kursListJson = jsonEncode(kursList.map((kurs) => kurs.toJson()).toList());
//   await sp.setString('temporaryAddKurs', kursListJson);
// }

// Future<void> synchronizeAddKurs() async {
//   const url = "http://10.0.2.2:8082/proyek_pos/kurs"; // Adjust your API endpoint
//   final uri = Uri.parse(url);

//   // Fetch the kurs list from local storage
//   String? temp = sp.getString('temporaryAddKurs');
//   if (temp == null) {
//     return; // No kurs data to synchronize
//   }

//   List<dynamic> temporaryAddKursList;
//   try {
//     temporaryAddKursList = jsonDecode(temp);
//   } catch (e) {
//     print('Error decoding JSON: $e');
//     return; // Stop execution on decode error
//   }

//   List<Kurs> temporaryAddKurs = temporaryAddKursList.map((item) => Kurs.fromJson(item)).toList();

//   for (var kurs in List.from(temporaryAddKurs)) {
//     try {
//       final response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'tanggal': kurs.tanggal,
//           'kurs': kurs.kurs,
//         }),
//       );

//       final body = jsonDecode(response.body);
//       if (response.statusCode == 200 && body['success']) {
//         temporaryAddKurs.remove(kurs);
//         await updateKursLocalStorage(temporaryAddKurs);
//       } else {
//         break; // Stop the loop on response error
//       }
//     } catch (e) {
//       print('Error during synchronization: $e');
//       break; // Stop the loop on request error
//     }
//   }
// }
