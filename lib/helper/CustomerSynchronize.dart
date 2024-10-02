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

Future<void> saveUnsentDeleteCustomersLocally(
    Map<String, dynamic> customer) async {
  String? unsentDeleteCustomers = sp.getString('temporaryDeleteCustomer');
  List<dynamic> unsentDeleteCustomersList =
      jsonDecode(unsentDeleteCustomers ?? '[]');
  unsentDeleteCustomersList.add(customer);
  await sp.setString(
      'temporaryDeleteCustomer', jsonEncode(unsentDeleteCustomersList));
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
      } else if (body['message'] == 'Error validation' &&
          body['errors']['no_hp'] != null) {
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

  List<dynamic> temporaryDeleteCustomer;
  try {
    temporaryDeleteCustomer = jsonDecode(temp ?? '[]');
  } catch (e) {
    print('Error decoding JSON: $e');
    return; // Stop execution if there's an error decoding
  }
  // print(temporaryDeleteCustomer);
  // return;
  // return;

  // List<Customer> temporaryDeleteCustomer = temporaryDeleteCustomerList
  //     .map((item) => Customer.fromJson(item))
  //     .toList();
  // print(temporaryDeleteCustomer);
  // return;

  for (var customer in List.from(temporaryDeleteCustomer)) {
    try {
      // print(customer['no_hp']);
      final response = await http.delete(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
            {'no_hp': customer['no_hp']}), // Send customer no_hp to delete
      );

      final body = jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200 && body['success']) {
        temporaryDeleteCustomer.remove(customer); // Remove from local list
        await sp.setString('temporaryDeleteCustomer',
            jsonEncode(temporaryDeleteCustomer)); // Update local storage
      } else if (body['message'] ==
              'No user found with the given handphone number.' &&
          !body['success']) {
        temporaryDeleteCustomer.remove(customer); // Remove from local list
        await sp.setString(
            'temporaryDeleteCustomer', jsonEncode(temporaryDeleteCustomer));
      } else {
        print(
            'Failed to delete customer: ${response.statusCode}'); // Handle unsuccessful response
        break; // Stop the loop if there's an issue with the response
      }
    } catch (e) {
      print("Error occurred: $e"); // Handle errors
      break; // Stop the loop if there's an error
    }
  }
}

Future<void> saveUnsentEditCustomerLocally(Map<String, dynamic> customer) async {
  String? unsentEditCustomerJson = sp.getString('unsentEditCustomer');
  List<dynamic> unsentEditCustomerList = jsonDecode(unsentEditCustomerJson ?? '[]');
  unsentEditCustomerList.add(customer);
  print("check");
  print(unsentEditCustomerList);
  await sp.setString('unsentEditCustomer', jsonEncode(unsentEditCustomerList));
}

Future<void> synchronizeEditCustomers() async {
  const url = "http://10.0.2.2:8082/proyek_pos/customer";
  final uri = Uri.parse(url);

  // Get the list of unsent edited customers from local storage
  String? temp = sp.getString('unsentEditCustomer');
  if (temp == null) {
    return; // No unsent edited customers to sync
  }

  List<dynamic> unsentEditCustomerList;
  try {
    unsentEditCustomerList = jsonDecode(temp);
  } catch (e) {
    print('Error decoding JSON: $e');
    return; // Stop execution if there's an error decoding
  }

  for (var customer in List.from(unsentEditCustomerList)) {
    try {
      String noHp = customer['no_hp'].toString().trim();
      final response = await http.put(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'no_hp': noHp,
          'nama': customer['nama'],
          'alamat': customer['alamat'],
          'kota': customer['kota'],
        }),
      );
      print(customer['no_hp'].toString().length);
      final body = jsonDecode(response.body);
      print('1');
      print(body);
      if (response.statusCode == 200 && body['success']) {
        unsentEditCustomerList.remove(customer);
        await sp.setString('unsentEditCustomer', jsonEncode(unsentEditCustomerList));
        print("test");
        print(sp.getString('unsentEditCustomer'));
      } else {
        print('Failed to update customer: ${response.statusCode}');
        break; // Stop the loop if there's an issue with the response
      }
    } catch (e) {
      print("Error occurred: $e");
      break; // Stop the loop if there's an error
    }
  }
}


