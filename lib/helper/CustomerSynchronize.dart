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
  if (temp == null) {
    return;
  }
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

Future<void> synchronizeDeleteCustomers() async {
  const url = "http://10.0.2.2:8082/proyek_pos/customer";
  final uri = Uri.parse(url);
  
  // Get the list of customers to delete from local storage
  String? temp = sp.getString('temporaryDeleteCustomer');
  if (temp == null) {
    return; // If no customers to delete, exit the function
  }
  
  List<dynamic> temporaryDeleteCustomerList;
  try {
    temporaryDeleteCustomerList = jsonDecode(temp ?? '[]');
  } catch (e) {
    print('Error decoding JSON: $e');
    return; // Stop execution if there's an error decoding
  }

  List<Customer> temporaryDeleteCustomer =
      temporaryDeleteCustomerList.map((item) => Customer.fromJson(item)).toList();

  for (var customer in List.from(temporaryDeleteCustomer)) {
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({'no_hp': customer.noHp}), // Send customer no_hp to delete
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success']) {
        temporaryDeleteCustomer.remove(customer); // Remove from local list
        await updateLocalStorage(temporaryDeleteCustomer); // Update local storage
      } else {
        print('Failed to delete customer: ${response.statusCode}'); // Handle unsuccessful response
        break; // Stop the loop if there's an issue with the response
      }
    } catch (e) {
      print("Error occurred: $e"); // Handle errors
      break; // Stop the loop if there's an error
    }
  }
}
