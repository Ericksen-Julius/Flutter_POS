import 'dart:convert';

import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/CustomerModel.dart';
import 'package:http/http.dart' as http;

Future<void> updateLocalStorage(List<Customer> customers) async {
  // Simpan daftar pelanggan yang diperbarui ke local storage
  // Misalnya, menggunakan SharedPreferences
  String customerList =
      jsonEncode(customers.map((user) => user.toJson()).toList());
  await sp.setString('temporaryAddCustomer', customerList);
}

Future<void> synchronizeAddCustomers() async {
  const url = "http://10.0.2.2:8082/proyek_pos/customer";
  final uri = Uri.parse(url);
  // Ambil daftar pelanggan dari local storage
  String? temp = sp.getString('temporaryAddCustomer');
  List<dynamic> temporaryAddCustomerList;
  try {
    temporaryAddCustomerList = jsonDecode(temp ?? '[]');
  } catch (e) {
    print('Error saat melakukan decode JSON: $e');
    return; // Hentikan eksekusi jika ada kesalahan saat decode
  }

  List<Customer> temporaryAddCustomer =
      temporaryAddCustomerList.map((item) => Customer.fromJson(item)).toList();

  for (var customer in List.from(temporaryAddCustomer)) {
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            'no_hp': customer.noHp,
            'nama': customer.nama,
            'alamat': customer.alamat,
            'kota': customer.kota,
          },
        ),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success']) {
        temporaryAddCustomer.remove(customer);
        await updateLocalStorage(temporaryAddCustomer);
      } else {
        break; // Menghentikan loop jika ada masalah dengan respons
      }
    } catch (e) {
      break; // Menghentikan loop jika ada kesalahan
    }
  }
}
